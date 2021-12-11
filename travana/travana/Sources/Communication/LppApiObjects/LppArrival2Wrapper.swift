//
//  LppArrival2Wrapper.swift
//  travana
//
//  Created by Domen Kralj on 25/10/2020.
//  Copyright © 2020 Domen Kralj. All rights reserved.
//

import Foundation

struct LppArrival2Wrapper: Decodable, Encodable {
    
    public var arrivals: [LppArrival2]
    // api also support "station" value
    
    private enum CodingKeys : String, CodingKey {
        case arrivals
    }
}
