//
//  StockFeedUseCase.swift
//  StockTracker
//
//  Created by Jameel Shehadeh on 03/04/2026.
//

import Foundation

protocol StockFeedUseCase {
    func getStocks() async throws -> [Stock]
    func startFeed(with symbols: [String]) async throws
    func stopFeed()
    func observe() -> AsyncStream<Stock>
}
