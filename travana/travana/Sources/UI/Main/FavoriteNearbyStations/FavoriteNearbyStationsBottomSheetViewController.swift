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
    
    @IBOutlet weak var favoritesButton: UIButton!
    @IBOutlet weak var nearbyButton: UIButton!
    
    // when view is loaded.
    override func viewDidLoad() {
        super.viewDidLoad()
        
        // set line view to be the half of the screen
        self.pageLineView.width(constant: UIScreen.main.bounds.width/2)
        
        // set corner radius to the handle view
        self.handleView.setCornerRadius(cornerRadius: 4)
        
    }
    
    override func viewDidAppear(_ animated: Bool) {
        print(self.screenType)
        self.setStationScreenType(screenType: self.screenType)
        //self.toggleStationScreenTypeButtons(screenType: self.screenType)
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
        self.toggleStationScreenType(screenType: screenType)
    }
    
    private func toggleStationScreenType(screenType: FavoriteNearbyStationsScreenType) {
        
        if self.screenType == FavoriteNearbyStationsScreenType.favorites {
            self.screenType = screenType
            self.favoriteNearbyStationsPageViewController.setNearbyStationsViewController()
        } else {
            self.screenType = screenType
            self.favoriteNearbyStationsPageViewController.setFavoriteStationsViewController()
        }
        self.toggleStationScreenTypeButtons(screenType: self.screenType)
    }
    
    private func setStationScreenType(screenType: FavoriteNearbyStationsScreenType) {
        self.screenType = screenType
        if self.screenType == FavoriteNearbyStationsScreenType.favorites {
            self.favoriteNearbyStationsPageViewController.setFavoriteStationsViewController()
        } else {
            self.favoriteNearbyStationsPageViewController.setNearbyStationsViewController()
        }
        self.toggleStationScreenTypeButtons(screenType: self.screenType)
    }
    
    // toggle stations type buttons (arrivals or routes) and animate
    private func toggleStationScreenTypeButtons(screenType: FavoriteNearbyStationsScreenType) {
        
        if screenType == FavoriteNearbyStationsScreenType.favorites {
            let favoritesX = self.favoritesButton.titleLabel!.frame.minX
            self.pageLineViewConstraintLeftoSafeArea.constant = favoritesX
            self.pageLineView.width(constant: self.favoritesButton.intrinsicContentSize.width)
            self.favoritesButton.setTitleColor(UIColor.MAIN_RED, for: .normal)
            self.nearbyButton.setTitleColor(UIColor.MAIN_LIGHT_GREY, for: .normal)
        } else {
            let routesX = self.nearbyButton.titleLabel!.frame.origin.x + self.nearbyButton.frame.origin.x
            self.pageLineViewConstraintLeftoSafeArea.constant = routesX
            self.pageLineView.width(constant: self.nearbyButton.intrinsicContentSize.width)
            self.favoritesButton.setTitleColor(UIColor.MAIN_LIGHT_GREY, for: .normal)
            self.nearbyButton.setTitleColor(UIColor.MAIN_RED, for: .normal)
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
