//
//  FavoriteNearbyStationTableViewCell.swift
//  travana
//
//  Created by Domen Kralj on 28/10/2020.
//  Copyright © 2020 Domen Kralj. All rights reserved.
//

import UIKit
import CoreLocation

class FavoriteNearbyStationTableViewCell: UITableViewCell {

    private var station: LppStation? = nil
    private let TO_CENTER_VIEW_WIDTH: CGFloat = 56
    private var locationManager = CLLocationManager()
    
    @IBOutlet weak var stationNameText: UILabel!
    @IBOutlet weak var favoriteButton: UIButton!
    @IBOutlet weak var toCenterView: UIView!
    @IBOutlet weak var routesUiCollectionView: UICollectionView!
    @IBOutlet weak var collectionViewHeightConstraint: NSLayoutConstraint!
    @IBOutlet weak var toCenterViewLeftConstraint: NSLayoutConstraint!
    @IBOutlet weak var distanceText: UILabel!
    
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
            self.toCenterView.width(constant: 0)
            self.toCenterView.isHidden = true
            self.toCenterViewLeftConstraint.constant = 0
        } else {
            self.toCenterView.width(constant: TO_CENTER_VIEW_WIDTH)
            self.toCenterView.isHidden = false
            self.toCenterViewLeftConstraint.constant = 10
        }
        
        // set favorite button view
        if LppApi.isStationInFavorites(stationRefId: self.station!.refId) {
            self.favoriteButton.isHidden = false
        } else {
            self.favoriteButton.isHidden = true
        }
        
        // set distance label
        if CLLocationManager.locationServicesEnabled() {
            switch CLLocationManager.authorizationStatus() {
                case .notDetermined, .restricted, .denied:
                    // Location services are not enabled
                    self.distanceText.isHidden = true
                case .authorizedAlways, .authorizedWhenInUse:
                    // Location services should be enabled
                    let locationValue: CLLocationCoordinate2D? = self.locationManager.location?.coordinate
                    if locationValue != nil {
                        let stationLocation = CLLocation(latitude: station.latitude, longitude: station.longitude)
                        let userLocation = CLLocation(latitude: locationValue!.latitude, longitude: locationValue!.longitude)
                        let distanceInMeters = userLocation.distance(from: stationLocation)
                        
                        if distanceInMeters < 1000 {
                            self.distanceText.text = String(Int(distanceInMeters)) + " " + "m".localized
                        } else {
                            self.distanceText.text = String((distanceInMeters/1000.0).rounded(toPlaces: 1)) + " " + "km".localized
                        }
                    } else {
                        // Location services are not enabled
                        self.distanceText.isHidden = true
                    }
                default:
                    // Location services are not enabled
                    self.distanceText.isHidden = true
                break
            }
        } else {
            // Location services are not enabled
            self.distanceText.isHidden = true
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
        
        return station!.routeGroupsOnStation!.count
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let cell = self.routesUiCollectionView.dequeueReusableCell(withReuseIdentifier: "RoutePillCollectionViewCell", for: indexPath) as! RoutePillCollectionViewCell
        let routeNumber = station!.routeGroupsOnStation![indexPath.row]
        cell.setCell(routeNumber: routeNumber)
        return cell
    }
}
