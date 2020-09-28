//
//  HttpClient.swift
//  travana
//
//  Created by Domen Kralj on 28/09/2020.
//  Copyright © 2020 Domen Kralj. All rights reserved.
//

import Foundation
import SwiftyJSON

/// - HttpClient class provides HTTP request methods for GET and POST requests.
class HttpClient {
    
    private static let DEFAULT_TIMEOUT: Int = 10 // seconds
    private let log: ConsoleLogger = LoggerFactory.getLogger(name: "HttpClientLog")
    
    init() {}

    func getRequest(urlStr: String, params: [String : String]?, headers: [String : String]?, timeout: Int = HttpClient.DEFAULT_TIMEOUT, callback: @escaping (Error?, String?) -> Void) {
        
        var queryItems: Array<URLQueryItem> = []
        if let paramsDictionary = params {
            for (name, value) in paramsDictionary {
                queryItems.append(URLQueryItem(name: name, value: value))
            }
        }
        
        var urlComps = URLComponents(string: urlStr)!
        urlComps.queryItems = queryItems
        
        guard let url = urlComps.url else {
            callback(HttpError.InvalidUrl(url: urlStr), nil)
            return
        }
        
        var request = URLRequest(url: url)
        request.httpMethod = "GET"
        request.timeoutInterval = Double(timeout)
        request.addValue("application/json", forHTTPHeaderField: "Content-Type")

        if let headerDictionary = headers {
            for (key, value) in headerDictionary {
                request.addValue(value, forHTTPHeaderField: key)
            }
        }
        let session = URLSession.shared
        self.executeHttpRequest(request: request, session: session, callback: callback)
    }
    /// Mark: - POST REQUESTS

    /// - POST req for JSON data
    func postRequest(urlStr: String, reqJson: JSON, timeout: Int = HttpClient.DEFAULT_TIMEOUT, callback: @escaping (Error?, String?) -> Void) {
        guard let url = URL(string: urlStr) else {
            callback(HttpError.InvalidUrl(url: urlStr), nil)
            return
        }
        var request = URLRequest(url: url)
        request.httpMethod = "POST"
        request.timeoutInterval = Double(timeout)
        request.addValue("application/json", forHTTPHeaderField: "Content-Type")

        do {
            request.httpBody = try reqJson.rawData()
        } catch let error {
            self.log.error("Error setting JSON request as HTTP request body.", e: error)
            callback(error, "Error setting JSON request as HTTP request body.")
            return
        }
        let session = URLSession.shared
        self.executeHttpRequest(request: request, session: session, callback: callback)
    }
  
    /// - Execute request with JSON response
    private func executeHttpRequest(request: URLRequest, session: URLSession, callback: @escaping (Error?, String?) -> Void) {
        let task = session.dataTask(with: request, completionHandler: { (data, response, error) -> Void in
            if let error = error {
                self.log.debug(error.localizedDescription)
                callback(error, nil)
                return
            }

            guard let data = data else {
                if error != nil {
                    callback(error, nil)
                } else {
                    callback(HttpError.NoDataError, nil)
                }
                return
            }

            if let response = response as? HTTPURLResponse {
                if 200...299 ~= response.statusCode {
                    callback(nil, String(data: data, encoding: .utf8))
                } else {
                    if let url = request.url?.absoluteString {
                        callback(RequestError.RequestFailedException("HTTP request to \(url) failed with status code: \(response.statusCode)"), "Message: \(String(describing: String(data: data, encoding: .utf8))).")
                    } else {
                        callback(RequestError.RequestFailedException("HTTP request to unknown host failed with status code: \(response.statusCode)"), "Message: \(String(describing: String(data: data, encoding: .utf8))).")
                    }
                }
            } else {
                self.log.debug("Invalid response object in HTTP request")
                callback(HttpError.ObjectIsNotResponse, nil)
            }
        })
        task.resume()
    }
}

