//
//  HomeTableCell.swift
//  CIS380
//
//  Created by John Tunisi on 12/2/15.
//  Copyright © 2015 John Tunisi. All rights reserved.
//

import UIKit

class HomeTableCell: UITableViewCell {
    
    @IBOutlet weak var title: UILabel!
    @IBOutlet weak var story: UILabel!
    
    override func awakeFromNib() {
        super.awakeFromNib()
        
    }
    
    override func setSelected(selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)
    }
    
}