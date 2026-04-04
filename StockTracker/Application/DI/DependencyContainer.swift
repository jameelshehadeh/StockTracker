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
    let appConfiguration: AppConfiguration
    private(set) var flows: Flows

    init(
        appConfiguration: AppConfiguration = .init()
    ) {
        self.appConfiguration = appConfiguration
        self.webSocketClient = URLSessionWebSocketClient(url: appConfiguration.socketBaseURL)
        self.appState = SharedStateService(webSocket: webSocketClient)
        self.flows = Flows(stockFlow: .init(appState: appState, webSocketClient: webSocketClient))
    }
}

extension DependencyContainer {
    struct Flows {
        let stockFlow: StockFlow
    }
}
