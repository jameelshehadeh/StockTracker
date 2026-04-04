//
//  FeedControlButton.swift
//  StockTracker
//
//  Created by Jameel Shehadeh on 04/04/2026.
//


import SwiftUI

struct FeedControlButton: View {
    
    let connectionState: SocketConnectionState
    let startFeed: () -> Void
    let stopFeed: () -> Void
    
    var body: some View {
        Button {
            if connectionState == .connected {
                stopFeed()
            } else {
                startFeed()
            }
        } label: {
            Text(connectionState == .connected ? "Stop Feed" : "Start Feed")
                .font(.headline)
                .frame(maxWidth: .infinity)
                .padding()
                .background(connectionState == .connected ? Color.red : Color.green)
                .foregroundColor(.white)
                .cornerRadius(12)
        }
    }
}
