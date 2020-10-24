//
//  RoutesOnStationTableViewCell.swift
//  travana
//
//  Created by Domen Kralj on 23/10/2020.
//  Copyright © 2020 Domen Kralj. All rights reserved.
//

import UIKit

class RoutesOnStationTableViewCell: UITableViewCell {
    
    public var stationViewController: StationViewController!
    public var station: LppStation!
    private var route: LppRouteOnStation!
    
    @IBOutlet weak var routeNameText: UILabel!
    @IBOutlet weak var routeNumberView: UIView!
    @IBOutlet weak var routeNumberText: UILabel!
    
    override func awakeFromNib() {
        super.awakeFromNib()
        
        // remove cell highlight color when clicked
        self.selectionStyle = .none
    
        self.routeNumberView.setCornerRadius(cornerRadius: 14)
    }
    
    public func setCell(route: LppRouteOnStation) {
        self.route = route
        self.routeNumberText.text = route.routeNumber
        self.routeNumberView.setBackgroundColor(color: Colors.getColorFromString(string: route.routeNumber))
        self.routeNameText.text = route.routeGroupName
    }
    @IBAction func openTimetableButtonClicked(_ sender: UIButton) {
        // pass data to TimetableViewController and open TimetableViewController
        let lppRoute = LppRoute.getLppRoute(route: route)
        let vc = UIStoryboard.init(name: "Main", bundle: Bundle.main).instantiateViewController(withIdentifier: "TimetableViewController") as! TimetableViewController
        vc.route = lppRoute
        vc.station = self.station
        vc.modalPresentationStyle = .fullScreen
        self.stationViewController.present(vc, animated: true, completion: nil)
    }
    @IBAction func openRouteButtonClicked(_ sender: UIButton) {
        // pass route data to RouteViewController and open RouteViewController
        let lppRoute = LppRoute.getLppRoute(route: route)
        let vc = UIStoryboard.init(name: "Main", bundle: Bundle.main).instantiateViewController(withIdentifier: "RouteViewController") as! RouteViewController
        vc.route = lppRoute
        vc.modalPresentationStyle = .fullScreen
        self.stationViewController.present(vc, animated: true, completion: nil)
    }
}
