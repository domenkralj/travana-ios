//
//  Colors.swift
//  travana
//
//  Created by Domen Kralj on 28/09/2020.
//  Copyright © 2020 Domen Kralj. All rights reserved.
//

import Foundation
import UIKit


class Colors {
    
    // Returns UIColor from RGB code
      static func UIColorFromRGB(rgbValue: UInt) -> UIColor {
          return UIColor(
              red: CGFloat((rgbValue & 0xFF0000) >> 16) / 255.0,
              green: CGFloat((rgbValue & 0x00FF00) >> 8) / 255.0,
              blue: CGFloat(rgbValue & 0x0000FF) / 255.0,
              alpha: CGFloat(1.0)
          )
      }
}

extension UIColor {
    static var LIGHT_BLUE: UIColor {
        return Colors.UIColorFromRGB(rgbValue: 0xA3D8E7)
    }

    static var DIRTY_GREY: UIColor {
        return Colors.UIColorFromRGB(rgbValue: 0xEDECEA)
    }
    
    static var LIGHT_CYAN: UIColor {
        return Colors.UIColorFromRGB(rgbValue: 0xE0FFFF)
    }

    static var LIGHT_GREY: UIColor {
        return Colors.UIColorFromRGB(rgbValue: 0xE5E5E5)
    }
    
    static var METALLIC_THEME_SHADOW: UIColor {
        return Colors.UIColorFromRGB(rgbValue: 0x243443)
    }
    
    static var DARK_GREY: UIColor {
        return Colors.UIColorFromRGB(rgbValue: 0xD7D7D7)
    }
    
    static var LIGHTER_BLACK: UIColor {
        return Colors.UIColorFromRGB(rgbValue: 0x424240)
    }
    
    static var GREY: UIColor {
        return Colors.UIColorFromRGB(rgbValue: 0x505050)
    }

}

