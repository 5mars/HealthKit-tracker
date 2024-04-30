//
//  Step_TrackerApp.swift
//  Step Tracker
//
//  Created by Jeremy Cinq-Mars on 2024-04-29.
//

import SwiftUI

@main
struct Step_TrackerApp: App {
    let hkManager = HealthKitManager()
    var body: some Scene {
        WindowGroup {
            DashBoardView()
                .environment(hkManager)
        }
    }
}
