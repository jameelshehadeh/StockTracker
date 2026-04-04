//
//  StockListView.swift
//  StockTracker
//
//  Created by Jameel Shehadeh on 04/04/2026.
//


import SwiftUI

struct StockListView: View {
    
    @State private var viewModel: StockListViewModel
    
    init(viewModel: StockListViewModel) {
        _viewModel = State(initialValue: viewModel)
    }
    
    var body: some View {
        NavigationStack {
            List(viewModel.stocks) { stock in
                Button {
                    
                } label: {
                    StockRowView(stock: stock)
                }
                .buttonStyle(.plain)
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
    }
}
