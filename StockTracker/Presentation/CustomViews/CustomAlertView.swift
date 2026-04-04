//
//  CustomAlertView.swift
//  StockTracker
//
//  Created by Jameel Shehadeh on 04/04/2026.
//


import SwiftUI

struct CustomAlertView: View {
    let title: String
    let message: String
    let dismissAction: () -> Void
    
    init(title: String = "error", message: String, dismissAction: @escaping () -> Void) {
        self.title = title
        self.message = message
        self.dismissAction = dismissAction
    }
    
    var body: some View {
        VStack(spacing: 16) {
            Text(title)
                .font(.headline)
                .foregroundColor(.primary)
            Text(message)
                .font(.subheadline)
                .foregroundColor(.primary)
                .multilineTextAlignment(.center)
            Button(action: dismissAction) {
                Text("Dismiss")
                    .bold()
                    .frame(maxWidth: .infinity)
                    .padding()
                    .cornerRadius(8)
            }
        }
        .padding()
        .background(Material.ultraThinMaterial)
        .cornerRadius(16)
        .shadow(radius: 10)
        .padding(.horizontal, 40)
    }
}
