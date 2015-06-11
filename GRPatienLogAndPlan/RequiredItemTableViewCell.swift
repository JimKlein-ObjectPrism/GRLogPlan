//
//  RequiredItemTableViewCell.swift
//  GRPatienLogAndPlan
//
//  Created by James Klein on 5/21/15.
//  Copyright (c) 2015 ObjectPrism Corp. All rights reserved.
//

import UIKit

class RequiredItemTableViewCell: UITableViewCell {
    static let cellIdentifer = "RequiredItemCell"
    //static let cellIdentifier: String = "RequiredItemCell"
    var requiredItemsHandler: RequiredItemsSelectedDelegate?

    @IBOutlet weak var titleLable: UILabel!
    @IBOutlet weak var detailTextView: UITextView!

     @IBOutlet weak var rItemSwitch: UISwitch!
    override func awakeFromNib() {
        super.awakeFromNib()
//        var text = "\n\u{2022}  8 oz Milk " +
//        "\n\u{2022}  1 c Salad with 1 Tbs Kartini Dressing or ½ Tbs Kartini Dressing + ½ oz hard Cheese"
//
//        self.detailTextView.text = text
    }

    override func setSelected(selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }

    @IBAction func switchSelectionChanged(sender: UISwitch) {
        requiredItemsHandler?.requiredItemSwitchSelectedHandler(sender.on)
    }
    

}
