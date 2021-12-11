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
    public var route: LppRoute?
    
    init (routeStationArrivals: [LppStationArrival], busesOnRoute: [LppBus], route: LppRoute?) {
        self.routeStationArrivals = routeStationArrivals
        self.busesOnRoute = busesOnRoute
        self.route = route
    }
}
