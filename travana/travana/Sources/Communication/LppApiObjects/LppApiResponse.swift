//
//  LppApiResponse.swift
//  travana
//
//  Created by Domen Kralj on 08/10/2020.
//  Copyright © 2020 Domen Kralj. All rights reserved.
//

import Foundation

class LppApiResponse<T: Codable>: Codable {

    var success: Bool?
    var data: T?
    
    private enum CodingKeys : String, CodingKey {
        case success, data
    }
}
