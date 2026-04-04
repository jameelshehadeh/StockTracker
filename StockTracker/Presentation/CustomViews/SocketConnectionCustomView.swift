//
//  SocketConnectionCustomView.swift
//  StockTracker
//
//  Created by Jameel Shehadeh on 04/04/2026.
//

import SwiftUI

struct SocketConnectionCustomView: View {
    
    let connectionState: SocketConnectionState
    
    var body: some View {
        HStack(spacing: 4) {
            Circle()
                .fill(connectionState == .connected ? Color.green : Color.red)
                .frame(width: 10, height: 10)
            Text(connectionState == .connected ? "Connected" : "Disconnected")
                .font(.caption)
        }
    }
}

#Preview {
    SocketConnectionCustomView(connectionState: .connected)
}
