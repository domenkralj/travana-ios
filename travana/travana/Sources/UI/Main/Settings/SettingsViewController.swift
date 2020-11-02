//
//  SettingsViewController.swift
//  travana
//
//  Created by Domen Kralj on 04/10/2020.
//  Copyright © 2020 Domen Kralj. All rights reserved.
//

import UIKit

// Screen used for settings
class SettingsViewController: UIViewController {

    private let preferences = UserDefaults.standard
    
    @IBOutlet weak var arrivalTimeSegmentedControl: UISegmentedControl!
    
    // when view is loaded.
    override func viewDidLoad() {
        super.viewDidLoad()
        
        // set ui to the current set settings
        if preferences.object(forKey: Constants.ARRIVAL_TIME_MODE_KEY) == nil || preferences.string(forKey: Constants.ARRIVAL_TIME_MODE_KEY)! == Constants.ARRIVAL_TIME_MODE_MINUTES {
            self.arrivalTimeSegmentedControl.selectedSegmentIndex = 0
        } else {
            self.arrivalTimeSegmentedControl.selectedSegmentIndex = 1
        }
        
        // localize arrivalTimeSegmentedControl
        self.arrivalTimeSegmentedControl.setTitle("minutes_(3_min)".localized, forSegmentAt: 0)
        self.arrivalTimeSegmentedControl.setTitle("hours_(14_35)".localized, forSegmentAt: 1)
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
    
    // called when back button is clicked
    @IBAction func backButtonClicked(_ sender: UIButton) {
        self.dismiss(animated: true, completion: nil)
    }
    
    // TODO READ
    // https://stackoverflow.com/questions/19206762/ios-equivalent-for-android-shared-preferences
    @IBAction func arrivalTimeValueChanged(_ sender: UISegmentedControl) {
        // save to settings
        if sender.selectedSegmentIndex == 0 {
            self.preferences.set(Constants.ARRIVAL_TIME_MODE_MINUTES, forKey: Constants.ARRIVAL_TIME_MODE_KEY)
        } else {
            self.preferences.set(Constants.ARRIVAL_TIME_MODE_HOURS, forKey: Constants.ARRIVAL_TIME_MODE_KEY)
        }
    }
}

