//
//  StockRowView.swift
//  StockTracker
//
//  Created by Jameel Shehadeh on 04/04/2026.
//


import SwiftUI

struct StockRowView: View {
    let stock: Stock
    
    var body: some View {
        VStack(alignment: .leading, spacing: 4) {
            Text(stock.symbol)
                .font(.headline)
            Text(stock.name)
                .font(.subheadline)
                .foregroundColor(.secondary)
            HStack {
                Text("$\(stock.price, specifier: "%.2f")")
                    .font(.subheadline)
                Spacer()
                Text(stock.priceChange >= 0 ? "▲ \(stock.priceChange, specifier: "%.2f")" : "▼ \(abs(stock.priceChange), specifier: "%.2f")")
                    .foregroundColor(stock.priceChange >= 0 ? .green : .red)
                    .font(.subheadline)
            }
        }
        .padding(.vertical, 4)
    }
}
