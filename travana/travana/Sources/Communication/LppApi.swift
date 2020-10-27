//
//  LppApi.swift
//  travana
//
//  Created by Domen Kralj on 28/09/2020.
//  Copyright © 2020 Domen Kralj. All rights reserved.
//

import Foundation

// client for retirving data from https://data.lpp.si/doc
// class used for operating with lpp api backend (data)
class LppApi {
    
    private static let ACTIVE_ROUTES_LINK = "https://data.lpp.si/api/route/active-routes"
    private static let STATIONS_DETAILS_LINK = "https://data.lpp.si/api/station/station-details"
    private static let ARRIVALS_ON_ROUTE_LINK = "https://data.lpp.si/api/route/arrivals-on-route"
    private static let BUSES_ON_ROUTE_LINK = "https://data.lpp.si/api/bus/buses-on-route"
    private static let LPP_DETOURS_INFO = "https://www.lpp.si/javni-prevoz/obvozi"
    private static let ROUTES_ON_STATION_LINK = "https://data.lpp.si/api/station/routes-on-station"
    private static let TIMETABLE_LINK = "https://data.lpp.si/api/station/timetable"
    private static let ARRIVAL_LINK = "https://data.lpp.si/api/station/arrival"
    
    private let logger: ConsoleLogger = LoggerFactory.getLogger(name: "LppApi")
    private let httpClient: HttpClient
    private let decoder: JSONDecoder
    
    required init?(httpClient: HttpClient) {
        self.httpClient = httpClient
        self.decoder = JSONDecoder()
    }
    
    public func getStations(callback: @escaping (Response<[LppStation]>) -> ()) {
        
        var stations: [LppStation]? = nil
        
        self.httpClient.getRequest(urlStr: LppApi.STATIONS_DETAILS_LINK, params: nil, headers: nil) { [weak self] (error, response) in
        guard let self = self else { return }
        
            if error != nil {
                let errorMessage = "Error retrieving stations data, error: \(error!)"
                self.logger.error(errorMessage)
                let error = RequestError.RequestFailedException(errorMessage)
                callback(Response.failure(error: error))
                return
            }
            
            if response == nil {
                let errorMessage = "Error retrieving stations data, response is null"
                self.logger.error(errorMessage)
                let error = RequestError.RequestFailedException(errorMessage)
                callback(Response.failure(error: error))
                return
            }
            do {
                stations = try self.decoder.decode(LppApiResponse<[LppStation]>.self, from: Data(response!.utf8)).data
                callback(Response.success(data: stations!))
            } catch let parseError {
                let errorMessage = "Error retrieving stations data, parsing json to object failed: \(parseError)"
                self.logger.error(errorMessage)
                let error = RequestError.RequestFailedException(errorMessage)
                callback(Response.failure(error: error))
                return
            }
        }
    }
    
    public func getRoutes(callback: @escaping (Response<[LppRoute]>) -> ()) {
        
        var routes: [LppRoute]? = nil
        
        self.httpClient.getRequest(urlStr: LppApi.ACTIVE_ROUTES_LINK, params: nil, headers: nil) { [weak self] (error, response) in
        guard let self = self else { return }
        
            if error != nil {
                let errorMessage = "Error retrieving routes data, error: \(error!)"
                self.logger.error(errorMessage)
                let error = RequestError.RequestFailedException(errorMessage)
                callback(Response.failure(error: error))
                return
            }
            
            if response == nil {
                let errorMessage = "Error retrieving routes data, response is null"
                self.logger.error(errorMessage)
                let error = RequestError.RequestFailedException(errorMessage)
                callback(Response.failure(error: error))
                return
            }
            do {
                routes = try self.decoder.decode(LppApiResponse<[LppRoute]>.self, from: Data(response!.utf8)).data
                callback(Response.success(data: routes!))
            } catch let parseError {
                let errorMessage = "Error retrieving routes data, parsing json to object failed: \(parseError)"
                self.logger.error(errorMessage)
                let error = RequestError.RequestFailedException(errorMessage)
                callback(Response.failure(error: error))
                return
            }
        }
    }
    
    public func getStationsAndBusRoutes(callback: @escaping (Response<[String: Any]>) -> ()) {
        
        // the callback in the function paramater is called with success when both request are successfull
        // weather day data and weather week data
        var isOneRequestSuccessful = false
        var routes: [LppRoute]? = nil
        var stations: [LppStation]? = nil
        
        self.getStations() { (result) in
            if result.success {
                stations = result.data!
                if isOneRequestSuccessful {
                    let routesAndStationsData = ["routes": routes!, "stations": stations!] as [String : Any]
                    callback(Response.success(data: routesAndStationsData))
                    return
                } else {
                    isOneRequestSuccessful = true
                }
            } else {
                let errorMessage = "Error retrieving arrivals on route data: \(result.error!)"
                let error = RequestError.RequestFailedException(errorMessage)
                callback(Response.failure(error: error))
                return
            }
        }
        
        self.getRoutes() {(result) in
            if result.success {
                routes = result.data!
                if isOneRequestSuccessful {
                    let routesAndStationsData = ["routes": routes!, "stations": stations!] as [String : Any]
                    callback(Response.success(data: routesAndStationsData))
                    return
                } else {
                    isOneRequestSuccessful = true
                }
            } else {
                let errorMessage = "Error retrieving buses on route data: \(result.error!)"
                let error = RequestError.RequestFailedException(errorMessage)
                callback(Response.failure(error: error))
                return
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
            
            if response == nil {
                let errorMessage = "Error retrieving arrivals on route data, response is null"
                self.logger.error(errorMessage)
                let error = RequestError.RequestFailedException(errorMessage)
                callback(Response.failure(error: error))
                return
            }
            
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
            
            if response == nil {
                let errorMessage = "Error retrieving buses on route data, response is null"
                self.logger.error(errorMessage)
                let error = RequestError.RequestFailedException(errorMessage)
                callback(Response.failure(error: error))
                return
            }
            
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
        }
    }
    
    public func getRoutesOnStation(stationCode: String, callback: @escaping (Response<[LppRouteOnStation]>) -> ()) {
        
        let params = ["station-code": stationCode]
        
        var routesOnStation: [LppRouteOnStation]? = nil
        
        self.httpClient.getRequest(urlStr: LppApi.ROUTES_ON_STATION_LINK, params: params, headers: nil) { [weak self] (error, response) in
        guard let self = self else { return }
            
            if error != nil {
                let errorMessage = "Error retrieving routes on station data, error: \(error!)"
                self.logger.error(errorMessage)
                let error = RequestError.RequestFailedException(errorMessage)
                callback(Response.failure(error: error))
                return
            }
            
            if response == nil {
                let errorMessage = "Error retrieving routes on station data, response is null"
                self.logger.error(errorMessage)
                let error = RequestError.RequestFailedException(errorMessage)
                callback(Response.failure(error: error))
                return
            }
            
            do {
                routesOnStation = try self.decoder.decode(LppApiResponse<[LppRouteOnStation]>.self, from: Data(response!.utf8)).data!
                callback(Response.success(data: routesOnStation!))
            } catch let parseError {
                let errorMessage = "Error retrieving routes on station data, parsing json to object failed: \(parseError)"
                self.logger.error(errorMessage)
                let error = RequestError.RequestFailedException(errorMessage)
                callback(Response.failure(error: error))
                return
            }
        }
    }
    
    public func getTimetable(stationCode: String, routeGroupNumber: String, nextHours: Int, previousHours: Int, callback: @escaping (Response<LppTimetable>) -> ()) {
        
        let params = ["station-code": stationCode, "route-group-number": routeGroupNumber, "next-hours" : String(nextHours), "previous-hours" : String(previousHours)]
        
        var timetable: LppTimetable? = nil
        
        self.httpClient.getRequest(urlStr: LppApi.TIMETABLE_LINK, params: params, headers: nil) { [weak self] (error, response) in
        guard let self = self else { return }
            
            if error != nil {
                let errorMessage = "Error retrieving timetable data, error: \(error!)"
                self.logger.error(errorMessage)
                let error = RequestError.RequestFailedException(errorMessage)
                callback(Response.failure(error: error))
                return
            }
            
            if response == nil {
                let errorMessage = "Error retrieving timetable data, response is null"
                self.logger.error(errorMessage)
                let error = RequestError.RequestFailedException(errorMessage)
                callback(Response.failure(error: error))
                return
            }
            
            do {
                timetable = try self.decoder.decode(LppApiResponse<LppTimetable>.self, from: Data(response!.utf8)).data!
                callback(Response.success(data: timetable!))
            } catch let parseError {
                let errorMessage = "Error retrieving timetable data, parsing json to object failed: \(parseError)"
                self.logger.error(errorMessage)
                let error = RequestError.RequestFailedException(errorMessage)
                callback(Response.failure(error: error))
                return
            }
        }
    }
    
        public func getArrivals(stationCode: String, callback: @escaping (Response<[LppArrival2]>) -> ()) {
        
        let params = ["station-code": stationCode]
        
        var arrivals: [LppArrival2]? = nil
        
        self.httpClient.getRequest(urlStr: LppApi.ARRIVAL_LINK, params: params, headers: nil) { [weak self] (error, response) in
        guard let self = self else { return }
            
            if error != nil {
                let errorMessage = "Error retrieving arrival data, error: \(error!)"
                self.logger.error(errorMessage)
                let error = RequestError.RequestFailedException(errorMessage)
                callback(Response.failure(error: error))
                return
            }
            
            if response == nil {
                let errorMessage = "Error retrieving arrival data, response is null"
                self.logger.error(errorMessage)
                let error = RequestError.RequestFailedException(errorMessage)
                callback(Response.failure(error: error))
                return
            }
            
            do {
                arrivals = try self.decoder.decode(LppApiResponse<LppArrival2Wrapper>.self, from: Data(response!.utf8)).data!.arrivals
                callback(Response.success(data: arrivals!))
            } catch let parseError {
                let errorMessage = "Error retrieving arrival data, parsing json to object failed: \(parseError)"
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
    
    public func getDetoursInfo(callback: @escaping (Response<[LppDetourInfo]>) -> ()) {
        
        var detours: [LppDetourInfo]? = nil
        
        self.httpClient.getRequest(urlStr: LppApi.LPP_DETOURS_INFO, params: nil, headers: nil) { [weak self] (error, response) in
        guard let self = self else { return }
            
            if error != nil {
                let errorMessage = "Error retrieving detours info, error: \(error!)"
                self.logger.error(errorMessage)
                let error = RequestError.RequestFailedException(errorMessage)
                callback(Response.failure(error: error))
                return
            }
            
            if response == nil {
                let errorMessage = "Error retrieving detours info, response is null"
                self.logger.error(errorMessage)
                let error = RequestError.RequestFailedException(errorMessage)
                callback(Response.failure(error: error))
                return
            }
            
            do {
                detours = try self.getDetoursFromHtml(htmlString: response!)
                if detours == nil {
                    let errorMessage = "Error retrieving detours info, cannot extract detours from html string"
                    self.logger.error(errorMessage)
                    let error = RequestError.RequestFailedException(errorMessage)
                    callback(Response.failure(error: error))
                    return
                }
                callback(Response.success(data: detours!))
            } catch let Error {
                let errorMessage = "Error retrieving detours info parsing json to object failed: \(Error)"
                self.logger.error(errorMessage)
                let error = RequestError.RequestFailedException(errorMessage)
                callback(Response.failure(error: error))
                return
            }
        }
    }
    
    public func getDetoursFromHtml(htmlString: String) throws -> [LppDetourInfo]? {
        
        var s = htmlString
        
        let main_html_word = "views-field views-field-nothing";
        let main_html_word_title = "content__box--title";
        let main_html_word_time = "content__box--date";
        
        var detours: [LppDetourInfo] = []
        
        while s.contains(find: main_html_word) && s.contains(find: main_html_word_title) {
            s = s.substring(fromIndex: s.index(of: main_html_word)! + main_html_word.count)
            s = s.substring(fromIndex: s.index(of: main_html_word_title)! + main_html_word_title.count)
            
            let index = s.index(of: "href")
            if index == nil {
                return nil
            }
            s = s.substring(fromIndex: index!)
            
            let index2 = s.index(of: "href")
            if index2 == nil {
                return nil
            }
            let index3 = s.index(of: ">")
            if index3 == nil {
                return nil
            }
            let href = s.substring(fromIndex: index2! + 6, toIndex: index3! - 1)
            let index4 = s.index(of: href)
            if index4 == nil {
                return nil
            }
            s = s.substring(fromIndex: index4! + href.count)

            let index5 = s.index(of: ">")
            if index5 == nil {
                return nil
            }
            let index6 = s.index(of: "<")
            if index6 == nil {
                return nil
            }
            let title = s.substring(fromIndex: index5! + 1, toIndex: index6!)

            let index7 = s.index(of: title)
            if index7 == nil {
                return nil
            }
            s = s.substring(fromIndex: index7! + title.count)
            let index8 = s.index(of: main_html_word_time)
            if index8 == nil {
                return nil
            }
            s = s.substring(fromIndex: index8! + main_html_word_title.count + 1)

            let index9 = s.index(of: "<")
            if index9 == nil {
                return nil
            }
            let date = s.substring(fromIndex: 0, toIndex: index9!)

            let df = LppDetourInfo(title: title, date: date, moreDataUrl: href)

            detours.append(df)
        }
        return detours
    }
    
}
