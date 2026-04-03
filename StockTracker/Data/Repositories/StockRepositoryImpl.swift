//
//  StockRepositoryImpl.swift
//  StockTracker
//
//  Created by Jameel Shehadeh on 03/04/2026.
//

import Foundation

final class StockRepositoryImpl: StockRepository {
    private let webSocketClient: WebSocketClient
    private var sendTask: Task<Void, Never>?
    private var continuation: AsyncStream<Stock>.Continuation?
    
    lazy var priceUpdates: AsyncStream<Stock> = {
        AsyncStream { [weak self] continuation in
            self?.continuation = continuation
        }
    }()
    
    init(webSocketClient: WebSocketClient) {
        self.webSocketClient = webSocketClient
    }
    
    func getStocks() async throws -> [Stock] {
        guard let url = Bundle.main.url(forResource: "stocks", withExtension: "json"),
              let data = try? Data(contentsOf: url),
              let stocks = try? JSONDecoder().decode([StockDTO].self, from: data) else {
            return []
        }
        return stocks.map {
            Stock(
                id: $0.symbol,
                symbol: $0.symbol,
                name: $0.name,
                price: $0.price,
                priceChange: 0.0,
                description: $0.description
            )
        }
    }
    
    func startPriceFeed(with symbols: [String]) async throws {
        try await webSocketClient.connect()
        Task { [weak self] in
            guard let self else { return }
            for await message in self.webSocketClient.receive() {
                if let stock = self.decode(message) {
                    self.continuation?.yield(stock)
                }
            }
        }
        
        sendTask = Task { [weak self] in
            guard let self else { return }
            await self.sendRandomUpdates(symbols: symbols)
        }
    }
    
    func stopPriceFeed() {
        sendTask?.cancel()
        sendTask = nil
        webSocketClient.disconnect()
        continuation?.finish()
    }
    
    private func decode(_ message: String) -> Stock? {
        guard let data = message.data(using: .utf8),
              let update = try? JSONDecoder().decode(PriceUpdate.self, from: data) else {
            return nil
        }
        return Stock(
            id: update.symbol,
            symbol: update.symbol,
            name: "",
            price: update.price,
            priceChange: 0.0,
            description: ""
        )
    }
    
    private func sendRandomUpdates(symbols: [String]) async {
        while !Task.isCancelled {
            guard let symbol = symbols.randomElement() else { continue }
            let price = Double(Int.random(in: 5000...50000)) / 100
            let message = "{\"symbol\": \"\(symbol)\", \"price\": \(price)}"
            try? await webSocketClient.send(message)
            try? await Task.sleep(nanoseconds: 1_000_000_000)
        }
    }
}
