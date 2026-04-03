//
//  WebSocketClient.swift
//  StockTracker
//
//  Created by Jameel Shehadeh on 02/04/2026.
//

import Foundation

protocol WebSocketClient {
    func connect() async throws
    func disconnect()
    func send(_ message: String) async throws
    func receive() -> AsyncStream<String>
    func observeConnection() -> AsyncStream<SocketConnectionState>
}
