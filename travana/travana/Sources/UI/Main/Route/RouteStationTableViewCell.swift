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
    
    @IBOutlet weak var upperStationLineView: UIView!
    @IBOutlet weak var stationDotView: UIView!
    @IBOutlet weak var downStationDotView: UIView!
    
    private let log: ConsoleLogger = LoggerFactory.getLogger(name: "RouteStationTableViewCell")
    
    override func awakeFromNib() {
        super.awakeFromNib()
        
        // create circle
        self.stationDotView.setCornerRadius(cornerRadius: 6)
        
        // remove cell highlight color when clicked
        self.selectionStyle = .none
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }
    
    public func setCell(stationArrivals: LppStationArrival, stationPostion: StationPositon, routeColor: UIColor, showJustStationName: Bool) {
        
        // set route color
        self.upperStationLineView.setBackgroundColor(color: routeColor)
        self.stationDotView.setBackgroundColor(color: routeColor)
        self.downStationDotView.setBackgroundColor(color: routeColor)
        
        // set staion lines depends on the station position
        if stationPostion == StationPositon.first {
            self.upperStationLineView.isHidden = true
            self.downStationDotView.isHidden = false
        } else if stationPostion == StationPositon.last {
            self.upperStationLineView.isHidden = false
            self.downStationDotView.isHidden = true
        } else {
            self.upperStationLineView.isHidden = false
            self.downStationDotView.isHidden = false
        }
        
        // add station to the label
        self.stationNameText.text = stationArrivals.name
        
        // data is outdated - remove arrivals times
        if showJustStationName {
            self.firstArrivalTimeContainer.isHidden = true
            self.secondArrivalTimeContainer.isHidden = true
            return
        }
        
        let arrivals = stationArrivals.arrivals
        
        // no arrivals
        if arrivals.count == 0 {
            self.firstArrivalTimeContainer.isHidden = true
            self.secondArrivalTimeContainer.isHidden = false
            self.secondArrivalTimeLiveIcon.isHidden = true
            self.secondArrivalTimeText.font = UIFont.systemFont(ofSize: self.secondArrivalTimeText.font.pointSize)
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
                self.secondArrivalTimeText.font = UIFont.systemFont(ofSize: self.secondArrivalTimeText.font.pointSize)
                self.secondArrivalTimeLiveIcon.isHidden = false
            case Lpp.SCHEDULED:
                self.secondArrivalTimeText.text = String(arrival.etaMin) + " " + "min".localized
                self.secondArrivalTimeText.font = UIFont.systemFont(ofSize: self.secondArrivalTimeText.font.pointSize)
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
                self.firstArrivalTimeText.font = UIFont.systemFont(ofSize: self.secondArrivalTimeText.font.pointSize)
                self.firstArrivalTimeLiveIcon.isHidden = false
            case Lpp.SCHEDULED:
                self.firstArrivalTimeText.text = String(firstArrival.etaMin) + " " + "min".localized
                self.firstArrivalTimeText.font = UIFont.systemFont(ofSize: self.secondArrivalTimeText.font.pointSize)
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
                self.secondArrivalTimeText.font = UIFont.systemFont(ofSize: self.secondArrivalTimeText.font.pointSize)
                self.secondArrivalTimeLiveIcon.isHidden = false
            case Lpp.SCHEDULED:
                self.secondArrivalTimeText.text = String(secondArrival.etaMin) + " " + "min".localized
                self.secondArrivalTimeText.font = UIFont.systemFont(ofSize: self.secondArrivalTimeText.font.pointSize)
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

enum StationPositon {
    case first, middle, last
}
