//
//  NearbyStationsViewController.swift
//  travana
//
//  Created by Domen Kralj on 27/10/2020.
//  Copyright © 2020 Domen Kralj. All rights reserved.
//

import UIKit
import CoreLocation

class NearbyStationsViewController: UIViewController {

    public var mainViewController: MainViewController!
    private var nearbyStations: [LppStation]? = nil
    private var locationManager = CLLocationManager()
    
    @IBOutlet weak var loading: UIActivityIndicatorView!
    @IBOutlet weak var errorView: UIView!
    @IBOutlet weak var tryAgainView: UIView!
    @IBOutlet weak var errorText: UILabel!
    @IBOutlet weak var locationIsNotAvailibleStackView: UIStackView!
    @IBOutlet weak var nearbyStationsTableView: UITableView!
    
    override func viewDidLoad() {
        super.viewDidLoad()

        // set search result table view
        self.nearbyStationsTableView.dataSource = self
        self.nearbyStationsTableView.delegate = self
        self.nearbyStationsTableView.register(UINib(nibName: "FavoriteNearbyStationTableViewCell", bundle: nil), forCellReuseIdentifier: "FavoriteNearbyStationTableViewCell")
        self.nearbyStationsTableView.contentInset = UIEdgeInsets(top: 0, left: 0, bottom: 120, right: 0)
        
        // set ui to the error and try again view
        self.errorView.setCornerRadius(cornerRadius: 20)
        self.tryAgainView.setCornerRadius(cornerRadius: 15)

    }
    
    override func viewWillAppear(_ animated: Bool) {
        self.reloadViewController()
        self.setUI(state: self.mainViewController.screenState)
    }
    
    // filter stations data and update table view
    public func reloadViewController() {
    
        let locationValue: CLLocationCoordinate2D? = self.locationManager.location?.coordinate
        // set distance label
        if CLLocationManager.locationServicesEnabled() {
            switch CLLocationManager.authorizationStatus() {
                case .notDetermined, .restricted, .denied:
                    // Location services are not enabled
                    self.locationIsNotAvailibleStackView.isHidden = false
                    self.nearbyStationsTableView.isHidden = true
                    return
                case .authorizedAlways, .authorizedWhenInUse:
                    // Location services should be enabled
                    if locationValue != nil {
                        self.locationIsNotAvailibleStackView.isHidden = true
                        self.nearbyStationsTableView.isHidden = false
                    } else {
                        // Location services are not enabled
                        self.locationIsNotAvailibleStackView.isHidden = false
                        self.nearbyStationsTableView.isHidden = true
                        return
                    }
                default:
                    // Location services are not enabled
                    self.locationIsNotAvailibleStackView.isHidden = false
                    self.nearbyStationsTableView.isHidden = true
                    return
            }
        } else {
            // Location services are not enabled
            self.locationIsNotAvailibleStackView.isHidden = false
            self.nearbyStationsTableView.isHidden = true
            return
        }
        
        let fullStations = self.mainViewController?.stations
        if fullStations == nil {
            DispatchQueue.main.async {
                self.nearbyStationsTableView.reloadData()
            }
            return
        }
        self.nearbyStations = fullStations!
        // sort locations by distance - data is already sorted in main view controller - retrieve stations
        //self.nearbyStations = self.nearbyStations!.sorted(by: { Utils.getDistanceBetweenCoordinates(latitude1: $0.latitude, longitude1: $0.longitude, latitude2: locationValue!.latitude, longitude2: locationValue!.longitude) < Utils.getDistanceBetweenCoordinates(latitude1: $1.latitude, longitude1: $1.longitude, latitude2: locationValue!.latitude, longitude2: locationValue!.longitude) })
        
        DispatchQueue.main.async {
            self.nearbyStationsTableView.reloadData()
        }
    }
    
    // set ui, depends on screen state
    public func setUI(state: ScreenState) {
        switch state {
        case ScreenState.done:
            self.nearbyStationsTableView.isHidden = false
            self.loading.isHidden = true
            self.errorView.isHidden = true
            self.tryAgainView.isHidden = true
        case ScreenState.error:
            self.nearbyStationsTableView.isHidden = true
            self.loading.isHidden = true
            self.errorView.isHidden = false
            self.tryAgainView.isHidden = false
            
            if Connectivity.isConnectedToNetwork() {
                self.errorText.text = "error_during_loading".localized
            } else {
                self.errorText.text = "no_internet_connection".localized
            }
            
        case ScreenState.loading:
            self.nearbyStationsTableView.isHidden = true
            self.loading.isHidden = false
            self.errorView.isHidden = true
            self.tryAgainView.isHidden = true
        }
    }
    
    // called when try again button is clicked
    @IBAction func tryAgainButtonClicked(_ sender: UIButton) {
        // set ui to loading
        DispatchQueue.main.async {
            self.setUI(state: ScreenState.loading)
        }
        // try to retieve data again
        DispatchQueue.main.asyncAfter(deadline: .now() + .seconds(1), execute: {
            self.mainViewController?.retrieveStations()
        })
    }
}

extension NearbyStationsViewController: UITableViewDataSource, UITableViewDelegate {
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        if self.nearbyStations == nil {
            return 0
        }
        
        // show just 50 stations
        if self.nearbyStations!.count > 50 {
            return 50
        }
        
        return self.nearbyStations!.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "FavoriteNearbyStationTableViewCell", for: indexPath) as! FavoriteNearbyStationTableViewCell
        cell.setCell(station: self.nearbyStations![indexPath.row])
        return cell
    }
    
    // called when one of the cells is clicked
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        // open station view controller
        let station = self.nearbyStations![indexPath.row]
        let vc = UIStoryboard.init(name: "Main", bundle: Bundle.main).instantiateViewController(withIdentifier: "StationViewController") as! StationViewController
        vc.station = station
        vc.modalPresentationStyle = .fullScreen
        self.present(vc, animated: true, completion: nil)
    }
}
