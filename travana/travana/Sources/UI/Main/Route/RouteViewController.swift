//
//  RouteViewController.swift
//  travana
//
//  Created by Domen Kralj on 14/10/2020.
//  Copyright © 2020 Domen Kralj. All rights reserved.
//

import UIKit
import GoogleMaps
import CoreLocation

// Screen used for showing route data
class RouteViewController: UIViewController, GMSMapViewDelegate {
    
    enum CardState {
        case expanded
        case collapsed
    }

    var routeBottomSheetViewController:RouteBottomSheetViewController!
    var visualEffectView:UIVisualEffectView!
    
    var runningAnimations = [UIViewPropertyAnimator]()
    var animationProgressWhenInterrupted:CGFloat = 0
    
    var cardVisible = false
    var nextState: CardState {
        return cardVisible ? .collapsed : .expanded
    }
    
    public var route: LppRoute? = nil
    private var busesOnRouteMarkers: [GMSMarker]? = nil
    private var screenState: ScreenState = ScreenState.done
    private var isRouteInitilized = false
    private var requestFailedInRow = 0              // if 4 request failed in row (data is outdated for 40 seconds) - remove arrivals
    private var updateLppDatatimer: Timer!
    private let NUMBERS_OF_FAILED_REQUEST_BEFORE_REMOVE_ARRIVALS = 6
    private let lppApi: LppApi
    private let REFRESH_RATE = 5.0     // 5 seconds
    private let logger: ConsoleLogger = LoggerFactory.getLogger(name: "RouteViewController")
    private let locationManager = CLLocationManager()
    
    // create bus marker icon
    private let busMarkerView = UIImageView(image: UIImage(named: "ic_bus_marker")!.withRenderingMode(.alwaysOriginal))
    
    var cardHeight:CGFloat = 0
    let cardHandleAreaHeight:CGFloat = 120

    @IBOutlet weak var mapView: GMSMapView!
    @IBOutlet weak var centerOnLocationView: UIView!
    @IBOutlet weak var centerOnLocationIcon: UIImageView!
    @IBOutlet weak var errorView: UIView!
    @IBOutlet weak var tryAgainView: UIView!
    @IBOutlet weak var loadingView: UIView!
    @IBOutlet weak var loadingIndicator: UIActivityIndicatorView!
    
    required init?(coder aDecoder: NSCoder) {
        let app = UIApplication.shared.delegate as! AppDelegate
        let appData: TravanaAppDataContainer = app.getAppData()
        self.lppApi = appData.getLppApi()
        
        super.init(coder: aDecoder)
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        // create timer which tries to update bus arrivals and bus locations data every 10 seconds
         self.updateLppDatatimer = Timer.scheduledTimer(timeInterval: self.REFRESH_RATE, target: self, selector: #selector(self.upadateBusesAndArrivalsOnRoute), userInfo: nil, repeats: true)
        
        self.centerOnLocationView.setCornerRadius(cornerRadius: 27)
        
        // returs if lpp route data is nil
        if route == nil {
            self.logger.info("Opening route view controller without lpp route data")
            self.dismiss(animated: true, completion: nil)
        }
        
        // set Google maps - map design
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
        
        // set mapview
        self.mapView.settings.compassButton = true
        self.mapView.delegate = self
    
        // start loading animation
        self.loadingIndicator.startAnimating()
        
        // set ui to the views
        self.errorView.setCornerRadius(cornerRadius: 20)
        self.tryAgainView.setCornerRadius(cornerRadius: 17)
        self.loadingView.setCornerRadius(cornerRadius: 17)
        
        // set route stations bottom sheet view
        self.setUpRouteStationBottomSheetViewController(route: route!)
        
        // set ui to loading
        self.setUi(state: ScreenState.loading)
        
    }
    
    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(animated)
        
        // set camera to Ljublajna - default city
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
        
        // retrieve data and set ui
        // this function is called just one - when view is created
        self.retrieveBusesAndArrivalsOnRoute()
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
    
    // retrieve bus route data and update ui - called just first time
    private func retrieveBusesAndArrivalsOnRoute() {
        DispatchQueue.main.async() {
            self.setUi(state: ScreenState.loading)
        }
        self.lppApi.getBusesAndArrivalsOnRoute(tripId: route!.tripId, routeGroupNumber: route!.routeNumber) {
            (result) in
            if result.success {
                self.isRouteInitilized = true
                DispatchQueue.main.async() {
                    self.setUi(state: ScreenState.done)
                    self.setOrUpdateBuses(buses: result.data!.busesOnRoute)
                    self.drawRouteOnMapAndUpdateCamera(stations: result.data!.routeStationArrivals, routeColor: Colors.getColorFromString(string: self.route!.routeNumber))
                    self.routeBottomSheetViewController.setStationsArrivals(stationArrivals: result.data!.routeStationArrivals)
                }
            } else {
                self.isRouteInitilized = false
                DispatchQueue.main.async() {
                    self.setUi(state: ScreenState.error)
                }
            }
        }
    }
    
    // update buses and arrivals data
    @IBAction private func upadateBusesAndArrivalsOnRoute() {
        self.lppApi.getBusesAndArrivalsOnRoute(tripId: route!.tripId, routeGroupNumber: route!.routeNumber) {
            (result) in
            if result.success {
                DispatchQueue.main.async() {
                    if self.screenState == ScreenState.error {
                        self.setUi(state: ScreenState.done)
                    }
                    self.setOrUpdateBuses(buses: result.data!.busesOnRoute)
                    self.routeBottomSheetViewController.setStationsArrivals(stationArrivals: result.data!.routeStationArrivals)
                    self.requestFailedInRow = 0
                }
            } else {
                DispatchQueue.main.async() {
                    self.setUi(state: ScreenState.error)
                }
                self.requestFailedInRow = self.requestFailedInRow + 1
                if self.requestFailedInRow >= self.NUMBERS_OF_FAILED_REQUEST_BEFORE_REMOVE_ARRIVALS {
                    self.routeBottomSheetViewController.removeArrivals()
                    
                    print("claning resurces")
                    print(self.busesOnRouteMarkers!.count)
                    // remove busses on route, if data is outdated
                    DispatchQueue.main.async() {
                       for busMarker in self.busesOnRouteMarkers! {
                            busMarker.map = nil
                        }
                    }
                }
            }
        }
    }
    
    // TODO - FUNCTION SHOULD BE SHORTHER
    // update or set buses on route on the map
    private func setOrUpdateBuses(buses: [LppBus]) {
        
        // if markers are not already initlized, initilize and add buses to the map
        if self.busesOnRouteMarkers == nil {
            self.busesOnRouteMarkers = []
            for bus in buses {
                // show buses just on selected trip, not all buses on the row
                // show just buses on line (GROSUPLJE - BEŽIGRAND) and not all the buses on the lines (GROSUPLJE - BEŽIGRAD and BEŽIGRAD - GROSUPLJE)
                if route!.tripId != bus.tripId {
                    continue
                }
                let busCoor = CLLocationCoordinate2D(latitude: bus.latitude, longitude: bus.longitude)
                let busMarker = GMSMarker(position: busCoor)
                busMarker.iconView = self.busMarkerView
                busMarker.userData = bus.busUnitId              // add bus id to the marker
                busMarker.isFlat = true
                busMarker.rotation = bus.cardinalDirection
                busMarker.groundAnchor = CGPoint(x: 0.5, y: 0.5)
                busMarker.zIndex = 1                            // show marker above other icons
                busMarker.map = mapView
                self.busesOnRouteMarkers!.append(busMarker)
            }
            return
        }
        
        // remove markers which are outdated
        for i in 0..<self.busesOnRouteMarkers!.count {
            let busMarker = self.busesOnRouteMarkers![i]
            var isBusMarkOutdated = true
            for bus in buses {
                if bus.busUnitId == (busMarker.userData as! String) {
                    isBusMarkOutdated = false
                    break
                }
            }
            if isBusMarkOutdated {
                // remove marker from map
                busMarker.map = nil
                self.busesOnRouteMarkers?.remove(at: i)
            }
         }
        
        // add new markers and move/update and animate old, but still valid buses
        for bus in buses {
            if route!.tripId != bus.tripId {
                continue
            }
            
            var isBusAlreadyShown = false
            for busMarker in self.busesOnRouteMarkers! {
                if bus.busUnitId == (busMarker.userData as! String) {
                    // update bus
                    isBusAlreadyShown = true
                    busMarker.position = CLLocationCoordinate2D(latitude: bus.latitude, longitude: bus.longitude)
                    busMarker.rotation = bus.cardinalDirection
                    busMarker.map = mapView
                }
            }
            // add bus marker if bus is not already shown
            if !isBusAlreadyShown {
                let busCoor = CLLocationCoordinate2D(latitude: bus.latitude, longitude: bus.longitude)
                let busMarker = GMSMarker(position: busCoor)
                busMarker.iconView = self.busMarkerView
                busMarker.userData = bus.busUnitId              // add bus id to the marker
                busMarker.isFlat = true
                busMarker.rotation = bus.cardinalDirection
                busMarker.groundAnchor = CGPoint(x: 0.5, y: 0.5)
                busMarker.map = mapView
                self.busesOnRouteMarkers!.append(busMarker)
            }
        }
    }
    
    // set ui depends on screen state
    private func setUi(state: ScreenState) {
        switch state {
        case ScreenState.loading:
            self.loadingView.isHidden = false
            self.errorView.isHidden = true
            self.tryAgainView.isHidden = true
            self.screenState = ScreenState.loading
        case ScreenState.done:
            self.loadingView.isHidden = true
            self.errorView.isHidden = true
            self.tryAgainView.isHidden = true
            self.screenState = ScreenState.done
        case ScreenState.error:
            self.loadingView.isHidden = true
            self.errorView.isHidden = false
            self.tryAgainView.isHidden = false
            self.screenState = ScreenState.error
        }
    }
    
    private func drawRouteOnMapAndUpdateCamera(stations: [LppStationArrival], routeColor: UIColor) {
        
        let routePath = GMSMutablePath()
        var bounds = GMSCoordinateBounds()
        
        // create station markers
        let stationMarkerView = UIImageView(image: UIImage(named: "ic_station_pin_marker")!.withRenderingMode(.alwaysTemplate))
        stationMarkerView.tintColor = routeColor
        
        let stationMarkerViewInner = UIImageView(image: UIImage(named: "ic_station_pin_marker_inner")!.withRenderingMode(.alwaysTemplate))
        stationMarkerViewInner.tintColor = UIColor.MAIN_GREY
        
        // add markers and draw line between markers
        for station in stations {
            let stationCoor = CLLocationCoordinate2D(latitude: station.latitude, longitude: station.longitude)
            routePath.add(stationCoor)
            bounds = bounds.includingCoordinate(stationCoor)
            
            let stationMarker = GMSMarker(position: stationCoor)
            stationMarker.title = station.name
            stationMarker.userData = station.stationCode            // add station code tag to marker - read station code - when user click on marker
            stationMarker.snippet = ""                              // empty snippet creates info window better
            stationMarker.iconView = stationMarkerView
            stationMarker.isFlat = true
            stationMarker.groundAnchor = CGPoint(x: 0.5, y: 0.5)
            stationMarker.map = mapView
            
            let stationMarkerInner = GMSMarker(position: stationCoor)
            stationMarkerInner.title = station.name
            stationMarker.userData = station.stationCode            // add station code tag to marker - read station code - when user click on marker
            stationMarkerInner.snippet = ""                         // empty snippet creates info window better
            stationMarkerInner.iconView = stationMarkerViewInner
            stationMarkerInner.isFlat = true
            stationMarkerInner.groundAnchor = CGPoint(x: 0.5, y: 0.5)
            stationMarkerInner.map = mapView
        }
        let rectangle = GMSPolyline(path: routePath)
        rectangle.strokeWidth = 6.0
        rectangle.strokeColor = routeColor
        rectangle.map = self.mapView
        
        let update = GMSCameraUpdate.fit(bounds, withPadding: 60)
        self.mapView.animate(with: update)
        
    }
    
    private func setUpRouteStationBottomSheetViewController(route: LppRoute) {
        
        self.cardHeight = self.view.frame.height - (view.window?.windowScene?.statusBarManager?.statusBarFrame.height ?? 20)
        
        visualEffectView = UIVisualEffectView()
        visualEffectView.frame = self.view.frame
        self.view.addSubview(visualEffectView)
        
        routeBottomSheetViewController = (UIStoryboard.init(name: "Main", bundle: Bundle.main).instantiateViewController(withIdentifier: "RouteBottomSheetViewController")) as? RouteBottomSheetViewController
        routeBottomSheetViewController.route = route
        self.addChild(routeBottomSheetViewController)
        self.view.addSubview(routeBottomSheetViewController.view)
        
        routeBottomSheetViewController.view.frame = CGRect(x: 0, y: self.view.frame.height - cardHandleAreaHeight, width: self.view.bounds.width, height: cardHeight)
        
        routeBottomSheetViewController.view.clipsToBounds = true
        
        let tapGestureRecognizer = UITapGestureRecognizer(target: self, action: #selector(MainViewController.handleCardTap(recognzier:)))
        let panGestureRecognizer = UIPanGestureRecognizer(target: self, action: #selector(MainViewController.handleCardPan(recognizer:)))
        
        routeBottomSheetViewController.handleArea.addGestureRecognizer(tapGestureRecognizer)
        routeBottomSheetViewController.handleArea.addGestureRecognizer(panGestureRecognizer)
        
        // enable user interaction with self.view
        self.visualEffectView.removeFromSuperview()
    }
    
    // called when info window of marker is clicked
    func mapView(_ mapView: GMSMapView, didTap marker: GMSMarker) -> Bool {
        return false
    }
    
    // called when info window (window, which is shown when user clicks on the marker)
    func mapView(_ mapView: GMSMapView, didTapInfoWindowOf marker: GMSMarker) {
        //TODO - OPEN STATION VIEW CONTROLLER
        print("TODO - OPEN STATION VIEW CONTROLLER FOR STATION WITH: " + (marker.userData as! String))
    }
    
    @IBAction func handleCardTap(recognzier:UITapGestureRecognizer) {
        switch recognzier.state {
        case .ended:
            animateTransitionIfNeeded(state: nextState, duration: 0.9)
        default:
            break
        }
    }
    
    
    @IBAction func handleCardPan(recognizer:UIPanGestureRecognizer) {
        switch recognizer.state {
        case .began:
            startInteractiveTransition(state: nextState, duration: 0.9)
        case .changed:
            let translation = recognizer.translation(in: self.routeBottomSheetViewController.handleArea)
            var fractionComplete = translation.y / cardHeight
            fractionComplete = cardVisible ? fractionComplete : -fractionComplete
            updateInteractiveTransition(fractionCompleted: fractionComplete)
        case .ended:
            continueInteractiveTransition()
        default:
            break
        }
    }

    // called when center on location button is clicked
    // check if location is availible, update map camera view
    @IBAction func centerOnLocationButtonClicked(_ sender: Any) {
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
    // try to retrieve data again and update ui
    @IBAction func tryAgainButtonClicked(_ sender: UIButton) {
        // if route is already drawn just upadate bus locations data, otherwise retrieve data and update whole ui (route and arrivals)
        if isRouteInitilized {
            self.upadateBusesAndArrivalsOnRoute()
        } else {
            self.retrieveBusesAndArrivalsOnRoute()
        }
    }
    
    private func animateTransitionIfNeeded (state:CardState, duration:TimeInterval) {
        if runningAnimations.isEmpty {
            let frameAnimator = UIViewPropertyAnimator(duration: duration, dampingRatio: 1) {
                switch state {
                case .expanded:
                    self.routeBottomSheetViewController.view.frame.origin.y = self.view.frame.height - self.cardHeight
                case .collapsed:
                    self.routeBottomSheetViewController.view.frame.origin.y = self.view.frame.height - self.cardHandleAreaHeight
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
    
    private func startInteractiveTransition(state:CardState, duration:TimeInterval) {
        if runningAnimations.isEmpty {
            animateTransitionIfNeeded(state: state, duration: duration)
        }
        for animator in runningAnimations {
            animator.pauseAnimation()
            animationProgressWhenInterrupted = animator.fractionComplete
        }
    }
    
    private func updateInteractiveTransition(fractionCompleted:CGFloat) {
        for animator in runningAnimations {
            animator.fractionComplete = fractionCompleted + animationProgressWhenInterrupted
        }
    }
    
    private func continueInteractiveTransition (){
        for animator in runningAnimations {
            animator.continueAnimation(withTimingParameters: nil, durationFactor: 0)
        }
    }
}


