//
//  GeoJsonShape.swift
//  travana
//
//  Created by Domen Kralj on 11/12/2021.
//  Copyright © 2021 Domen Kralj. All rights reserved.
//

import Foundation

class GeoJsonShape: Decodable, Encodable {

    public var type: String
    public var coordinates: [[Double]]
    public var bbox: [Double]
 
    private enum CodingKeys : String, CodingKey {
        case type = "type", coordinates = "coordinates", bbox = "bbox"
    }
    
}
