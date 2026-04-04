//
//  StockListErrors.swift
//  StockTracker
//
//  Created by Jameel Shehadeh on 04/04/2026.
//

import Foundation

enum StockListErrors: LocalizedError {
    
    case failedToLoadStocks
    case failedToStartFeed
    case sendFailed
    case unknownError
    
    var errorDescription: String? {
        switch self {
        case .failedToLoadStocks:
            return "Failed to load stocks. Please try again later."
        case .failedToStartFeed:
            return "Failed to start the feed. Please try again."
        case .sendFailed:
            return "Unable to send stock update. Please retry."
        case .unknownError:
            return "Something went wrong. Please try again."
        }
    }
}
