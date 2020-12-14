//
//  ErrorResponse.swift
//  CurrencyConverter
//
//  Created by Rajneesh 2020/12/12.
//  Copyright © 2020 Rajneesh. All rights reserved.
//

import Foundation

struct ErrorResponse: Codable {
    let code: Int
    let info: String
}
