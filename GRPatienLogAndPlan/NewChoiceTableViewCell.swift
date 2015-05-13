//
//  NewChoiceTableViewCell.swift
//  GRPatienLogAndPlan
//
//  Created by James Klein on 5/11/15.
//  Copyright (c) 2015 ObjectPrism Corp. All rights reserved.
//

import UIKit

class NewChoiceTableViewCell: UITableViewCell {

    static let cellIdentifier: String = "ChoiceCell"
    
    var segmentSelectionHandler: ChoiceItemSelectedDelegate?
    
    var indexPathSection: Int!
    var indexPathRow: Int!
    var indexPath: NSIndexPath!
    
    @IBOutlet weak var choiceSegmentControl: UISegmentedControl!
    @IBOutlet weak var choiceLabel: UILabel!
//    @IBOutlet weak var choiceLabel: UILabel!
//    
//    @IBOutlet weak var choiceSegmentControl: UISegmentedControl!
//
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }

    override func setSelected(selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }

    @IBAction func didSelectSegment(sender: AnyObject) {
        if let seg = sender as? UISegmentedControl {
            var choice = seg.selectedSegmentIndex
            
            
            if  segmentSelectionHandler != nil {
                segmentSelectionHandler?.choiceItemSelectedHandler(choice, indexPath: indexPath)
            }
        }

    }
}
