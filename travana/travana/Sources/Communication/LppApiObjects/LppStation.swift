//
//  LppStation.swift
//  travana
//
//  Created by Domen Kralj on 08/10/2020.
//  Copyright © 2020 Domen Kralj. All rights reserved.
//

import Foundation

class LppStation: Decodable, Encodable {
    
    private var intId: Int
    private var latitude: Double
    private var longitude: Double
    private var name: String
    private var refId: String
    private var routeGroupsOnStation: Array<String>
    
    private enum CodingKeys : String, CodingKey {
        case intId = "int_id", latitude, longitude, name, refId = "ref_id", routeGroupsOnStation = "route_groups_on_station"
    }
    
}
