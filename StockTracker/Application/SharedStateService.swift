//
//  SharedStateService.swift
//  StockTracker
//
//  Created by Jameel Shehadeh on 03/04/2026.
//


import Foundation

@MainActor
@Observable
final class SharedStateService {
    private let webSocket: WebSocketClient
    private var observationTask: Task<Void, Never>?
    private(set) var connectionState: SocketConnectionState = .disconnected
    private(set) var stocks: [String: Stock] = [:]
    
    init(webSocket: WebSocketClient) {
        self.webSocket = webSocket
        observeSocketConnection()
    }
    
    private func observeSocketConnection() {
        observationTask = Task { [weak self] in
            guard let self else { return }
            for await state in webSocket.observeConnection() {
                await MainActor.run {
                    self.connectionState = state
                }
            }
        }
    }
    
    func update(stock: Stock) {
        stocks[stock.symbol] = stock
    }
}
