//
//  LppTimetableTimesUnit.swift
//  travana
//
//  Created by Domen Kralj on 24/10/2020.
//  Copyright © 2020 Domen Kralj. All rights reserved.
//

import Foundation

class LppTimetableTimes: Decodable, Encodable {
    
    public var hour: Int
    public var minutes: [Int]
    public var isCurrent: Bool
    
    private enum CodingKeys : String, CodingKey {
        case hour, minutes, isCurrent = "is_current"
    }
}

