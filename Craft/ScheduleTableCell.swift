//
//  ScheduleTableCell.swift
//  CIS380
//
//  Created by John Tunisi on 12/2/15.
//  Copyright © 2015 John Tunisi. All rights reserved.
//

import UIKit

class ScheduleTableCell: UITableViewCell {
    
    @IBOutlet weak var name: UILabel!
    @IBOutlet weak var timeAM: UILabel!
    @IBOutlet weak var timePM: UILabel!
    @IBOutlet weak var imageLabel: UIImageView!
    
    override func awakeFromNib() {
        super.awakeFromNib()
        
    }
    
    override func setSelected(selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)
    }
    
}