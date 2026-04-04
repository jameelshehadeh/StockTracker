//
//  StockDetailViewModel.swift
//  StockTracker
//
//  Created by Jameel Shehadeh on 04/04/2026.
//


import Foundation

@MainActor
@Observable
final class StockDetailViewModel {
        
    private let appState: SharedStateService
    private(set) var stock: Stock
    
    var stocks: [String: Stock] {
        appState.stocks
    }
    
    init(appState: SharedStateService, stock: Stock) {
        self.appState = appState
        self.stock = stock
    }
    
    func updateIfNeeded() {
        if let updated = appState.stocks[stock.symbol] {
            stock = updated
        }
    }
    
}
