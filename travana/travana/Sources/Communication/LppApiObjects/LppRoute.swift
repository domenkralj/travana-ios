//
//  LppRoute.swift
//  travana
//
//  Created by Domen Kralj on 08/10/2020.
//  Copyright © 2020 Domen Kralj. All rights reserved.
//

import Foundation

class LppRoute: Decodable, Encodable {
    
    private var tripId: String
    private var routeId: String
    private var routeNumber: String
    private var routeName: String
    private var shortRouteName: String
    private var tripIntId: Int
    
    private enum CodingKeys : String, CodingKey {
        case tripId = "trip_id", routeId = "route_id", routeNumber = "route_number", routeName = "route_name", shortRouteName = "short_route_name", tripIntId = "trip_int_id"
    }
    
}
