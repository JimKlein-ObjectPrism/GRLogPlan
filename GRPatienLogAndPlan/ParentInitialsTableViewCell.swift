//
//  ParentInitialsTableViewCell.swift
//  FoodItemDataStoreTest
//
//  Created by Jim Klein on 3/3/15.
//  Copyright (c) 2015 ObjectPrism Corp. All rights reserved.
//

import UIKit

class ParentInitialsTableViewCell: UITableViewCell, UIActionSheetDelegate {

    @IBOutlet weak var initialsButton: UIButton!
    
    @IBOutlet weak var titleLabel: UILabel!
    
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
        //choiceSegmentControl.selectedSegmentIndex = -1

    }

    override func setSelected(selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }
    
    //MARK: Action handler
    
    
    //MARK: - AlertView methods
    
    
    /*
    let actionSheet = UIActionSheet(title: "Takes the appearance of the bottom bar if specified; otherwise, same as UIActionSheetStyleDefault.", delegate: self, cancelButtonTitle: "Cancel", destructiveButtonTitle: "Destroy", otherButtonTitles: "OK")
    actionSheet.actionSheetStyle = .Default
    actionSheet.showInView(self.view)
    
    // MARK: UIActionSheetDelegate
    
    func actionSheet(actionSheet: UIActionSheet, clickedButtonAtIndex buttonIndex: Int) {
        switch buttonIndex {
            ...
        }

    }
*/
    @IBAction func showActions(sender: AnyObject) {
        let actionSheet = UIActionSheet(title: "Takes the appearance of the bottom bar if specified; otherwise, same as UIActionSheetStyleDefault.", delegate: self, cancelButtonTitle: "Cancel", destructiveButtonTitle: "Destroy", otherButtonTitles: "OK")
        actionSheet.actionSheetStyle = .Default
        //actionSheet.showInView()
        
    }

	
}
