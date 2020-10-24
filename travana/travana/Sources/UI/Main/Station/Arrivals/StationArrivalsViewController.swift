//
//  StationArrivalsViewController.swift
//  travana
//
//  Created by Domen Kralj on 23/10/2020.
//  Copyright © 2020 Domen Kralj. All rights reserved.
//

import UIKit

// view used for showing stations arrivals
class StationArrivalsViewController: UIViewController {

    @IBOutlet weak var arrivalsTableView: UITableView!
    
    // when view is loaded.
    override func viewDidLoad() {
        super.viewDidLoad()
        
        self.arrivalsTableView.dataSource = self
        self.arrivalsTableView.delegate = self
        self.arrivalsTableView.register(UINib(nibName: "ArrivalsTableViewCell", bundle: nil), forCellReuseIdentifier: "ArrivalsTableViewCell")
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
}

extension StationArrivalsViewController: UITableViewDataSource, UITableViewDelegate {
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return 50
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "ArrivalsTableViewCell", for: indexPath) as! ArrivalsTableViewCell
        var string = ""
        for _ in 0...indexPath.row {
            string = string + String(indexPath.row) + " "
        }
        cell.customText.text = string
        return cell
    }
}
