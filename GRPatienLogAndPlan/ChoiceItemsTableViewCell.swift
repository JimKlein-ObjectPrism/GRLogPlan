//
//  ChoiceItemsTableViewCell.swift
//  FoodItemDataStoreTest
//
//  Created by Jim Klein on 2/18/15.
//  Copyright (c) 2015 ObjectPrism Corp. All rights reserved.
//

import UIKit

class ChoiceItemsTableViewCell: UITableViewCell {
    //TODO: get correct delegate
    static let cellIdentifier: String = "ChoiceCell"
    
    var segmentSelectionHandler: ChoiceItemSelectedDelegate?
    
    var indexPathSection: Int!
    var indexPathRow: Int!
    var indexPath: NSIndexPath!
   
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

    @IBAction func didSelectSegment(sender: AnyObject) {
        //
        if let seg = sender as? UISegmentedControl {
            let choice = seg.selectedSegmentIndex
            
        
            if  segmentSelectionHandler != nil {
                segmentSelectionHandler?.choiceItemSelectedHandler(choice, indexPath: indexPath)
            }
        }   

    }
}
