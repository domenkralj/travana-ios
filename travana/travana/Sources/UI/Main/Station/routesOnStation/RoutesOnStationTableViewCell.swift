//
//  RoutesOnStationTableViewCell.swift
//  travana
//
//  Created by Domen Kralj on 23/10/2020.
//  Copyright © 2020 Domen Kralj. All rights reserved.
//

import UIKit

class RoutesOnStationTableViewCell: UITableViewCell {
    
    private var route: LppRouteOnStation!
    
    @IBOutlet weak var routeNameText: UILabel!
    @IBOutlet weak var routeNumberView: UIView!
    @IBOutlet weak var routeNumberText: UILabel!
    
    override func awakeFromNib() {
        super.awakeFromNib()
        
        // remove cell highlight color when clicked
        self.selectionStyle = .none
    
        self.routeNumberView.setCornerRadius(cornerRadius: 14)
    }
    
    public func setCell(route: LppRouteOnStation) {
        self.route = route
        self.routeNumberText.text = route.routeNumber
        self.routeNumberView.setBackgroundColor(color: Colors.getColorFromString(string: route.routeNumber))
        self.routeNameText.text = route.routeGroupName
    }
    @IBAction func openTimetableButtonClicked(_ sender: UIButton) {
        print("TODO OPEN " + self.route.routeId)
    }
    @IBAction func openRouteButtonClicked(_ sender: UIButton) {
        print("TODO OPEN " + self.route.routeId)
    }
}
