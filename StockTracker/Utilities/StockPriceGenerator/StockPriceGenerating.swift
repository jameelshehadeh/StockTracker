//
//  StockPriceGenerating.swift
//  StockTracker
//
//  Created by Jameel Shehadeh on 04/04/2026.
//

import Foundation

protocol StockPriceGenerating {
    func start(symbols: [String], updateCallback: @escaping (Stock) -> Void)
    func stop()
}
