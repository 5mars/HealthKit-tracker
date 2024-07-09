//
//  ChartDataTypes.swift
//  Step Tracker
//
//  Created by Jeremy Cinq-Mars on 2024-05-02.
//

import Foundation

struct WeekdayChartData: Identifiable, Equatable {
    let id = UUID()
    let date: Date
    let value: Double
}
