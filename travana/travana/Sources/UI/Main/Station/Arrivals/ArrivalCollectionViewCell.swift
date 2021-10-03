//
//  ArrivalCollectionViewCell.swift
//  travana
//
//  Created by Domen Kralj on 25/10/2020.
//  Copyright © 2020 Domen Kralj. All rights reserved.
//

import UIKit

class ArrivalCollectionViewCell: UICollectionViewCell {
    
    private static let LIVE_ICON_WIDTH = 15
    private let log: ConsoleLogger = LoggerFactory.getLogger(name: "ArrivalsTableViewCell")
    private var preferences = UserDefaults.standard
    
    @IBOutlet weak var isLiveIcon: UIImageView!
    @IBOutlet weak var etaMinText: UILabel!
    @IBOutlet weak var etaMinTextLeftConstraint: NSLayoutConstraint!
    
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
        self.contentView.setCornerRadius(cornerRadius: 17)
    }
    
    public func setCell(arrival: LppArrival2) {
        
        // check settings and show time depends on settings (14 min, 12:33)
        if preferences.object(forKey: Constants.ARRIVAL_TIME_MODE_KEY) == nil || preferences.string(forKey: Constants.ARRIVAL_TIME_MODE_KEY)! == Constants.ARRIVAL_TIME_MODE_MINUTES {
            self.etaMinText.text = String(arrival.etaMin) + " " + "min"
        } else {
            let dateFormatterPrint = DateFormatter()
            dateFormatterPrint.dateFormat = "HH:mm"
            self.etaMinText.text = dateFormatterPrint.string(from: Date().adding(minutes: arrival.etaMin))
        }
        
        switch arrival.type {
        case Lpp.PREDICTED:
            self.isLiveIcon.isHidden = false
            self.isLiveIcon.width(constant: CGFloat(ArrivalCollectionViewCell.LIVE_ICON_WIDTH))
            self.etaMinTextLeftConstraint.constant = -10
            self.contentView.setBackgroundColor(color: UIColor.MAIN_LIGHT_GREY_2)
        case Lpp.SCHEDULED:
            self.isLiveIcon.isHidden = true
            self.isLiveIcon.width(constant: 0)
            self.etaMinTextLeftConstraint.constant = 0
            self.contentView.setBackgroundColor(color: UIColor.MAIN_LIGHT_GREY_2)
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
            self.log.error("Catching unknown station type")
        }
        
    }
}
