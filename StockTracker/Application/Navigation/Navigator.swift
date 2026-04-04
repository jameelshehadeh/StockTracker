//
//  Navigator.swift
//  StockTracker
//
//  Created by Jameel Shehadeh on 04/04/2026.
//

import SwiftUI

@Observable
@MainActor
final class Navigator {
    var path: NavigationPath = .init()
    
    func push(_ destination: any Hashable) {
        path.append(destination)
    }
    
    func pop() {
        if !path.isEmpty {
            path.removeLast()
        }
    }
}
