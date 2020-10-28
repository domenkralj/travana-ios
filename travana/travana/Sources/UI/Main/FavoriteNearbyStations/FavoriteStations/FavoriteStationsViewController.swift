//
//  FavoriteStationsViewController.swift
//  travana
//
//  Created by Domen Kralj on 27/10/2020.
//  Copyright © 2020 Domen Kralj. All rights reserved.
//

import UIKit

class FavoriteStationsViewController: UIViewController {

    public var mainViewController: MainViewController? = nil
    
    @IBOutlet weak var favoriteStationsTableView: UITableView!
    @IBOutlet weak var loading: UIActivityIndicatorView!
    @IBOutlet weak var errorView: UIView!
    @IBOutlet weak var tryAgainView: UIView!

    override func viewDidLoad() {
        super.viewDidLoad()

        // set search result table view
        self.favoriteStationsTableView.dataSource = self
        self.favoriteStationsTableView.delegate = self
        self.favoriteStationsTableView.register(UINib(nibName: "FavoriteNearbyStationTableViewCell", bundle: nil), forCellReuseIdentifier: "FavoriteNearbyStationTableViewCell")
        
        // set ui to the error and try again view
        self.errorView.setCornerRadius(cornerRadius: 20)
        self.tryAgainView.setCornerRadius(cornerRadius: 15)

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
}

extension FavoriteStationsViewController: UITableViewDataSource, UITableViewDelegate {
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        if self.mainViewController?.stations == nil {
            return 0
        }
        
        return self.mainViewController!.stations!.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "FavoriteNearbyStationTableViewCell", for: indexPath) as! FavoriteNearbyStationTableViewCell
        cell.setCell(station: self.mainViewController!.stations![indexPath.row])
        return cell
    }
}
