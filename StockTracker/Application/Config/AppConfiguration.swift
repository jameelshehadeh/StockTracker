//
//  AppConfiguration.swift
//  StockTracker
//
//  Created by Jameel Shehadeh on 04/04/2026.
//

import Foundation

final class AppConfiguration {
    
    lazy var socketBaseURL: URL = {
        guard let apiBaseURLString = Bundle.main.object(forInfoDictionaryKey: "SOCKET_BASE_URL") as? String, let url = URL(string: apiBaseURLString) else {
            fatalError("SocketBaseURL must not be empty in plist")
        }
        return url
    }()
    
}
