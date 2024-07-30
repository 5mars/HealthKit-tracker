//
//  ChartHelper.swift
//  Step Tracker
//
//  Created by Jeremy Cinq-Mars on 2024-07-09.
//

import Foundation
import Algorithms

struct ChartHelper {
    /// Converts an array of `HealthMetric` objects into an array of `DateValueChartData` objects suitable for charting.
    ///
    /// This function transforms health metric data into a format that can be easily visualized.
    ///
    /// - Parameters:
    ///   - data: An array of ``HealthMetric`` objects, each containing a date and a value.
    ///
    /// - Returns: An array of ``DateValueChartData``  objects, each containing a date and a corresponding value.
    ///
    /// - Example:
    /// ```swift
    /// let healthMetrics = [
    ///     HealthMetric(date: Date(), value: 100),
    ///     HealthMetric(date: Date() + 86400, value: 120) // Add one day
    /// ]
    /// let chartData = convert(data: healthMetrics)
    /// print(chartData) // Output: [{date: ..., value: 100}, {date: ..., value: 120}]
    /// ```
    static func convert(data: [HealthMetric]) -> [DateValueChartData] {
        data.map { .init(date: $0.date, value: $0.value)}
    }
    
    /// Extracts data for a specific date from an array of ``DateValueChartData`` objects.
    ///
    /// This function filters the provided data array to find the entry that corresponds to the `selectedDate`. It leverages the current calendar to determine if the dates are on the same day.
    ///
    /// - Parameters:
    ///   - data: An array of ``DateValueChartData`` objects, each containing a date and a value.
    ///   - selectedDate: The date for which you want to extract data. This parameter can be nil.
    ///
    /// - Returns:
    ///   A single ``DateValueChartData`` object containing the data for the ``selectedDate` if found, otherwise nil.
    ///
    /// - Example:
    /// ```swift
    /// let chartData = [
    ///     DateValueChartData(date: Date(), value: 100),
    ///     DateValueChartData(date: Date() + 86400, value: 120) // One day later
    /// ]
    /// let selectedDate = Date()
    ///
    /// if let selectedItem = parseSelectedData(from: chartData, in: selectedDate) {
    ///   print("Selected data:", selectedItem)
    /// } else {
    ///   print("No data found for selected date")
    /// }
    /// ```    
    static func parseSelectedData(from data: [DateValueChartData], in selectedDate: Date?) -> DateValueChartData? {
        guard let selectedDate else { return nil }
        return data.first {
            Calendar.current.isDate(selectedDate, inSameDayAs: $0.date)
        }
    }
    
    /// Calculates average values for health metrics grouped by weekdays.
    ///
    /// This function takes an array of ``HealthMetric`` objects and calculates the average value for each weekday. It groups the metrics by their weekday (represented by an integer) and then calculates the average value within each group.
    ///
    /// - Parameters:
    ///   - metric: An array of ``HealthMetric`` objects, each containing a date and a value.
    ///
    /// - Returns:
    ///   An array of ``DateValueChartData`` objects, where each object represents the average value for a specific weekday. The `date` property of each ``DateValueChartData`` object represents the first day of the corresponding weekday group, and the `value` property represents the average value for that weekday.
    ///
    /// - Example:
    /// ```swift
    /// let healthMetrics = [
    ///     HealthMetric(date: Date(), value: 1000),
    ///     HealthMetric(date: Date() + 86400, value: 1200), // One day later (same weekday)
    ///     HealthMetric(date: Date() + 172800, value: 800) // Two days later (different weekday)
    /// ]
    ///
    /// let averageValues = averageWeekdayCount(for: healthMetrics)
    /// print(averageValues) // Output: [{date: ..., value: 1100}, {date: ..., value: 800}]
    /// ```
    static func averageWeekdayCount(for metric: [HealthMetric]) -> [DateValueChartData] {
        let sortedByWeekday = metric.sorted(using: KeyPathComparator(\.date.weekdayInt))
        let weekdayArray = sortedByWeekday.chunked {
            $0.date.weekdayInt == $1.date.weekdayInt
        }
        
        var weekDayChartData: [DateValueChartData] = []
        
        for array in weekdayArray {
            guard let firstValue = array.first else { continue }
            let total = array.reduce(0) { $0 + $1.value }
            let avgSteps = total/Double(array.count)
            
            weekDayChartData.append(.init(date: firstValue.date, value: avgSteps))
        }
        
        return weekDayChartData
    }
    
    /// Calculates average daily weight differences grouped by weekdays.
    ///
    /// This function takes an array of ``HealthMetric`` objects and calculates the average difference in weight between consecutive days for each weekday. It groups the calculations by their weekday (represented by an integer) and then calculates the average daily difference within each group.
    ///
    /// - Parameters:
    ///   - weights: An array of ``HealthMetric`` objects, each containing a date and a value (assumed to be weight).
    ///
    /// - Returns:
    ///   An array of ``DateValueChartData`` objects, where each object represents the average daily weight difference for a specific weekday. The `date` property of each ``DateValueChartData` object represents the first day of the corresponding weekday group, and the `value` property represents the average daily weight difference for that weekday.
    ///
    /// - Example:
    /// ```swift
    /// let weightMetrics = [
    ///     HealthMetric(date: Date(), value: 70.0),
    ///     HealthMetric(date: Date() + 86400, value: 70.5), // One day later (weight difference)
    ///     HealthMetric(date: Date() + 172800, value: 71.0), // Two days later (weight difference, different weekday)
    /// ]
    ///
    /// let averageDiffs = averageDailyWeightDiffs(for: weightMetrics)
    /// print(averageDiffs) // Output: [{date: ..., value: 0.25}, {date: ..., value: 0.5}] (possible output)
    /// ```
    /// 
    /// - Note: This function requires at least two weight measurements (array size > 1) to calculate differences. It returns an empty array if there's only one measurement or no measurements.
    static func averageDailyWeightDiffs(for weights: [HealthMetric]) -> [DateValueChartData] {
        var diffValues: [(date: Date, value: Double)] = []
        
        guard weights.count > 1 else { return [] }
        
        for i in 1..<weights.count {
            let date = weights[i].date
            let diff = weights[i].value - weights[i - 1].value
            diffValues.append((date: date, value: diff))
        }
        
        let sortedByWeekday = diffValues.sorted(using: KeyPathComparator(\.date.weekdayInt))
        let weekdayArray = sortedByWeekday.chunked {
            $0.date.weekdayInt == $1.date.weekdayInt
        }
        
        var weekdayChartData: [DateValueChartData] = []

        for array in weekdayArray {
            guard let firstValue = array.first else { continue }
            let total = array.reduce(0) { $0 + $1.value }
            let avgWeightDiff = total/Double(array.count)
            
            weekdayChartData.append(.init(date: firstValue.date, value: avgWeightDiff))
        }
        
        return weekdayChartData
    }
}
