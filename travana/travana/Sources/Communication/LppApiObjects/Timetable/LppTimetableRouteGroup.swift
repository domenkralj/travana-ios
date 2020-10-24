//
//  LppTimetableRouteGroups.swift
//  travana
//
//  Created by Domen Kralj on 24/10/2020.
//  Copyright © 2020 Domen Kralj. All rights reserved.
//

import Foundation

class LppTimetableRouteGroup: Decodable, Encodable {
    
    public var routeGroupNumber: String
    public var routes: [LppTimetableRoute]
    
    private enum CodingKeys : String, CodingKey {
        case routeGroupNumber = "route_group_number", routes
    }
    
}
