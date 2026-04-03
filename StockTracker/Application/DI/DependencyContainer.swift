//
//  DependencyContainer.swift
//  StockTracker
//
//  Created by Jameel Shehadeh on 03/04/2026.
//

import Foundation

final class DependencyContainer {

    let appState: SharedStateService
    let webSocketClient: WebSocketClient
    private(set) var flows: Flows
    
    init(
        appState: SharedStateService,
        webSocketClient: WebSocketClient
    ) {
        self.appState = appState
        self.webSocketClient = webSocketClient
        self.flows = Flows(stockFlow: .init(appState: appState, webSocketClient: webSocketClient))
    }
    
}

extension DependencyContainer {
    struct Flows {
        let stockFlow: StockFlow
    }
}

