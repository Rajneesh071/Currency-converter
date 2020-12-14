//
//  CurrencyListResponse.swift
//  CurrencyConverter
//
//  Created by Rajneesh 2020/12/12.
//  Copyright © 2020 Rajneesh. All rights reserved.
//

import Foundation

struct CurrencyListResponse: Codable {
    let currencies: [String: String]?
    let success: Bool
    let error: ErrorResponse?
}

// Mark :- Country Currency

struct CountryCurrency: Codable {
    let code: String
    let name: String
}
