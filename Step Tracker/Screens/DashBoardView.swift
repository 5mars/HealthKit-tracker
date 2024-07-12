//
//  DashBoardView.swift
//  Step Tracker
//
//  Created by Jeremy Cinq-Mars on 2024-04-29.
//

import SwiftUI
import Charts

enum HealthMetricContext: CaseIterable, Identifiable {
    // could add another case if you want to track something else like calories, or sleep
    case steps, weight
    var id: Self { self }
    
    var title: String {
        switch self {
        case.steps:
            return "Steps"
        case.weight:
            return "Weight"
        }
    }
}

struct DashBoardView: View {
    
    @Environment(HealthKitManager.self) private var hkManager
    @State private var isShowingPermissionPrimingSheet = false
    @State private var selectedStat: HealthMetricContext = .steps
    @State private var isShowingAlert = false
    @State private var fetchError: STError = .noData
    
    var body: some View {
        NavigationStack {
            ScrollView {
                VStack(spacing: 20) {
                    Picker("Selected Stat", selection: $selectedStat) {
                        ForEach(HealthMetricContext.allCases) {
                            Text($0.title)
                        }
                    }
                    .pickerStyle(.segmented)
                    
                    switch selectedStat {
                    case .steps:
                        StepBarChart(chartData: ChartHelper.convert(data: hkManager.stepData))
                        StepPieChart(chartData: ChartHelper.averageWeekdayCount(for: hkManager.stepData))
                    case .weight:
                        WeightLineChart(chartData: ChartHelper.convert(data: hkManager.weightData))
                        WeightDiffChart(chartData: ChartHelper.averageDailyWeightDiffs(for: hkManager.weightDiffData))
                    }
                }
            }
            .padding()
            .task { fetchHealthData() }
            .navigationTitle("Dashboard")
            .toolbar {
                ToolbarItem(placement: .topBarTrailing) {
                    // Navigate to SettingsView
                    NavigationLink {
                        Settings()
                    } label: {
                        Image(systemName: "gearshape")
                            .accessibilityLabel("Settings")
                    }
                }
            }
            .navigationDestination(for: HealthMetricContext.self) { metric in
                HealthDataListView(metric: metric)
            }
            .fullScreenCover(isPresented: $isShowingPermissionPrimingSheet, onDismiss: {
                fetchHealthData()
            }, content: {
                HKPermissionPrimmingView()
            })
            .alert(isPresented: $isShowingAlert, error: fetchError) { fetchError in
                // Action Button
            } message: { fetchError in
                Text(fetchError.failureReason)
            }

        }
        .tint(selectedStat == .steps ? .pink : .indigo)
    }
    
    private func fetchHealthData() {
        Task {
            do {
                async let steps = hkManager.fetchStepCount()
                async let weightsForLineChart = hkManager.fetchWeights(daysBack: 28)
                async let weightsForDiffBarChart = hkManager.fetchWeights(daysBack: 29)
                
                hkManager.stepData = try await steps
                hkManager.weightData = try await weightsForLineChart
                hkManager.weightDiffData = try await weightsForDiffBarChart
            } catch STError.authNotDetermined {
                isShowingPermissionPrimingSheet = true
            } catch STError.noData {
                fetchError = .noData
                isShowingAlert = true
            } catch {
                fetchError = .unableToCompleteRequest
                isShowingAlert = true
            }
        }
    }
}

#Preview {
    DashBoardView()
        .environment(HealthKitManager())
}
