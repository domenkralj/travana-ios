//
//  LppTimetableStation.swift
//  travana
//
//  Created by Domen Kralj on 24/10/2020.
//  Copyright © 2020 Domen Kralj. All rights reserved.
//

import Foundation

class LppTimetable: Decodable, Encodable {
    
    public var station: LppTimetableStation
    public var routeGroups: [LppTimetableRouteGroup]
    
    private enum CodingKeys : String, CodingKey {
        case station, routeGroups = "route_groups"
    }
    
}

