//
//  ParentInitsTableViewCell.swift
//  GRPatienLogAndPlan
//
//  Created by James Klein on 5/13/15.
//  Copyright (c) 2015 ObjectPrism Corp. All rights reserved.
//

import UIKit

class ParentInitsTableViewCell: UITableViewCell {

    static let cellIdentifer = "ParentInitialsCell"

    @IBOutlet weak var parentInitsButton: UIButton!
    
    var parentButtonHandler: ParentInitialsSelectedDelegate?
    
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }

    override func setSelected(selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }

    @IBAction func parentInitialsButtonTapped(sender: AnyObject) {
        parentButtonHandler?.parentInitialsSelectedHandler()
    }
}
