//
//  MealViewModel.swift
//  GRPatienLogAndPlan
//
//  Created by James Klein on 5/11/15.
//  Copyright (c) 2015 ObjectPrism Corp. All rights reserved.
//

import Foundation

//add protocols
//add enum declarations

public class MealViewModel: NSObject {
    weak var tableView: UITableView!
    weak var tableviewController: UITableViewController!
    
    var parentsArray: [String]! = ["Lisa Doe", "John Doe", "Jon Smith"]
    
    
    
    //MARK:  Cell For Row At Index Path Helpers
    func tableCell(tableView: UITableView, cellForFoodItemAtIndexPath indexPath: NSIndexPath, inArray choicesArray: [FoodItem]) -> UITableViewCell
    {
        let currentItem = choicesArray[indexPath.row]
        
        if let itemWithChoice = currentItem as? FoodItemWithChoice {
            var cell = tableView.dequeueReusableCellWithIdentifier(NewChoiceTableViewCell.cellIdentifier, forIndexPath: indexPath) as! NewChoiceTableViewCell
            cell.choiceLabel?.text = itemWithChoice.itemDescription
            cell.indexPath = indexPath
                
            var segControl = cell.choiceSegmentControl as UISegmentedControl
                
            segControl.removeAllSegments()
            
            for i in 0 ..< itemWithChoice.choiceItems.count {
                if i  < 2 {
                    var choiceItem = itemWithChoice.choiceItems[i]
                    segControl.insertSegmentWithTitle(choiceItem.itemDescription, atIndex: i, animated: false)

                    // cell size apportionament, used below, requires cell to have width = 0
                    segControl.setWidth(0, forSegmentAtIndex: i)
                }
                else{
                    segControl.insertSegmentWithTitle(itemWithChoice.choiceItems[i].itemDescription, atIndex: i, animated: false)
                    segControl.setWidth(0, forSegmentAtIndex: i)
                }
        }
        
            segControl.apportionsSegmentWidthsByContent = true

            return cell
        }
        else {
            //handle plain FoodItem
            let cell = tableView.dequeueReusableCellWithIdentifier("Cell", forIndexPath: indexPath)  as! UITableViewCell
            cell.textLabel?.text = currentItem.name
            cell.detailTextLabel?.text = currentItem.itemDescription
            return cell
        }
        
    }
    
    func tableCell(tableView: UITableView, cellForMedicineItem indexPath: NSIndexPath, medicineText: String, switchState: Bool) -> MedicineTableViewCell
    {
        
        let cell = tableView.dequeueReusableCellWithIdentifier(MedicineTableViewCell.cellIdentifer, forIndexPath: indexPath)  as! MedicineTableViewCell
        //cell.textLabel?.text = currentItem.name
        cell.medicineLabel.text = medicineText
        cell.medicineListingLable?.text = medicineText
        cell.medicineSwitch.on = switchState
        return cell
        
    }
    func tableCell(tableView: UITableView, cellForAddOnItem indexPath: NSIndexPath, addOnText: String, switchState: Bool, switchSelectionHandler: AddOnItemSelectedDelegate) -> AddOnTableViewCell
    {
        
        let cell: AddOnTableViewCell = tableView.dequeueReusableCellWithIdentifier(AddOnTableViewCell.cellIdentifer, forIndexPath: indexPath)  as! AddOnTableViewCell
        //cell.textLabel?.text = currentItem.name
        cell.addOnTakenHandler = switchSelectionHandler//self as? AddOnItemSelectedDelegate
        cell.addOnLabel?.text = addOnText
        cell.addOnSwitch.on = switchState
        return cell
        
    }
    func tableCell(tableView: UITableView, cellForLocationItem indexPath: NSIndexPath, locationText: String?,  locationSelectionHandler: LocationSelectedDelegate) -> LocationTableViewCell
    {
        
        let cell: LocationTableViewCell = tableView.dequeueReusableCellWithIdentifier(LocationTableViewCell.cellIdentifer, forIndexPath: indexPath)  as! LocationTableViewCell
        //cell.textLabel?.text = currentItem.name
        cell.locationButtonHandler = locationSelectionHandler
        if locationText != nil {
            
        }
        cell.locationButton.setTitle(locationText, forState: .Normal)
        //cell.locationButton.titleLabel?.text = locationText
        //cell.addOnSwitch.on = switchState
        return cell
        
    }
    func tableCell(tableView: UITableView, cellForParentInitialsItem indexPath: NSIndexPath, parentInitialsText: String?,  parentSelectionHandler: ParentInitialsSelectedDelegate) -> ParentInitsTableViewCell
    {
        
        let cell: ParentInitsTableViewCell = tableView.dequeueReusableCellWithIdentifier(ParentInitsTableViewCell.cellIdentifer, forIndexPath: indexPath)  as! ParentInitsTableViewCell
        //cell.textLabel?.text = currentItem.name
        cell.parentButtonHandler = parentSelectionHandler
        var defaultInitials = parentInitialsText
        if defaultInitials == nil {
            defaultInitials = getParentInitials()[0]
        }
        cell.parentInitsButton.setTitle(defaultInitials, forState: .Normal)
        //cell.locationButton.titleLabel?.text = locationText
        //cell.addOnSwitch.on = switchState
        return cell
        
    }
    func tableCell(tableView: UITableView, cellForTimeItem indexPath: NSIndexPath, time: NSDate?,  timeSelectionHandler: TimeSelectedDelegate) -> TimeTableViewCell
    {
        
        let cell: TimeTableViewCell = tableView.dequeueReusableCellWithIdentifier(TimeTableViewCell.cellIdentifer, forIndexPath: indexPath)  as! TimeTableViewCell
        //cell.textLabel?.text = currentItem.name
        cell.timeSelectedHandler = timeSelectionHandler
        //var defaultInitials = parentInitialsText
        var pickerTime = time
        if pickerTime == nil  {
            pickerTime = NSDate()
        }
        //cell.parentInitsButton.setTitle(timeText, forState: .Normal)
        //cell.locationButton.titleLabel?.text = locationText
        //cell.timeUIPicker.date = pickerTime!
        var dateFormatter = NSDateFormatter()
        dateFormatter.dateFormat = "HH:mm"
  
        cell.timeTextField.text = dateFormatter.stringFromDate(pickerTime!)
        return cell
        
    }
    
    //MARK: Toggle Food Item Rows
    func toggleSelectionArrayAndPropertyInModel (indexPath: NSIndexPath, inout mutableArray: [FoodItem], immutableArray: [FoodItem], inout propertyInModel: String?)
    {
        if mutableArray.count == 1 {
            // selecting row when only one row in section, deselects row and displays full list of options
            mutableArray = immutableArray  //immutable array contains full list of values
            propertyInModel = nil
            tableView.reloadData()
        } else {
            //
            if let choiceItem = immutableArray[indexPath.row] as? FoodItemWithChoice {
                return
            } else {
                mutableArray = [immutableArray[indexPath.row]]
                propertyInModel = immutableArray[indexPath.row].name

                // delete cells
                let rows = getIndexPathArrayOfRowsToDelete(indexPath, countOfArrayOfFoodItems: immutableArray.count)
                animateRowDeletion(rows)
            }
        }
    }
    
    
    //MARK: Segmented Control Handler
    
    func toggleSelectionArrayAndPropertyInModelForSegmentedControl (#selectedIndexPath: NSIndexPath, selectedSegment: Int, inout mutableArray: [FoodItem], immutableArray: [FoodItem], inout propertyInModel: String?)
    {
        if mutableArray.count == 1 {
            //for FoodItemWithChoice this gets called when user changes selection after they've selected this tableCell from the list
            //mutableArray = immutableArray  //immutable array contains full list of values
            propertyInModel = self.getItemNameAndChoiceItemName(selectedIndexPath: selectedIndexPath, selectedSegment: selectedSegment, mutableArray: mutableArray)
        } else {
            var indexPathArrayToDelete = getIndexPathArrayOfRowsToDelete(selectedIndexPath, countOfArrayOfFoodItems: mutableArray.count)
            
            propertyInModel = self.getItemNameAndChoiceItemName(selectedIndexPath: selectedIndexPath, selectedSegment: selectedSegment, mutableArray: mutableArray)            
            mutableArray = [immutableArray[selectedIndexPath.row]]
            
            animateRowDeletion(indexPathArrayToDelete)
            //tableView.reloadData()
        }
    }
    func deleteRowsInDataSource ( originalCountRowsInSection: Int , selectedRow: Int, selectedSection: Int ){
        
            }
    func getIndexPathArrayOfRowsToDelete ( indexPathToKeep: NSIndexPath, countOfArrayOfFoodItems: Int) -> [NSIndexPath]
    {
        var pathSet: [NSIndexPath] = [NSIndexPath]()
        for index in 0 ..< countOfArrayOfFoodItems {
            
            if index  != indexPathToKeep.row {
                let indexPathToDelete = NSIndexPath(forRow: index , inSection: indexPathToKeep.section)
                pathSet.append(indexPathToDelete)
            }
        }
        return pathSet
    }
    
    func animateRowDeletion ( rowsToDelete: [AnyObject] ) {// selectedRow: Int, rowsOriginallyInSection: Int , selectedSection: Int){
        
        tableView.beginUpdates()
        tableView.deleteRowsAtIndexPaths(rowsToDelete, withRowAnimation: UITableViewRowAnimation.Automatic)
        tableView.endUpdates()
    }

    func getItemNameAndChoiceItemName ( #selectedIndexPath: NSIndexPath, selectedSegment: Int, mutableArray: [FoodItem] ) -> String
    {
        // cast always succeeds because only FoodItemWithChoice items get the cells with the segmented controls
        let choiceItem = mutableArray[selectedIndexPath.row] as? FoodItemWithChoice
        let itemName = choiceItem!.name
        let childChoiceItemName = choiceItem!.choiceItems[selectedSegment].name
        var compoundName = itemName + "," + childChoiceItemName
        return compoundName
    }
    
//    //MARK: Alert View methods
//    func showAlertForPropertyInput(title: String, buttonValues: [String],  inout modelProperty: String?){
//        
//        let cancel = "Cancel"
//        
//        // create controller
//        let alertController = UIAlertController(title: nil, message: title, preferredStyle: .ActionSheet)
//        
//        //let button = sender as! UIButton
//        
//        let cancelAction = UIAlertAction(title: "Cancel", style: .Cancel) { (action) in
//            // ...
//        }
//        alertController.addAction(cancelAction)
//        var a: String? = "a"
//        
//        var b:String? = ""
//        for i in 0 ..< buttonValues.count {
//            
//            var buttonIndex = i
//            
//            var action = UIAlertAction(title: buttonValues[i], style: .Default, handler: {
//                (alert: UIAlertAction!) -> Void in
//                self.setPropertyInModel(value: buttonValues[i], propertyInModel: &modelProperty)
//                //self.setPropertyInModel(value: b!, propertyInModel: &b)//modelProperty)//&self.breakfast.parentInitials)
//                self.tableView.reloadData()
//            })
//            
//            alertController.addAction(action)
//        }
//        
//        self.tableviewController.presentViewController(alertController, animated: true, completion: nil)
//
//    }
    
    
     //MARK: Helper Methods
   
    func setPropertyInModel (#value: String, inout propertyInModel: String?){
        propertyInModel = value
    }
    func setPropertyInModel (#boolValue: Bool, inout boolPropertyInModel: Bool?){
        boolPropertyInModel = boolValue
    }
    
    func getFoodItem ( itemName: String, foodItemArray: [FoodItem] ) -> [FoodItem] {
        // get subtype of food items for selection
        let fItems = foodItemArray.filter({m in
            m.name == itemName
        })
        
        return fItems
    }
    
    func getParentInitials() -> [String] {
        var initials = [String]()
        //TODO: implement more robust version of getParentInitials
        for fullName in self.parentsArray{
            var fullNameArr = split(fullName) {$0 == " "}
            
            var firstName: String = fullNameArr[0]
            var lastName: String? = fullNameArr.count > 1 ? fullNameArr[fullNameArr.count-1] : nil
            
            var firstInitial = firstName[firstName.startIndex]
            var lastInitial = lastName?[lastName!.startIndex]
            
            initials.append("\(firstInitial). \(lastInitial!).")
        }
        return initials
    }
    
}
