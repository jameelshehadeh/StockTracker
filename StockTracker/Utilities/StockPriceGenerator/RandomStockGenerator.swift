//
//  RandomStockGenerator.swift
//  StockTracker
//
//  Created by Jameel Shehadeh on 04/04/2026.
//

import Foundation

final class RandomStockGenerator:StockPriceGenerating {

    private var task: Task<Void, Never>?
    private let priceRange: ClosedRange<Int>

    init(priceRange: ClosedRange<Int> = 1000...50000) {
        self.priceRange = priceRange
    }

    func start(symbols: [String], updateCallback: @escaping (Stock) -> Void) {
        task = Task {
            while !Task.isCancelled {
                guard let symbol = symbols.randomElement() else { continue }
                let price = Double(Int.random(in: priceRange)) / 100
                let stock = Stock(
                    id: symbol,
                    symbol: symbol,
                    name: "",
                    price: price,
                    priceChange: 0.0,
                    description: ""
                )
                updateCallback(stock)
                try? await Task.sleep(nanoseconds: 1_000_000_000)
            }
        }
    }

    func stop() {
        task?.cancel()
        task = nil
    }
}
