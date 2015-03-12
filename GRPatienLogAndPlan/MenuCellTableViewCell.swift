//
//  MenuCellTableViewCell.swift
//  FoodItemDataStoreTest
//
//  Created by James Klein on 3/8/15.
//  Copyright (c) 2015 ObjectPrism Corp. All rights reserved.
//

import UIKit

class MenuCellTableViewCell: UITableViewCell {

    @IBOutlet weak var statusDisplayView: UIView!
    @IBOutlet weak var titleLabel: UILabel!

    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }

    override func setSelected(selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }

}
