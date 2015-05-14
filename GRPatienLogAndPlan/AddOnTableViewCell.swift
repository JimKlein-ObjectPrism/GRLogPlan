//
//  AddOnTableViewCell.swift
//  GRPatienLogAndPlan
//
//  Created by James Klein on 5/13/15.
//  Copyright (c) 2015 ObjectPrism Corp. All rights reserved.
//

import UIKit

class AddOnTableViewCell: UITableViewCell {
    static let cellIdentifer = "AddOnCell"

    @IBOutlet weak var addOnLabel: UILabel!
    @IBOutlet weak var addOnSwitch: UISwitch!
    var addOnTakenHandler: AddOnItemSelectedDelegate?

    
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }

    override func setSelected(selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
        
    }

    @IBAction func addOnSwitchChanged(sender: AnyObject) {
        if let addOnTaken = sender as? UISwitch {
            addOnTakenHandler?.addOnItemSelectedHandler(addOnTaken.on)
        }
    }
}
