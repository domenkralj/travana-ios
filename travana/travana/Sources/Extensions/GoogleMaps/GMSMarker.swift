//
//  GMSMarker.swift
//  travana
//
//  Created by Domen Kralj on 17/10/2020.
//  Copyright © 2020 Domen Kralj. All rights reserved.
//

import Foundation
import GoogleMaps

extension GMSMarker {
    func setIconSize(scaledToSize newSize: CGSize) {
        UIGraphicsBeginImageContextWithOptions(newSize, false, 0.0)
        icon?.draw(in: CGRect(x: 0, y: 0, width: newSize.width, height: newSize.height))
        let newImage: UIImage = UIGraphicsGetImageFromCurrentImageContext()!
        UIGraphicsEndImageContext()
        icon = newImage
    }
}
