//
//  StockListViewModelTests.swift
//  StockTracker
//
//  Created by Jameel Shehadeh on 05/04/2026.
//

import XCTest
@testable import StockTracker

@MainActor
final class StockListViewModelTests: XCTestCase {
    
    private var viewModel: StockListViewModel!
    private var mockUseCase: MockStockFeedUseCase!
    private var appState: SharedStateService!
    
    override func setUp() {
        super.setUp()
        
        mockUseCase = MockStockFeedUseCase()
        appState = SharedStateService(webSocket: MockWebSocketClient())
        
        viewModel = StockListViewModel(
            appState: appState,
            stockFeedUseCase: mockUseCase
        )
    }
    
    func test_onAppear_loadsStocksSuccessfully() async {
        mockUseCase.stocksResult = .success([
            Stock(id: "AAPL", symbol: "AAPL", name: "", price: 100, priceChange: 0, description: "")
        ])
        
        await viewModel.onAppear()
        
        XCTAssertEqual(viewModel.stocks.count, 1)
        XCTAssertEqual(viewModel.stocks.first?.symbol, "AAPL")
    }
    
    func test_onAppear_setsErrorOnFailure() async {
        mockUseCase.stocksResult = .failure(NSError(domain: "", code: -1))
        
        await viewModel.onAppear()
        
        XCTAssertEqual(
            viewModel.errorMessage,
            StockListErrors.failedToLoadStocks.localizedDescription
        )
    }
        
    func test_startFeed_callsUseCase() async {
        mockUseCase.stocksResult = .success([
            Stock(id: "AAPL", symbol: "AAPL", name: "", price: 100, priceChange: 0, description: "")
        ])
        
        await viewModel.onAppear()
        await viewModel.startFeed()
        
        XCTAssertTrue(mockUseCase.startFeedCalled)
    }
    
    func test_startFeed_setsErrorOnFailure() async {
        mockUseCase.startFeedResult = .failure(NSError(domain: "", code: -1))
        
        await viewModel.startFeed()
        
        XCTAssertEqual(
            viewModel.errorMessage,
            StockListErrors.failedToStartFeed.localizedDescription
        )
    }
    
    func test_stopFeed_callsUseCase() {
        viewModel.stopFeed()
        XCTAssertTrue(mockUseCase.stopFeedCalled)
    }
    
    func test_sort_byPrice() async {
        mockUseCase.stocksResult = .success([
            Stock(id: "1", symbol: "A", name: "", price: 10, priceChange: 0, description: ""),
            Stock(id: "2", symbol: "B", name: "", price: 20, priceChange: 0, description: "")
        ])
        
        await viewModel.onAppear()
        
        viewModel.sort(by: .byPrice)
        
        XCTAssertEqual(viewModel.stocks.first?.price, 20)
    }
    
    func test_sort_byPriceChange() async {
        mockUseCase.stocksResult = .success([
            Stock(id: "1", symbol: "A", name: "", price: 10, priceChange: 1, description: ""),
            Stock(id: "2", symbol: "B", name: "", price: 20, priceChange: 5, description: "")
        ])
        
        await viewModel.onAppear()
        
        viewModel.sort(by: .byPriceChange)
        
        XCTAssertEqual(viewModel.stocks.first?.priceChange, 5)
    }
        
    func test_observe_updatesStockPrice() async {
        let initialStock = Stock(
            id: "AAPL",
            symbol: "AAPL",
            name: "",
            price: 100,
            priceChange: 0,
            description: ""
        )
        
        mockUseCase.stocksResult = .success([initialStock])
        
        let stream = AsyncStream<Stock> { continuation in
            continuation.yield(
                Stock(
                    id: "AAPL",
                    symbol: "AAPL",
                    name: "",
                    price: 120,
                    priceChange: 0,
                    description: ""
                )
            )
        }
        
        mockUseCase.observeStream = stream
        
        await viewModel.onAppear()
        
        try? await Task.sleep(nanoseconds: 100_000_000)
        
        XCTAssertEqual(viewModel.stocks.first?.price, 120)
    }
}
