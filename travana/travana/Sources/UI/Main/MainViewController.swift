//
//  MainViewController.swift
//  travana
//
//  Created by Domen Kralj on 28/09/2020.
//  Copyright © 2020 Domen Kralj. All rights reserved.
//

import UIKit
import GoogleMaps
import GoogleMapsUtils
import SideMenu
import CoreLocation
 
// ViewController used for controlling all container views of the main application
class MainViewController: UIViewController, GMSMapViewDelegate {

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
    
    public var stations: [LppStation]? = nil
    
    private let lppApi: LppApi
    private let logger: ConsoleLogger = LoggerFactory.getLogger(name: "MainViewController")
    private var clusterManager: GMUClusterManager!

    @IBOutlet weak var topBarView: UIView!
    @IBOutlet weak var mapView: GMSMapView!
    @IBOutlet weak var centerOnLocationView: UIView!
    @IBOutlet weak var errorView: UIView!
    @IBOutlet weak var tryAgainView: UIView!
    @IBOutlet weak var loadingView: UIView!
    
    required init?(coder aDecoder: NSCoder) {
        let app = UIApplication.shared.delegate as! AppDelegate
        let appData: TravanaAppDataContainer = app.getAppData()
        self.lppApi = appData.getLppApi()
        
        super.init(coder: aDecoder)
    }
    
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
        
        // Set up the cluster manager with the supplied icon generator and
        // renderer.
        let iconGenerator = GMUDefaultClusterIconGenerator(buckets: [5, 10, 50, 200], backgroundColors: [UIColor.MAIN_ORANGE_DARKER, UIColor.MAIN_BLUE, UIColor.MAIN_GREEN_DARKER, UIColor.MAIN_RED])
        let algorithm = GMUNonHierarchicalDistanceBasedAlgorithm()
        let renderer = GMUDefaultClusterRenderer(mapView: mapView,
                                    clusterIconGenerator: iconGenerator)
        clusterManager = GMUClusterManager(map: mapView, algorithm: algorithm,
                                                          renderer: renderer)

        // Register self to listen to GMSMapViewDelegate events.
        clusterManager.setMapDelegate(self)
        
        // set corner radius to the top bar
        self.topBarView.setCornerRadius(cornerRadius: 10)
        
        self.centerOnLocationView.setCornerRadius(cornerRadius: 27)
        
        // set up bottom sheet favorite, nearby station
        setUpBottomSheetViewController()
        
        // ask for location use in foreground
        self.locationManager.requestWhenInUseAuthorization()
        
        // set ui to the views
        self.errorView.setCornerRadius(cornerRadius: 20)
        self.tryAgainView.setCornerRadius(cornerRadius: 17)
        self.loadingView.setCornerRadius(cornerRadius: 17)
        
        // retrive stations data, and draw stations markers and show favorites and nearby tableviews
        self.retrieveStations()
        
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
    
    public func retrieveStations() {
        DispatchQueue.main.async() {
            self.setUI(state: ScreenState.loading)
        }
        self.lppApi.getStations() { (result) in
            if result.success {
                self.stations = result.data
                DispatchQueue.main.async() {
                    self.setUI(state: ScreenState.done)
                    self.drawStations()
                    self.setFavoriteNearbyViewControllers()                             // reload tableviews in the favorite and nearby stations view controllers
                }
            } else {
                DispatchQueue.main.async() {
                    self.setUI(state: ScreenState.error)
                }
            }
        }
    }
    
    // TODO
    private func setFavoriteNearbyViewControllers() {
        let favoriteStationViewController = self.favoriteNearbyStationBottomSheetViewController.favoriteNearbyStationsPageViewController.favoriteNearbyViewControllers[0] as! FavoriteStationsViewController
        //let nearbyStatationViewController = self.favoriteNearbyStationBottomSheetViewController.favoriteNearbyStationsPageViewController.favoriteNearbyViewControllers[1] as! NearbyStationsViewController
        favoriteStationViewController.favoriteStationsTableView.reloadData()
    }
    
    private func drawStations() {
        if self.stations == nil {
            self.logger.error("Trying to draw stations markers without stations data")
            return
        }
        
        // create station markers
        let stationMarkerView = UIImageView(image: UIImage(named: "ic_station_pin_marker_basic")!.withRenderingMode(.alwaysOriginal))
        
        // add stations markers
        for station in self.stations! {
            let stationCoor = CLLocationCoordinate2D(latitude: station.latitude, longitude: station.longitude)
            
            let stationMarker = GMSMarker(position: stationCoor)
            stationMarker.title = station.refId
            stationMarker.userData = station                        // add station code tag to marker - read station code - when user click on marker
            stationMarker.snippet = ""                              // empty snippet creates info window better
            stationMarker.iconView = stationMarkerView
            stationMarker.isFlat = true
            stationMarker.groundAnchor = CGPoint(x: 0.5, y: 0.5)
            self.clusterManager.add(stationMarker)
        }
        
    }
    
    // set ui, depends on screen state
    // this function also sets ui of the favoriteStationsViewController and nearbyStationsViewController
    private func setUI(state: ScreenState) {
        
        let favoriteStationViewController = self.favoriteNearbyStationBottomSheetViewController.favoriteNearbyStationsPageViewController.favoriteNearbyViewControllers[0] as! FavoriteStationsViewController
        //let nearbyStatationViewController = self.favoriteNearbyStationBottomSheetViewController.favoriteNearbyStationsPageViewController.favoriteNearbyViewControllers[1] as! NearbyStationsViewController
        
        switch state {
        case ScreenState.done:
            self.loadingView.isHidden = true
            self.errorView.isHidden = true
            self.tryAgainView.isHidden = true
            favoriteStationViewController.setUI(state: ScreenState.done)
        case ScreenState.error:
            self.loadingView.isHidden = true
            self.errorView.isHidden = false
            self.tryAgainView.isHidden = false
            favoriteStationViewController.setUI(state: ScreenState.error)
        case ScreenState.loading:
            self.loadingView.isHidden = false
            self.errorView.isHidden = true
            self.tryAgainView.isHidden = true
            favoriteStationViewController.setUI(state: ScreenState.loading)
        }
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
    
    
    // TODO
    // called when one of the markers is clicked
    func mapView(_ mapView: GMSMapView, didTap marker: GMSMarker) -> Bool {
      // center the map on tapped marker
      mapView.animate(toLocation: marker.position)
      // check if a cluster icon was tapped
      if marker.userData is GMUCluster {
        // zoom in on tapped cluster
        mapView.animate(toZoom: mapView.camera.zoom + 1)
        print("Did tap cluster")
        return true
      }

      print("Did tap a normal marker")
      return false
    }
    
    // create custom info window
    func mapView(_ mapView: GMSMapView, markerInfoWindow marker: GMSMarker) -> UIView? {
        let stationInfoWindow = Bundle.main.loadNibNamed("StationInfoWindow", owner: self, options: nil)?[0] as! StationInfoWindowUIView
        let stationRefId = marker.title
        var markerStation: LppStation? = nil
        for station in self.stations! {
            if station.refId == stationRefId {
                markerStation = station
                break
            }
        }
        if markerStation == nil {
            return nil
        }
        stationInfoWindow.setCell(station: markerStation!)
        return stationInfoWindow
    }
    
    func renderer(_ renderer: GMUClusterRenderer, willRenderMarker marker: GMSMarker) {

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
    
    // called when try again button is clicked
    @IBAction func tryAgainButtonClicked(_ sender: UIButton) {
        // set ui to loading
        DispatchQueue.main.async {
            self.setUI(state: ScreenState.loading)
        }
        // try to retieve data again
        DispatchQueue.main.asyncAfter(deadline: .now() + .seconds(1), execute: {
            self.retrieveStations()
        })
    }
}

enum ScreenState {
    case error, done, loading
}

