//
//  TestData.swift
//  CurrencyConverterTest
//
//  Created by Rajneesh on 14/12/20.
//  Copyright © 2020 Rajneesh. All rights reserved.
//

import Foundation
@testable import CurrencyConverter

struct TestData {
    static let currencyListDate : Data = {
        let url = Bundle.main.url(forResource: "currency", withExtension: "json")!
        let data = try! Data(contentsOf: url)
        return data
    }()
    static let currencyRateDate : Data = {
        let url = Bundle.main.url(forResource: "currencyRate", withExtension: "json")!
        let data = try! Data(contentsOf: url)
        return data
    }()
    
}
