//
//  FavoriteNearbyStationsPageViewController.swift
//  travana
//
//  Created by Domen Kralj on 27/10/2020.
//  Copyright © 2020 Domen Kralj. All rights reserved.
//

import UIKit

// page view controller used for controlling views in stationViewController (arrivals or routes)
class FavoriteNearbyStationsPageViewController: UIPageViewController, UIPageViewControllerDataSource, UIPageViewControllerDelegate {

    private(set) lazy var favoriteNearbyViewControllers: [UIViewController] = {
        return [self.getFavoriteStationsViewController(), self.getNearbyStationsViewController()]}()
    
    public var mainViewController: MainViewController? = nil
    public var favoriteNearbyStationPageViewControllerListener: FavoriteNearbyStationPageViewControllerListener? = nil
    
    // when view is loaded.
    override func viewDidLoad() {
        super.viewDidLoad()
    
        self.dataSource = self
        self.delegate = self
        
        // set first view controller - arrivals
        if let firstViewController = self.favoriteNearbyViewControllers.first { self.setViewControllers([firstViewController], direction: .forward, animated: true, completion: nil) }
    }
    
    // set view to the favorite stations view
    public func setFavoriteStationsViewController() {
        DispatchQueue.main.async() {
            self.setViewControllers([self.favoriteNearbyViewControllers[0]], direction: .reverse, animated: true, completion: nil)
        }
    }
    
    // set view to the nearby stations view
    public func setNearbyStationsViewController() {
        DispatchQueue.main.async() {
            self.setViewControllers([self.favoriteNearbyViewControllers[1]], direction: .forward, animated: true, completion: nil)
        }
    }
    
    // creates favorites stations view controller
    private func getFavoriteStationsViewController() -> UIViewController {
        let favoriteStationsViewController = UIStoryboard(name: "Main", bundle: nil).instantiateViewController(withIdentifier: "FavoriteStationsViewController") as! FavoriteStationsViewController
        favoriteStationsViewController.mainViewController = self.mainViewController
        return favoriteStationsViewController
    }
    
    // creates nearby stations view controller
    private func getNearbyStationsViewController() -> UIViewController {
        let nearbyStationsViewController = UIStoryboard(name: "Main", bundle: nil).instantiateViewController(withIdentifier: "NearbyStationsViewController") as! NearbyStationsViewController
        nearbyStationsViewController.mainViewController = self.mainViewController
        return nearbyStationsViewController
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        
        // set status bar font to white
        setNeedsStatusBarAppearanceUpdate()
    }

    // called every time when page is swiped right
    // change view controller
    func pageViewController(_ pageViewController: UIPageViewController, viewControllerBefore viewController: UIViewController) -> UIViewController? {
        guard let viewControllerIndex = self.favoriteNearbyViewControllers.firstIndex(of: viewController) else {
            return nil
        }
        
        let previousIndex = viewControllerIndex - 1
        
        guard previousIndex >= 0 else {
            return nil
        }
        
        guard favoriteNearbyViewControllers.count > previousIndex else {
            return nil
        }
        return favoriteNearbyViewControllers[previousIndex]
    }
    
    // called every time when page is swiped left
    // change view controller
    func pageViewController(_ pageViewController: UIPageViewController, viewControllerAfter viewController: UIViewController) -> UIViewController? {
        guard let viewControllerIndex = favoriteNearbyViewControllers.firstIndex(of: viewController) else {
            return nil
        }
        
        let nextIndex = viewControllerIndex + 1
        let orderedViewControllersCount = favoriteNearbyViewControllers.count

        guard orderedViewControllersCount != nextIndex else {
            return nil
        }
        
        guard orderedViewControllersCount > nextIndex else {
            return nil
        }
        
        return favoriteNearbyViewControllers[nextIndex]
    }
    
    // called every time when page is swiped (not changed by buttons)
    func pageViewController(_ pageViewController: UIPageViewController, didFinishAnimating finished: Bool, previousViewControllers: [UIViewController], transitionCompleted completed: Bool) {
        let viewControllerIndex = self.favoriteNearbyViewControllers.firstIndex(of: previousViewControllers[0])
        if completed {
            // call protocol that page has been swiped
            if viewControllerIndex == 1 {
                self.favoriteNearbyStationPageViewControllerListener?.pageSwiped(screenType: FavoriteNearbyStationsScreenType.favorites)
            } else {
                self.favoriteNearbyStationPageViewControllerListener?.pageSwiped(screenType: FavoriteNearbyStationsScreenType.nearby)
            }
        }
    }
}

protocol FavoriteNearbyStationPageViewControllerListener {
    func pageSwiped(screenType: FavoriteNearbyStationsScreenType)
}



