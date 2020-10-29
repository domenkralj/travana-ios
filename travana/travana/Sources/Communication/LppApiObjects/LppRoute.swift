//
//  LppRoute.swift
//  travana
//
//  Created by Domen Kralj on 08/10/2020.
//  Copyright © 2020 Domen Kralj. All rights reserved.
//

import Foundation

class LppRoute: Decodable, Encodable {
    
    public var tripId: String
    public var routeId: String
    public var routeNumber: String
    public var routeName: String
    public var shortRouteName: String?
    public var tripIntId: Int?
    
    private enum CodingKeys : String, CodingKey {
        case tripId = "trip_id", routeId = "route_id", routeNumber = "route_number", routeName = "route_name", shortRouteName = "short_route_name", tripIntId = "trip_int_id"
    }
    
    init(routeId: String, routeNumber: String, tripId: String, routeName: String, shortRouteName: String) {
        self.routeId = routeId
        self.routeNumber = routeNumber
        self.tripId = tripId
        self.routeName = routeName
        self.shortRouteName = shortRouteName
    }
    
    private init(routeId: String, routeNumber: String, tripId: String, routeName: String?, routeGroupName: String) {
        self.routeId = routeId
        self.routeNumber = routeNumber
        self.tripId = tripId
        self.routeName = routeGroupName
        self.shortRouteName = routeName
    }
    
    public static func getLppRoute(route: LppRouteOnStation) -> LppRoute {
        return LppRoute(routeId: route.routeId, routeNumber: route.routeNumber, tripId: route.tripId, routeName: route.routeName, routeGroupName: route.routeGroupName)
    }
}
