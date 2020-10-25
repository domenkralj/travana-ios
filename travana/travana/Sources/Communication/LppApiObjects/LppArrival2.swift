//
//  LppArrival2.swift
//  travana
//
//  Created by Domen Kralj on 25/10/2020.
//  Copyright © 2020 Domen Kralj. All rights reserved.
//

import Foundation

class LppArrival2: Decodable, Encodable {
    
    public var routeId: String
    public var tripId: String
    public var vehicleId: String
    public var type: Int
    public var etaMin: Int
    public var routeName: String
    public var tripName: String
    public var depot: Int
    public var stations: LppArrival2Station
    
    private enum CodingKeys : String, CodingKey {
        case routeId = "route_id", tripId = "trip_id", vehicleId = "vehicle_id", type, etaMin = "eta_min", routeName = "route_name", tripName = "trip_name", depot, stations
    }
}
