//
//  StationArrivalsViewController.swift
//  travana
//
//  Created by Domen Kralj on 23/10/2020.
//  Copyright © 2020 Domen Kralj. All rights reserved.
//

import UIKit

// view used for showing stations arrivals
class StationArrivalsViewController: UIViewController {

    public var station: LppStation!
    private var lppApi: LppApi
    private var arrivals: [[LppArrival2]]? = nil
    
    @IBOutlet weak var arrivalsTableView: UITableView!
    
    required init?(coder aDecoder: NSCoder) {
        let app = UIApplication.shared.delegate as! AppDelegate
        let appData: TravanaAppDataContainer = app.getAppData()
        self.lppApi = appData.getLppApi()
        
        super.init(coder: aDecoder)
    }
    
    
    // when view is loaded.
    override func viewDidLoad() {
        super.viewDidLoad()
        
        self.lppApi.getArrivals(stationCode: station.refId) {
            (result) in
            if result.success {
                self.arrivals = self.splitArrivalsByTripIdAndSort(arrivals: result.data)
                DispatchQueue.main.async() {
                    self.arrivalsTableView.reloadData()
                }
            } else {
                print("ŽELVA ERROR")
            }
        }
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        
        // set status bar font to white
        setNeedsStatusBarAppearanceUpdate()
    }
    
    // set status bar font to white
    override var preferredStatusBarStyle: UIStatusBarStyle {
        .lightContent
    }
    
    private func retrieveArrivals() {
        
    }
    
    // split arrivals by trip id and sort them by route number
    private func splitArrivalsByTripIdAndSort(arrivals: [LppArrival2]?) -> [[LppArrival2]]? {
        if arrivals == nil {
            return nil
        }
        var splitedArrivals: [[LppArrival2]] = []
        
        // split arrivals by trip id
        let innerArrivals = arrivals!
        for arrival in innerArrivals {
            var isArrivalAdded = false
            for i in 0..<splitedArrivals.count {
                
                if arrival.tripId == splitedArrivals[i][0].tripId {
                    splitedArrivals[i].append(arrival)
                    isArrivalAdded = true
                    break
                }
            }
            if !isArrivalAdded {
                splitedArrivals.append([arrival])
            }
        }
        // sort array of arrivals by route number
        splitedArrivals = splitedArrivals.sorted(by: { Utils.routeNumberToInt(routeNumber: $0[0].routeName)! < Utils.routeNumberToInt(routeNumber: $1[0].routeName)! })
        
        return splitedArrivals
    }
    
    @IBAction func tryAgainButtonClicked(_ sender: UIButton) {
    }
}

extension StationArrivalsViewController: UITableViewDataSource, UITableViewDelegate {
    
    // returns size of the tableview
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        if arrivals == nil {
            return 0
        }
        return arrivals!.count
    }
    
    // renders arrivals table view size
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "ArrivalsTableViewCell", for: indexPath) as! ArrivalsTableViewCell
        let arrivals = self.arrivals![indexPath.row]
        cell.setCell(arrivals: arrivals)
        cell.reloadCollectionViewArrivalsData()
        return cell
    }
}
