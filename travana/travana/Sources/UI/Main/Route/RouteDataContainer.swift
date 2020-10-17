//
//  RouteContainer.swift
//  travana
//
//  Created by Domen Kralj on 17/10/2020.
//  Copyright © 2020 Domen Kralj. All rights reserved.
//

import Foundation

class RouteDataContainer {

    public var routeStationArrivals: [LppStationArrival]
    public var busesOnRoute: [LppBus]
    
    init (routeStationArrivals: [LppStationArrival], busesOnRoute: [LppBus]) {
        self.routeStationArrivals = routeStationArrivals
        self.busesOnRoute = busesOnRoute
    }
}
