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

    private var searchResult: [SearchResultContainer]?
    private var filtertedSearchResult: [SearchResultContainer]?
    private let lppApi: LppApi
    private let logger: ConsoleLogger = LoggerFactory.getLogger(name: "SearchViewController")
    
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
        searchTextField.attributedPlaceholder = NSAttributedString(string: "Bavarski dvor, 6B, dolgi most".localized, attributes: [NSAttributedString.Key.foregroundColor: UIColor.GREY])
        
        // set search result table view
        self.searchResultsTableView.dataSource = self
        self.searchResultsTableView.delegate = self
        self.searchResultsTableView.register(UINib(nibName: "SearchResultTableViewCell", bundle: nil), forCellReuseIdentifier: "SearchResultTableViewCell")

        // set ui to the error and tru again view
        self.errorView.layer.cornerRadius = 15
        self.tryAgainView.layer.cornerRadius = 10
        
        //start animating loading
        self.loading.startAnimating()
        
        self.tryAgainViewGesture = UITapGestureRecognizer(target: self, action: #selector(tryAgainViewClicked))
        self.tryAgainView.addGestureRecognizer(tryAgainViewGesture!)
        
        self.retrieveStationsAndBusRoutes()
        
    }
    
    private func retrieveStationsAndBusRoutes() {
        // set ui to loading
        DispatchQueue.main.async {
            self.setUI(state: ScreenState.loading)
        }
        self.lppApi.getStationsAndBusRoutes() { (result) -> () in
            if result.success {
                // clear previous search results
                self.searchResult?.removeAll()
                self.searchResult = []
                
                // add stations and routes to the list
                
                let stations = result.data!["stations"] as! [LppStation]
                for station in stations {
                    self.searchResult!.append(SearchResultContainer(station: station))
                }
                
                let routes = result.data!["routes"] as! [LppRoute]
                for route in routes {
                    self.searchResult!.append(SearchResultContainer(route: route))
                }
                
                // update ui and reload searchResultTableview
                DispatchQueue.main.async {
                    self.setUI(state: ScreenState.done)
                    self.searchResultsTableView.reloadData()
                }
                
                // set results to the filtered list (data was loaded - search text is empty - show all results)
                self.filtertedSearchResult = self.searchResult
                
            } else {
                // set ui to error
                DispatchQueue.main.async {
                    self.setUI(state: ScreenState.error)
                }
            }
        }
    }
    
    private func updateResultTable() {
        // check if valid data exists
        if searchResult == nil {
            self.logger.info("Calling update result table without any data, returning function")
            return
        }
        
        var searchPattern = searchTextField.text
        
        // if search pattern is empty show all results
        if searchPattern == nil || searchPattern!.isEmpty {
            self.filtertedSearchResult = searchResult
            DispatchQueue.main.async {
                self.searchResultsTableView.reloadData()
            }
            return
        }
        
        // clear search pattern
        searchPattern = searchPattern!.replacingOccurrences(of: "ž", with: "z")
        searchPattern = searchPattern!.replacingOccurrences(of: "č", with: "c")
        searchPattern = searchPattern!.replacingOccurrences(of: "š", with: "s")
        searchPattern = searchPattern!.replacingOccurrences(of: " ", with: "")
        
        self.filtertedSearchResult = []
        for result in searchResult! {
            if result.resultType == SearchResultType.route {
                let route = result.route!
                var routeSearchid = route.routeName + "#" + route.shortRouteName + "#" + route.routeNumber
                routeSearchid = routeSearchid.replacingOccurrences(of: "ž", with: "z")
                routeSearchid = routeSearchid.replacingOccurrences(of: "č", with: "c")
                routeSearchid = routeSearchid.replacingOccurrences(of: "š", with: "s")
                routeSearchid = routeSearchid.replacingOccurrences(of: " ", with: "")
                if routeSearchid.containsIgnoringCase(find: searchPattern!) {
                    filtertedSearchResult?.append(result)
                }
            } else {
                let station = result.station!
                var stationSearchId = station.name
                stationSearchId = stationSearchId.replacingOccurrences(of: "ž", with: "z")
                stationSearchId = stationSearchId.replacingOccurrences(of: "č", with: "c")
                stationSearchId = stationSearchId.replacingOccurrences(of: "š", with: "s")
                stationSearchId = stationSearchId.replacingOccurrences(of: " ", with: "")
                if stationSearchId.containsIgnoringCase(find: searchPattern!) {
                    filtertedSearchResult?.append(result)
                }
            }
        }
        DispatchQueue.main.async {
            self.searchResultsTableView.reloadData()
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
    
    // called when back button is clicked
    @IBAction func backButtonClicked(_ sender: UIButton) {
        self.dismiss(animated: true, completion: nil)
    }
    
    // called when try again view is clicked
    @IBAction func tryAgainViewClicked() {
        DispatchQueue.main.async {
            self.setUI(state: ScreenState.loading)
        }
        DispatchQueue.main.asyncAfter(deadline: .now() + .seconds(1), execute: {
            self.retrieveStationsAndBusRoutes()
        })
    }
    
    // called whean search text field is changed
    @IBAction func searchTextFieldChanged(_ sender: UITextField) {
        self.updateResultTable()
    }
}

extension SearchViewController: UITableViewDataSource, UITableViewDelegate {
    
    // return result tableview size
    // if there is more than 200 results, display 200
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        if filtertedSearchResult == nil {
            return 0
        }
        
        if filtertedSearchResult!.count > 200  {
            return 200
        }
        
        return filtertedSearchResult!.count
    }
    
    // reneder result cell
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "SearchResultTableViewCell", for: indexPath) as? SearchResultTableViewCell
        let result = filtertedSearchResult![indexPath.row]
        cell?.setResultCell(result: result)
        return cell!
    }
    
    // called when one of the cells is clicked
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        print("clicked")
        
        let result = self.filtertedSearchResult![indexPath.row]
        if result.resultType == SearchResultType.station {
            // TODO - OPEN STATION
        } else {
            let route = filtertedSearchResult![indexPath.row].route
            let vc = (UIStoryboard.init(name: "Main", bundle: Bundle.main).instantiateViewController(withIdentifier: "RouteViewController") as? RouteViewController)!
            vc.route = route!.routeName
            vc.modalPresentationStyle = .fullScreen
            self.present(vc, animated: true, completion: nil)
        }
    }
}

enum SearchResultType {
    case station, route
}


