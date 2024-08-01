//
//  Array+Ext.swift
//  Step Tracker
//
//  Created by Jeremy Cinq-Mars on 2024-07-12.
//

import Foundation

extension Array where Element == Double {
    var average: Double{
        guard !self.isEmpty else { return 0 }
        let total = self.reduce(0, +)
        return total/Double(self.count)
    }
}
