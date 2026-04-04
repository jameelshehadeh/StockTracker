//
//  StockTrackerApp.swift
//  StockTracker
//
//  Created by Jameel Shehadeh on 02/04/2026.
//

import SwiftUI

@main
struct StockTrackerApp: App {
    
    private let container: DependencyContainer
    
    init() {
        container = DependencyContainer()
    }
    
    var body: some Scene {
        WindowGroup {
            container.flows.stockFlow.stockListScreen()
        }
    }
}
