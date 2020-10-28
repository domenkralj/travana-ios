//
//  FavoriteNearbyStationTableViewCell.swift
//  travana
//
//  Created by Domen Kralj on 28/10/2020.
//  Copyright © 2020 Domen Kralj. All rights reserved.
//

import UIKit

class FavoriteNearbyStationTableViewCell: UITableViewCell {

    private var station: LppStation? = nil
    private let FAVORITE_BUTTON_WITDTH: CGFloat = 22
    
    @IBOutlet weak var stationNameText: UILabel!
    @IBOutlet weak var favoriteButton: UIButton!
    @IBOutlet weak var toCenterView: UIView!
    @IBOutlet weak var routesUiCollectionView: UICollectionView!
    @IBOutlet weak var collectionViewHeightConstraint: NSLayoutConstraint!
    
    override func awakeFromNib() {
        super.awakeFromNib()
        
        // remove cell highlight color when clicked
        self.selectionStyle = .none

        self.toCenterView.setCornerRadius(cornerRadius: 10)
        
        self.routesUiCollectionView.register(UINib(nibName: "RoutePillCollectionViewCell", bundle: nil), forCellWithReuseIdentifier: "RoutePillCollectionViewCell")

    }
    
    public func setCell(station: LppStation) {
        
        self.station = station
        self.stationNameText.text = station.name
        
        // set to center view
        if station.refId.toInt() % 2 == 0 {
            self.toCenterView.isHidden = true
        } else {
            self.toCenterView.isHidden = false
        }
        
        // set favorite button view
        // TODO - READ FROM SHEARD PREFRENCES
        if true {
            self.favoriteButton.width(constant: FAVORITE_BUTTON_WITDTH)
        } else {
            self.favoriteButton.width(constant: 0)
        }
        
        self.routesUiCollectionView.dataSource = self
        self.routesUiCollectionView.reloadData()
        self.fitCollectionViewHeight()
    }
    
    private func fitCollectionViewHeight() {
        let height = self.routesUiCollectionView.collectionViewLayout.collectionViewContentSize.height
        self.collectionViewHeightConstraint.constant = height
        self.layoutIfNeeded()
    }
}

extension FavoriteNearbyStationTableViewCell: UICollectionViewDataSource {
    
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        if station == nil {
            return 10
        }
        
        return station!.routeGroupsOnStation.count
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let cell = self.routesUiCollectionView.dequeueReusableCell(withReuseIdentifier: "RoutePillCollectionViewCell", for: indexPath) as! RoutePillCollectionViewCell
        let routeNumber = station!.routeGroupsOnStation[indexPath.row]
        cell.setCell(routeNumber: routeNumber)
        return cell
    }
}
