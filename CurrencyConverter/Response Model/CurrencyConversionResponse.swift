//
//  CurrencyConversionResponse.swift
//  CurrencyConverter
//
//  Created by Rajneesh 2020/12/12.
//  Copyright © 2020 Rajneesh. All rights reserved.
//

import Foundation

struct CurrencyConversionResponse: Codable {
    let result: Double?
    let success: Bool
    let error: ErrorResponse?
}
