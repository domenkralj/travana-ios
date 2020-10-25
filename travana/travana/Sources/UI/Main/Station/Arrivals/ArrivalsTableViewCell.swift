//
//  ArrivalsTableViewCell.swift
//  travana
//
//  Created by Domen Kralj on 24/10/2020.
//  Copyright © 2020 Domen Kralj. All rights reserved.
//

import UIKit

class ArrivalsTableViewCell: UITableViewCell {
    
    private let logger: ConsoleLogger = LoggerFactory.getLogger(name: "ArrivalsTableViewCell")
    private var arrivals: [LppArrival2]? = nil
    
    @IBOutlet weak var arrivalsCollectionView: UICollectionView!
    @IBOutlet weak var routeNumberView: UIView!
    @IBOutlet weak var routeNumberText: UILabel!
    @IBOutlet weak var destinationText: UILabel!
    
    @IBOutlet weak var arrivalsCollectionViewHeightConstraint: NSLayoutConstraint!
    
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
            
        // remove cell highlight color when clicked
        self.selectionStyle = .none
        
        self.routeNumberView.setCornerRadius(cornerRadius: 14)
        
        // set arrivals collections view
        self.arrivalsCollectionView.dataSource = self
        self.arrivalsCollectionView.delegate = self
        self.fitCollectionViewHeight()
    }
    
    public func reloadCollectionViewArrivalsData() {
        self.fitCollectionViewHeight()
    }
    
    public func setCell(arrivals: [LppArrival2]) {
        self.arrivals = arrivals
        
        // set route data
        let arrival = arrivals[0]
        self.destinationText.text = arrival.stations.arrival
        self.routeNumberText.text = arrival.routeName
        self.routeNumberView.setBackgroundColor(color: Colors.getColorFromString(string: arrival.routeName))
        self.arrivalsCollectionView.reloadData()
    }
    
    private func fitCollectionViewHeight() {
        let height = self.arrivalsCollectionView.collectionViewLayout.collectionViewContentSize.height
        arrivalsCollectionViewHeightConstraint.constant = height
        self.layoutIfNeeded()
    }
    
}

extension ArrivalsTableViewCell: UICollectionViewDataSource, UICollectionViewDelegate, UICollectionViewDelegateFlowLayout {
    
    // return size of arrivals the uicollection view
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        if self.arrivals == nil {
            return 0
        }
        return self.arrivals!.count
    }
    
    // renders arrivals collection view cells
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let cell = self.arrivalsCollectionView.dequeueReusableCell(withReuseIdentifier: "ArrivalCollectionViewCell", for: indexPath) as! ArrivalCollectionViewCell
        let arrival = self.arrivals![indexPath.row]
        cell.setCell(arrival: arrival)
        return cell
    }
    
    
    // return size of the arrivals ui collection view
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
        let arrival = self.arrivals![indexPath.row]
        
        // returns collection view cell width depends on cell type
        if arrival.type == Lpp.PREDICTED {
            return CGSize(width: 85, height: 35)
        } else if arrival.type == Lpp.SCHEDULED {
            return CGSize(width: 70, height: 35)
        }
        return CGSize(width: 85, height: 35)
    }
}
