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
    private static let ARRIVALS_ON_ROUTE_LINK = "https://data.lpp.si/api/route/arrivals-on-route"
    private static let BUSES_ON_ROUTE_LINK = "https://data.lpp.si/api/bus/buses-on-route"
    
    private let logger: ConsoleLogger = LoggerFactory.getLogger(name: "LppApi")
    private let httpClient: HttpClient
    private let decoder: JSONDecoder
    
    required init?(httpClient: HttpClient) {
        self.httpClient = httpClient
        self.decoder = JSONDecoder()
    }
    
    // used for search
    public func getStationsAndBusRoutes(callback: @escaping (Response<[String: Any]>) -> ()) {
        
        // the callback in the function paramater is called with success when both request are successfull
        // weather day data and weather week data
        var isOneRequestSuccessful = false
        var routes: Array<LppRoute>? = nil
        var stations: Array<LppStation>? = nil
        
        self.httpClient.getRequest(urlStr: LppApi.ACTIVE_ROUTES_LINK, params: nil, headers: nil) { [weak self] (error, response) in
        guard let self = self else { return }
        
            if error != nil {
                let errorMessage = "Error retrieving routes data, error: \(error!)"
                self.logger.error(errorMessage)
                let error = RequestError.RequestFailedException(errorMessage)
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
                    let errorMessage = "Error retrieving routes data, parsing json to object failed: \(parseError)"
                    self.logger.error(errorMessage)
                    let error = RequestError.RequestFailedException(errorMessage)
                    callback(Response.failure(error: error))
                    return
                }
            } else {
                let errorMessage = "Error retrieving routes data, response is null"
                self.logger.error(errorMessage)
                let error = RequestError.RequestFailedException(errorMessage)
                callback(Response.failure(error: error))
                return
            }
            // retrieve stations data
            //------------------------------------------------------------
            
            self.httpClient.getRequest(urlStr: LppApi.STATIONS_DETAILS_LINK, params: nil, headers: nil) { [weak self] (error, response) in
            guard let self = self else { return }
            
                if error != nil {
                    let errorMessage = "Error retrieving stations data, error: \(error!)"
                    self.logger.error(errorMessage)
                    let error = RequestError.RequestFailedException(errorMessage)
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
                        let errorMessage = "Error retrieving routes data, parsing json to object failed: \(parseError)"
                        self.logger.error(errorMessage)
                        let error = RequestError.RequestFailedException(errorMessage)
                        callback(Response.failure(error: error))
                        return
                    }
                } else {
                    let errorMessage = "Error retrieving routes data, response is null"
                    self.logger.error(errorMessage)
                    let error = RequestError.RequestFailedException(errorMessage)
                    callback(Response.failure(error: error))
                }
            }
        }
    }
    
    public func getArrivalsOnRoute(tripId: String, callback: @escaping (Response<[LppStationArrival]>) -> ()) {
        
        let params = ["trip-id": tripId]
        
        var stationsArrivals: [LppStationArrival]? = nil
        
        self.httpClient.getRequest(urlStr: LppApi.ARRIVALS_ON_ROUTE_LINK, params: params, headers: nil) { [weak self] (error, response) in
        guard let self = self else { return }
            
            if error != nil {
                let errorMessage = "Error retrieving arrivals on route data, error: \(error!)"
                self.logger.error(errorMessage)
                let error = RequestError.RequestFailedException(errorMessage)
                callback(Response.failure(error: error))
                return
            }
            
            if response != nil {
                do {
                    stationsArrivals = try self.decoder.decode(LppApiResponse<[LppStationArrival]>.self, from: Data(response!.utf8)).data!
                    callback(Response.success(data: stationsArrivals!))
                } catch let parseError {
                    let errorMessage = "Error retrieving arrivals on route data, parsing json to object failed: \(parseError)"
                    self.logger.error(errorMessage)
                    let error = RequestError.RequestFailedException(errorMessage)
                    callback(Response.failure(error: error))
                    return
                }
            } else {
                let errorMessage = "Error retrieving arrivals on route data, response is null"
                self.logger.error(errorMessage)
                let error = RequestError.RequestFailedException(errorMessage)
                callback(Response.failure(error: error))
                return
            }
        }
    }
    
    public func getBusesOnRoute(routeGroupNumber: String, callback: @escaping (Response<[LppBus]>) -> ()) {
        
        let params = ["route-group-number": routeGroupNumber, "specific": "1"]
        
        let headers = ["apikey": "D2F0C381-6072-45F9-A05E-513F1515DD6A"]
        
        var busesOnRoute: [LppBus]? = nil
        
        self.httpClient.getRequest(urlStr: LppApi.BUSES_ON_ROUTE_LINK, params: params, headers: headers) { [weak self] (error, response) in
        guard let self = self else { return }
            
            if error != nil {
                let errorMessage = "Error retrieving buses on route data, error: \(error!)"
                self.logger.error(errorMessage)
                let error = RequestError.RequestFailedException(errorMessage)
                callback(Response.failure(error: error))
                return
            }
            
            if response != nil {
                do {
                    busesOnRoute = try self.decoder.decode(LppApiResponse<[LppBus]>.self, from: Data(response!.utf8)).data!
                    callback(Response.success(data: busesOnRoute!))
                } catch let parseError {
                    let errorMessage = "Error retrieving buses on route data, parsing json to object failed: \(parseError)"
                    self.logger.error(errorMessage)
                    let error = RequestError.RequestFailedException(errorMessage)
                    callback(Response.failure(error: error))
                    return
                }
            } else {
                let errorMessage = "Error retrieving buses on route data, response is null"
                self.logger.error(errorMessage)
                let error = RequestError.RequestFailedException(errorMessage)
                callback(Response.failure(error: error))
                return
            }
        }
    }
    
    public func getBusesAndArrivalsOnRoute(tripId: String, routeGroupNumber: String, callback: @escaping (Response<RouteDataContainer>) -> ()) {
        
        var isOneRequestSuccesful = false
        var routeStationArrivals: [LppStationArrival]? = nil
        var busesOnRoute: [LppBus]? = nil
        
        self.getArrivalsOnRoute(tripId: tripId) {
            (result) in
            if result.success {
                routeStationArrivals = result.data!
                if isOneRequestSuccesful {
                    let routeData = RouteDataContainer(routeStationArrivals: routeStationArrivals!, busesOnRoute: busesOnRoute!)
                    callback(Response.success(data: routeData))
                } else {
                    isOneRequestSuccesful = true
                }
            } else {
                let errorMessage = "Error retrieving arrivals on route data: \(result.error!)"
                let error = RequestError.RequestFailedException(errorMessage)
                callback(Response.failure(error: error))
                return
            }
        }
        
        self.getBusesOnRoute(routeGroupNumber: routeGroupNumber) {
            (result) in
            if result.success {
                busesOnRoute = result.data!
                if isOneRequestSuccesful {
                    let routeData = RouteDataContainer(routeStationArrivals: routeStationArrivals!, busesOnRoute: busesOnRoute!)
                    callback(Response.success(data: routeData))
                } else {
                    isOneRequestSuccesful = true
                }
            } else {
                let errorMessage = "Error retrieving buses on route data: \(result.error!)"
                let error = RequestError.RequestFailedException(errorMessage)
                callback(Response.failure(error: error))
                return
            }
        }
    }
    
}
