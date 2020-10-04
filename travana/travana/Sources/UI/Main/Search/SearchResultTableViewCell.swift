//
//  SearchResultTableViewCell.swift
//  travana
//
//  Created by Domen Kralj on 04/10/2020.
//  Copyright © 2020 Domen Kralj. All rights reserved.
//

import UIKit

class SearchResultTableViewCell: UITableViewCell {

    @IBOutlet weak var mainText: UILabel!
    @IBOutlet weak var toCenterView: UIView!
    @IBOutlet weak var busLineView: UIView!
    @IBOutlet weak var busLineText: UILabel!
    @IBOutlet weak var stationImageView: UIImageView!
    
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
        
        self.toCenterView.layer.cornerRadius = 13
        
        self.busLineView.layer.cornerRadius = 13
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)
        // Configure the view for the selected state
    }
    
    public func setResultCell(type: SearchResultType, line: String, mainText: String, toCenter: Bool){
        
        self.mainText.text = mainText
        
        if type == SearchResultType.busLine {
            self.busLineView.isHidden = false
            self.busLineText.text = line
        } else if type == SearchResultType.station {
            stationImageView.isHidden = false
            if (toCenter) {
                self.toCenterView.isHidden = false
            }
        }
    }
    
}
