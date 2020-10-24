//
//  LppTimetableTimes.swift
//  travana
//
//  Created by Domen Kralj on 24/10/2020.
//  Copyright © 2020 Domen Kralj. All rights reserved.
//

import Foundation

class LppTimetableRoute: Decodable, Encodable {
    
    public var timetable: [LppTimetableTimes]
    // on the backend "stations" is also avilible
    public var name: String
    public var parentName: String
    public var groupName: String
    public var routeNumberSuffix: String
    public var isGarage: Bool
    
    private enum CodingKeys : String, CodingKey {
        case timetable, name, parentName = "parent_name", groupName = "group_name", routeNumberSuffix = "route_number_suffix", isGarage = "is_garage"
    }    
}
