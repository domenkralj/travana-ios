//
//  MainViewController.swift
//  travana
//
//  Created by Domen Kralj on 28/09/2020.
//  Copyright © 2020 Domen Kralj. All rights reserved.
//

import UIKit
import GoogleMaps
import SideMenu
import CoreLocation
 
// ViewController used for controlling all container views of the main application
class MainViewController: UIViewController {
    
    enum CardState {
        case expanded
        case collapsed
    }
    
    var favoriteNearbyStationBottomSheetViewController: FavoriteNearbyStationsBottomSheetViewController!
    var visualEffectView: UIVisualEffectView!
    
    var cardHeight: CGFloat = 0
    let cardHandleAreaHeight: CGFloat = 150
    private let locationManager = CLLocationManager()
    
    var cardVisible = false
    var nextState: CardState {
        return cardVisible ? .collapsed : .expanded
    }
    
    var runningAnimations = [UIViewPropertyAnimator]()
    var animationProgressWhenInterrupted:CGFloat = 0
    
    private let logger: ConsoleLogger = LoggerFactory.getLogger(name: "MainViewController")

    @IBOutlet weak var topBarView: UIView!
    @IBOutlet weak var mapView: GMSMapView!
    @IBOutlet weak var centerOnLocationView: UIView!
    
    override func viewDidLoad() {
        do {
            // Set the map style by passing the URL of the local file.
            if let styleURL = Bundle.main.url(forResource: "google-maps-style", withExtension: "json") {
                self.mapView.mapStyle = try GMSMapStyle(contentsOfFileURL: styleURL)
            } else {
                logger.error("Unable to find google-maps-style.json")
            }
        } catch {
            logger.error("One or more of the map styles failed to load. \(error)")
        }
        
        // set corner radius to the top bar
        self.topBarView.setCornerRadius(cornerRadius: 10)
        
        self.centerOnLocationView.setCornerRadius(cornerRadius: 27)
        
        // set up bottom sheet favorite, nearby station
        setUpBottomSheetViewController()
        
        // ask for location use in foreground
        self.locationManager.requestWhenInUseAuthorization()

    }
    
    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(animated)
        
        // set camera to Ljubljana - default city
        let ljubljana = GMSCameraPosition.camera(
          withLatitude: 46.056946,
          longitude: 14.505751,
          zoom: 12
        )
        self.mapView.camera = ljubljana
        
        // if location services are availible show location on map
        if CLLocationManager.locationServicesEnabled() {
            switch CLLocationManager.authorizationStatus() {
                case .notDetermined, .restricted, .denied:
                    self.mapView.isMyLocationEnabled = false
                case .authorizedAlways, .authorizedWhenInUse:
                    self.mapView.isMyLocationEnabled = true
                default:
                    self.mapView.isMyLocationEnabled = false
            }
        } else {
            // Location services are not enabled
            self.mapView.isMyLocationEnabled = false
        }
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
    
    func setUpBottomSheetViewController() {
        
        self.cardHeight = self.view.frame.height - (view.window?.windowScene?.statusBarManager?.statusBarFrame.height ?? 20)
        
        visualEffectView = UIVisualEffectView()
        visualEffectView.frame = self.view.frame
        self.view.addSubview(visualEffectView)
        
        favoriteNearbyStationBottomSheetViewController = (UIStoryboard.init(name: "Main", bundle: Bundle.main).instantiateViewController(withIdentifier: "FavoriteNearbyStationsBottomSheetViewController")) as? FavoriteNearbyStationsBottomSheetViewController
        self.favoriteNearbyStationBottomSheetViewController.mainViewController = self
        self.addChild(favoriteNearbyStationBottomSheetViewController)
        self.view.addSubview(favoriteNearbyStationBottomSheetViewController.view)
        
        favoriteNearbyStationBottomSheetViewController.view.frame = CGRect(x: 0, y: self.view.frame.height - cardHandleAreaHeight, width: self.view.bounds.width, height: cardHeight)
        
        favoriteNearbyStationBottomSheetViewController.view.clipsToBounds = true
    
        // this should be commented - better ux
        //favoriteNearbyStationBottomSheetViewController.handleArea.addGestureRecognizer(tapGestureRecognizer)
        //let tapGestureRecognizer = UITapGestureRecognizer(target: self, action: #selector(MainViewController.handleCardTap(recognzier:)))
    
        let panGestureRecognizer = UIPanGestureRecognizer(target: self, action: #selector(MainViewController.handleCardPan(recognizer:)))
        favoriteNearbyStationBottomSheetViewController.handleArea.addGestureRecognizer(panGestureRecognizer)
        
        // enable user interaction with self.view
        self.visualEffectView.removeFromSuperview()
        
    }
    
    public func tooggleFavoritesNeabyBottomSheetViewController() {
        self.animateTransitionIfNeeded(state: nextState, duration: 0.9)
    }
    
    @IBAction func handleCardTap(recognzier: UITapGestureRecognizer) {
        switch recognzier.state {
        case .ended:
            self.animateTransitionIfNeeded(state: nextState, duration: 0.9)
        default:
            break
        }
    }
    
    @IBAction func handleCardPan (recognizer:UIPanGestureRecognizer) {
        switch recognizer.state {
        case .began:
            startInteractiveTransition(state: nextState, duration: 0.9)
        case .changed:
            let translation = recognizer.translation(in: self.favoriteNearbyStationBottomSheetViewController.handleArea)
            var fractionComplete = translation.y / cardHeight
            fractionComplete = cardVisible ? fractionComplete : -fractionComplete
            self.updateInteractiveTransition(fractionCompleted: fractionComplete)
        case .ended:
            self.continueInteractiveTransition()
        default:
            break
        }
        
    }
    
    func animateTransitionIfNeeded (state:CardState, duration:TimeInterval) {
        if runningAnimations.isEmpty {
            let frameAnimator = UIViewPropertyAnimator(duration: duration, dampingRatio: 1) {
                switch state {
                case .expanded:
                    self.favoriteNearbyStationBottomSheetViewController.view.frame.origin.y = self.view.frame.height - self.cardHeight
                case .collapsed:
                    self.favoriteNearbyStationBottomSheetViewController.view.frame.origin.y = self.view.frame.height - self.cardHandleAreaHeight
                }
            }
            
            frameAnimator.addCompletion { _ in
                self.cardVisible = !self.cardVisible
                self.runningAnimations.removeAll()
            }
            
            frameAnimator.startAnimation()
            runningAnimations.append(frameAnimator)
            
            
            let blurAnimator = UIViewPropertyAnimator(duration: duration, dampingRatio: 1) {
                switch state {
                case .expanded:
                    self.visualEffectView.effect = UIBlurEffect(style: .dark)
                case .collapsed:
                    self.visualEffectView.effect = nil
                }
            }
            
            blurAnimator.startAnimation()
            runningAnimations.append(blurAnimator)
            
        }
    }
    
    func startInteractiveTransition(state:CardState, duration:TimeInterval) {
        if runningAnimations.isEmpty {
            animateTransitionIfNeeded(state: state, duration: duration)
        }
        for animator in runningAnimations {
            animator.pauseAnimation()
            animationProgressWhenInterrupted = animator.fractionComplete
        }
    }
    
    func updateInteractiveTransition(fractionCompleted:CGFloat) {
        for animator in runningAnimations {
            animator.fractionComplete = fractionCompleted + animationProgressWhenInterrupted
        }
    }
    
    func continueInteractiveTransition (){
        for animator in runningAnimations {
            animator.continueAnimation(withTimingParameters: nil, durationFactor: 0)
        }
    }
    
    // called when search button is clicked
    @IBAction func searchButtonClicked(_ sender: UIButton) {
        // opean search view controller
        let vc = (UIStoryboard.init(name: "Main", bundle: Bundle.main).instantiateViewController(withIdentifier: "SearchViewController") as? SearchViewController)!
        vc.modalPresentationStyle = .fullScreen
        self.present(vc, animated: true, completion: nil)
    }
    
    // called when menu button is clicked
    @IBAction func menuButtonClicked(_ sender: UIButton) {
        let settingsVc = (UIStoryboard.init(name: "Main", bundle: Bundle.main).instantiateViewController(withIdentifier: "MainNavigationDrawerViewController"))
        let slideMenuNavigationController = SideMenuNavigationController(rootViewController: settingsVc)
        slideMenuNavigationController.leftSide = true
        slideMenuNavigationController.presentationStyle = .menuSlideIn
        slideMenuNavigationController.navigationBar.isHidden = true
        self.present(slideMenuNavigationController, animated: true, completion: nil)
    }
    
    // called when center on location button is clicked
    @IBAction func centerOnLocationButtonClicked(_ sender: UIButton) {
        // if location is enabled, center map camera on location or ask for location
        if mapView.isMyLocationEnabled {
            let location: CLLocationCoordinate2D? = self.locationManager.location?.coordinate
            if location != nil {
                self.mapView.animate(to: GMSCameraPosition.camera(withLatitude: location!.latitude, longitude: location!.longitude, zoom: 16.0))
            } else {
                // Do nothing - maybe show toast, that user location is not availible
            }
        } else {
            // try to ask for user location
            // ask for location use in foreground
            self.locationManager.requestWhenInUseAuthorization()
        }
    }
}

enum ScreenState {
    case error, done, loading
}

