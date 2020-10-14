//
//  RouteViewController.swift
//  travana
//
//  Created by Domen Kralj on 14/10/2020.
//  Copyright © 2020 Domen Kralj. All rights reserved.
//

import UIKit

// Screen used for showing route data
class RouteViewController: UIViewController {

    public var route: LppRoute? = nil
    private let logger: ConsoleLogger = LoggerFactory.getLogger(name: "RouteViewController")
    
    @IBOutlet weak var routeText: UILabel!
    // when view is loaded.
    override func viewDidLoad() {
        super.viewDidLoad()
        
        // returs if lpp route data is nil
        if route == nil {
            self.logger.info("Opening route view controller without lpp route data")
            self.dismiss(animated: true, completion: nil)
        }
    }
}


