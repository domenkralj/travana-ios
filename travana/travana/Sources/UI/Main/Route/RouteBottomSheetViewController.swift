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

    public var showJustStationName = false
    public var route: LppRoute? = nil
    public var stationArrivals: [LppStationArrival]? = nil
    private let lppApi: LppApi!
    private let logger: ConsoleLogger = LoggerFactory.getLogger(name: "RouteBottomSheetViewController")
    
    @IBOutlet weak var handleArea: UIView!
    @IBOutlet weak var routeName: MovingLabel!
    @IBOutlet weak var routeStationsTableView: UITableView!
    @IBOutlet weak var holderImageView: UIView!
    @IBOutlet weak var routeNumberView: UIView!
    @IBOutlet weak var routeNumberText: UILabel!
    
    required init?(coder aDecoder: NSCoder) {
        let app = UIApplication.shared.delegate as! AppDelegate
        let appData: TravanaAppDataContainer = app.getAppData()
        self.lppApi = appData.getLppApi()
        
        super.init(coder: aDecoder)
    }
    
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
        self.routeStationsTableView.delegate = self
        self.routeStationsTableView.register(UINib(nibName: "RouteStationTableViewCell", bundle: nil), forCellReuseIdentifier: "RouteStationTableViewCell")
        
        // set route labels
        self.routeName.text = route!.routeName + "     "    // spaces on the end separates the start of the label with the end (moving label)
        self.routeNumberText.text = route!.routeNumber
        self.routeNumberView.setBackgroundColor(color: Colors.getColorFromString(string: route!.routeNumber))
    }
    
    public func setStationsArrivals(stationArrivals: [LppStationArrival]) {
        self.stationArrivals = stationArrivals
        self.showJustStationName = false
        DispatchQueue.main.async() {
            self.routeStationsTableView.reloadData()
        }
    }
    
    public func removeArrivals() {
        self.showJustStationName = true
        DispatchQueue.main.async() {
            self.routeStationsTableView.reloadData()
        }
    }
    
    // called when back button is clicked
    @IBAction func backButtonClicked(_ sender: UIButton) {
        self.dismiss(animated: true, completion: nil)
    }
    @IBAction func oppositeStationButtonClicked(_ sender: UIButton) {
        DispatchQueue.main.async() {
            sender.isEnabled = false
        }
        self.lppApi.getRoutes() {(result) in
            if result.success {
                let routes = result.data!
                
                DispatchQueue.main.async() {
                    sender.isEnabled = true
                }
                
                // filter stations - check if stations with opposite ref id exits
                let filteredRoutes = routes.filter { $0.routeId == self.route!.routeId && $0.tripId != self.route!.tripId}
                
                if filteredRoutes.isEmpty {
                    Toast.show(message: "opposite_route_do_not_exits".localized, controller: self)
                    return
                } else if filteredRoutes.count == 1 {
                    // open opposite station view controller
                    DispatchQueue.main.async() {
                        let vc = UIStoryboard.init(name: "Main", bundle: Bundle.main).instantiateViewController(withIdentifier: "RouteViewController") as! RouteViewController
                        vc.route = filteredRoutes[0]
                        vc.modalPresentationStyle = .fullScreen
                        self.present(vc, animated: true, completion: nil)
                    }
                } else {
                    // TODO - OPEN DIALOG
                }
                    
            } else {
                Toast.show(message: "error_ccured_try_again".localized, controller: self)
                DispatchQueue.main.async() {
                    sender.isEnabled = true
                }
            }
        }
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
        var stationPostion = StationPositon.middle
        if indexPath.row == 0 {
            stationPostion = StationPositon.first
        } else if indexPath.row == stationArrivals!.count - 1 {
            stationPostion = StationPositon.last
        }
        routeStationCell.setCell(stationArrivals: stationArrivals![indexPath.row], stationPostion: stationPostion, routeColor: Colors.getColorFromString(string: route!.routeNumber), showJustStationName: showJustStationName)
        return routeStationCell
    }
    
    // called when one of the cells is clicked
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        print("clicked")
        // TODO OPEN STATION VIEW CONTROLLER
    }
}
