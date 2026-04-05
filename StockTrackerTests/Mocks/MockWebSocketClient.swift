//
//  MockWebSocketClient.swift
//  StockTracker
//
//  Created by Jameel Shehadeh on 05/04/2026.
//

@testable import StockTracker

final class MockWebSocketClient: WebSocketClient {
        
        func connect() async throws {}
        func disconnect() {}
        
        func send(_ message: String) async throws {}
        
        func receive() -> AsyncStream<String> {
            AsyncStream { _ in }
        }
        
        func observeConnection() -> AsyncStream<SocketConnectionState> {
            AsyncStream { continuation in
                continuation.yield(.connected)
            }
        }
    }
