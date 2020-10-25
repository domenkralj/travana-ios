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
    
    // 100 colors used for displaying lines
    private static var colors: [UIColor] = [
        Colors.UIColorFromRGB(rgbValue: 0x45e6a2),
        Colors.UIColorFromRGB(rgbValue: 0xbfe645),
        Colors.UIColorFromRGB(rgbValue: 0x8ce645),
        Colors.UIColorFromRGB(rgbValue: 0x45bee6),
        Colors.UIColorFromRGB(rgbValue: 0x45e6ad),
        Colors.UIColorFromRGB(rgbValue: 0xa0e645),
        Colors.UIColorFromRGB(rgbValue: 0x76e645),
        Colors.UIColorFromRGB(rgbValue: 0x45e6db),
        Colors.UIColorFromRGB(rgbValue: 0x45b6e6),
        Colors.UIColorFromRGB(rgbValue: 0x45e6b3),
        Colors.UIColorFromRGB(rgbValue: 0xe6b045),
        Colors.UIColorFromRGB(rgbValue: 0x75e645),
        Colors.UIColorFromRGB(rgbValue: 0xd6e645),
        Colors.UIColorFromRGB(rgbValue: 0x45e6a5),
        Colors.UIColorFromRGB(rgbValue: 0x45b1e6),
        Colors.UIColorFromRGB(rgbValue: 0x7fe645),
        Colors.UIColorFromRGB(rgbValue: 0x45e674),
        Colors.UIColorFromRGB(rgbValue: 0x7ae645),
        Colors.UIColorFromRGB(rgbValue: 0x46e645),
        Colors.UIColorFromRGB(rgbValue: 0xe4e645),
        Colors.UIColorFromRGB(rgbValue: 0x75e645),
        Colors.UIColorFromRGB(rgbValue: 0x45e67e),
        Colors.UIColorFromRGB(rgbValue: 0xdee645),
        Colors.UIColorFromRGB(rgbValue: 0x45e65b),
        Colors.UIColorFromRGB(rgbValue: 0x99e645),
        Colors.UIColorFromRGB(rgbValue: 0xe6dd45),
        Colors.UIColorFromRGB(rgbValue: 0x45e64d),
        Colors.UIColorFromRGB(rgbValue: 0xe3e645),
        Colors.UIColorFromRGB(rgbValue: 0x45e676),
        Colors.UIColorFromRGB(rgbValue: 0x55e645),
        Colors.UIColorFromRGB(rgbValue: 0x45e66d),
        Colors.UIColorFromRGB(rgbValue: 0x45e6de),
        Colors.UIColorFromRGB(rgbValue: 0x45e651),
        Colors.UIColorFromRGB(rgbValue: 0x45e685),
        Colors.UIColorFromRGB(rgbValue: 0x45e65c),
        Colors.UIColorFromRGB(rgbValue: 0x45e6bd),
        Colors.UIColorFromRGB(rgbValue: 0xa6e645),
        Colors.UIColorFromRGB(rgbValue: 0x57e645),
        Colors.UIColorFromRGB(rgbValue: 0xe3e645),
        Colors.UIColorFromRGB(rgbValue: 0x45e66a),
        Colors.UIColorFromRGB(rgbValue: 0x45e693),
        Colors.UIColorFromRGB(rgbValue: 0x45c7e6),
        Colors.UIColorFromRGB(rgbValue: 0xb0e645),
        Colors.UIColorFromRGB(rgbValue: 0x45e67a),
        Colors.UIColorFromRGB(rgbValue: 0x55e645),
        Colors.UIColorFromRGB(rgbValue: 0x45e6c5),
        Colors.UIColorFromRGB(rgbValue: 0x45e67c),
        Colors.UIColorFromRGB(rgbValue: 0x50e645),
        Colors.UIColorFromRGB(rgbValue: 0xd2e645),
        Colors.UIColorFromRGB(rgbValue: 0x45e6b1),
        Colors.UIColorFromRGB(rgbValue: 0x45bee6),
        Colors.UIColorFromRGB(rgbValue: 0x98e645),
        Colors.UIColorFromRGB(rgbValue: 0xc2e645),
        Colors.UIColorFromRGB(rgbValue: 0x45e6ae),
        Colors.UIColorFromRGB(rgbValue: 0x45b8e6),
        Colors.UIColorFromRGB(rgbValue: 0x45e6ab),
        Colors.UIColorFromRGB(rgbValue: 0x7fe645),
        Colors.UIColorFromRGB(rgbValue: 0x45e0e6),
        Colors.UIColorFromRGB(rgbValue: 0x56e645),
        Colors.UIColorFromRGB(rgbValue: 0x45dde6),
        Colors.UIColorFromRGB(rgbValue: 0xabe645),
        Colors.UIColorFromRGB(rgbValue: 0x4ee645),
        Colors.UIColorFromRGB(rgbValue: 0xe6da45),
        Colors.UIColorFromRGB(rgbValue: 0x45e679),
        Colors.UIColorFromRGB(rgbValue: 0xaae645),
        Colors.UIColorFromRGB(rgbValue: 0x45e6e4),
        Colors.UIColorFromRGB(rgbValue: 0xdde645),
        Colors.UIColorFromRGB(rgbValue: 0x45e64e),
        Colors.UIColorFromRGB(rgbValue: 0x45e6ae),
        Colors.UIColorFromRGB(rgbValue: 0x6ee645),
        Colors.UIColorFromRGB(rgbValue: 0xade645),
        Colors.UIColorFromRGB(rgbValue: 0x4be645),
        Colors.UIColorFromRGB(rgbValue: 0xe6da45),
        Colors.UIColorFromRGB(rgbValue: 0x45e68c),
        Colors.UIColorFromRGB(rgbValue: 0x45e6c6),
        Colors.UIColorFromRGB(rgbValue: 0x45e67f),
        Colors.UIColorFromRGB(rgbValue: 0xdde645),
        Colors.UIColorFromRGB(rgbValue: 0xa4e645),
        Colors.UIColorFromRGB(rgbValue: 0x45e6d0),
        Colors.UIColorFromRGB(rgbValue: 0x45e653),
        Colors.UIColorFromRGB(rgbValue: 0x63e645),
        Colors.UIColorFromRGB(rgbValue: 0x45e6a1),
        Colors.UIColorFromRGB(rgbValue: 0xb4e645),
        Colors.UIColorFromRGB(rgbValue: 0x45e673),
        Colors.UIColorFromRGB(rgbValue: 0x8be645),
        Colors.UIColorFromRGB(rgbValue: 0x45e69d),
        Colors.UIColorFromRGB(rgbValue: 0xa1e645),
        Colors.UIColorFromRGB(rgbValue: 0xe6e445),
        Colors.UIColorFromRGB(rgbValue: 0x9fe645),
        Colors.UIColorFromRGB(rgbValue: 0xdce645),
        Colors.UIColorFromRGB(rgbValue: 0x45bee6),
        Colors.UIColorFromRGB(rgbValue: 0x45e6ce),
        Colors.UIColorFromRGB(rgbValue: 0x72e645),
        Colors.UIColorFromRGB(rgbValue: 0x45e682),
        Colors.UIColorFromRGB(rgbValue: 0xe6cd45),
        Colors.UIColorFromRGB(rgbValue: 0xd2e645),
        Colors.UIColorFromRGB(rgbValue: 0x45cee6),
        Colors.UIColorFromRGB(rgbValue: 0x53e645),
        Colors.UIColorFromRGB(rgbValue: 0x45e6b0),
        Colors.UIColorFromRGB(rgbValue: 0x5be645)
    ]
    
    public static func getColorFromString(string: String) -> UIColor {
        let stringCode = string.replacingOccurrences( of:"[^0-9]", with: "", options: .regularExpression)
        return colors[stringCode.toInt()]
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
    
    static var MAIN_GREY: UIColor {
        return Colors.UIColorFromRGB(rgbValue: 0x212429)
    }
    
    static var MAIN_LIGHT_GREY: UIColor {
        return Colors.UIColorFromRGB(rgbValue: 0xC0C0C0)
    }
    
    static var MAIN_RED: UIColor {
        return Colors.UIColorFromRGB(rgbValue: 0xC72360)
    }
    
    static var MAIN_ORANGE: UIColor {
        return Colors.UIColorFromRGB(rgbValue: 0xFFBB33)
    }

}

class HSVColor {
    let h: Float // Angle in degrees [0,360] or -1 as Undefined
    let s: Float // Percent [0,1]
    let v: Float // Percent [0,1]
    
    init(h: Float, s: Float, v: Float) {
        self.h = h
        self.s = s
        self.v = v
    }
}

