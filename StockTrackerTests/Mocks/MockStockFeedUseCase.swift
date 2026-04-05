//
//  MockStockFeedUseCase.swift
//  StockTracker
//
//  Created by Jameel Shehadeh on 05/04/2026.
//

@testable import StockTracker

final class MockStockFeedUseCase: StockFeedUseCase {
    
    var stocksResult: Result<[Stock], Error> = .success([])
    var startFeedResult: Result<Void, Error> = .success(())
    var observeStream: AsyncStream<Stock> = AsyncStream { _ in }
    
    private(set) var startFeedCalled = false
    private(set) var stopFeedCalled = false
    
    func getStocks() async throws -> [Stock] {
        try stocksResult.get()
    }
    
    func startFeed(with symbols: [String]) async throws {
        startFeedCalled = true
        try startFeedResult.get()
    }
    
    func stopFeed() {
        stopFeedCalled = true
    }
    
    func observe() -> AsyncStream<Stock> {
        observeStream
    }
}
