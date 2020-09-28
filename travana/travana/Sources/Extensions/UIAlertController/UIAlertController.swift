//
//  UIAlertController.swift
//  travana
//
//  Created by Domen Kralj on 28/09/2020.
//  Copyright © 2020 Domen Kralj. All rights reserved.
//

import UIKit

extension UIAlertController {
    
    // Customize background color, corner radius and text color.
    func customize(titleAlignment: NSTextAlignment? = NSTextAlignment.center, messageAlignment: NSTextAlignment? = NSTextAlignment.center) {
        
        let titleStyle = NSMutableParagraphStyle()
        if let alignment = titleAlignment {
            titleStyle.alignment = alignment
        }
        let messageStyle = NSMutableParagraphStyle()
        if let alignment = messageAlignment {
            messageStyle.alignment = alignment
        }
        
        if let title = self.title {
            let attributedString = NSAttributedString(string: title, attributes: [
                NSAttributedString.Key.font : UIFont.NIKS_NORMAL(size: 18),
                NSAttributedString.Key.foregroundColor : UIColor.black,
                NSAttributedString.Key.paragraphStyle: titleStyle
            ])
            self.setValue(attributedString, forKey: "attributedTitle")
        }
        if let message = self.message {
            let attributedMessage = NSAttributedString(string: message, attributes: [
                NSAttributedString.Key.font : UIFont.NIKS_NORMAL(size: 16),
                NSAttributedString.Key.foregroundColor : UIColor.black,
                NSAttributedString.Key.paragraphStyle: messageStyle
            ])
            self.setValue(attributedMessage, forKey: "attributedMessage")
        }
        
        if let firstSubview = self.view.subviews.first, let alertControllerView = firstSubview.subviews.first {
            let subviews = alertControllerView.subviews
            for subview in subviews {
                subview.backgroundColor = UIColor.LIGHT_BLUE
                subview.layer.cornerRadius = 18
                subview.alpha = 1
                subview.tintColor = UIColor.black
            }
        }
        
        self.view.tintColor = UIColor.black
    }
}
