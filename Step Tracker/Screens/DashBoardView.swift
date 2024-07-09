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

    var isSteps: Bool {selectedStat == .steps}

    
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
                        StepBarChart(selectedStat: selectedStat, chartData: hkManager.stepData)
                        StepPieChart(chartData: ChartMath.averageWeekdayCount(for: hkManager.stepData))
                    case .weight:
                        WeightLineChart(selectedStat: selectedStat, chartData: hkManager.weightData)
                        WeightDiffChart(chartData: ChartMath.averageDailyWeightDiffs(for: hkManager.weightDiffData))
                    }
                }
            }
            .padding()
            .task {
                do {
                    try await hkManager.fetchStepCount()
                    try await hkManager.fetchWeights()
                    try await hkManager.fetchWeightsDifferentials()
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
            .sheet(isPresented: $isShowingPermissionPrimingSheet, onDismiss: {
                //fetch health data
            }, content: {
                HKPermissionPrimmingView()
            })
            .alert(isPresented: $isShowingAlert, error: fetchError) { fetchError in
                // Action Button
            } message: { fetchError in
                Text(fetchError.failureReason)
            }

        }
        .tint(isSteps ? .pink : .indigo)
    }
}

#Preview {
    DashBoardView()
        .environment(HealthKitManager())
}
