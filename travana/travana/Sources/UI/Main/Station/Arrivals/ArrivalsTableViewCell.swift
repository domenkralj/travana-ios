//
//  ArrivalsTableViewCell.swift
//  travana
//
//  Created by Domen Kralj on 24/10/2020.
//  Copyright © 2020 Domen Kralj. All rights reserved.
//

import UIKit

class ArrivalsTableViewCell: UITableViewCell {

    @IBOutlet weak var customText: UILabel!
    
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
        
        // remove cell highlight color when clicked
        self.selectionStyle = .none
        self.contentView.setPadding(top: 15, left: 20, bottom: 15, right: 20)
    }    
}
