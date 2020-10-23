//
//  LppRouteOnStation.swift
//  travana
//
//  Created by Domen Kralj on 23/10/2020.
//  Copyright © 2020 Domen Kralj. All rights reserved.
//

import Foundation

class LppRouteOnStation: Decodable, Encodable {
    
    public var routeId: String
    public var routeNumber: String
    public var tripId: String
    public var routeName: String
    public var routeGroupName: String
    public var isGarage: Bool
    
    private enum CodingKeys : String, CodingKey {
        case routeId = "route_id", routeNumber = "route_number", tripId = "trip_id", routeName = "route_name", routeGroupName = "route_group_name", isGarage = "is_garage"
    }
}

