//
//  Date.swift
//  travana
//
//  Created by Domen Kralj on 28/09/2020.
//  Copyright © 2020 Domen Kralj. All rights reserved.
//

import Foundation

extension Date {
    
    func currentTimeMillis() -> Int64 {
        return Int64(self.timeIntervalSince1970 * 1000)
    }
    
    static func getMillis(date: Date) -> Int64 {
        return Int64((date.timeIntervalSince1970 * 1000.0).rounded())
    }
}
