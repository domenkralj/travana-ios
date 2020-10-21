//
//  StationViewController.swift
//  travana
//
//  Created by Domen Kralj on 21/10/2020.
//  Copyright © 2020 Domen Kralj. All rights reserved.
//

import UIKit

// Screen used for showing station data
class StationViewController: UIViewController {
    
    private static let TO_CENTER_VIEW_WIDTH = 70
    private var isStationInFavorites = false
    
    @IBOutlet weak var toCenterView: UIView!
    @IBOutlet weak var addToFavoritesButton: UIButton!
    
    // when view is loaded.
    override func viewDidLoad() {
        super.viewDidLoad()
        
        // se to center view
        self.toCenterView.setCornerRadius(cornerRadius: 13)
        
        // TODO - CHECK IF STATION IS FAVORITES
        // IF YES SET isStationInFavorites
        
        self.setToCenterView(show: false)
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        
        // set status bar font to white
        setNeedsStatusBarAppearanceUpdate()
    }
    
    // set status bar font to white
    override var preferredStatusBarStyle: UIStatusBarStyle {
        .lightContent
    }
    
    private func setToCenterView(show: Bool) {
        if show {
            self.toCenterView.width(constant: CGFloat(StationViewController.TO_CENTER_VIEW_WIDTH))
            self.toCenterView.isHidden = false
        } else {
            self.toCenterView.width(constant: 0)
            self.toCenterView.isHidden = true
        }
    }
    
    private func setFavoritesButton(selected: Bool) {
        if selected {
            self.addToFavoritesButton.setBackgroundImage(UIImage(systemName: "heart.fill"), for: .normal)
        } else {
            self.addToFavoritesButton.setBackgroundImage(UIImage(systemName: "heart"), for: .normal)
        }
    }
    
    // called when back button is clicked
    @IBAction func backButtonPressed(_ sender: UIButton) {
        self.dismiss(animated: true, completion: nil)
    }
    
    // called when add to favorites button is clicked
    @IBAction func addToFavoritesButtonClicked(_ sender: UIButton) {
        self.isStationInFavorites = !self.isStationInFavorites
        self.setFavoritesButton(selected: isStationInFavorites)
        // TODO ADD OR REMOVE STATION FROM FAVORITES
    }
    
    // called when opposite station button is clicked
    @IBAction func oppositeStationButtonClicked(_ sender: UIButton) {
    }
}
