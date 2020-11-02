//
//  MainNavigationDrawerViewController.swift
//  travana
//
//  Created by Domen Kralj on 04/10/2020.
//  Copyright © 2020 Domen Kralj. All rights reserved.
//

import UIKit

// Main navigation drawer
class MainNavigationDrawerViewController: UIViewController {

    @IBOutlet weak var detoursView: UIView!
    @IBOutlet weak var newsView: UIView!
    @IBOutlet weak var settingsView: UIView!
    @IBOutlet weak var infoView: UIView!
    
    private var detoursViewGesture: UITapGestureRecognizer?
    private var newsViewGesture: UITapGestureRecognizer?
    private var settingsViewGesture: UITapGestureRecognizer?
    private var infoViewGesture: UITapGestureRecognizer?
    
    required init?(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)
        
        self.detoursViewGesture = UITapGestureRecognizer(target: self, action: #selector(detoursViewClicked))
        self.newsViewGesture = UITapGestureRecognizer(target: self, action: #selector(newsViewClicked))
        self.settingsViewGesture = UITapGestureRecognizer(target: self, action: #selector(settingsViewClicked))
        self.infoViewGesture = UITapGestureRecognizer(target: self, action: #selector(infoViewClicked))
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        
        if let detoursViewGesture = self.detoursViewGesture {
            self.detoursView.addGestureRecognizer(detoursViewGesture)
        }
        if let newsViewGesture = self.newsViewGesture {
            self.newsView.addGestureRecognizer(newsViewGesture)
        }
        if let settingsViewGesture = self.settingsViewGesture {
            self.settingsView.addGestureRecognizer(settingsViewGesture)
        }
        if let infoViewGesture = self.infoViewGesture {
            self.infoView.addGestureRecognizer(infoViewGesture)
        }
    }
    
    override func viewWillDisappear(_ animated: Bool) {
        super.viewWillDisappear(animated)
        
           if let detoursViewGesture = self.detoursViewGesture {
            self.detoursView.removeGestureRecognizer(detoursViewGesture)
        }
        if let newsViewGesture = self.newsViewGesture {
            self.newsView.removeGestureRecognizer(newsViewGesture)
        }
        if let settingsViewGesture = self.settingsViewGesture {
            self.settingsView.removeGestureRecognizer(settingsViewGesture)
        }
        if let infoViewGesture = self.infoViewGesture {
            self.infoView.removeGestureRecognizer(infoViewGesture)
        }
    }
    
    @IBAction func detoursViewClicked() {
        let vc = UIStoryboard.init(name: "Main", bundle: Bundle.main).instantiateViewController(withIdentifier: "DetoursViewController") as! DetoursViewController
        vc.modalPresentationStyle = .fullScreen
        self.present(vc, animated: true, completion: nil)
    }
    
    @IBAction func newsViewClicked() {
        let urlString = Constants.LPP_WEBSIDE_NEWS_LINK
        
        if let url = URL(string: urlString) {
            let vc = UIStoryboard.init(name: "Main", bundle: Bundle.main).instantiateViewController(withIdentifier: "WebViewController") as! WebViewController
            vc.url = url
            vc.webTitle = urlString
            vc.modalPresentationStyle = .fullScreen
            self.present(vc, animated: true, completion: nil)
        } else {
            Toast.show(message: "something_went_wrong_cannot_open_news".localized, controller: self)
        }
    }
    
    @IBAction func settingsViewClicked() {
        let vc = UIStoryboard.init(name: "Main", bundle: Bundle.main).instantiateViewController(withIdentifier: "SettingsViewController") as! SettingsViewController
        vc.modalPresentationStyle = .fullScreen
        self.present(vc, animated: true, completion: nil)
    }
    
    @IBAction func infoViewClicked() {
        let vc = UIStoryboard.init(name: "Main", bundle: Bundle.main).instantiateViewController(withIdentifier: "InfoViewController") as! InfoViewController
        vc.modalPresentationStyle = .fullScreen
        self.present(vc, animated: true, completion: nil)
    }
}
