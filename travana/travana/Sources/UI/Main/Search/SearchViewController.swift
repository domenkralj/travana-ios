//
//  SearchViewController.swift
//  travana
//
//  Created by Domen Kralj on 04/10/2020.
//  Copyright © 2020 Domen Kralj. All rights reserved.
//

import UIKit

// Screen used for searching
class SearchViewController: UIViewController {

    @IBOutlet weak var searchTextField: UITextField!
    @IBOutlet weak var searchResultsTableView: UITableView!
    
    // when view is loaded.
    override func viewDidLoad() {
        super.viewDidLoad()
    
        // set search place hodler (text and color)
        searchTextField.attributedPlaceholder = NSAttributedString(string: "Bavarski dvor, 19B, dolgi most".localized, attributes: [NSAttributedString.Key.foregroundColor: UIColor.GREY])
        
        // set search result table view
        self.searchResultsTableView.dataSource = self
        self.searchResultsTableView.delegate = self
        self.searchResultsTableView.register(UINib(nibName: "SearchResultTableViewCell", bundle: nil), forCellReuseIdentifier: "SearchResultTableViewCell")
    }
    
    // called when back button is pressed
    @IBAction func backButtonClicked(_ sender: UIButton) {
        self.dismiss(animated: true, completion: nil)
    }
}

extension SearchViewController: UITableViewDataSource, UITableViewDelegate {
    
    // return result tableview size
    // if there is more than 200 results, display 200
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return 50
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "SearchResultTableViewCell", for: indexPath) as? SearchResultTableViewCell

        cell?.mainText.text = String(indexPath.row)
        
        return cell!
    }
}

enum SearchResultType {
    case station, busLine
}

