//
//  Array.swift
//  travana
//
//  Created by Domen Kralj on 28/09/2020.
//  Copyright © 2020 Domen Kralj. All rights reserved.
//

import Foundation

extension Array where Element: Equatable {
    
    /// Removes trailing elements that fulfill suffix condition.
    public func removeTrailingElements(suffix: Element) -> [Element] {
        
        var array = self
        var previousValue = suffix
        
        for i in (0..<array.endIndex).reversed() {
            
            let value = array[i]
            guard value == previousValue else {
                break
            }
            
            array.remove(at: i)
            previousValue = value
        }
        
        return array
    }
}
