//
//  MenuCellTableViewCell.swift
//  FoodItemDataStoreTest
//
//  Created by James Klein on 3/8/15.
//  Copyright (c) 2015 ObjectPrism Corp. All rights reserved.
//

import UIKit

class MenuCellTableViewCell: UITableViewCell {

    @IBOutlet var statusDisplayView: UIView!
    @IBOutlet var titleLabel: UILabel!
    
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }

    override func setSelected(selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }

}
