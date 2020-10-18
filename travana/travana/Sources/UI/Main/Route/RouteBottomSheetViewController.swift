//
//  RouteBottomSheetViewController.swift
//  travana
//
//  Created by Domen Kralj on 15/10/2020.
//  Copyright © 2020 Domen Kralj. All rights reserved.
//

import UIKit

// Bottom sheet view, which can be pulled up
// It is used for showing stations and arrivals in the bus route
class RouteBottomSheetViewController: UIViewController {

    public var route: LppRoute? = nil
    public var stationArrivals: [LppStationArrival]? = nil
    private let logger: ConsoleLogger = LoggerFactory.getLogger(name: "RouteBottomSheetViewController")
    
    @IBOutlet weak var handleArea: UIView!
    @IBOutlet weak var routeName: MovingLabel!
    @IBOutlet weak var routeStationsTableView: UITableView!
    @IBOutlet weak var holderImageView: UIView!
    @IBOutlet weak var routeNumberView: UIView!
    @IBOutlet weak var routeNumberText: UILabel!
    
    // when view is loaded.
    override func viewDidLoad() {
        super.viewDidLoad()
        
        // returs if lpp route data is nil
        if route == nil {
            self.logger.info("Opening route view controller without lpp route data or stations data")
            self.dismiss(animated: false, completion: nil)
        }
        
        // set corner radius to the holderImageView
        self.holderImageView.setCornerRadius(cornerRadius: 3)
        
        // set corner radius to the routeNumberView
        self.routeNumberView.setCornerRadius(cornerRadius: 14)
        
        // set routeStationsTableView and set data source for routeStationsTableView
        self.routeStationsTableView.dataSource = self
        self.routeStationsTableView.register(UINib(nibName: "RouteStationTableViewCell", bundle: nil), forCellReuseIdentifier: "RouteStationTableViewCell")
        
        // set route labels
        self.routeName.text = route!.routeName + "     "    // spaces on the end separates the start of the label with the end (moving label)
        self.routeNumberText.text = route!.routeNumber
        self.routeNumberView.setBackgroundColor(color: Colors.getColorFromString(string: route!.routeNumber))
    }
    
    public func setStationsArrivals(stationArrivals: [LppStationArrival]) {
        self.stationArrivals = stationArrivals
        DispatchQueue.main.async() {
            self.routeStationsTableView.reloadData()
        }
    }
    
    // called when back button is clicked
    @IBAction func backButtonClicked(_ sender: Any) {
        self.dismiss(animated: true, completion: nil)
    }
    @IBAction func oppositeStationButtonClicked(_ sender: Any) {
        // TODO CHECK IF OPPOSITE ROUTE EXTIS - AND OPEN IF
    }
}

extension RouteBottomSheetViewController: UITableViewDataSource, UITableViewDelegate {
    
    // returns size of the stations tableview
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        if stationArrivals == nil {
            return 0
        }
        return stationArrivals!.count
    }
    
    // render station arrivals cells
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let routeStationCell = self.routeStationsTableView.dequeueReusableCell(withIdentifier: "RouteStationTableViewCell", for: indexPath) as! RouteStationTableViewCell
        routeStationCell.setCell(stationArrivals: stationArrivals![indexPath.row])
        return routeStationCell
    }
}
