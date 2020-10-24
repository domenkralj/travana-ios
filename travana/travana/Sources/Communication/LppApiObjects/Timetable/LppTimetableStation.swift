//
//  LppTimetableStation.swift
//  travana
//
//  Created by Domen Kralj on 24/10/2020.
//  Copyright © 2020 Domen Kralj. All rights reserved.
//

import Foundation

class LppTimetableStation: Decodable, Encodable {
    
    public var refId: String
    public var name: String
    
    private enum CodingKeys: String, CodingKey {
        case refId = "ref_id", name
    }
}
