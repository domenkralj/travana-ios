//
//  TimetableTableViewCell.swift
//  travana
//
//  Created by Domen Kralj on 24/10/2020.
//  Copyright © 2020 Domen Kralj. All rights reserved.
//

import UIKit

class TimetableTableViewCell: UITableViewCell {

    @IBOutlet weak var hourText: UILabel!
    @IBOutlet weak var minutesText: UILabel!
    @IBOutlet weak var hourCircleView: UIView!
    
    override func awakeFromNib() {
        super.awakeFromNib()
        
        // remove cell highlight color when clicked
        self.selectionStyle = .none
        
        self.hourCircleView.setBorder(borderWidth: 2, borderColor: UIColor.LIGHT_GREY)
        self.hourCircleView.setCornerRadius(cornerRadius: 20)
        
    }
    
    public func setCell(timetableTimes: LppTimetableTimes) {
        self.hourText.text = String(timetableTimes.hour)
    
        var minutesStringArray: [String] = []
        for minute in timetableTimes.minutes {
            if minute < 10 {
                minutesStringArray.append("0" + String(minute))
            } else {
                minutesStringArray.append(String(minute))
            }
        }
        self.minutesText.text = minutesStringArray.joined(separator: "  ")
        
        if timetableTimes.isCurrent {
            self.contentView.setBackgroundColor(color: UIColor.MAIN_RED)
        } else {
            self.contentView.setBackgroundColor(color: UIColor.MAIN_GREY)
        }
    }
}
