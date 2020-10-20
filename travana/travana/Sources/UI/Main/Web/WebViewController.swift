//
//  WebViewController.swift
//  travana
//
//  Created by Domen Kralj on 20/10/2020.
//  Copyright © 2020 Domen Kralj. All rights reserved.
//

import UIKit
import WebKit

// Screen used for info data
class WebViewController: UIViewController, WKNavigationDelegate {

    public var url: URL? = nil
    public var webTitle: String = ""
    private let logger: ConsoleLogger = LoggerFactory.getLogger(name: "WebViewController")
    
    @IBOutlet weak var webView: WKWebView!
    @IBOutlet weak var loading: UIActivityIndicatorView!
    @IBOutlet weak var titleText: UILabel!
    
    // when view is loaded.
    override func viewDidLoad() {
        super.viewDidLoad()
        
        self.webView.isOpaque = false
        self.webView.backgroundColor = UIColor.clear
        self.webView.navigationDelegate = self
        
        // open web view
        if url != nil {
            self.titleText.text = webTitle
            self.webView.load(URLRequest(url: url!))
        }
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        
        // start loading animation
        self.loading.startAnimating()
        
        // set status bar font to white
        setNeedsStatusBarAppearanceUpdate()
    }
    
    override func viewDidAppear(_ animated: Bool) {
        if url == nil {
            self.logger.error("Opening WebViewController with empty url")
            self.dismiss(animated: true, completion: nil)
        }
    }
    
    // set status bar font to white
    override var preferredStatusBarStyle: UIStatusBarStyle {
        .lightContent
    }
    
    // called when webview stop loading
    func webView(_ webView: WKWebView, didFinish navigation: WKNavigation!) {
        // stop loading animation
        self.loading.stopAnimating()
    }
    
    // called when back button is pressed
    @IBAction func backButtonPressed(_ sender: UIButton) {
        self.dismiss(animated: true, completion: nil)
    }
}

