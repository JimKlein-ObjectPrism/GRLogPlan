//
//  TimeEntryTableViewCell.swift
//  FoodItemDataStoreTest
//
//  Created by Jim Klein on 3/3/15.
//  Copyright (c) 2015 ObjectPrism Corp. All rights reserved.
//

import UIKit

class TimeEntryTableViewCell: UITableViewCell {

   
    @IBOutlet weak var titleTextLabel: UILabel!
    
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    
    }

    override func setSelected(selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }

}
