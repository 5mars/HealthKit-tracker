//
//  ChartDataTypes.swift
//  Step Tracker
//
//  Created by Jeremy Cinq-Mars on 2024-05-02.
//

import Foundation

struct DateValueChartData: Identifiable, Equatable {
    let id = UUID()
    let date: Date
    let value: Double
}
