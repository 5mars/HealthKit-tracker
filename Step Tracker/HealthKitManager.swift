//
//  HealthKitManager.swift
//  Step Tracker
//
//  Created by Jeremy Cinq-Mars on 2024-04-30.
//

import Foundation
import HealthKit
import Observation

@Observable class HealthKitManager {
    
    let store = HKHealthStore()
    
    let types: Set = [HKQuantityType(.stepCount), HKQuantityType(.bodyMass)]
    
}
