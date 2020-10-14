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
    
    // TODO - INIT COLORS
    private static var colors: [UIColor] = [
        UIColor(hue: 111.634, saturation: 0.7, brightness: 0.9, alpha: 1.0),
        UIColor(hue: 111.634, saturation: 0.7, brightness: 0.9, alpha: 1.0),
        UIColor(hue: 111.634, saturation: 0.7, brightness: 0.9, alpha: 1.0),
        UIColor(hue: 111.634, saturation: 0.7, brightness: 0.9, alpha: 1.0),
        UIColor(hue: 111.634, saturation: 0.7, brightness: 0.9, alpha: 1.0),
        UIColor(hue: 111.634, saturation: 0.7, brightness: 0.9, alpha: 1.0),
        UIColor(hue: 111.634, saturation: 0.7, brightness: 0.9, alpha: 1.0),
        UIColor(hue: 111.634, saturation: 0.7, brightness: 0.9, alpha: 1.0),
        UIColor(hue: 111.634, saturation: 0.7, brightness: 0.9, alpha: 1.0),
        UIColor(hue: 111.634, saturation: 0.7, brightness: 0.9, alpha: 1.0),
        UIColor(hue: 111.634, saturation: 0.7, brightness: 0.9, alpha: 1.0),
        UIColor(hue: 111.634, saturation: 0.7, brightness: 0.9, alpha: 1.0),
        UIColor(hue: 111.634, saturation: 0.7, brightness: 0.9, alpha: 1.0),
        UIColor(hue: 111.634, saturation: 0.7, brightness: 0.9, alpha: 1.0),
        UIColor(hue: 111.634, saturation: 0.7, brightness: 0.9, alpha: 1.0),
        UIColor(hue: 111.634, saturation: 0.7, brightness: 0.9, alpha: 1.0),
        UIColor(hue: 111.634, saturation: 0.7, brightness: 0.9, alpha: 1.0),
        UIColor(hue: 111.634, saturation: 0.7, brightness: 0.9, alpha: 1.0),
        UIColor(hue: 111.634, saturation: 0.7, brightness: 0.9, alpha: 1.0),
        UIColor(hue: 111.634, saturation: 0.7, brightness: 0.9, alpha: 1.0),
        UIColor(hue: 111.634, saturation: 0.7, brightness: 0.9, alpha: 1.0),
        UIColor(hue: 111.634, saturation: 0.7, brightness: 0.9, alpha: 1.0),
        UIColor(hue: 111.634, saturation: 0.7, brightness: 0.9, alpha: 1.0),
        UIColor(hue: 111.634, saturation: 0.7, brightness: 0.9, alpha: 1.0),
        UIColor(hue: 111.634, saturation: 0.7, brightness: 0.9, alpha: 1.0),
        UIColor(hue: 111.634, saturation: 0.7, brightness: 0.9, alpha: 1.0),
        UIColor(hue: 111.634, saturation: 0.7, brightness: 0.9, alpha: 1.0),
        UIColor(hue: 111.634, saturation: 0.7, brightness: 0.9, alpha: 1.0),
        UIColor(hue: 111.634, saturation: 0.7, brightness: 0.9, alpha: 1.0),
        UIColor(hue: 111.634, saturation: 0.7, brightness: 0.9, alpha: 1.0),
        UIColor(hue: 111.634, saturation: 0.7, brightness: 0.9, alpha: 1.0),
        UIColor(hue: 111.634, saturation: 0.7, brightness: 0.9, alpha: 1.0),
        UIColor(hue: 111.634, saturation: 0.7, brightness: 0.9, alpha: 1.0),
        UIColor(hue: 111.634, saturation: 0.7, brightness: 0.9, alpha: 1.0),
        UIColor(hue: 111.634, saturation: 0.7, brightness: 0.9, alpha: 1.0),
        UIColor(hue: 111.634, saturation: 0.7, brightness: 0.9, alpha: 1.0),
        UIColor(hue: 111.634, saturation: 0.7, brightness: 0.9, alpha: 1.0),
        UIColor(hue: 111.634, saturation: 0.7, brightness: 0.9, alpha: 1.0),
        UIColor(hue: 111.634, saturation: 0.7, brightness: 0.9, alpha: 1.0),
        UIColor(hue: 111.634, saturation: 0.7, brightness: 0.9, alpha: 1.0),
        UIColor(hue: 111.634, saturation: 0.7, brightness: 0.9, alpha: 1.0),
        UIColor(hue: 111.634, saturation: 0.7, brightness: 0.9, alpha: 1.0),
        UIColor(hue: 111.634, saturation: 0.7, brightness: 0.9, alpha: 1.0),
        UIColor(hue: 111.634, saturation: 0.7, brightness: 0.9, alpha: 1.0),
        UIColor(hue: 111.634, saturation: 0.7, brightness: 0.9, alpha: 1.0),
        UIColor(hue: 111.634, saturation: 0.7, brightness: 0.9, alpha: 1.0),
        UIColor(hue: 111.634, saturation: 0.7, brightness: 0.9, alpha: 1.0),
        UIColor(hue: 111.634, saturation: 0.7, brightness: 0.9, alpha: 1.0),
        UIColor(hue: 111.634, saturation: 0.7, brightness: 0.9, alpha: 1.0),
        UIColor(hue: 111.634, saturation: 0.7, brightness: 0.9, alpha: 1.0),
        UIColor(hue: 111.634, saturation: 0.7, brightness: 0.9, alpha: 1.0),
        UIColor(hue: 111.634, saturation: 0.7, brightness: 0.9, alpha: 1.0),
        UIColor(hue: 111.634, saturation: 0.7, brightness: 0.9, alpha: 1.0),
        UIColor(hue: 111.634, saturation: 0.7, brightness: 0.9, alpha: 1.0),
        UIColor(hue: 111.634, saturation: 0.7, brightness: 0.9, alpha: 1.0),
        UIColor(hue: 111.634, saturation: 0.7, brightness: 0.9, alpha: 1.0),
        UIColor(hue: 111.634, saturation: 0.7, brightness: 0.9, alpha: 1.0),
        UIColor(hue: 111.634, saturation: 0.7, brightness: 0.9, alpha: 1.0),
        UIColor(hue: 111.634, saturation: 0.7, brightness: 0.9, alpha: 1.0),
        UIColor(hue: 111.634, saturation: 0.7, brightness: 0.9, alpha: 1.0),
        UIColor(hue: 111.634, saturation: 0.7, brightness: 0.9, alpha: 1.0),
        UIColor(hue: 111.634, saturation: 0.7, brightness: 0.9, alpha: 1.0),
        UIColor(hue: 111.634, saturation: 0.7, brightness: 0.9, alpha: 1.0),
        UIColor(hue: 111.634, saturation: 0.7, brightness: 0.9, alpha: 1.0),
        UIColor(hue: 111.634, saturation: 0.7, brightness: 0.9, alpha: 1.0),
        UIColor(hue: 111.634, saturation: 0.7, brightness: 0.9, alpha: 1.0),
        UIColor(hue: 111.634, saturation: 0.7, brightness: 0.9, alpha: 1.0),
        UIColor(hue: 111.634, saturation: 0.7, brightness: 0.9, alpha: 1.0),
        UIColor(hue: 111.634, saturation: 0.7, brightness: 0.9, alpha: 1.0),
        UIColor(hue: 111.634, saturation: 0.7, brightness: 0.9, alpha: 1.0),
        UIColor(hue: 111.634, saturation: 0.7, brightness: 0.9, alpha: 1.0),
        UIColor(hue: 111.634, saturation: 0.7, brightness: 0.9, alpha: 1.0),
        UIColor(hue: 111.634, saturation: 0.7, brightness: 0.9, alpha: 1.0),
        UIColor(hue: 111.634, saturation: 0.7, brightness: 0.9, alpha: 1.0),
        UIColor(hue: 111.634, saturation: 0.7, brightness: 0.9, alpha: 1.0),
        UIColor(hue: 111.634, saturation: 0.7, brightness: 0.9, alpha: 1.0),
        UIColor(hue: 111.634, saturation: 0.7, brightness: 0.9, alpha: 1.0),
        UIColor(hue: 111.634, saturation: 0.7, brightness: 0.9, alpha: 1.0),
        UIColor(hue: 111.634, saturation: 0.7, brightness: 0.9, alpha: 1.0),
        UIColor(hue: 111.634, saturation: 0.7, brightness: 0.9, alpha: 1.0),
        UIColor(hue: 111.634, saturation: 0.7, brightness: 0.9, alpha: 1.0),
        UIColor(hue: 111.634, saturation: 0.7, brightness: 0.9, alpha: 1.0),
        UIColor(hue: 111.634, saturation: 0.7, brightness: 0.9, alpha: 1.0),
        UIColor(hue: 111.634, saturation: 0.7, brightness: 0.9, alpha: 1.0),
        UIColor(hue: 111.634, saturation: 0.7, brightness: 0.9, alpha: 1.0),
        UIColor(hue: 111.634, saturation: 0.7, brightness: 0.9, alpha: 1.0),
        UIColor(hue: 111.634, saturation: 0.7, brightness: 0.9, alpha: 1.0),
        UIColor(hue: 111.634, saturation: 0.7, brightness: 0.9, alpha: 1.0),
        UIColor(hue: 111.634, saturation: 0.7, brightness: 0.9, alpha: 1.0),
        UIColor(hue: 111.634, saturation: 0.7, brightness: 0.9, alpha: 1.0),
        UIColor(hue: 111.634, saturation: 0.7, brightness: 0.9, alpha: 1.0),
        UIColor(hue: 111.634, saturation: 0.7, brightness: 0.9, alpha: 1.0),
        UIColor(hue: 111.634, saturation: 0.7, brightness: 0.9, alpha: 1.0),
        UIColor(hue: 111.634, saturation: 0.7, brightness: 0.9, alpha: 1.0),
        UIColor(hue: 111.634, saturation: 0.7, brightness: 0.9, alpha: 1.0),
        UIColor(hue: 111.634, saturation: 0.7, brightness: 0.9, alpha: 1.0),
        UIColor(hue: 111.634, saturation: 0.7, brightness: 0.9, alpha: 1.0),
        UIColor(hue: 111.634, saturation: 0.7, brightness: 0.9, alpha: 1.0),
        UIColor(hue: 111.634, saturation: 0.7, brightness: 0.9, alpha: 1.0),
        UIColor(hue: 111.634, saturation: 0.7, brightness: 0.9, alpha: 1.0),
        UIColor(hue: 111.634, saturation: 0.7, brightness: 0.9, alpha: 1.0),
        UIColor(hue: 111.634, saturation: 0.7, brightness: 0.9, alpha: 1.0),
        UIColor(hue: 111.634, saturation: 0.7, brightness: 0.9, alpha: 1.0),
        UIColor(hue: 111.634, saturation: 0.7, brightness: 0.9, alpha: 1.0),
        UIColor(hue: 111.634, saturation: 0.7, brightness: 0.9, alpha: 1.0),
        UIColor(hue: 111.634, saturation: 0.7, brightness: 0.9, alpha: 1.0),
        UIColor(hue: 111.634, saturation: 0.7, brightness: 0.9, alpha: 1.0),
        UIColor(hue: 111.634, saturation: 0.7, brightness: 0.9, alpha: 1.0),
        UIColor(hue: 111.634, saturation: 0.7, brightness: 0.9, alpha: 1.0),
        UIColor(hue: 111.634, saturation: 0.7, brightness: 0.9, alpha: 1.0),
        UIColor(hue: 111.634, saturation: 0.7, brightness: 0.9, alpha: 1.0),
        UIColor(hue: 111.634, saturation: 0.7, brightness: 0.9, alpha: 1.0)
    ]
    
    public static func getColorFromString(string: String) -> UIColor {
        let stringCode = string.replacingOccurrences( of:"[^0-9]", with: "", options: .regularExpression)
        return colors[stringCode.toInt()]
    }


    private static func rgbToHsl(red:CGFloat, green:CGFloat, blue:CGFloat) -> (h:CGFloat, s:CGFloat, l:CGFloat){
            let r:CGFloat = red/255
            let g:CGFloat = green/255
            let b:CGFloat = blue/255
            print("r = \(r), g = \(g), b = \(b)")
            
            let Max:CGFloat = max(r, g, b)
            let Min:CGFloat = min(r, g, b)
     
            //h 0-360
            var h:CGFloat = 0
            if Max == Min {
                h = 0.0
            }else if Max == r && g >= b {
                h = 60 * (g-b)/(Max-Min)
            } else if Max == r && g < b {
                h = 60 * (g-b)/(Max-Min) + 360
            } else if Max == g {
                h = 60 * (b-r)/(Max-Min) + 120
            } else if Max == b {
                h = 60 * (r-g)/(Max-Min) + 240
            }
            print("h = \(h)")
            
            //l 0-1
            let l:CGFloat = (r + g + b) / 3
            print("l = \(l)")
            
            //s 0-1
            var s:CGFloat = 0
            if l == 0 || Max == Min {
                s = 0
            } else if l > 0 && l <= 0.5 {
                s = (Max - Min)/(2*l)
            } else if l > 0.5 {
                s = (Max - Min)/(2 - 2*l)
            }
            print("s = \(s)")
                
            return (h, s, l)
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

