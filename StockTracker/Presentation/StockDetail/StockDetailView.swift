//
//  StockDetailView.swift
//  StockTracker
//
//  Created by Jameel Shehadeh on 04/04/2026.
//


import SwiftUI

struct StockDetailView: View {
    @State private var viewModel: StockDetailViewModel
    
    init(viewModel: StockDetailViewModel) {
        _viewModel = State(initialValue: viewModel)
    }
    
    var body: some View {
        VStack(spacing: 16) {
            let stock = viewModel.stock
            Text("$\(stock.price, specifier: "%.2f")")
                .font(.largeTitle)
            Text(stock.priceChange >= 0 ? "▲ \(stock.priceChange, specifier: "%.2f")" : "▼ \(abs(stock.priceChange), specifier: "%.2f")")
                .foregroundColor(stock.priceChange >= 0 ? .green : .red)
                .font(.title2)
            Text(stock.description)
                .font(.body)
                .padding()
        }
        .onChange(of: viewModel.stocks, {
            viewModel.updateIfNeeded()
        })
        .navigationTitle(viewModel.stock.symbol)
    }
}
