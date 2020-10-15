//
//  UIView.swift
//  travana
//
//  Created by Domen Kralj on 28/09/2020.
//  Copyright © 2020 Domen Kralj. All rights reserved.
//

import Foundation
import UIKit

extension UIView {
    
    /// Method for setting custom UIView height.
    func height(constant: CGFloat) {
        self.setConstraint(value: constant, attribute: .height)
    }

    /// Method for setting custom UIView width.
    func width(constant: CGFloat) {
        self.setConstraint(value: constant, attribute: .width)
    }
    
    func setBackgroundColor(color: UIColor) {
        self.layer.backgroundColor = color.cgColor
    }
    
    func setCornerRadius(cornerRadius: CGFloat) {
        self.layer.cornerRadius = cornerRadius
    }

    /// Method for removing current constraints from UIView.
    private func removeConstraint(attribute: NSLayoutConstraint.Attribute) {
        constraints.forEach {
            if $0.firstAttribute == attribute {
                removeConstraint($0)
            }
        }
    }
    
    /// Method for setting new constraings to UIView.
    private func setConstraint(value: CGFloat, attribute: NSLayoutConstraint.Attribute) {
        self.removeConstraint(attribute: attribute)
        let constraint =
            NSLayoutConstraint(item: self,
                               attribute: attribute,
                               relatedBy: NSLayoutConstraint.Relation.equal,
                               toItem: nil,
                               attribute: NSLayoutConstraint.Attribute.notAnAttribute,
                               multiplier: 1,
                               constant: value)
        self.addConstraint(constraint)
    }
    
    /// Method for retireving parent UIViewController of UIView.
    func findParentViewController() -> UIViewController? {
        if let nextResponder = self.next as? UIViewController {
            return nextResponder
        } else if let nextResponder = self.next as? UIView {
            return nextResponder.findParentViewController()
        } else {
            return nil
        }
    }
    
}
