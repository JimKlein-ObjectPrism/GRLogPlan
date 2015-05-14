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
    
    var parentsArray: [String]! = ["Jane Doe", "John Doe", "Jon Smith"]
    
    
    
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
        for fullName in self.parentsArray{
            var fullNameArr = split(fullName) {$0 == " "}
            var firstName: String = fullNameArr[0]
            var lastName: String? = fullNameArr.count > 1 ? fullNameArr[fullNameArr.count-1] : nil
            var firstInitial = firstName[firstName.startIndex]
            var lastNameCharCount = Array(arrayLiteral: lastName).count
            var lastInitial = lastName?[lastName!.startIndex]
            //Array(arrayLiteral: lastName)[lastNameCharCount - 1]
            initials.append("\(firstInitial). \(lastInitial).")
        }
        return initials
    }
    
}
