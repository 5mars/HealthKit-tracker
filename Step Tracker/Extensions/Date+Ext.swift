//
//  Date+Ext.swift
//  Step Tracker
//
//  Created by Jeremy Cinq-Mars on 2024-05-02.
//

import Foundation

extension Date {
    var weekdayInt: Int {
        Calendar.current.component(.weekday, from: self)
    }
}
