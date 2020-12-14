//
//  LiveExchangeResponse.swift
//  CurrencyConverter
//
//  Created by Rajneesh 2020/12/12
//  Copyright © 2020 Rajneesh. All rights reserved.
//

import Foundation

struct LiveExchangeResponse: Codable {
    let terms, privacy: String?
    let timestamp: Int?
    let source: String?
    var quotes: [String: Double]
    let success: Bool
    let error: ErrorResponse?
}

// Mark :- Currency Quote

struct ExchangeRate: Codable {
    let currency: String
    let rate: Double
}
