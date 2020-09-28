//
//  TravanaAppDataContainer.swift
//  travana
//
//  Created by Domen Kralj on 28/09/2020.
//  Copyright © 2020 Domen Kralj. All rights reserved.
//

import Foundation

// Holds the global state for all the application.
class TravanaAppDataContainer {
    
    private let httpClient: HttpClient
    private let lppApi: LppApi

    init() {
        self.httpClient = HttpClient()
        self.lppApi = LppApi(httpClient: httpClient)!
    }
    
    public func getHttpClient() -> HttpClient {
        return self.httpClient
    }
    
    public func getLppApi() -> LppApi {
        return self.lppApi
    }
}
