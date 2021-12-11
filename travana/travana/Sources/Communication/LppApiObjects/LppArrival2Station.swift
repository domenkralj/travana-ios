//
//  LppArrivalStation.swift
//  travana
//
//  Created by Domen Kralj on 25/10/2020.
//  Copyright © 2020 Domen Kralj. All rights reserved.
//

import Foundation

struct LppArrival2Station: Decodable, Encodable {
    
    public var departure: String
    public var arrival: String

    private enum CodingKeys : String, CodingKey {
        case departure, arrival
    }
}
