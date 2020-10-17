//
//  RouteViewController.swift
//  travana
//
//  Created by Domen Kralj on 14/10/2020.
//  Copyright © 2020 Domen Kralj. All rights reserved.
//

import UIKit
import GoogleMaps

// Screen used for showing route data
class RouteViewController: UIViewController {
    
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
    private let logger: ConsoleLogger = LoggerFactory.getLogger(name: "RouteViewController")
    private let lppApi: LppApi
    private let REFRESH_RATE = 5000     //5 seconds
    
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
        
        // create circle
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
        
        self.lppApi.getBusesAndArrivalsOnRoute(tripId: route!.tripId, routeGroupNumber: route!.routeNumber) {
            (result) in
            if result.success {
                print(result.data!.busesOnRoute)
                print(result.data!.routeStationArrivals)
            } else {
                print("Error both")
            }
        }
        
        self.setUi(state: ScreenState.done)
        
        // start loading animation
        self.loadingIndicator.startAnimating()
        
        // set ui to the views
        self.errorView.setCornerRadius(cornerRadius: 20)
        self.tryAgainView.setCornerRadius(cornerRadius: 17)
        self.loadingView.setCornerRadius(cornerRadius: 17)
        
        // set route stations bottom sheet view
        self.setUpRouteStationBottomSheetViewController(route: route!)
    }
    
    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(animated)
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
    
    
    private func setUi(state: ScreenState) {
        switch state {
        case ScreenState.loading:
            self.loadingView.isHidden = false
            self.errorView.isHidden = true
            self.tryAgainView.isHidden = true
        case ScreenState.done:
            self.loadingView.isHidden = true
            self.errorView.isHidden = true
            self.tryAgainView.isHidden = true
        case ScreenState.error:
            self.loadingView.isHidden = true
            self.errorView.isHidden = false
            self.tryAgainView.isHidden = false
        }
    }
    
    private func setUpRouteStationBottomSheetViewController(route: LppRoute) {
        
        self.cardHeight = self.view.frame.height - 20
        
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
    
    @IBAction func handleCardTap(recognzier:UITapGestureRecognizer) {
        switch recognzier.state {
        case .ended:
            animateTransitionIfNeeded(state: nextState, duration: 0.9)
        default:
            break
        }
    }
    
    
    @IBAction func handleCardPan (recognizer:UIPanGestureRecognizer) {
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
    
    @IBAction func tryAgainButtonClicked(_ sender: UIButton) {
        // TODO - TRY AGAIN
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


