//
//  Utils.swift
//  travana
//
//  Created by Domen Kralj on 19/10/2020.
//  Copyright © 2020 Domen Kralj. All rights reserved.
//

import Foundation

struct Utils {
    public static func degressToRadians(_ number: Double) -> Double {
        return number * .pi / 180
    }
    
    public static func routeNumberToInt(routeNumber: String) -> Int? {
        return Int(routeNumber.replacingOccurrences( of:"[^0-9]", with: "", options: .regularExpression))
    }
    
}
