//
//  LppBus.swift
//  travana
//
//  Created by Domen Kralj on 17/10/2020.
//  Copyright © 2020 Domen Kralj. All rights reserved.
//

import Foundation

class LppBus: Decodable, Encodable {
    
    public var routeNumber: String
    public var routeId: String
    public var tripId: String
    public var routeName: String
    public var destination: String
    public var busUnitId: String
    public var busName: String
    public var busTimestamp: String
    public var longitude: Double
    public var latitude: Double
    public var altitude: Double
    public var groundSpeed: Double
    public var cardinalDirection: Double
    
    private enum CodingKeys : String, CodingKey {
        case routeNumber = "route_number", routeId = "route_id", tripId = "trip_id", routeName = "route_name", destination, busUnitId = "bus_unit_id", busName = "bus_name", busTimestamp = "bus_timestamp", longitude, latitude, altitude, groundSpeed = "ground_speed", cardinalDirection = "cardinal_direction"
    }
}


