//
//  StationViewController.swift
//  travana
//
//  Created by Domen Kralj on 21/10/2020.
//  Copyright © 2020 Domen Kralj. All rights reserved.
//

import UIKit

// Screen used for showing station data
class StationViewController: UIViewController, StationPageViewControllerListener {
    
    private static let TO_CENTER_VIEW_WIDTH = 70
    
    public var station: LppStation!
    public var routesOnStation: [LppRouteOnStation]? = nil
    private var isStationInFavorites = false
    private var stationPageViewController: StationPageViewController!
    private var screenType: StationScreenType = StationScreenType.arrivals
    private var lppApi: LppApi
    
    @IBOutlet weak var toCenterView: UIView!
    @IBOutlet weak var addToFavoritesButton: UIButton!
    @IBOutlet weak var pageLineView: UIView!
    @IBOutlet weak var pageLineViewConstraintLeftoSafeArea: NSLayoutConstraint!
    @IBOutlet weak var stationNameText: UILabel!
    @IBOutlet weak var arrivalsButton: UIButton!
    @IBOutlet weak var routesButton: UIButton!
    
    
    required init?(coder aDecoder: NSCoder) {
        let app = UIApplication.shared.delegate as! AppDelegate
        let appData: TravanaAppDataContainer = app.getAppData()
        self.lppApi = appData.getLppApi()
        
        super.init(coder: aDecoder)
    }
    
    // when view is loaded.
    override func viewDidLoad() {
        super.viewDidLoad()
        
        // set to center view
        self.toCenterView.setCornerRadius(cornerRadius: 13)
        
        // pass station data to station page view controller
        self.stationPageViewController.station = self.station
        
        // set station name text
        self.stationNameText.text = self.station.name
        
        // set station to center view
        self.setToCenterView(show: station.refId.toInt() % 2 == 1)
        
        self.isStationInFavorites = LppApi.isStationInFavorites(stationRefId: station.refId)
        self.setFavoritesButton(selected: self.isStationInFavorites)
        
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        
        // set status bar font to white
        setNeedsStatusBarAppearanceUpdate()
    }
    
    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(animated)

        self.setStationScreenType(screenType: self.screenType)
        // self.toggleStationScreenTypeButtons(screenType: self.screenType)
    }
    
    // get an instance of the StationPageViewController
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        if let vc = segue.destination as? StationPageViewController, segue.identifier == "showStationPageViewController" {
            // pass station data to station page view controller
            vc.station = self.station
            
            // add listner to the station page view controler
            // protcol which is called every time when page view controller is swiped (not set by buttons)
            vc.stationPageViewControllerListener = self
            
            vc.stationViewController = self
            self.stationPageViewController = vc
        }
    }
    
    // set status bar font to white
    override var preferredStatusBarStyle: UIStatusBarStyle {
        .lightContent
    }
    
    // called when page is swiped
    func pageSwiped(screenType: StationScreenType) {
        self.toggleStationScreenType(screenType: screenType)
    }
    
    private func setToCenterView(show: Bool) {
        if show {
            self.toCenterView.width(constant: CGFloat(StationViewController.TO_CENTER_VIEW_WIDTH))
            self.toCenterView.isHidden = false
        } else {
            self.toCenterView.width(constant: 0)
            self.toCenterView.isHidden = true
        }
    }
    
    private func setStationScreenType(screenType: StationScreenType) {
        
        if self.screenType == StationScreenType.arrivals {
            self.stationPageViewController.setStationArrivalsViewController()
        } else {
            self.stationPageViewController.setStationRoutesViewController()
        }
        self.toggleStationScreenTypeButtons(screenType: self.screenType)
    }
    
    // toggle station screen type
    private func toggleStationScreenType(screenType: StationScreenType) {
        
        if self.screenType == StationScreenType.arrivals {
            self.screenType = StationScreenType.routes
            self.stationPageViewController.setStationRoutesViewController()
        } else {
            self.screenType = StationScreenType.arrivals
            self.stationPageViewController.setStationArrivalsViewController()
        }
        self.toggleStationScreenTypeButtons(screenType: self.screenType)
    }
    
    // toggle stations type buttons (arrivals or routes) and animate
    private func toggleStationScreenTypeButtons(screenType: StationScreenType) {
    
        if screenType == StationScreenType.arrivals {
            let arrivalsX = self.arrivalsButton.titleLabel!.frame.origin.x
            self.pageLineViewConstraintLeftoSafeArea.constant = arrivalsX
            self.pageLineView.width(constant: self.arrivalsButton.intrinsicContentSize.width)
        } else {
            let routesX = self.routesButton.titleLabel!.frame.origin.x + self.routesButton.frame.origin.x
            self.pageLineViewConstraintLeftoSafeArea.constant = routesX
            self.pageLineView.width(constant: self.routesButton.intrinsicContentSize.width)
        }
        UIView.animate(withDuration: 0.25) {
            self.view.layoutIfNeeded()
        }
    }
    
    // set favorite button ui depends on state (selected or not)
    private func setFavoritesButton(selected: Bool) {
        if selected {
            self.addToFavoritesButton.setBackgroundImage(UIImage(systemName: "heart.fill"), for: .normal)
        } else {
            self.addToFavoritesButton.setBackgroundImage(UIImage(systemName: "heart"), for: .normal)
        }
    }
    
    // called when arrivals button is clicked
    @IBAction func arrivalsButtonClicked(_ sender: UIButton) {
        self.screenType = StationScreenType.arrivals
        self.setStationScreenType(screenType: self.screenType)
        self.stationPageViewController.setStationArrivalsViewController()
    }
    
    // called when routes button is clicked
    @IBAction func routesButtonClicked(_ sender: UIButton) {
        self.screenType = StationScreenType.routes
        self.setStationScreenType(screenType: self.screenType)
        self.stationPageViewController.setStationRoutesViewController()
    }
    
    // called when back button is clicked
    @IBAction func backButtonPressed(_ sender: UIButton) {
        self.dismiss(animated: true, completion: nil)
    }
    
    // called when add to favorites button is clicked
    @IBAction func addToFavoritesButtonClicked(_ sender: UIButton) {
        // remove or add stations to favorites and set ui
        if isStationInFavorites {
            LppApi.removeStationFromFavorites(stationRefId: self.station.refId)
        } else {
            LppApi.addStationToFavorites(stationRefId: self.station.refId)
        }
        self.isStationInFavorites = !self.isStationInFavorites
        self.setFavoritesButton(selected: isStationInFavorites)
    }
    
    // called when opposite station button is clicked
    @IBAction func oppositeStationButtonClicked(_ sender: UIButton) {
        sender.isEnabled = false
        self.lppApi.getStations() {(result) in
            if result.success {
                let stations = result.data!
                let currentStationRefId = self.station.refId.toInt()
                
                var oppositeStationRefId: Int!
                if currentStationRefId % 2 == 0 {
                    oppositeStationRefId = currentStationRefId - 1
                } else {
                    oppositeStationRefId = currentStationRefId + 1
                }
                
                // filter stations - check if stations with opposite ref id exits
                let filteredStations = stations.filter { $0.refId.toInt() == oppositeStationRefId }
                if filteredStations.isEmpty {
                    Toast.show(message: "opposite_station_do_not_exit".localized, controller: self)
                    return
                }
                sender.isEnabled = true
                    
                // open opposite station view controller
                let vc = UIStoryboard.init(name: "Main", bundle: Bundle.main).instantiateViewController(withIdentifier: "StationViewController") as! StationViewController
                vc.station = filteredStations[0]
                vc.modalPresentationStyle = .fullScreen
                self.present(vc, animated: true, completion: nil)
                    
            } else {
                Toast.show(message: "error_ccured_try_again".localized, controller: self)
                sender.isEnabled = true
            }
        }
    }
}

enum StationScreenType {
    case arrivals, routes
}
