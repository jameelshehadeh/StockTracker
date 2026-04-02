//
//  ObserveStocksUseCase.swift
//  StockTracker
//
//  Created by Jameel Shehadeh on 02/04/2026.
//

import Foundation

protocol ObserveStocksUseCase {
    func execute() -> AsyncStream<Stock>
}

final class ObserveStocksUseCaseImpl {
    private let repository: StockRepository
    
    init(repository: StockRepository) {
        self.repository = repository
    }
}

extension ObserveStocksUseCaseImpl: ObserveStocksUseCase {
    func execute() -> AsyncStream<Stock> {
        repository.priceUpdates
    }
}
