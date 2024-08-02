//
//  Settings.swift
//  Step Tracker
//
//  Created by Jeremy Cinq-Mars on 2024-06-27.
//

import SwiftUI

struct Settings: View {
    @State var colorScheme: ColorScheme? = nil
    @AppStorage("colorScheme") private var storedColorScheme: String?
    @AppStorage("isDarkMode") private var isDarkMode: Bool = true
    
    var body: some View {
        NavigationStack {
            Form {
                Toggle(isOn: $isDarkMode, label: {
                    HStack {
                        Image(systemName: "moon.stars.fill")
                        
                        Text("Dark Mode")
                            .fontDesign(.rounded)
                            .bold()
                    }
                })
                .tint(.indigo)
            }
            .navigationTitle("Settings")
            .preferredColorScheme(isDarkMode ? .dark : .light)
        }
    }
}

#Preview {
    Settings()
}
