//
//  LppArrival.swift
//  travana
//
//  Created by Domen Kralj on 15/10/2020.
//  Copyright © 2020 Domen Kralj. All rights reserved.
//

import Foundation

class LppStationArrival: Decodable, Encodable {
    
    public var name: String
    public var stationCode: String
    public var orderNumber: Int
    public var latitude: Double
    public var longitude: Double
    public var stationIntId: Int
    public var arrivals: [LppArrival]
    
    private enum CodingKeys : String, CodingKey {
        case name = "name", stationCode = "station_code", orderNumber = "order_no", latitude, longitude, stationIntId = "station_int_id", arrivals
    }
}

