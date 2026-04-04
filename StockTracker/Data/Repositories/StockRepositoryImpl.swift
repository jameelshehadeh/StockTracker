//
//  StockRepositoryImpl.swift
//  StockTracker
//
//  Created by Jameel Shehadeh on 03/04/2026.
//

import Foundation

final class StockRepositoryImpl: StockRepository {
    
    enum StockRepositoryError: Error {
        case encodingFailed
        case decodingFailed
        case failedConnectingToSocket
        case couldntLoadStocks
    }
    
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
            throw StockRepositoryError.couldntLoadStocks
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
        do {
            try await webSocketClient.connect()
        } catch {
            throw StockRepositoryError.failedConnectingToSocket
        }
        listen()
        startRandomStockGeneration(symbols)
    }
    
    func stopPriceFeed() {
        stopRandomStockGeneration()
        stopListening()
    }
    
    func listen() {
        wsTask = Task { [weak self] in
            guard let self else { return }
            for await message in self.webSocketClient.receive() {
                if let stock = try? self.decode(message) {
                    self.continuation?.yield(stock)
                }
            }
        }
    }
    
    func stopListening(){
        wsTask?.cancel()
        wsTask = nil
        webSocketClient.disconnect()
    }
    
    func startRandomStockGeneration(_ symbols: [String]){
        randomGenerator.start(symbols: symbols) { [weak self] stock in
            guard let self else { return }
            Task {
                try? await self.sendPriceUpdate(stock)
            }
        }
    }
    
    func stopRandomStockGeneration(){
        randomGenerator.stop()
    }
    
    private func sendPriceUpdate(_ stock: Stock) async throws {
        let update = PriceUpdate(symbol: stock.symbol, price: stock.price)
        let message = try encode(update)
        try? await webSocketClient.send(message)
    }
    
    private func encode(_ priceUpdate: PriceUpdate) throws -> String {
        do {
            let data = try JSONEncoder().encode(priceUpdate)
            guard let message = String(data: data, encoding: .utf8) else {
                throw StockRepositoryImpl.StockRepositoryError.encodingFailed
            }
            return message
        } catch {
            throw error
        }
    }
    
    private func decode(_ message: String) throws -> Stock {
        guard let data = message.data(using: .utf8),
              let update = try? JSONDecoder().decode(PriceUpdate.self, from: data) else {
            throw StockRepositoryError.decodingFailed
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
