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
            self.logger.info("Opening route view controller without lpp route data")
            self.dismiss(animated: true, completion: nil)
        }
        
        // set corner radius to the holderImageView
        self.holderImageView.setCornerRadius(cornerRadius: 3)
        
        // set corner radius to the routeNumberView
        self.routeNumberView.setCornerRadius(cornerRadius: 14)
        
        // set routeStationsTableView and set data source for routeStationsTableView
        self.routeStationsTableView.dataSource = self
        self.routeStationsTableView.register(UINib(nibName: "RouteStationTableViewCell", bundle: nil), forCellReuseIdentifier: "RouteStationTableViewCell")
        
        self.routeName.text = route!.routeName
        self.routeNumberText.text = route!.routeNumber
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
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return 200
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let routeStationCell = self.routeStationsTableView.dequeueReusableCell(withIdentifier: "RouteStationTableViewCell", for: indexPath) as! RouteStationTableViewCell
        return routeStationCell
    }
}
