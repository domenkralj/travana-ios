//
//  LoadingViewController.swift
//  travana
//
//  Created by Domen Kralj on 28/09/2020.
//  Copyright © 2020 Domen Kralj. All rights reserved.
//

import UIKit

/// Splash screen
class LoadingViewController: UIViewController {
    
    private static let DELAY: Double = 1 // seconds
    
    /// default initializer
    required init?(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)
    }

    /// when view is loaded.
    override func viewDidLoad() {
        super.viewDidLoad()
        // Open Main screen after DELAY
        DispatchQueue.main.asyncAfter(deadline: .now() + LoadingViewController.DELAY) {
            if let vc = UIStoryboard(name: "Main", bundle: nil).instantiateViewController(withIdentifier: "MainViewController") as? MainViewController {
                vc.modalPresentationStyle = .fullScreen
                self.present(vc, animated: true, completion: nil)
            }
        }
    }
}
