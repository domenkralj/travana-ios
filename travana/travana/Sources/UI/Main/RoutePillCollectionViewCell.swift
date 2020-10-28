//
//  RoutePillCollectionViewCell.swift
//  travana
//
//  Created by Domen Kralj on 28/10/2020.
//  Copyright © 2020 Domen Kralj. All rights reserved.
//

import UIKit

class RoutePillCollectionViewCell: UICollectionViewCell {

    @IBOutlet weak var routeText: UILabel!
    
    override func awakeFromNib() {
        super.awakeFromNib()
        
        self.setCornerRadius(cornerRadius: 10)
    }
    
    public func setCell(routeNumber: String) {
        self.routeText.text = routeNumber
        
        self.setBackgroundColor(color: Colors.getColorFromString(string: routeNumber))
    }

}
