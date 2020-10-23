//
//  StationRoutesViewController.swift
//  travana
//
//  Created by Domen Kralj on 23/10/2020.
//  Copyright © 2020 Domen Kralj. All rights reserved.
//

import UIKit

// view used for showing station routes
class StationRoutesViewController: UIViewController {

    public var station: LppStation!
    private let lppApi: LppApi
    private var routesOnStation: [LppRouteOnStation]? = nil
    @IBOutlet weak var routesOnStationTableView: UITableView!
    
    required init?(coder aDecoder: NSCoder) {
        let app = UIApplication.shared.delegate as! AppDelegate
        let appData: TravanaAppDataContainer = app.getAppData()
        self.lppApi = appData.getLppApi()
        
        super.init(coder: aDecoder)
    }
    
    
    // when view is loaded.
    override func viewDidLoad() {
        super.viewDidLoad()
        
        print("Creating StationRoutesViewController")
    }
    
    private func setUi(state: ScreenState) {
        
    }
    
    //  retrive routes on station data
    private func retrieveRoutesOnStation() {
        self.lppApi.getRoutesOnStation(stationCode: station.refId) {
            (result) in
            if result.success {
                self.routesOnStation = result.data
            } else {
                
            }
        }
    }
}

extension StationRoutesViewController: UITableViewDataSource, UITableViewDelegate {
    
    // returns size of the routes on stations tableview
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        if self.routesOnStation == nil {
            return 0
        }
        return self.routesOnStation!.count
    }
    
    
    // renders routes on station tableview cells
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        
    }
    
}
