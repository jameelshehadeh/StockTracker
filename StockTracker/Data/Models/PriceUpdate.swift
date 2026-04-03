//
//  PriceUpdate.swift
//  StockTracker
//
//  Created by Jameel Shehadeh on 03/04/2026.
//
import Foundation

struct PriceUpdate: Decodable {
    let symbol: String
    let price: Double
}
