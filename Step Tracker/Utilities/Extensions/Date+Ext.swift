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
    
    var weekDayTitle: String {
        self.formatted(.dateTime.weekday(.wide))
    }
    
    var accessibilityDate: String {
        self.formatted(.dateTime.month(.wide).day())
    }
}
