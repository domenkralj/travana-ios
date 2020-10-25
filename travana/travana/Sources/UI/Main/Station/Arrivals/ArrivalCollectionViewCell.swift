//
//  ArrivalCollectionViewCell.swift
//  travana
//
//  Created by Domen Kralj on 25/10/2020.
//  Copyright © 2020 Domen Kralj. All rights reserved.
//

import UIKit

class ArrivalCollectionViewCell: UICollectionViewCell {
    
    private static let LIVE_ICON_WIDTH = 11
    private let log: ConsoleLogger = LoggerFactory.getLogger(name: "ArrivalsTableViewCell")
    
    @IBOutlet weak var isLiveIcon: UIImageView!
    @IBOutlet weak var etaMinText: UILabel!
    @IBOutlet weak var etaMinTextLeftConstraint: NSLayoutConstraint!
    
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
        self.contentView.setBorder(borderWidth: 2, borderColor: UIColor.MAIN_LIGHT_GREY)
        self.contentView.setCornerRadius(cornerRadius: 17)
    }
    
    public func setCell(arrival: LppArrival2) {
        self.etaMinText.text = String(arrival.etaMin) + " " + "min"
        
        switch arrival.type {
        case Lpp.PREDICTED:
            self.isLiveIcon.isHidden = false
            self.isLiveIcon.width(constant: CGFloat(ArrivalCollectionViewCell.LIVE_ICON_WIDTH))
            self.etaMinTextLeftConstraint.constant = -8
            self.contentView.setBackgroundColor(color: UIColor.MAIN_GREY)
        case Lpp.SCHEDULED:
            self.isLiveIcon.isHidden = true
            self.isLiveIcon.width(constant: 0)
            self.etaMinTextLeftConstraint.constant = 0
            self.contentView.setBackgroundColor(color: UIColor.MAIN_GREY)
        case Lpp.APPROACHING_STATION:
            self.isLiveIcon.isHidden = true
            self.etaMinText.text = "arrival".localized.uppercased()
            self.etaMinTextLeftConstraint.constant = 0
            self.contentView.setBackgroundColor(color: UIColor.MAIN_RED)
        case Lpp.DETUR:
            self.isLiveIcon.isHidden = true
            self.etaMinText.text = "detour".localized.uppercased()
            self.etaMinTextLeftConstraint.constant = 0
            self.contentView.setBackgroundColor(color: UIColor.MAIN_ORANGE)
        default:
            self.log.error("Catching unkown station type")  // hide both containers
        }
        
    }
}
