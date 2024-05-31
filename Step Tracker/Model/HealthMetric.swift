//
//  HealthMetric.swift
//  Step Tracker
//
//  Created by Jeremy Cinq-Mars on 2024-05-01.
//

import Foundation

struct HealthMetric: Identifiable {
    let id = UUID()
    let date: Date
    let value: Double
}
