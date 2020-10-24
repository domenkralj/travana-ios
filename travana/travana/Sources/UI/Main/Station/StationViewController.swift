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
        
        // set line view to be the half of the screen
        self.pageLineView.width(constant: UIScreen.main.bounds.width/2)
        
        // pass station data to station page view controller
        self.stationPageViewController.station = self.station
        
        // set station name text
        self.stationNameText.text = self.station.name
        
        // set station to center view
        self.setToCenterView(show: station.refId.toInt() % 2 == 1)
        
        // TODO - CHECK IF STATION IS FAVORITES
        // IF YES SET isStationInFavorites
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        
        // set status bar font to white
        setNeedsStatusBarAppearanceUpdate()
    }
    
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
            self.pageLineViewConstraintLeftoSafeArea.constant = 0
        } else {
            self.pageLineViewConstraintLeftoSafeArea.constant = UIScreen.main.bounds.width/2
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
        self.toggleStationScreenTypeButtons(screenType: StationScreenType.arrivals)
        self.stationPageViewController.setStationArrivalsViewController()
    }
    
    // called when routes button is clicked
    @IBAction func routesButtonClicked(_ sender: UIButton) {
        self.toggleStationScreenTypeButtons(screenType: StationScreenType.routes)
        self.stationPageViewController.setStationRoutesViewController()
    }
    
    // called when back button is clicked
    @IBAction func backButtonPressed(_ sender: UIButton) {
        self.dismiss(animated: true, completion: nil)
    }
    
    // called when add to favorites button is clicked
    @IBAction func addToFavoritesButtonClicked(_ sender: UIButton) {
        self.isStationInFavorites = !self.isStationInFavorites
        self.setFavoritesButton(selected: isStationInFavorites)
        // TODO ADD OR REMOVE STATION FROM FAVORITES
    }
    
    // called when opposite station button is clicked
    @IBAction func oppositeStationButtonClicked(_ sender: UIButton) {
    }
}

enum StationScreenType {
    case arrivals, routes
}
