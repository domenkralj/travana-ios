//
//  FavoriteNearbyStationsBotoomSheetViewController.swift
//  travana
//
//  Created by Domen Kralj on 04/10/2020.
//  Copyright © 2020 Domen Kralj. All rights reserved.
//

import UIKit

// Bottom sheet view, which can be pulled up
// It is used for showing favorite and nearby stations
class FavoriteNearbyStationsBottomSheetViewController: UIViewController {
    
    @IBOutlet weak var handleArea: UIView!
    
    // when view is loaded.
    override func viewDidLoad() {
        super.viewDidLoad()
    }
    
    // TODO REMOVE
    @IBAction func openTestStationButtonClicked(_ sender: UIButton) {
        //let vc = UIStoryboard.init(name: "Main", bundle: Bundle.main).instantiateViewController(withIdentifier: "StationViewController") as! StationViewController
        //vc.modalPresentationStyle = .fullScreen
        //self.present(vc, animated: true, completion: nil)
    }
}
