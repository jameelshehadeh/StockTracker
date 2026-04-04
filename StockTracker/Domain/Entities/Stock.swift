//
//  Stock.swift
//  StockTracker
//
//  Created by Jameel Shehadeh on 02/04/2026.
//

import Foundation

struct Stock: Identifiable, Hashable {
    let id: String
    let symbol: String
    let name: String
    let price: Double
    let priceChange: Double
    let description: String
}
