//
//  RouteContainer.swift
//  travana
//
//  Created by Domen Kralj on 17/10/2020.
//  Copyright © 2020 Domen Kralj. All rights reserved.
//

import Foundation
import CoreLocation

class RouteDataContainer {

    public var routeStationArrivals: [LppStationArrival]
    public var busesOnRoute: [LppBus]
    // public var routePath: [CLLocation]
    
    init (routeStationArrivals: [LppStationArrival], busesOnRoute: [LppBus]) {
        self.routeStationArrivals = routeStationArrivals
        self.busesOnRoute = busesOnRoute
        // self.routePath = routePath
    }
}
