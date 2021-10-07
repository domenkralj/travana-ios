//
//  InfoViewController.swift
//  travana
//
//  Created by Domen Kralj on 04/10/2020.
//  Copyright © 2020 Domen Kralj. All rights reserved.
//

import UIKit

// Screen used for info data
class InfoViewController: UIViewController {

    @IBOutlet weak var versionText: UILabel!
    
    // when view is loaded.
    override func viewDidLoad() {
        super.viewDidLoad()
        
        
        let appVersion = Bundle.main.infoDictionary?["CFBundleShortVersionString"] as? String
        self.versionText.text = "version".localized + " " + (appVersion ?? "-.-.-")
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
    @IBAction func backButtonPressed(_ sender: UIButton) {
        self.dismiss(animated: true, completion: nil)
    }
    
    // called when contact button is clicked
    @IBAction func contactButtonClicked(_ sender: UIButton) {
        // open email
        // TODO - CHECK FOR ALTERNATIVES
        let email = "info_mail".localized
        if let url = URL(string: "mailto:\(email)") {
          if #available(iOS 10.0, *) {
            UIApplication.shared.open(url)
          } else {
            UIApplication.shared.openURL(url)
          }
        }
    }
}

