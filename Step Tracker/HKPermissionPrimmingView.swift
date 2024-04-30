//
//  HKPermissionPrimmingView.swift
//  Step Tracker
//
//  Created by Jeremy Cinq-Mars on 2024-04-30.
//

import SwiftUI

struct HKPermissionPrimmingView: View {
    
    var description = """
    This app displays your step and weight data in interactive charts.

    You can also add new step or weight data to Apple Health from this app. Your data is private and secured
    """
    
    var body: some View {
        VStack(spacing: 130) {
            VStack(alignment: .leading, spacing: 10) {
                Image(.appleHealth)
                    .resizable()
                    .frame(width: 90, height: 90)
                    .shadow(color: .gray.opacity(0.3), radius: 16)
                    .padding(.bottom, 12)
                
                Text("Apple Health Integration")
                    .font(.title2.bold())
                
                Text(description)
                    .foregroundStyle(.secondary)
            }
            
            Button {
                //do code later
            } label: {
                Text("Connect Apple Health")
                    .padding(5)
            }
            .buttonStyle(.borderedProminent)
            .tint(.pink)
            .shadow(color: .gray.opacity(0.3), radius: 10)
        }
        .padding(30)
    }
}

#Preview {
    HKPermissionPrimmingView()
}
