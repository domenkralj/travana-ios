//
//  UIUtils.swift
//  travana
//
//  Created by Domen Kralj on 28/09/2020.
//  Copyright © 2020 Domen Kralj. All rights reserved.
//

import Foundation
import UIKit

class UIUtils {
    
    /// Show toast with text message and specific duration seconds. Toast background color is black, radius 16 and alpha 0.6
    static func showToast(controller: UIViewController, message: String, seconds: Double) {
        var alert: UIAlertController? = nil
        
        DispatchQueue.main.async {
            alert = UIAlertController(title: message, message: nil, preferredStyle: .alert)
            alert!.customize(titleAlignment: NSTextAlignment.center)
            
            // Show toast
            controller.present(alert!, animated: true)
        }
        
        // Hide/remove toast
        DispatchQueue.main.asyncAfter(deadline: DispatchTime.now() + seconds) {
            alert?.dismiss(animated: true)
        }
    }
}
