//
//  StationInfoWindowUIView.swift
//  travana
//
//  Created by Domen Kralj on 28/10/2020.
//  Copyright © 2020 Domen Kralj. All rights reserved.
//

import UIKit

class StationInfoWindowUIView: UIView {

    private var station: LppStation!
    
    @IBOutlet weak var statioNameText: UILabel!
    @IBOutlet weak var toCenterView: UIView!
    @IBOutlet weak var mainViewHolder: UIView!
    @IBOutlet weak var routesUiCollectionView: UICollectionView!
    
    override func awakeFromNib() {
        self.mainViewHolder.setCornerRadius(cornerRadius: 5)
        self.toCenterView.setCornerRadius(cornerRadius: 9)
        
        self.routesUiCollectionView.register(UINib(nibName: "RoutePillCollectionViewCell", bundle: nil), forCellWithReuseIdentifier: "RoutePillCollectionViewCell")
    }
    
    public func setCell(station: LppStation) {
        self.station = station
        self.statioNameText.text = station.name
        
        if station.refId.toInt() % 2 == 0 {
            self.toCenterView.isHidden = true
        } else {
            self.toCenterView.isHidden = false
        }
        
        self.routesUiCollectionView.dataSource = self
    
        // set height of the window depends of route group count
        let routeGroupCount = station.routeGroupsOnStation!.count
        
        switch routeGroupCount {
        case 0..<6:
             self.frame.size.height = 120
        case 0..<12:
             self.frame.size.height = 130
        case 0..<18:
            self.frame.size.height = 160
        case 0..<24:
            self.frame.size.height = 190
        case 0..<30:
            self.frame.size.height = 220
        default:
            self.frame.size.height = 120
        }
    }
}

extension StationInfoWindowUIView: UICollectionViewDataSource {
    
    // returns size of the rotue pills collection view
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return station.routeGroupsOnStation!.count
    }
    
    // renders route pills collection view
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let cell = routesUiCollectionView.dequeueReusableCell(withReuseIdentifier: "RoutePillCollectionViewCell", for: indexPath) as! RoutePillCollectionViewCell
        let routeGroupName = station.routeGroupsOnStation![indexPath.row]
        cell.setCell(routeNumber: routeGroupName)
        return cell
    }
}
