//
//  FavoriteNearbyStationsBotoomSheetViewController.swift
//  travana
//
//  Created by Domen Kralj on 04/10/2020.
//  Copyright © 2020 Domen Kralj. All rights reserved.
//

import UIKit

// Bottom sheet view, which can be pulled up
// It is used for showing favorite and nearby stations
class FavoriteNearbyStationsBottomSheetViewController: UIViewController, FavoriteNearbyStationPageViewControllerListener {

    public var mainViewController: MainViewController!
    public var favoriteNearbyStationsPageViewController: FavoriteNearbyStationsPageViewController!
    private var screenType: FavoriteNearbyStationsScreenType = FavoriteNearbyStationsScreenType.favorites
    
    @IBOutlet weak var handleArea: UIView!
    @IBOutlet weak var handleView: UIView!
    @IBOutlet weak var pageLineView: UIView!
    @IBOutlet weak var pageLineViewConstraintLeftoSafeArea: NSLayoutConstraint!
    
    // when view is loaded.
    override func viewDidLoad() {
        super.viewDidLoad()
        
        // set line view to be the half of the screen
        self.pageLineView.width(constant: UIScreen.main.bounds.width/2)
        
        // set corner radius to the handle view
        self.handleView.setCornerRadius(cornerRadius: 4)
        
    }
    
    override func viewWillAppear(_ animated: Bool) {
    }
    
    // get an instance of the FavoriteNearbyStationsPageViewController
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        if let vc = segue.destination as? FavoriteNearbyStationsPageViewController, segue.identifier == "showFavoriteNearbyStationsPageViewController" {
            // add listner to the station page view controler
            // protcol which is called every time when page view controller is swiped (not set by buttons)
            vc.favoriteNearbyStationPageViewControllerListener = self
            vc.mainViewController = self.mainViewController
            self.favoriteNearbyStationsPageViewController = vc
        }
    }
    
    // called when FavoriteNearbyStationsPageViewController is swiped
    func pageSwiped(screenType: FavoriteNearbyStationsScreenType) {
        self.toggleStationScreenTypeButtons(screenType: screenType)
    }
    
    // toggle stations type buttons (arrivals or routes) and animate
    private func toggleStationScreenTypeButtons(screenType: FavoriteNearbyStationsScreenType) {
        if screenType == FavoriteNearbyStationsScreenType.favorites {
            self.pageLineViewConstraintLeftoSafeArea.constant = 0
        } else {
            self.pageLineViewConstraintLeftoSafeArea.constant = UIScreen.main.bounds.width/2
        }
        UIView.animate(withDuration: 0.25) {
            self.view.layoutIfNeeded()
        }
    }
    
    @IBAction func favoritesButtonClicked(_ sender: UIButton) {
        if !self.mainViewController.cardVisible {
            self.mainViewController.tooggleFavoritesNeabyBottomSheetViewController()
        }
        self.favoriteNearbyStationsPageViewController.setFavoriteStationsViewController()
        self.toggleStationScreenTypeButtons(screenType: FavoriteNearbyStationsScreenType.favorites)
    }
    
    @IBAction func nearbyButtonClicked(_ sender: UIButton) {
        if !self.mainViewController.cardVisible {
            self.mainViewController.tooggleFavoritesNeabyBottomSheetViewController()
        }
        self.favoriteNearbyStationsPageViewController.setNearbyStationsViewController()
        self.toggleStationScreenTypeButtons(screenType: FavoriteNearbyStationsScreenType.nearby)
    }
}

enum FavoriteNearbyStationsScreenType {
    case favorites, nearby
}
