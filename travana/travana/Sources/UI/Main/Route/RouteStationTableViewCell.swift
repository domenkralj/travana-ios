//
//  RouteStationTableViewCell.swift
//  travana
//
//  Created by Domen Kralj on 15/10/2020.
//  Copyright © 2020 Domen Kralj. All rights reserved.
//

import UIKit

class RouteStationTableViewCell: UITableViewCell {

    @IBOutlet weak var customCell: UILabel!
    
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }
    
}