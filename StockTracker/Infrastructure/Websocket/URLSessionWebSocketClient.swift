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
    
    private var connectionContinuation: AsyncStream<SocketConnectionState>.Continuation?
    
    init(url: URL) {
        self.url = url
    }
    
    func connect() async throws {
        connectionContinuation?.yield(.disconnected)
        
        let session = URLSession(configuration: .default)
        task = session.webSocketTask(with: url)
        task?.resume()
        
        connectionContinuation?.yield(.connected)
    }
    
    func disconnect() {
        task?.cancel(with: .goingAway, reason: nil)
        task = nil
        connectionContinuation?.yield(.disconnected)
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
                        self.connectionContinuation?.yield(.disconnected)
                        break
                    }
                }
            }
        }
    }
    
    func observeConnection() -> AsyncStream<SocketConnectionState> {
        AsyncStream { continuation in
            self.connectionContinuation = continuation
            if task != nil {
                continuation.yield(.connected)
            } else {
                continuation.yield(.disconnected)
            }
        }
    }
}
