//
//  StockFlow.swift
//  StockTracker
//
//  Created by Jameel Shehadeh on 03/04/2026.
//

import SwiftUI

final class StockFlow {
    
    private let appState: SharedStateService
    private let webSocketClient: WebSocketClient
    
    private lazy var stockRepository: StockRepository = StockRepositoryImpl(
        webSocketClient: webSocketClient
    )
    
    private lazy var stockFeedUseCase: StockFeedUseCase = StockFeedUseCaseImpl(
        repository: stockRepository
    )
    
    init(appState: SharedStateService, webSocketClient: WebSocketClient) {
        self.appState = appState
        self.webSocketClient = webSocketClient
    }

}
