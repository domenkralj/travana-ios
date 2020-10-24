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
    public var stationViewController: StationViewController!
    private let lppApi: LppApi
    private var routesOnStation: [LppRouteOnStation]? = nil
    @IBOutlet weak var routesOnStationTableView: UITableView!
    @IBOutlet weak var loading: UIActivityIndicatorView!
    @IBOutlet weak var errorView: UIView!
    @IBOutlet weak var tryAgainView: UIView!
    
    required init?(coder aDecoder: NSCoder) {
        let app = UIApplication.shared.delegate as! AppDelegate
        let appData: TravanaAppDataContainer = app.getAppData()
        self.lppApi = appData.getLppApi()
        
        super.init(coder: aDecoder)
    }
    
    
    // when view is loaded.
    override func viewDidLoad() {
        super.viewDidLoad()
        
        // set routes on station table view
        self.routesOnStationTableView.dataSource = self
        self.routesOnStationTableView.register(UINib(nibName: "RoutesOnStationTableViewCell", bundle: nil), forCellReuseIdentifier: "RoutesOnStationTableViewCell")
        
        // set ui to the error and tru again view
        self.errorView.setCornerRadius(cornerRadius: 20)
        self.tryAgainView.setCornerRadius(cornerRadius: 15)
        
        self.retrieveRoutesOnStation()
    }
    
    // set ui, depends on screen state
    private func setUI(state: ScreenState) {
        switch state {
        case ScreenState.done:
            self.routesOnStationTableView.isHidden = false
            self.loading.isHidden = true
            self.errorView.isHidden = true
            self.tryAgainView.isHidden = true
        case ScreenState.error:
            self.routesOnStationTableView.isHidden = true
            self.loading.isHidden = true
            self.errorView.isHidden = false
            self.tryAgainView.isHidden = false
        case ScreenState.loading:
            self.routesOnStationTableView.isHidden = true
            self.loading.isHidden = false
            self.errorView.isHidden = true
            self.tryAgainView.isHidden = true
        }
    }
    
    //  retrive routes on station data
    private func retrieveRoutesOnStation() {
        DispatchQueue.main.async() {
            self.setUI(state: ScreenState.loading)
        }
        print(station.refId)
        self.lppApi.getRoutesOnStation(stationCode: station.refId) {
            (result) in
            if result.success {
                // remove in garage routes
                var routesOnStationFiltered: [LppRouteOnStation] = []
                
                for route in result.data! {
                    if route.isGarage {
                        continue
                    }
                    routesOnStationFiltered.append(route)
                }
                self.routesOnStation = routesOnStationFiltered
                DispatchQueue.main.async() {
                    self.setUI(state: ScreenState.done)
                    self.routesOnStationTableView.reloadData()
                }
            } else {
                DispatchQueue.main.async() {
                    self.setUI(state: ScreenState.error)
                }
            }
        }
    }
    
    // called when try again button is clicked
    @IBAction func tryAgainButtonClicked(_ sender: UIButton) {
        // set ui to loading
        DispatchQueue.main.async {
            self.setUI(state: ScreenState.loading)
        }
        // try to retrieve routes on station data again
        DispatchQueue.main.asyncAfter(deadline: .now() + .seconds(1), execute: {
            self.retrieveRoutesOnStation()
        })
    }
}

extension StationRoutesViewController: UITableViewDataSource {
    
    // returns size of the routes on stations tableview
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        if self.routesOnStation == nil {
            return 0
        }
        return self.routesOnStation!.count
    }
    
    
    // renders routes on station tableview cells
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "RoutesOnStationTableViewCell", for: indexPath) as! RoutesOnStationTableViewCell
        let routeOnStation = self.routesOnStation![indexPath.row]
        cell.setCell(route: routeOnStation)
        cell.station = self.station
        cell.stationViewController = self.stationViewController
        return cell
    }
    
}
