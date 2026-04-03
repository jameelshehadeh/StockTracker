//
//  StockFeedUseCaseImpl.swift
//  StockTracker
//
//  Created by Jameel Shehadeh on 03/04/2026.
//

import Foundation

final class StockFeedUseCaseImpl: StockFeedUseCase {
    
    private let repository: StockRepository
    
    init(repository: StockRepository) {
        self.repository = repository
    }
    
    func getStocks() async throws -> [Stock] {
        try await repository.getStocks()
    }
    
    func startFeed(with symbols: [String]) async throws {
        try await repository.startPriceFeed(with: symbols)
    }
    
    func stopFeed() {
        repository.stopPriceFeed()
    }
    
    func observe() -> AsyncStream<Stock> {
        repository.priceUpdates
    }
}
