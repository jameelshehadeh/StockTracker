//
//  StockRepositoryImpl.swift
//  StockTracker
//
//  Created by Jameel Shehadeh on 03/04/2026.
//

import Foundation

final class StockRepositoryImpl: StockRepository {
    private let webSocketClient: WebSocketClient
    private let randomGenerator: StockPriceGenerating
    private var wsTask: Task<Void, Never>?
    private var continuation: AsyncStream<Stock>.Continuation?
    
    lazy var priceUpdates: AsyncStream<Stock> = {
        AsyncStream { [weak self] continuation in
            self?.continuation = continuation
        }
    }()

    init(
        webSocketClient: WebSocketClient,
        randomGenerator: StockPriceGenerating
    ) {
        self.webSocketClient = webSocketClient
        self.randomGenerator = randomGenerator
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
        wsTask = Task { [weak self] in
            guard let self else { return }
            for await message in self.webSocketClient.receive() {
                if let stock = self.decode(message) {
                    self.continuation?.yield(stock)
                }
            }
        }
        randomGenerator.start(symbols: symbols) { [weak self] stock in
            guard let self else { return }
            self.sendPriceUpdate(stock)
        }
    }
    
    private func sendPriceUpdate(_ stock: Stock) {
        Task {
            let update = PriceUpdate(symbol: stock.symbol, price: stock.price)
            do {
                let data = try JSONEncoder().encode(update)
                if let message = String(data: data, encoding: .utf8) {
                    try await webSocketClient.send(message)
                }
            } catch {
                print("Encoding error: \(error)")
            }
        }
    }
    
    func stopPriceFeed() {
        randomGenerator.stop()
        wsTask?.cancel()
        wsTask = nil
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
}
