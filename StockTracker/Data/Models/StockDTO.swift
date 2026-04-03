//
//  StockDTO.swift
//  StockTracker
//
//  Created by Jameel Shehadeh on 03/04/2026.
//
import Foundation

struct StockDTO: Decodable {
    let symbol: String
    let name: String
    let price: Double
    let description: String
}
