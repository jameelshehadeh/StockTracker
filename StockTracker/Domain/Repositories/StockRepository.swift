//
//  StockRepository.swift
//  StockTracker
//
//  Created by Jameel Shehadeh on 02/04/2026.
//

import Foundation

protocol StockRepository {
    var priceUpdates: AsyncStream<Stock> { get }
    func getStocks() async throws -> [Stock]
    func startPriceFeed() async throws
    func stopPriceFeed()
}
