//
//  RouteStationTableViewCell.swift
//  travana
//
//  Created by Domen Kralj on 15/10/2020.
//  Copyright © 2020 Domen Kralj. All rights reserved.
//

import UIKit

class RouteStationTableViewCell: UITableViewCell {
    
    @IBOutlet weak var stationNameText: UILabel!
    @IBOutlet weak var firstArrivalTimeText: UILabel!
    @IBOutlet weak var firstArrivalTimeContainer: UIView!
    @IBOutlet weak var firstArrivalTimeLiveIcon: UIImageView!
    @IBOutlet weak var secondArrivalTimeText: UILabel!
    @IBOutlet weak var secondArrivalTimeContainer: UIView!
    @IBOutlet weak var secondArrivalTimeLiveIcon: UIImageView!
    
    private let log: ConsoleLogger = LoggerFactory.getLogger(name: "RouteStationTableViewCell")
    
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }
    
    public func setCell(stationArrivals: LppStationArrival) {
        self.stationNameText.text = stationArrivals.name
        
        let arrivals = stationArrivals.arrivals
        
        // no arrivals
        if arrivals.count == 0 {
            self.firstArrivalTimeContainer.isHidden = true
            self.secondArrivalTimeContainer.isHidden = false
            self.secondArrivalTimeLiveIcon.isHidden = true
            self.secondArrivalTimeText.text = "/"
            return
        }
        
        // DETUR
        if arrivals[0].type == Lpp.DETUR {
            self.firstArrivalTimeContainer.isHidden = true
            self.secondArrivalTimeContainer.isHidden = false
            self.secondArrivalTimeLiveIcon.isHidden = true
            self.secondArrivalTimeText.font = UIFont.boldSystemFont(ofSize: self.secondArrivalTimeText.font.pointSize)
            self.secondArrivalTimeText.text = "detur".localized.uppercased()
            return
        }
        
        if arrivals.count == 1 {
            // just one arrival, hide first container
            self.firstArrivalTimeContainer.isHidden = true
            self.secondArrivalTimeContainer.isHidden = false
            
            let arrival = arrivals[0]
            
            self.firstArrivalTimeContainer.isHidden = true
            self.secondArrivalTimeContainer.isHidden = false
            
            switch arrival.type {
            case Lpp.PREDICTED:
                self.secondArrivalTimeText.text = String(arrival.etaMin) + " " + "min".localized
                self.secondArrivalTimeLiveIcon.isHidden = false
            case Lpp.SCHEDULED:
                self.secondArrivalTimeText.text = String(arrival.etaMin) + " " + "min".localized
                self.secondArrivalTimeLiveIcon.isHidden = true
            case Lpp.APPROACHING_STATION:
                self.secondArrivalTimeLiveIcon.isHidden = true
                self.secondArrivalTimeText.font = UIFont.boldSystemFont(ofSize: self.secondArrivalTimeText.font.pointSize)
                self.secondArrivalTimeText.text = "arrival".localized.uppercased()
            default:
                self.log.error("Catching unkown station type")  // hide both containers
                self.secondArrivalTimeContainer.isHidden = true
            }
            return
        } else if arrivals.count >= 2 {
            // just one arrival, hide first container
            self.firstArrivalTimeContainer.isHidden = false
            self.secondArrivalTimeContainer.isHidden = false
            
            let firstArrival = arrivals[0]
            
            switch firstArrival.type {
            case Lpp.PREDICTED:
                self.firstArrivalTimeText.text = String(firstArrival.etaMin) + " " + "min".localized
                self.firstArrivalTimeLiveIcon.isHidden = false
            case Lpp.SCHEDULED:
                self.firstArrivalTimeText.text = String(firstArrival.etaMin) + " " + "min".localized
                self.firstArrivalTimeLiveIcon.isHidden = true
            case Lpp.APPROACHING_STATION:
                self.firstArrivalTimeLiveIcon.isHidden = true
                self.firstArrivalTimeText.font = UIFont.boldSystemFont(ofSize: self.secondArrivalTimeText.font.pointSize)
                self.firstArrivalTimeText.text = "arrival".localized.uppercased()
            default:
                self.log.error("Catching unkown station type")  // hide both containers
                self.firstArrivalTimeContainer.isHidden = true
                self.secondArrivalTimeContainer.isHidden = true
            }
            
            let secondArrival = arrivals[1]
            
            switch secondArrival.type {
            case Lpp.PREDICTED:
                self.secondArrivalTimeText.text = String(secondArrival.etaMin) + " " + "min".localized
                self.secondArrivalTimeLiveIcon.isHidden = false
            case Lpp.SCHEDULED:
                self.secondArrivalTimeText.text = String(secondArrival.etaMin) + " " + "min".localized
                self.secondArrivalTimeLiveIcon.isHidden = true
            case Lpp.APPROACHING_STATION:
                self.secondArrivalTimeLiveIcon.isHidden = true
                self.secondArrivalTimeText.font = UIFont.boldSystemFont(ofSize: self.secondArrivalTimeText.font.pointSize)
                self.secondArrivalTimeText.text = "arrival".localized.uppercased()
            default:
                self.log.error("Catching unkown station type")  // hide both containers
                self.secondArrivalTimeContainer.isHidden = true
            }
            
            return
        }
    }
    
    // hide arrivals
    // called, when data is not updated - not show old data
    public func hideArrivals() {
        self.firstArrivalTimeContainer.isHidden = true
        self.secondArrivalTimeContainer.isHidden = true
    }
    
}
