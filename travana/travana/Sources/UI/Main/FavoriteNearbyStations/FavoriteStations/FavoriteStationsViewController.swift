//
//  FavoriteStationsViewController.swift
//  travana
//
//  Created by Domen Kralj on 27/10/2020.
//  Copyright © 2020 Domen Kralj. All rights reserved.
//

import UIKit

class FavoriteStationsViewController: UIViewController {

    public var mainViewController: MainViewController!
    private var favoriteStations: [LppStation]? = nil
    
    @IBOutlet weak var favoriteStationsTableView: UITableView!
    @IBOutlet weak var loading: UIActivityIndicatorView!
    @IBOutlet weak var errorView: UIView!
    @IBOutlet weak var tryAgainView: UIView!
    @IBOutlet weak var noFavoritesAddedStackView: UIStackView!
    @IBOutlet weak var errorText: UILabel!
    
    override func viewDidLoad() {
        super.viewDidLoad()

        // set search result table view
        self.favoriteStationsTableView.dataSource = self
        self.favoriteStationsTableView.delegate = self
        self.favoriteStationsTableView.register(UINib(nibName: "FavoriteNearbyStationTableViewCell", bundle: nil), forCellReuseIdentifier: "FavoriteNearbyStationTableViewCell")
        self.favoriteStationsTableView.contentInset = UIEdgeInsets(top: 0, left: 0, bottom: 120, right: 0)
        
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
    
        let fullStations = self.mainViewController?.stations
        if fullStations == nil {
            DispatchQueue.main.async {
                self.favoriteStationsTableView.reloadData()
            }
            return
        }
        var innerFavoriteStations: [LppStation] = []
        for station in fullStations! {
            if LppApi.isStationInFavorites(stationRefId: station.refId) {
                innerFavoriteStations.append(station)
            }
        }
        self.favoriteStations = innerFavoriteStations
        
        DispatchQueue.main.async {
            if self.favoriteStations!.count == 0 {
                self.noFavoritesAddedStackView.isHidden = false
                self.favoriteStationsTableView.isHidden = true
            } else {
                self.noFavoritesAddedStackView.isHidden = true
                self.favoriteStationsTableView.isHidden = false
            }
        }
        
        DispatchQueue.main.async {
            self.favoriteStationsTableView.reloadData()
        }
    }
    
    // set ui, depends on screen state
    public func setUI(state: ScreenState) {
        switch state {
        case ScreenState.done:
            self.favoriteStationsTableView.isHidden = false
            self.loading.isHidden = true
            self.errorView.isHidden = true
            self.tryAgainView.isHidden = true
        case ScreenState.error:
            self.favoriteStationsTableView.isHidden = true
            self.loading.isHidden = true
            self.errorView.isHidden = false
            self.tryAgainView.isHidden = false
            
            if Connectivity.isConnectedToNetwork() {
                self.errorText.text = "error_during_loading".localized
            } else {
                self.errorText.text = "no_internet_connection".localized
            }
            
        case ScreenState.loading:
            self.favoriteStationsTableView.isHidden = true
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
    @IBAction func addFavoritesButtonClicked(_ sender: UIButton) {
        // opean search view controller
        let vc = (UIStoryboard.init(name: "Main", bundle: Bundle.main).instantiateViewController(withIdentifier: "SearchViewController") as? SearchViewController)!
        vc.modalPresentationStyle = .fullScreen
        self.present(vc, animated: true, completion: nil)
    }
}

extension FavoriteStationsViewController: UITableViewDataSource, UITableViewDelegate {
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        if self.favoriteStations == nil {
            return 0
        }
        
        return self.favoriteStations!.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "FavoriteNearbyStationTableViewCell", for: indexPath) as! FavoriteNearbyStationTableViewCell
        cell.setCell(station: self.favoriteStations![indexPath.row])
        return cell
    }
    
    // called when one of the cells is clicked
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        // open station view controller
        let station = self.favoriteStations![indexPath.row]
        let vc = UIStoryboard.init(name: "Main", bundle: Bundle.main).instantiateViewController(withIdentifier: "StationViewController") as! StationViewController
        vc.station = station
        vc.modalPresentationStyle = .fullScreen
        self.present(vc, animated: true, completion: nil)
    }
}
