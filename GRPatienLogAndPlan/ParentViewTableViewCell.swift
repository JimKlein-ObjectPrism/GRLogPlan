//
//  ParentViewTableViewCell.swift
//  CoreDataTest
//
//  Created by James Klein on 4/16/15.
//  Copyright (c) 2015 James Klein. All rights reserved.
//

import UIKit

// A protocol that the TableViewCell uses to inform its delegate of state change
protocol TableViewCellDelegate {
    // indicates that the given item has been deleted
    func parentItemDeleted(todeleteItem: Int)
    func nameEntered( atIndex: Int, firstName: String?, lastName: String?)
}

class ParentViewTableViewCell: UITableViewCell, UITextFieldDelegate{

    // The object that acts as delegate for this cell.
    var delegate: TableViewCellDelegate?
    
    // The item that this cell renders.
    var parentItemIndexInProfileSet: Int?
    
    //handle datastore calls delegage
    var dataStoreDelegate: ProfileDataStoreDelegate!
    
    //handle events for TableViewCellDelegate
    var tableViewCellDelegate: TableViewCellDelegate!
    
    var originalCenter = CGPoint()
    var deleteOnDragRelease = false
    @IBOutlet weak var nameTextField: UITextField!
    
    @IBOutlet weak var nameLabel: UILabel!
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
        nameTextField.delegate = self
        
        // add a pan recognizer
        let recognizer = UIPanGestureRecognizer(target: self, action: "handlePan:")
        recognizer.delegate = self
        //addGestureRecognizer(recognizer)
    }
    

    override func setSelected(selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }
    
// MARK: - UITextFieldDelegate methods
    func textFieldShouldReturn(textField: UITextField) -> Bool {

        textField.resignFirstResponder()
        return false
    }
    
    func textFieldShouldBeginEditing(textField: UITextField) -> Bool {
        return true
    }
    
    func textFieldDidEndEditing(textField: UITextField) {
       
        
        let nameInput = textField.text  ?? ""
        let myArray: [String] = nameInput.componentsSeparatedByString(" ")
        let firstName: String? = myArray.first
        if myArray.count > 1 {
            let lastName: String? = myArray.last
            tableViewCellDelegate!.nameEntered(parentItemIndexInProfileSet!, firstName: firstName, lastName: lastName)
        } else {
            tableViewCellDelegate!.nameEntered(parentItemIndexInProfileSet!, firstName: firstName, lastName: nil)
        }
        
    }
    
    //MARK: - horizontal pan gesture methods
    func handlePan(recognizer: UIPanGestureRecognizer) {
        // 1
        if recognizer.state == .Began {
            // when the gesture begins, record the current center location
            originalCenter = center
        }
        // 2
        if recognizer.state == .Changed {
            let translation = recognizer.translationInView(self)
            center = CGPointMake(originalCenter.x + translation.x, originalCenter.y)
            // has the user dragged the item far enough to initiate a delete/complete?
            deleteOnDragRelease = frame.origin.x < -frame.size.width / 2.0
        }
        // 3
        if recognizer.state == .Ended {
            // the frame this cell had before user dragged it
            let originalFrame = CGRect(x: 0, y: frame.origin.y,
                width: bounds.size.width, height: bounds.size.height)
            if !deleteOnDragRelease {
                // if the item is not being deleted, snap back to the original location
                UIView.animateWithDuration(0.2, animations: {self.frame = originalFrame})
            }
            if deleteOnDragRelease {
                if delegate != nil && parentItemIndexInProfileSet != nil {
                    // notify the delegate that this item should be deleted
                    delegate!.parentItemDeleted(parentItemIndexInProfileSet!)
                }
            }
        }
    }
    
    override func gestureRecognizerShouldBegin(gestureRecognizer: UIGestureRecognizer) -> Bool {
        if let panGestureRecognizer = gestureRecognizer as? UIPanGestureRecognizer {
            let translation = panGestureRecognizer.translationInView(superview!)
            if fabs(translation.x) > fabs(translation.y) {
                return true
            }
            return false
        }
        return false
    }
}
