//
//  Double.swift
//  travana
//
//  Created by Domen Kralj on 29/10/2020.
//  Copyright © 2020 Domen Kralj. All rights reserved.
//

import Foundation

extension Double {
    
    // Rounds the double to decimal places value
    func rounded(toPlaces places:Int) -> Double {
        let divisor = pow(10.0, Double(places))
        return (self * divisor).rounded() / divisor
    }
}
