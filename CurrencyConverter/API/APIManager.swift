//
//  APIConfig.swift
//  CurrencyConverter
//
//  Created by Rajneesh 2020/12/12
//  Copyright © 2020 Rajneesh. All rights reserved.
//

import Foundation
import UIKit

enum HttpMethod: String {
    case post = "POST"
    case get  = "GET"
}


class APIManager: NSObject {
    
    #if DEBUG
    //Property injection (For testing purpose)
    var session: URLSessionProtocol
    #endif
    
    static let sharedInstance: APIManager = APIManager()
    
    private override init() {
        let config = URLSessionConfiguration.default
        let session = URLSession(configuration: config)
        self.session = session
    }
    
    
    public func requestApi(httpMethod: String = HttpMethod.get.rawValue, apiUrl: String, params: String?, handler: @escaping (Data?, URLResponse?, Error?)-> Void) {
        
        if let url = URL.with(string: apiUrl, param: params) {
            
            var urlRequest = URLRequest(url: url)
            urlRequest.httpMethod = httpMethod
            let HTTPHeaderField_ContentType  = "Content-Type"
            let ContentType_ApplicationJson  = "application/json"
            urlRequest.timeoutInterval = 60.0
            urlRequest.cachePolicy = cachePolicy(for: url)
            urlRequest.addValue(ContentType_ApplicationJson, forHTTPHeaderField: HTTPHeaderField_ContentType)
            
            print(urlRequest)
            
            let dataTask = session.dataTask(with: urlRequest) { data, response, error in
                handler(data, response, error)
            }
            dataTask.resume()
        }
    }
}

extension APIManager {
    /* Load data from server only after 30 seconds
     Till that time , load from cache if available.
     */
    func cachePolicy(for url:URL) -> URLRequest.CachePolicy {
        let key = url.absoluteString
        if let date = UserDefaults.standard.object(forKey: key) as? Date {
            if let diff = Calendar.current.dateComponents([.minute], from: date, to: Date()).minute, diff > 30 {
                UserDefaults.standard.setValue(Date(), forKey: key)
                return URLRequest.CachePolicy.reloadIgnoringCacheData
            }
        } else {
            UserDefaults.standard.setValue(Date(), forKey: key)
        }
        
        return URLRequest.CachePolicy.returnCacheDataElseLoad
        
    }
}

extension TimeInterval {
    var minute: TimeInterval { return self * 60.0 }
    var hour: TimeInterval { return self * 60 * 60 }
}


protocol URLSessionProtocol {
    typealias DataTaskResult = (Data?, URLResponse?, Error?) -> Void
    
    func dataTask(with request: URLRequest, completionHandler: @escaping DataTaskResult) -> URLSessionDataTaskProtocol
}

protocol URLSessionDataTaskProtocol {
    func resume()
}


extension URLSession: URLSessionProtocol {
    func dataTask(with request: URLRequest, completionHandler: @escaping URLSessionProtocol.DataTaskResult) -> URLSessionDataTaskProtocol {
        return dataTask(with: request, completionHandler: completionHandler) as URLSessionDataTask
    }
}

extension URLSessionDataTask: URLSessionDataTaskProtocol {}
