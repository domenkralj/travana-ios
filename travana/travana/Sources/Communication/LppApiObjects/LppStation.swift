//
//  LppStation.swift
//  travana
//
//  Created by Domen Kralj on 08/10/2020.
//  Copyright © 2020 Domen Kralj. All rights reserved.
//

import Foundation

struct LppStation: Decodable, Encodable {
    
    public var intId: Int
    public var latitude: Double
    public var longitude: Double
    public var name: String
    public var refId: String
    public var routeGroupsOnStation: [String]?
    
    private enum CodingKeys : String, CodingKey {
        case intId = "int_id", latitude, longitude, name, refId = "ref_id", routeGroupsOnStation = "route_groups_on_station"
    }
    
    init(intId: Int, latitude: Double, longitude: Double, name: String, refId: String, routeGroupsOnStation: [String]) {
        self.intId = intId
        self.latitude = latitude
        self.longitude = longitude
        self.name = name
        self.refId = refId
        self.routeGroupsOnStation = routeGroupsOnStation
    }
    
}
