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
                Button {
                    if viewModel.connectionState == .connected {
                        viewModel.stopFeed()
                    } else {
                        Task {
                            await viewModel.startFeed()
                        }
                    }
                } label: {
                    Text(viewModel.connectionState == .connected ? "Stop Feed" : "Start Feed")
                        .font(.headline)
                        .frame(maxWidth: .infinity)
                        .padding()
                        .background(viewModel.connectionState == .connected ? Color.red : Color.green)
                        .foregroundStyle(.white)
                        .cornerRadius(12)
                }
                .padding()
            }
            .toolbar {
                ToolbarItem(placement: .principal) {
                    connectionStatusView
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
    
    private var connectionStatusView: some View {
        HStack(spacing: 4) {
            Circle()
                .fill(viewModel.connectionState == .connected ? Color.green : Color.red)
                .frame(width: 10, height: 10)
            Text(viewModel.connectionState == .connected ? "Connected" : "Disconnected")
                .font(.caption)
        }
    }
    
    private var feedControlButton: some View {
        Button {
            if viewModel.connectionState == .connected {
                viewModel.stopFeed()
            } else {
                Task {
                    await viewModel.startFeed()
                }
            }
        } label: {
            Text(viewModel.connectionState == .connected ? "Stop Feed" : "Start Feed")
                .font(.headline)
        }
        .tint(viewModel.connectionState == .connected ? .red : .green)
    }
}
