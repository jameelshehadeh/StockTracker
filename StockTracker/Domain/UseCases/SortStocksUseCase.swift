//
//  SortStocksUseCase.swift
//  StockTracker
//
//  Created by Jameel Shehadeh on 02/04/2026.
//

import Foundation

enum SortOption {
    case byPrice
    case byPriceChange
}

protocol SortStocksUseCase {
    func execute(stocks: [Stock], sortedBy option: SortOption) -> [Stock]
}

final class SortStocksUseCaseImpl {
    init() {}
}

extension SortStocksUseCaseImpl: SortStocksUseCase {
    func execute(stocks: [Stock], sortedBy option: SortOption) -> [Stock] {
        switch option {
        case .byPrice:
            return stocks.sorted { $0.price > $1.price }
        case .byPriceChange:
            return stocks.sorted { $0.priceChange > $1.priceChange }
        }
    }
}
