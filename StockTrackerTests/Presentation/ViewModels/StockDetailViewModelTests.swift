//
//  StockDetailViewModelTests.swift
//  StockTracker
//
//  Created by Jameel Shehadeh on 05/04/2026.
//


import XCTest
@testable import StockTracker

@MainActor
final class StockDetailViewModelTests: XCTestCase {
    
    private var viewModel: StockDetailViewModel!
    private var mockAppState: SharedStateService!
    
    override func setUp() {
        super.setUp()
        mockAppState = SharedStateService(webSocket: MockWebSocketClient())
        let initialStock = Stock(id: "AAPL", symbol: "AAPL", name: "Apple", price: 100, priceChange: 0, description: "")
        viewModel = StockDetailViewModel(appState: mockAppState, stock: initialStock)
    }
    
    override func tearDown() {
        viewModel = nil
        mockAppState = nil
        super.tearDown()
    }
    
    func test_initialStockIsSetCorrectly() {
        let stock = viewModel.stock
        
        XCTAssertEqual(stock.symbol, "AAPL")
        XCTAssertEqual(stock.price, 100)
    }
    
    func test_updateIfNeeded_doesNothingIfNoUpdate() {
        let previousStock = viewModel.stock
        
        viewModel.updateIfNeeded()
        
        XCTAssertEqual(viewModel.stock.id, previousStock.id)
        XCTAssertEqual(viewModel.stock.price, previousStock.price)
    }
    
    func test_updateIfNeeded_updatesStockIfChanged() {
        let updatedStock = Stock(
            id: "AAPL",
            symbol: "AAPL",
            name: "Apple Inc",
            price: 120,
            priceChange: 20,
            description: "Updated"
        )
        mockAppState.update(stock: updatedStock)
        viewModel.updateIfNeeded()
        XCTAssertEqual(viewModel.stock.price, 120)
        XCTAssertEqual(viewModel.stock.name, "Apple Inc")
        XCTAssertEqual(viewModel.stock.description, "Updated")
    }
}
