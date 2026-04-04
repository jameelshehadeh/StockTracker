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
        
    private(set) var stock: Stock
    
    init(stock: Stock) {
        self.stock = stock
    }
    
    
}
