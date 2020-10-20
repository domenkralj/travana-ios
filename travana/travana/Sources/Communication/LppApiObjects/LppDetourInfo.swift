//
//  LppDetourInfo.swift
//  travana
//
//  Created by Domen Kralj on 20/10/2020.
//  Copyright © 2020 Domen Kralj. All rights reserved.
//

import Foundation

class LppDetourInfo {
    
    public var title: String
    public var date: String
    public var moreDataUrl: String
    
    init (title: String, date: String, moreDataUrl: String) {
        self.title = title
        self.date = date
        self.moreDataUrl = moreDataUrl
    }
    
}
