//
//  ChartMath.swift
//  Step Tracker
//
//  Created by Jeremy Cinq-Mars on 2024-05-02.
//

import Foundation
import Algorithms

struct ChartMath {
    static func averageWeekdayCount(for metric: [HealthMetric]) -> [WeekdayChartData] {

        let sortedByWeekday = metric.sorted { $0.date.weekdayInt < $1.date.weekdayInt }
        let weekdayArray = sortedByWeekday.chunked {
            $0.date.weekdayInt == $1.date.weekdayInt
        }
        
        var weekDayChartData: [WeekdayChartData] = []
        
        for array in weekdayArray {
            guard let firstValue = array.first else { continue }
            let total = array.reduce(0) { $0 + $1.value }
            let avgSteps = total/Double(array.count)
            
            weekDayChartData.append(.init(date: firstValue.date, value: avgSteps))
        }
        
        return weekDayChartData
    }
}
