//
//  StockTrackerApp.swift
//  StockTracker
//
//  Created by Jameel Shehadeh on 02/04/2026.
//

import SwiftUI

@main
struct StockTrackerApp: App {
    
    private let container: DependencyContainer
    
    init() {
        let webSocketClient = URLSessionWebSocketClient(
            url: URL(string: "wss://ws.postman-echo.com/raw")!
        )
        let appState = SharedStateService(webSocket: webSocketClient)
        container = DependencyContainer(
            appState: appState,
            webSocketClient: webSocketClient
        )
    }
    
    var body: some Scene {
        WindowGroup {
                container.flows.stockFlow.stockListScreen()
        }
    }
}
