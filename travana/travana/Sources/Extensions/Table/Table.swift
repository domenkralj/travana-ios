//
//  Table.swift
//  travana
//
//  Created by Domen Kralj on 28/09/2020.
//  Copyright © 2020 Domen Kralj. All rights reserved.
//

import UIKit

extension UITableView {
    
    // Sets common table properties.
    public func initTable(cellClass: AnyClass, identifier: String, delegate: UITableViewDelegate, dataSource: UITableViewDataSource) {
        self.delegate = delegate
        self.dataSource = dataSource
        self.alwaysBounceVertical = false
        self.separatorStyle = UITableViewCell.SeparatorStyle.none
        self.tableFooterView = UIView()
        self.register(cellClass, forCellReuseIdentifier: identifier)
    }
}

