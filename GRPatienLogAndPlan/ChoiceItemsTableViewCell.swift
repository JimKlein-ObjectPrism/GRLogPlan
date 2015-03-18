//
//  ChoiceItemsTableViewCell.swift
//  FoodItemDataStoreTest
//
//  Created by Jim Klein on 2/18/15.
//  Copyright (c) 2015 ObjectPrism Corp. All rights reserved.
//

import UIKit

class ChoiceItemsTableViewCell: UITableViewCell {

   
    @IBOutlet weak var choiceLabel: UILabel!
    
    @IBOutlet weak var choiceSegmentControl: UISegmentedControl!
    
    var isReusedCell: Bool = false
    
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
        choiceSegmentControl.selectedSegmentIndex = -1
    }

    override func setSelected(selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }

}
