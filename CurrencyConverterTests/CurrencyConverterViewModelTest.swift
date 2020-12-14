//
//  CurrencyConverterViewModelTest.swift
//  CurrencyConverterTests
//
//  Created by Rajneesh on 14/12/20.
//  Copyright © 2020 Rajneesh. All rights reserved.
//

import XCTest
@testable import CurrencyConverter

class CurrencyConverterViewModelTest: XCTestCase {
    var apiManagerNew: APIManager!
    let sessionNew = MockURLSession()
    
    override func setUp() {
        apiManagerNew = APIManager.sharedInstance
        apiManagerNew.session = sessionNew
    }

    override func tearDown() {
        apiManagerNew = nil
    }

    func testAvailableCurrenciesCount() {
        
        sessionNew.nextData = TestData.currencyListDate
        
        let viewModel = CurrencyConverterViewModel()
        viewModel.loadAllAvailableCurrencies()
        
        let expectation = XCTestExpectation()
        DispatchQueue.main.asyncAfter(deadline: .now() + 5) {
            
            XCTAssertTrue(viewModel.availableCurrencies!.count > 0, "Failed to get all currencies")
            expectation.fulfill()
        }
        wait(for: [expectation], timeout: 5.0)
    }
    
    func testAvailableCurrenciesRateCount() {
        
        sessionNew.nextData = TestData.currencyRateDate
        
        let viewModel = CurrencyConverterViewModel()
        
        viewModel.loadLiveCurrenciesExchangeRates()
        
        let expectation = XCTestExpectation()
        DispatchQueue.main.asyncAfter(deadline: .now() + 5) {
            
            XCTAssertTrue(viewModel.exchangeRates!.count > 0, "Failed to get all currencies exchange rate")

            expectation.fulfill()
        }
        wait(for: [expectation], timeout: 5.0)
    }
    
    func testConvertCurrencyAmount() {
        
        sessionNew.nextData = TestData.currencyRateDate
        
        let viewModel = CurrencyConverterViewModel()
        viewModel.loadLiveCurrenciesExchangeRates()
        let expectation = XCTestExpectation()
        DispatchQueue.main.asyncAfter(deadline: .now() + 5) {
            viewModel.convertCurrencyAmount(for: "INR", amount: 100)
            
            XCTAssertTrue(viewModel.convertedRates!.count > 0, "Failed to convert all currencies in desired currency rate")
            
            let currency = viewModel.convertedRates?.filter { $0.currency == "INR"}
            XCTAssertEqual(currency?.first?.rate, 100, "Some issue in currency conversion logic")
            expectation.fulfill()
        }
        wait(for: [expectation], timeout: 5.0)
    }
    
    
    func testPerformanceExample() {
        // This is an example of a performance test case.
        self.measure {
            // Put the code you want to measure the time of here.
        }
    }

}
