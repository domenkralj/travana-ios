//
//  TimetableViewController.swift
//  travana
//
//  Created by Domen Kralj on 24/10/2020.
//  Copyright © 2020 Domen Kralj. All rights reserved.
//

import UIKit

// Screen used for showing route timetable
class TimetableViewController: UIViewController {

    private static let TO_CENTER_VIEW_WIDTH = 50
    
    public var route: LppRoute!
    public var station: LppStation!
    
    @IBOutlet weak var routeNumberView: UIView!
    @IBOutlet weak var routeNumberText: UILabel!
    @IBOutlet weak var routeNameText: UILabel!
    
    @IBOutlet weak var toCenterView: UIView!
    @IBOutlet weak var stationNameText: UILabel!
    
    @IBOutlet weak var timetableTableView: UITableView!
    
    @IBOutlet weak var loading: UIActivityIndicatorView!
    @IBOutlet weak var tryAgainView: UIView!
    @IBOutlet weak var errorView: UIView!
    
    // when view is loaded.
    override func viewDidLoad() {
        super.viewDidLoad()
        
        self.toCenterView.setCornerRadius(cornerRadius: 8)
        
        self.routeNumberView.setCornerRadius(cornerRadius: 14)
        self.routeNumberView.setBackgroundColor(color: Colors.getColorFromString(string: route.routeNumber))
        self.routeNameText.text = route.routeNumber
        self.routeNameText.text = route.routeName
        
        // set to center view
        if self.station.refId.toInt() % 2 == 0 {
            self.toCenterView.width(constant: CGFloat(TimetableViewController.TO_CENTER_VIEW_WIDTH))
        } else {
            self.toCenterView.width(constant: 0)
        }
        
        // set station name text
        self.stationNameText.text = self.station.name

        // set ui to the error and tru again view
        self.errorView.setCornerRadius(cornerRadius: 20)
        self.tryAgainView.setCornerRadius(cornerRadius: 15)
        
        self.setUI(state: ScreenState.done)
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        
        // set status bar font to white
        setNeedsStatusBarAppearanceUpdate()
    }
    
    // set ui, depends on screen state
    private func setUI(state: ScreenState) {
        switch state {
        case ScreenState.done:
            self.timetableTableView.isHidden = false
            self.loading.isHidden = true
            self.errorView.isHidden = true
            self.tryAgainView.isHidden = true
        case ScreenState.error:
            self.timetableTableView.isHidden = true
            self.loading.isHidden = true
            self.errorView.isHidden = false
            self.tryAgainView.isHidden = false
        case ScreenState.loading:
            self.timetableTableView.isHidden = true
            self.loading.isHidden = false
            self.errorView.isHidden = true
            self.tryAgainView.isHidden = true
        }
    }
    
    // set status bar font to white
    override var preferredStatusBarStyle: UIStatusBarStyle {
        .lightContent
    }
    
    // called when back button is clicked
    @IBAction func backButtonPressed(_ sender: UIButton) {
        self.dismiss(animated: true, completion: nil)
    }
    
    // called when try again button is clicked
    @IBAction func tryAgainButtonClicked(_ sender: UIButton) {
        // set ui to loading
        DispatchQueue.main.async {
            self.setUI(state: ScreenState.loading)
        }
        // try to retieve data again
        DispatchQueue.main.asyncAfter(deadline: .now() + .seconds(1), execute: {
            //self.retrieveStationsAndBusRoutes()
            // TODO RELOAD DATA
        })
    }
}

/*
extension TimetableViewController: UITableViewDataSource {
    
    // returns size of the timetable tableview
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        
    }
    
    
}*/
