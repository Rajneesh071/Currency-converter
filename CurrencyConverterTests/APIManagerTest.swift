//
//  CurrencyConverterTests.swift
//  CurrencyConverterTests
//
//  Created by Rajneesh on 14/12/20.
//  Copyright © 2020 Rajneesh. All rights reserved.
//

import XCTest
@testable import CurrencyConverter

class APIManagerTest: XCTestCase {
    
    var apiManager: APIManager!
    let session = MockURLSession()
    
    override func setUp() {
        super.setUp()
        apiManager = APIManager.sharedInstance
        apiManager.session = session
    }
    
    override func tearDown() {
        super.tearDown()
    }
    
    func test_get_resume_called() {
        
        let dataTask = MockURLSessionDataTask()
        session.nextDataTask = dataTask
        
        guard let url = URL(string: "https://mockurl") else {
            fatalError("URL can't be empty")
        }
        
        apiManager.requestApi(apiUrl: url.absoluteString, params: "") { (data, res, err) in
        }
        
        XCTAssert(dataTask.resumeWasCalled)
    }
    
    func test_get_should_return_data() {
        let expectedData = "{}".data(using: .utf8)
        
        session.nextData = expectedData
        
        var actualData: Data?
        apiManager.requestApi(apiUrl: "", params: "") { (data, res, errr) in
            actualData = data
        }
        
        XCTAssertNotNil(actualData)
    }
}

