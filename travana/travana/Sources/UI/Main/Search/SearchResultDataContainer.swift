//
//  SearchResultContainer.swift
//  travana
//
//  Created by Domen Kralj on 11/10/2020.
//  Copyright © 2020 Domen Kralj. All rights reserved.
//

import Foundation

class SearchResultDataContainer {
    
    public var resultType: SearchResultType
    public var station: LppStation?
    public var route: LppRoute?
    
    init (station: LppStation) {
        self.resultType = SearchResultType.station
        self.station = station
    }
    
    init (route: LppRoute) {
        self.resultType = SearchResultType.route
        self.route = route
    }
}
