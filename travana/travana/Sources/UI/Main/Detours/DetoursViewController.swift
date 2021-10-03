//
//  DetoursViewController.swift
//  travana
//
//  Created by Domen Kralj on 04/10/2020.
//  Copyright © 2020 Domen Kralj. All rights reserved.
//

import UIKit

// Screen, which is showing lpp detours
class DetoursViewController: UIViewController {
    
    private let lppApi: LppApi
    private var detours: [LppDetourInfo]? = nil
    
    @IBOutlet weak var detoursTableView: UITableView!
    @IBOutlet weak var loading: UIActivityIndicatorView!
    @IBOutlet weak var errorView: UIView!
    @IBOutlet weak var tryAgainView: UIView!
    @IBOutlet weak var errorText: UILabel!
    @IBOutlet weak var noDetoursText: UILabel!
    
    required init?(coder aDecoder: NSCoder) {
        let app = UIApplication.shared.delegate as! AppDelegate
        let appData: TravanaAppDataContainer = app.getAppData()
        self.lppApi = appData.getLppApi()
        
        super.init(coder: aDecoder)
    }
    
    // when view is loaded.
    override func viewDidLoad() {
        super.viewDidLoad()
    
        // set detours table view
        self.detoursTableView.dataSource = self
        self.detoursTableView.delegate = self
        self.detoursTableView.register(UINib(nibName: "DetourTableViewCell", bundle: nil), forCellReuseIdentifier: "DetourTableViewCell")
                
        // set loading indicator
        self.loading.startAnimating()
        
        // set ui to the error and tru again view
        self.errorView.setCornerRadius(cornerRadius: 20)
        self.tryAgainView.setCornerRadius(cornerRadius: 15)
        
        // set ui to loading
        self.setUI(state: ScreenState.loading)
        
        // retirve deturs info data
        self.retriveDetoursInfo()
        
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
    
    private func retriveDetoursInfo() {
        DispatchQueue.main.async() {
            self.setUI(state: ScreenState.loading)
        }
        self.lppApi.getDetoursInfo() {
            (result) in
            if result.success {
                self.detours = result.data
                DispatchQueue.main.async() {
                    if (self.detours!.isEmpty) {
                        print("empty")
                        self.noDetoursText.isHidden = false;
                    }
                    self.setUI(state: ScreenState.done)
                    self.detoursTableView.reloadData()
                }
            } else {
                DispatchQueue.main.async() {
                    self.setUI(state: ScreenState.error)
                }
            }
        }
    }
    
    // set ui, depends on screen state
    private func setUI(state: ScreenState) {
        switch state {
        case ScreenState.done:
            self.detoursTableView.isHidden = false
            self.loading.isHidden = true
            self.errorView.isHidden = true
            self.tryAgainView.isHidden = true
        case ScreenState.error:
            self.detoursTableView.isHidden = true
            self.loading.isHidden = true
            self.errorView.isHidden = false
            self.tryAgainView.isHidden = false
            
            if Connectivity.isConnectedToNetwork() {
                self.errorText.text = "error_during_loading".localized
            } else {
                self.errorText.text = "no_internet_connection".localized
            }
            
        case ScreenState.loading:
            self.detoursTableView.isHidden = true
            self.loading.isHidden = false
            self.errorView.isHidden = true
            self.tryAgainView.isHidden = true
        }
    }
    
    private func openWebView(url: URL, webTitle: String?) {
        let vc = (UIStoryboard.init(name: "Main", bundle: Bundle.main).instantiateViewController(withIdentifier: "WebViewController") as? WebViewController)!
        vc.url = url
        if webTitle != nil {
            vc.webTitle = webTitle!
        }
        vc.modalPresentationStyle = .fullScreen
        self.present(vc, animated: true, completion: nil)
    }
    
    // called when open lpp detours button is clicked
    @IBAction func openLppDetousButtonClicked(_ sender: UIButton) {
        let urlString = Constants.LPP_WEBSIDE_DETOURS_LINK
        if let url = URL(string: urlString) {
            self.openWebView(url: url, webTitle: urlString)
        }
    }
    
    // called when back button is pressed
    @IBAction func backButtonClicked(_ sender: UIButton) {
        self.dismiss(animated: true, completion: nil)
    }
    
    // called when try again button is clicked
    @IBAction func tryAgainButtonClicked(_ sender: UIButton) {
        // set ui to loading
        DispatchQueue.main.async {
            self.setUI(state: ScreenState.loading)
        }
        // try to retieve data again
        DispatchQueue.main.asyncAfter(deadline: .now() + .seconds(1), execute: {
            self.retriveDetoursInfo()
        })
    }
}

extension DetoursViewController: UITableViewDataSource, UITableViewDelegate {
    
    // returns size of the detoursTableView
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        if detours == nil {
            return 0
        }
        return detours!.count
    }
    
    // render detours table view
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "DetourTableViewCell", for: indexPath) as! DetourTableViewCell
        let detour = self.detours![indexPath.row]
        cell.setCell(dateString: detour.date, titleString: detour.title)
        return cell
    }
    
    // called when one of the cells is clicked
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        
        let detour = self.detours![indexPath.row]
        print(detour.moreDataUrl)
        
        let urlString = Constants.LPP_WEBSIDE_LINK + detour.moreDataUrl
        
        if let url = URL(string: urlString) {
            self.openWebView(url: url, webTitle: urlString)
        } else {
            Toast.show(message: "canot_open_detailed_data_about_detour".localized, controller: self)
        }
    }
}
