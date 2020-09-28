//
//  LppApi.swift
//  travana
//
//  Created by Domen Kralj on 28/09/2020.
//  Copyright © 2020 Domen Kralj. All rights reserved.
//

import Foundation

// class used for operating with lpp api backend (data)
class LppApi {
    
    private let logger: ConsoleLogger = LoggerFactory.getLogger(name: "WeatherApi")
    private let httpClient: HttpClient
    private let decoder: JSONDecoder
    
    required init?(httpClient: HttpClient) {
        self.httpClient = httpClient
        self.decoder = JSONDecoder()
    }
}
