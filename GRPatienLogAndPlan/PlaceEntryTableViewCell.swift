//
//  PlaceEntryTableViewCell.swift
//  FoodItemDataStoreTest
//
//  Created by Jim Klein on 3/3/15.
//  Copyright (c) 2015 ObjectPrism Corp. All rights reserved.
//

import UIKit

class PlaceEntryTableViewCell: UITableViewCell {
   @IBOutlet weak var placeButton: UIButton!
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
