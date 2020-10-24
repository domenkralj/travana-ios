//
//  StationPageViewController.swift
//  travana
//
//  Created by Domen Kralj on 23/10/2020.
//  Copyright © 2020 Domen Kralj. All rights reserved.
//

import Foundation

import UIKit

// page view controller used for controlling views in stationViewController (arrivals or routes)
class StationPageViewController: UIPageViewController, UIPageViewControllerDataSource, UIPageViewControllerDelegate {

    private(set) lazy var orderedViewControllers: [UIViewController] = {
        return [self.getArrivalsViewController(), self.getRoutesViewController()]}()
    
    public var stationPageViewControllerListener: StationPageViewControllerListener? = nil
    public var station: LppStation!
    public var stationViewController: StationViewController!
    
    // when view is loaded.
    override func viewDidLoad() {
        super.viewDidLoad()
    
        self.dataSource = self
        self.delegate = self
        
        // set first view controller - arrivals
        if let firstViewController = self.orderedViewControllers.first { self.setViewControllers([firstViewController], direction: .forward, animated: true, completion: nil) }
    }
    
    // set view to the arrivals view
    public func setStationArrivalsViewController() {
        DispatchQueue.main.async() {
            self.setViewControllers([self.orderedViewControllers[0]], direction: .reverse, animated: true, completion: nil)
        }
    }
    
    // set view to the routes view
    public func setStationRoutesViewController() {
        DispatchQueue.main.async() {
            self.setViewControllers([self.orderedViewControllers[1]], direction: .forward, animated: true, completion: nil)
        }
    }
    
    // creates arrivals view controller
    private func getArrivalsViewController() -> UIViewController {
        return UIStoryboard(name: "Main", bundle: nil).instantiateViewController(withIdentifier: "StationArrivalsViewController")
    }
    
    // creates routes view controller
    private func getRoutesViewController() -> UIViewController {
        let routesViewController = UIStoryboard(name: "Main", bundle: nil).instantiateViewController(withIdentifier: "StationRoutesViewController") as! StationRoutesViewController
        routesViewController.station = self.station
        routesViewController.stationViewController = self.stationViewController
        return routesViewController as UIViewController
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        
        // set status bar font to white
        setNeedsStatusBarAppearanceUpdate()
    }

    // called every time when page is swiped right
    // change view controller
    func pageViewController(_ pageViewController: UIPageViewController, viewControllerBefore viewController: UIViewController) -> UIViewController? {
        guard let viewControllerIndex = self.orderedViewControllers.firstIndex(of: viewController) else {
            return nil
        }
        
        let previousIndex = viewControllerIndex - 1
        
        guard previousIndex >= 0 else {
            return nil
        }
        
        guard orderedViewControllers.count > previousIndex else {
            return nil
        }
        return orderedViewControllers[previousIndex]
    }
    
    // called every time when page is swiped left
    // change view controller
    func pageViewController(_ pageViewController: UIPageViewController, viewControllerAfter viewController: UIViewController) -> UIViewController? {
        guard let viewControllerIndex = orderedViewControllers.firstIndex(of: viewController) else {
            return nil
        }
        
        let nextIndex = viewControllerIndex + 1
        let orderedViewControllersCount = orderedViewControllers.count

        guard orderedViewControllersCount != nextIndex else {
            return nil
        }
        
        guard orderedViewControllersCount > nextIndex else {
            return nil
        }
        
        return orderedViewControllers[nextIndex]
    }
    
    // called every time when page is swiped (not changed by buttons)
    func pageViewController(_ pageViewController: UIPageViewController, didFinishAnimating finished: Bool, previousViewControllers: [UIViewController], transitionCompleted completed: Bool) {
        let viewControllerIndex = self.orderedViewControllers.firstIndex(of: previousViewControllers[0])
        if completed {
            // call protocol that page has been swiped
            if viewControllerIndex == 1 {
                self.stationPageViewControllerListener?.pageSwiped(screenType: StationScreenType.arrivals)
            } else {
                self.stationPageViewControllerListener?.pageSwiped(screenType: StationScreenType.routes)
            }
        }
    }
}
protocol StationPageViewControllerListener {
    func pageSwiped(screenType: StationScreenType)
}
