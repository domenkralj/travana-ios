//
//  DetourTableViewCell.swift
//  travana
//
//  Created by Domen Kralj on 20/10/2020.
//  Copyright © 2020 Domen Kralj. All rights reserved.
//

import UIKit

class DetourTableViewCell: UITableViewCell {

    @IBOutlet weak var dateText: UILabel!
    @IBOutlet weak var titleText: UILabel!
    
    override func awakeFromNib() {
        super.awakeFromNib()
        
        // remove cell highlight color when clicked
        self.selectionStyle = .none
    }
    
    public func setCell(dateString: String, titleString: String) {
        self.dateText.text = dateString
        self.titleText.text = titleString
    }
}
