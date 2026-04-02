//
//  URLSessionWebSocketClient.swift
//  StockTracker
//
//  Created by Jameel Shehadeh on 02/04/2026.
//

import Foundation

final class URLSessionWebSocketClient: WebSocketClient {
    private var task: URLSessionWebSocketTask?
    private let url: URL
    
    init(url: URL) {
        self.url = url
    }
    
    func connect() async throws {
        let session = URLSession(configuration: .default)
        task = session.webSocketTask(with: url)
        task?.resume()
    }
    
    func disconnect() {
        task?.cancel(with: .goingAway, reason: nil)
        task = nil
    }
    
    func send(_ message: String) async throws {
        try await task?.send(.string(message))
    }
    
    func receive() -> AsyncStream<String> {
        AsyncStream { continuation in
            Task {
                while let task = self.task {
                    do {
                        let message = try await task.receive()
                        switch message {
                        case .string(let text):
                            continuation.yield(text)
                        case .data:
                            break
                        default:
                            break
                        }
                    } catch {
                        continuation.finish()
                        break
                    }
                }
            }
        }
    }
}
