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
    private var screenState: ScreenState = ScreenState.loading
    private var requestsFailedInRow = 0
    private var updateLppDatatimer: Timer!
    private static let MAX_REQUEST_FAILED_IN_ROW = 3
    private static let REFRESH_RATE = 5.0     // 5 seconds
    
    @IBOutlet weak var loading: UIActivityIndicatorView!
    @IBOutlet weak var errorView: UIView!
    @IBOutlet weak var tryAgainView: UIView!
    
    @IBOutlet weak var arrivalsTableView: UITableView!
    @IBOutlet weak var noUpcomingArrivalsStackView: UIStackView!
    
    required init?(coder aDecoder: NSCoder) {
        let app = UIApplication.shared.delegate as! AppDelegate
        let appData: TravanaAppDataContainer = app.getAppData()
        self.lppApi = appData.getLppApi()
        
        super.init(coder: aDecoder)
    }
    
    
    // when view is loaded.
    override func viewDidLoad() {
        super.viewDidLoad()
        
        // set ui to the error and try again view
        self.errorView.setCornerRadius(cornerRadius: 20)
        self.tryAgainView.setCornerRadius(cornerRadius: 15)
        
        self.setUI(state: ScreenState.loading)
        
        self.retrieveArrivals()
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        
        // set status bar font to white
        setNeedsStatusBarAppearanceUpdate()
        
        // create timer which tries to update bus arrivals and bus locations data every 10 seconds
        self.startUpadatingTimer()
    }
    
    override func viewWillDisappear(_ animated: Bool) {
        // stop timer
        self.stopUpdatingTimer()
    }
    
    
    private func retrieveArrivals() {
        DispatchQueue.main.async() {
            self.setUI(state: ScreenState.loading)
        }
        self.lppApi.getArrivals(stationCode: station.refId) {
            (result) in
            if result.success {
                self.arrivals = self.splitArrivalsByTripIdAndSort(arrivals: result.data)
                self.requestsFailedInRow = 0
                
                DispatchQueue.main.async() {
                    if self.arrivals?.count == nil || self.arrivals!.count == 0 {
                        self.noUpcomingArrivalsStackView.isHidden = false
                        self.arrivalsTableView.isHidden = true
                    } else {
                        self.noUpcomingArrivalsStackView.isHidden = true
                        self.arrivalsTableView.isHidden = false
                    }
                    self.arrivalsTableView.reloadData()
                    self.setUI(state: ScreenState.done)
                }
                
            } else {
                DispatchQueue.main.async() {
                    self.setUI(state: ScreenState.error)
                }
            }
        }
    }
    
    // update arrivals - ui is set just if current state is error
    // this func is called from timer and never from user
    @objc private func updateArrivals() {
        self.lppApi.getArrivals(stationCode: station.refId) {
            (result) in
            if result.success {
                self.arrivals = self.splitArrivalsByTripIdAndSort(arrivals: result.data)
                
                DispatchQueue.main.async() {
                    if self.arrivals?.count == nil || self.arrivals!.count == 0 {
                        self.noUpcomingArrivalsStackView.isHidden = false
                        self.arrivalsTableView.isHidden = true
                    } else {
                        self.noUpcomingArrivalsStackView.isHidden = true
                        self.arrivalsTableView.isHidden = false
                    }
                }
                
                self.requestsFailedInRow = 0
                DispatchQueue.main.async() {
                    if self.screenState == ScreenState.error {
                        self.setUI(state: ScreenState.done)
                    }
                    self.arrivalsTableView.reloadData()
                }
            } else {
                self.requestsFailedInRow += 1
                if self.requestsFailedInRow > StationArrivalsViewController.MAX_REQUEST_FAILED_IN_ROW {
                    DispatchQueue.main.async() {
                        self.setUI(state: ScreenState.error)
                    }
                }
            }
        }
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
    
    private func startUpadatingTimer() {
        self.updateLppDatatimer = Timer.scheduledTimer(timeInterval: StationArrivalsViewController.REFRESH_RATE, target: self, selector: #selector(self.updateArrivals), userInfo: nil, repeats: true)
    }
    
    private func stopUpdatingTimer() {
        self.updateLppDatatimer?.invalidate()
        self.updateLppDatatimer = nil
    }
    
    // called when try again button is clicked
    @IBAction func tryAgainButtonClicked(_ sender: UIButton) {
        // set ui to loading
        DispatchQueue.main.async {
            self.setUI(state: ScreenState.loading)
        }
        // try to retieve data again
        DispatchQueue.main.asyncAfter(deadline: .now() + .seconds(1), execute: {
            self.retrieveArrivals()
        })
    }
    
    // set ui, depends on screen state
    private func setUI(state: ScreenState) {
        switch state {
        case ScreenState.done:
            self.arrivalsTableView.isHidden = false
            self.loading.stopAnimating()
            self.errorView.isHidden = true
            self.tryAgainView.isHidden = true
            self.screenState = ScreenState.done
        case ScreenState.error:
            self.arrivalsTableView.isHidden = true
            self.loading.stopAnimating()
            self.errorView.isHidden = false
            self.tryAgainView.isHidden = false
            self.screenState = ScreenState.error
        case ScreenState.loading:
            self.arrivalsTableView.isHidden = true
            self.loading.startAnimating()
            self.errorView.isHidden = true
            self.tryAgainView.isHidden = true
            self.screenState = ScreenState.loading
        }
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
    
    // called when one of the cells is clicked
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        // open route view controller
        let stationArrival = self.arrivals![indexPath.row][0]
        let route = LppRoute(routeId: stationArrival.routeId, routeNumber: stationArrival.routeName, tripId: stationArrival.tripId, routeName: stationArrival.tripName, shortRouteName: stationArrival.tripName)
        let vc = UIStoryboard.init(name: "Main", bundle: Bundle.main).instantiateViewController(withIdentifier: "RouteViewController") as! RouteViewController
        vc.route = route
        vc.modalPresentationStyle = .fullScreen
        self.present(vc, animated: true, completion: nil)
    }
}
