//
//  Utils.swift
//  travana
//
//  Created by Domen Kralj on 19/10/2020.
//  Copyright © 2020 Domen Kralj. All rights reserved.
//

import Foundation
import CoreLocation

struct Utils {
    public static func degressToRadians(_ number: Double) -> Double {
        return number * .pi / 180
    }
    
    public static func routeNumberToInt(routeNumber: String) -> Int? {
        return Int(routeNumber.replacingOccurrences( of:"[^0-9]", with: "", options: .regularExpression))
    }
    
    public static func getDistanceBetweenCoordinates(latitude1: Double, longitude1: Double, latitude2: Double, longitude2: Double) -> Double {
        let coordinate1 = CLLocation(latitude: latitude1, longitude: longitude1)
        let coordinate2 = CLLocation(latitude: latitude2, longitude: longitude2)

        let distanceInMeters = coordinate1.distance(from: coordinate2)
        return distanceInMeters
    }
    
}
