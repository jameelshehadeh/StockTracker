//
//  StockListView.swift
//  StockTracker
//
//  Created by Jameel Shehadeh on 04/04/2026.
//


import SwiftUI

struct StockListView: View {
    
    @State private var viewModel: StockListViewModel
    @State private var navigator: Navigator = .init()
    
    init(viewModel: StockListViewModel) {
        _viewModel = State(initialValue: viewModel)
    }
    
    var body: some View {
        NavigationStack(path: $navigator.path) {
            List(viewModel.stocks) { stock in
                Button {
                    navigator.push(MainNavigationDestination.stockDetail(stock: stock))
                } label: {
                    StockRowView(stock: stock)
                }
                .buttonStyle(.plain)
            }
            .navigationDestination(for: MainNavigationDestination.self) { destination in
                switch destination {
                case .stockDetail(stock: let stock):
                    StockDetailView(viewModel: .init(stock: stock))
                }
            }
            .navigationTitle("Stocks")
            .safeAreaInset(edge: .bottom) {
                FeedControlButton.init(connectionState: viewModel.connectionState, startFeed: {
                    Task {
                        await viewModel.startFeed()
                    }
                }, stopFeed: {
                    viewModel.stopFeed()
                })
                .padding()
            }
            .toolbar {
                ToolbarItem(placement: .principal) {
                    SocketConnectionCustomView(connectionState: viewModel.connectionState)
                }
                ToolbarItem(placement: .navigationBarTrailing) {
                    CustomSortMenu(selectedSortType: viewModel.selectedSortOption) { selectedSortOption in
                        viewModel.sort(by: selectedSortOption)
                    }
                }
            }
            .task {
                await viewModel.onAppear()
            }
        }
        .environment(navigator)
    }
}
