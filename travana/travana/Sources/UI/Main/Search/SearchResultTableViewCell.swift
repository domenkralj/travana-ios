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
    
    // set result cell (station or route)
    public func setResultCell(result: SearchResultContainer){
        if result.resultType == SearchResultType.route {
            let route = result.route!
            self.busLineView.isHidden = false
            self.busLineView.setBackgroundColor(color: Colors.getColorFromString(string: route.routeNumber))
            self.busLineText.text = route.routeNumber
            self.mainText.text = route.routeName
        } else if result.resultType == SearchResultType.station {
            let station = result.station!
            if station.refId.toInt() % 2 == 0 {
                self.toCenterView.isHidden = false
            } else {
                self.toCenterView.isHidden = true
            }
            self.stationImageView.isHidden = false
            self.busLineView.isHidden = true
            self.mainText.text = station.name
        }
    }
}
