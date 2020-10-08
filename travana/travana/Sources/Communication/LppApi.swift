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
    
    private static let ACTIVE_ROUTES_LINK = "https://data.lpp.si/api/route/active-routes"
    private static let STATIONS_DETAILS_LINK = "https://data.lpp.si/api/station/station-details"
    
    private let logger: ConsoleLogger = LoggerFactory.getLogger(name: "LppApi")
    private let httpClient: HttpClient
    private let decoder: JSONDecoder
    
    required init?(httpClient: HttpClient) {
        self.httpClient = httpClient
        self.decoder = JSONDecoder()
    }
    
    public func getStationsAndBusRoutes(callback: @escaping (Response<[String: Any]>) -> ()) {
        
        // the callback in the function paramater is called with success when both request are successfull
        // weather day data and weather week data
        var isOneRequestSuccessful = false
        var routes: Array<LppRoute>? = nil
        var stations: Array<LppStation>? = nil
        
        self.httpClient.getRequest(urlStr: LppApi.ACTIVE_ROUTES_LINK, params: nil, headers: nil) { [weak self] (error, response) in
        guard let self = self else { return }
        
            if error != nil {
                self.logger.error("Error retrieving routes data, error: \(error!)")
                let error = RequestError.RequestFailedException("Error retrieving routes data, error: \(error!)")
                callback(Response.failure(error: error))
                return
            }
            
            
            if response != nil {
                do {
                    routes = try self.decoder.decode(LppApiResponse<Array<LppRoute>>.self, from: Data(response!.utf8)).data
                    if isOneRequestSuccessful {
                        let routesAndStationsData = ["routes": routes!, "stations": stations!] as [String : Any]
                        callback(Response.success(data: routesAndStationsData))
                        return
                    } else {
                        isOneRequestSuccessful = true
                    }
                } catch let parseError {
                    self.logger.error("Error retrieving routes data, parsing json to object failed: \(parseError)")
                    let error = RequestError.RequestFailedException("Error retrieving routes data, parsing json to object failed: \(parseError)")
                    callback(Response.failure(error: error))
                    return
                }
            } else {
                self.logger.error("Error retrieving routes data, response is null")
                let error = RequestError.RequestFailedException("Error retrieving routes data, response is null")
                callback(Response.failure(error: error))
                return
            }
            // retrieve stations data
            //------------------------------------------------------------
            
            self.httpClient.getRequest(urlStr: LppApi.STATIONS_DETAILS_LINK, params: nil, headers: nil) { [weak self] (error, response) in
            guard let self = self else { return }
            
                if error != nil {
                    self.logger.error("Error retrieving stations data, error: \(error!)")
                    let error = RequestError.RequestFailedException("Error retrieving stations data, error: \(error!)")
                    callback(Response.failure(error: error))
                    return
                }
                
                
                if response != nil {
                    do {
                        stations = try self.decoder.decode(LppApiResponse<Array<LppStation>>.self, from: Data(response!.utf8)).data
                        if isOneRequestSuccessful {
                            let routesAndStationsData = ["routes": routes!, "stations": stations!] as [String : Any]
                            callback(Response.success(data: routesAndStationsData))
                            return
                        } else {
                            isOneRequestSuccessful = true
                        }
                    } catch let parseError {
                        self.logger.error("Error retrieving routes data, parsing json to object failed: \(parseError)")
                        let error = RequestError.RequestFailedException("Error retrieving routes data, parsing json to object failed: \(parseError)")
                        callback(Response.failure(error: error))
                        return
                    }
                } else {
                    self.logger.error("Error retrieving routes data, response is null")
                    let error = RequestError.RequestFailedException("Error retrieving routes data, response is null")
                    callback(Response.failure(error: error))
                }
            }
        }
    }
    
}
