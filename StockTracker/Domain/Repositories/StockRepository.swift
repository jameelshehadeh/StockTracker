//
//  StockRepository.swift
//  StockTracker
//
//  Created by Jameel Shehadeh on 02/04/2026.
//

import Foundation

enum ConnectionState {
    case connected
    case disconnected
}

protocol StockRepository {
    var priceUpdates: AsyncStream<Stock> { get }
    var connectionState: ConnectionState { get }
    func getStocks() async throws -> [Stock]
    func startPriceFeed() async throws
    func stopPriceFeed()
}
