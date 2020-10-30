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
    private var lppApi: LppApi
    private var timetable: [LppTimetableTimes]? = nil
    
    @IBOutlet weak var routeNumberView: UIView!
    @IBOutlet weak var routeNumberText: UILabel!
    @IBOutlet weak var routeNameText: UILabel!
    
    @IBOutlet weak var toCenterView: UIView!
    @IBOutlet weak var stationNameText: UILabel!
    
    @IBOutlet weak var timetableTableView: UITableView!
    @IBOutlet weak var noSchedulesArrivalsForTodayStackView: UIStackView!
    
    @IBOutlet weak var loading: UIActivityIndicatorView!
    @IBOutlet weak var tryAgainView: UIView!
    @IBOutlet weak var errorView: UIView!
    @IBOutlet weak var errorText: UILabel!
    
    required init?(coder aDecoder: NSCoder) {
        let app = UIApplication.shared.delegate as! AppDelegate
        let appData: TravanaAppDataContainer = app.getAppData()
        self.lppApi = appData.getLppApi()
        
        super.init(coder: aDecoder)
    }
    
    // when view is loaded.
    override func viewDidLoad() {
        super.viewDidLoad()
        
        self.toCenterView.setCornerRadius(cornerRadius: 8)
        
        self.routeNumberView.setCornerRadius(cornerRadius: 12)
        self.routeNumberView.setBackgroundColor(color: Colors.getColorFromString(string: route.routeNumber))
        self.routeNumberText.text = route.routeNumber
        self.routeNameText.text = route.routeName
        
        // set to center view
        if self.station.refId.toInt() % 2 == 0 {
            self.toCenterView.width(constant: 0)
        } else {
            self.toCenterView.width(constant: CGFloat(TimetableViewController.TO_CENTER_VIEW_WIDTH))
        }
        
        // set station name text
        self.stationNameText.text = self.station.name

        // set ui to the error and tru again view
        self.errorView.setCornerRadius(cornerRadius: 20)
        self.tryAgainView.setCornerRadius(cornerRadius: 15)
        
        self.timetableTableView.dataSource = self
        self.timetableTableView.register(UINib(nibName: "TimetableTableViewCell", bundle: nil), forCellReuseIdentifier: "TimetableTableViewCell")
        
        self.retriveTimetable()
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        
        // set status bar font to white
        setNeedsStatusBarAppearanceUpdate()
    }
    
    private func retriveTimetable() {
        DispatchQueue.main.async() {
           self.setUI(state: ScreenState.loading)
        }
        // calculate hours -> retrieve timetable for whole day
        let currentHour = Calendar.current.component(.hour, from: Date())
        let nextHours = 24 - currentHour
        let previousHours = currentHour
        
        // remove letter from route number (ex. 6B -> 6)
        let routeGroupNumber = self.route.routeNumber.replacingOccurrences( of:"[^0-9]", with: "", options: .regularExpression)
        self.lppApi.getTimetable(stationCode: station.refId, routeGroupNumber: routeGroupNumber, nextHours: nextHours, previousHours: previousHours) {
            (result) in
            if result.success {
                let routes = result.data!.routeGroups[0].routes
                for route in routes {
                    if route.isGarage {
                        continue
                    }
                    if (route.groupName + route.routeNumberSuffix) == self.route.routeNumber {
                        self.timetable = route.timetable
                        break
                    }
                }
                DispatchQueue.main.async() {
                    self.setUI(state: ScreenState.done)
                    self.timetableTableView.reloadData()
                    // if timetable is empty show "no schudeles arrivals for today label"
                    if self.timetable!.count == 0 {
                        self.noSchedulesArrivalsForTodayStackView.isHidden = false
                    } else {
                        self.noSchedulesArrivalsForTodayStackView.isHidden = true
                    }
                }
            } else {
                DispatchQueue.main.async() {
                    self.setUI(state: ScreenState.error)
                }
            }
        }
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
            
            if Connectivity.isConnectedToNetwork() {
                self.errorText.text = "error_during_loading".localized
            } else {
                self.errorText.text = "no_internet_connection".localized
            }
            
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
            self.retriveTimetable()
        })
    }
}

extension TimetableViewController: UITableViewDataSource {
    
    // returns size of the timetable tableview
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        if self.timetable == nil {
            return 0
        }
        return self.timetable!.count
    }
    
    
    // renders timetable tableview
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "TimetableTableViewCell", for: indexPath) as! TimetableTableViewCell
        cell.setCell(timetableTimes: timetable![indexPath.row])
        return cell
    }
}
