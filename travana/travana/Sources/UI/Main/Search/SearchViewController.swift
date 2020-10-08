//
//  SearchViewController.swift
//  travana
//
//  Created by Domen Kralj on 04/10/2020.
//  Copyright © 2020 Domen Kralj. All rights reserved.
//

import UIKit

// Screen used for searching
class SearchViewController: UIViewController {

    private let lppApi: LppApi
    private var stations: [LppStation]?
    private var routes: [LppRoute]?
    
    @IBOutlet weak var searchTextField: UITextField!
    @IBOutlet weak var searchResultsTableView: UITableView!
    @IBOutlet weak var loading: UIActivityIndicatorView!
    @IBOutlet weak var errorView: UIView!
    @IBOutlet weak var tryAgainView: UIView!
    
    private var tryAgainViewGesture: UITapGestureRecognizer?
    
    required init?(coder aDecoder: NSCoder) {
        let app = UIApplication.shared.delegate as! AppDelegate
        let appData: TravanaAppDataContainer = app.getAppData()
        self.lppApi = appData.getLppApi()
        
        super.init(coder: aDecoder)
    }
    
    // when view is loaded.
    override func viewDidLoad() {
        super.viewDidLoad()
    
        // set search place hodler (text and color)
        searchTextField.attributedPlaceholder = NSAttributedString(string: "Bavarski dvor, 19B, dolgi most".localized, attributes: [NSAttributedString.Key.foregroundColor: UIColor.GREY])
        
        // set search result table view
        self.searchResultsTableView.dataSource = self
        self.searchResultsTableView.delegate = self
        self.searchResultsTableView.register(UINib(nibName: "SearchResultTableViewCell", bundle: nil), forCellReuseIdentifier: "SearchResultTableViewCell")

        self.errorView.layer.cornerRadius = 15
        self.tryAgainView.layer.cornerRadius = 10
        
        //start animating loading
        self.loading.startAnimating()
        
        self.tryAgainViewGesture = UITapGestureRecognizer(target: self, action: #selector(tryAgainViewClicked))
        self.tryAgainView.addGestureRecognizer(tryAgainViewGesture!)
        
        self.setUI(state: ScreenState.error)
        //self.retrieveStationsAndBusRoutes()
    }
    
    private func retrieveStationsAndBusRoutes() {
        self.lppApi.getStationsAndBusRoutes() { (result) -> () in
            if result.success {
                self.stations = result.data!["stations"] as? [LppStation]
                self.routes = result.data!["routes"] as? [LppRoute]
                
                print("MICKA STATIONS" + String(self.stations!.count))
                print("MICKA ROUTES" + String(self.routes!.count))
            } else {
                // TODO SET ERROR UI
            }
        }
    }
    
    // set ui, depends on screen state
    private func setUI(state: ScreenState) {
        switch state {
        case ScreenState.done:
            self.searchResultsTableView.isHidden = false
            self.loading.isHidden = true
            self.errorView.isHidden = true
            self.tryAgainView.isHidden = true
        case ScreenState.error:
            self.searchResultsTableView.isHidden = true
            self.loading.isHidden = true
            self.errorView.isHidden = false
            self.tryAgainView.isHidden = false
        case ScreenState.loading:
            self.searchResultsTableView.isHidden = true
            self.loading.isHidden = false
            self.errorView.isHidden = true
            self.tryAgainView.isHidden = true
        }
    }
    
    // called when back button is pressed
    @IBAction func backButtonClicked(_ sender: UIButton) {
        self.dismiss(animated: true, completion: nil)
    }
    
    @IBAction func tryAgainViewClicked() {
        // TODO
        print("try again")
    }
}

extension SearchViewController: UITableViewDataSource, UITableViewDelegate {
    
    // return result tableview size
    // if there is more than 200 results, display 200
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return 50
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "SearchResultTableViewCell", for: indexPath) as? SearchResultTableViewCell

        cell?.mainText.text = String(indexPath.row)
        
        return cell!
    }
}

enum SearchResultType {
    case station, busLine
}


