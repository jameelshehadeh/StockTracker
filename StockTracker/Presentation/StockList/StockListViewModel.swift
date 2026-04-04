//
//  StockListViewModel.swift
//  StockTracker
//
//  Created by Jameel Shehadeh on 04/04/2026.
//


import Foundation

@MainActor
@Observable
final class StockListViewModel {
    
    private(set) var stocks: [Stock] = []
    var selectedSortOption: SortOption = .byPrice
    private var isObserving = false
    private var observationTask: Task<Void, Never>?
    
    var connectionState: SocketConnectionState {
        appState.connectionState
    }
    
    private let appState: SharedStateService
    private let stockFeedUseCase: StockFeedUseCase
    
    init(appState: SharedStateService, stockFeedUseCase: StockFeedUseCase) {
        self.appState = appState
        self.stockFeedUseCase = stockFeedUseCase
    }
    
    func onAppear() async {
        await loadStocks()
        if !isObserving {
            isObserving = true
            startObserving()
        }
    }
    
    func startFeed() async {
        do {
            try await stockFeedUseCase.startFeed(with: stocks.map { $0.symbol })
        } catch {
            print("Failed to start feed: \(error)")
        }
    }
    
    func stopFeed() {
        stockFeedUseCase.stopFeed()
    }
    
    func sort(by option: SortOption) {
        selectedSortOption = option
        applySort()
    }
    
    private func loadStocks() async {
        do {
            stocks = try await stockFeedUseCase.getStocks()
            applySort()
        } catch {
            print("Failed to load stocks: \(error)")
        }
    }
    
    private func startObserving() {
        observationTask = Task { [weak self] in
            guard let self else { return }
            for await update in stockFeedUseCase.observe() {
                await MainActor.run {
                    if let index = self.stocks.firstIndex(where: { $0.symbol == update.symbol }) {
                        let previous = self.stocks[index].price
                        let updatedStock = Stock(
                            id: update.symbol,
                            symbol: update.symbol,
                            name: self.stocks[index].name,
                            price: update.price,
                            priceChange: update.price - previous,
                            description: self.stocks[index].description
                        )
                        self.stocks[index] = updatedStock
                        self.appState.update(stock: updatedStock)
                        self.applySort()
                    }
                }
            }
        }
    }
    
    private func applySort() {
        switch selectedSortOption {
        case .byPrice:
            stocks = stocks.sorted { $0.price > $1.price }
        case .byPriceChange:
            stocks = stocks.sorted { $0.priceChange > $1.priceChange }
        }
    }
}