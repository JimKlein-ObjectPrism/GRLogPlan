//
//  SnackVM.swift
//  GRPatienLogAndPlan
//
//  Created by James Klein on 5/20/15.
//  Copyright (c) 2015 ObjectPrism Corp. All rights reserved.
//

import Foundation


public class SnackVM: MealViewModel, MealViewModelDelegate, UITableViewDataSource, UITableViewDelegate, ChoiceItemSelectedDelegate, MedicineItemSelectedDelegate,
    AddOnItemSelectedDelegate, LocationSelectedDelegate, ParentInitialsSelectedDelegate, TimeSelectedDelegate
{
    var snackTime: SnackTime
    //let dataStore: DataStore
    
    let snackItemArray: [FoodItem]
    var currentSnackItemArray: [FoodItem] = [FoodItem]()
    let fruitArray: [FoodItem]
    var currentFruitArray: [FoodItem]  = [FoodItem]()
    
    var snack: VMSnack
    
    init(dataStore: DataStore, snackTime: SnackTime)
    {
        self.snackTime = snackTime
        //self.dataStore = dataStore
        
        self.snack = dataStore.getSnack_Today(snackTime)
        self.snackItemArray = dataStore.buildFoodItemArray(filterString: "SnackItem")
        self.fruitArray = dataStore.buildFoodItemArray(filterString: "FruitItem")
        
        super.init(dataStore: dataStore)
        
        if snack.snackChoice != nil {
            currentSnackItemArray = getFoodItem(snack.snackChoice!, foodItemArray: snackItemArray)
        }
        else {
            currentSnackItemArray = snackItemArray
        }
        
        if snack.fruitChoice != nil {
            currentFruitArray = getFoodItem(snack.fruitChoice!, foodItemArray: fruitArray)
        }
        else {
            currentFruitArray  = fruitArray
        }
        
        //TODO: Initialize Parent Array from Profile.  No do this in the datastore
        
    }
    
    public func numberOfSectionsInTableView(tableView: UITableView) -> Int {
        return SnackMenuCategory.count(self.snackTime)
    }
    public func tableView(tableView: UITableView, titleForHeaderInSection section: Int) -> String? {
        if let menuSection = SnackMenuCategory(value: section, snackTime: self.snackTime){
            return menuSection.unselectedHeaderTitle()
        } else {
            //TODO: handle Index Out of Range error
            return nil
        }
    }
    
    
    @objc public func tableView(tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        
        if let menuSection = SnackMenuCategory(value: section, snackTime: self.snackTime){
            
            switch menuSection {
            case .SnackChoice:
                return self.currentSnackItemArray.count
//            case .Fruit:
//                return self.currentFruitArray.count
            case .Medicine:
                return 1
            case .AddOn:
                return 1
            case .AdditionalInfo:
                return 3
            }
        }
        else
        {
            //TODO: handle Index Out of Range error
            //assert(false, "Unimplemented error handler for Index Out of Range.")
            return 0
        }
    }
    
    
    @objc public func tableView(tableView: UITableView, cellForRowAtIndexPath indexPath: NSIndexPath) -> UITableViewCell {
        
        let menuSection = SnackMenuCategory(value: indexPath.section, snackTime: self.snackTime)
        
        switch menuSection! {
        case .SnackChoice:
            let cell = self.tableCell(tableView, cellForFoodItemAtIndexPath: indexPath, inArray: currentSnackItemArray, foodItemName: self.snack.snackChoice, viewModel: self)
            if let choiceCell = cell as? NewChoiceTableViewCell {
                //cellForFoodItemAtIndexPath returns a NewChoice... cell or a plain cell, add delegate only to choice cell
                choiceCell.segmentSelectionHandler = self
            }
            return cell
//        case .Fruit:
//            let cell = self.tableCell(tableView, cellForFoodItemAtIndexPath: indexPath, inArray: currentFruitArray, foodItemName: self.snack.fruitChoice, viewModel: self)
//            if let choiceCell = cell as? NewChoiceTableViewCell {
//                choiceCell.segmentSelectionHandler = self
//            }
//            return cell
        case .Medicine:
            let cell: MedicineTableViewCell = self.tableCell(tableView, cellForMedicineItem: indexPath, medicineText: snack.medicineText!, switchState: self.snack.medicineConsumed!)
            cell.medicineTakenHandler = self
            return cell
        case .AddOn:
            //let handler: AddOnItemSelectedDelegate = (self as? AddOnItemSelectedDelegate)!
            return tableCell(tableView, cellForAddOnItem: indexPath, addOnText: self.snack.addOnText!, switchState: self.snack.addOnConsumed!, switchSelectionHandler: self)
        case .AdditionalInfo:
            switch indexPath.row {
            case 0:
                return tableCell(tableView, cellForParentInitialsItem: indexPath, parentInitialsText: &self.snack.parentInitials, parentSelectionHandler: self)
            case 1:
                //if let location =  {
                    return tableCell(tableView , cellForLocationItem: indexPath, locationText: &self.snack.location, locationSelectionHandler: self)
//                }
//                else{
//                    //set it to
//                    var defaultLocation = LocationForMeal(rawValue: 0)?.name()
//                    return tableCell(tableView , cellForLocationItem: indexPath, locationText: defaultLocation, locationSelectionHandler: self)
//                }
            default:
                return tableCell(tableView, cellForTimeItem: indexPath, time: &snack.time, timeSelectionHandler: self)
                
            }
            
        default:
            let cell = tableView.dequeueReusableCellWithIdentifier("Cell", forIndexPath: indexPath) as! UITableViewCell
            return cell
        }
        
        
    }
    
    @objc public func didDeselectRowAtIndexPath (indexPath: NSIndexPath) {
        //selectedItemTitle = dataSource[indexPath.row]
        let menuSection = SnackMenuCategory( value: indexPath.section, snackTime: self.snackTime)
        
        switch menuSection!{
        case .SnackChoice:
            toggleSelectionArrayAndPropertyInModel(
                indexPath,
                mutableArray: &self.currentSnackItemArray,
                immutableArray: self.snackItemArray,
                propertyInModel: &snack.snackChoice
            )
//        case .Fruit:
//            toggleSelectionArrayAndPropertyInModel(
//                indexPath,
//                mutableArray: &currentFruitArray,
//                immutableArray: self.fruitArray,
//                propertyInModel: &snack.fruitChoice
//            )
        default:
            return
        }
    }
    
    //MARK: Data Update Delgate Methods
    func choiceItemSelectedHandler(childItemIndex: Int, indexPath: NSIndexPath){
        //update current meal item
        
        let menuSection = SnackMenuCategory(value: indexPath.section, snackTime: self.snackTime)
        
        switch menuSection! {
        case .SnackChoice:
            self.toggleSelectionArrayAndPropertyInModelForSegmentedControl(selectedIndexPath: indexPath, selectedSegment: childItemIndex, mutableArray: &self.currentSnackItemArray, immutableArray: self.snackItemArray, propertyInModel: &self.snack.snackChoice)
//        case .Fruit:
//            let itemNameAndSelectionName = self.getItemNameAndChoiceItemIndex(selectedIndexPath: indexPath, selectedSegment: childItemIndex, mutableArray: self.currentFruitArray)
//            setPropertyInModel(value: itemNameAndSelectionName, propertyInModel: &self.snack.fruitChoice)
        default:
            return
        }
    }
    func choiceItemSelectedHandler(medicineConsumed: Bool){
        setPropertyInModel(boolValue: medicineConsumed, boolPropertyInModel: &self.snack.medicineConsumed)
    }
    //MARK: Cell entry delegates
    func addOnItemSelectedHandler(addOnConsumed: Bool)
    {
        setPropertyInModel(boolValue: addOnConsumed, boolPropertyInModel: &self.snack.addOnConsumed)
    }
    
    func locationSelectedHandler(){
        
        let locations = Location.place
        
        let buttonList = locations
        let title = "Location"
        let cancel = "Cancel"
        let firstButtonItem = buttonList[0]
        
        // create controller
        let alertController = UIAlertController(title: nil, message: title, preferredStyle: .ActionSheet)
        
        //let button = sender as! UIButton
        let cancelAction = UIAlertAction(title: "Cancel", style: .Cancel) { (action) in
            // ...
        }
        alertController.addAction(cancelAction)
        
        var newTitle : String = ""
        
        // add Action buttons for each set of initials in the list
        for s in 0..<buttonList.count {
            
            var buttonIndex = s
            
            var action = UIAlertAction(title: buttonList[s], style: .Default, handler: {
                (alert: UIAlertAction!) -> Void in
                //send initials updated event
                newTitle = buttonList[s]
                self.setPropertyInModel(value: newTitle, propertyInModel: &self.snack.location)
                self.tableView.reloadData()
            })
            
            alertController.addAction(action)
        }
        
        self.tableviewController.presentViewController(alertController, animated: true, completion: nil)
    }
    
    func parentInitialsSelectedHandler(){
        
        let title = "Parent Initials"
        let initialsArray = getParentInitials()
        let returnString: () = self.showAlertForPropertyInput(title, buttonValues: initialsArray, modelProperty: &self.snack.parentInitials)
        
    }
    
    func timeSelectedHandler(selectedTime : NSDate){
        var dateFormatter = NSDateFormatter()
        dateFormatter.timeStyle = .ShortStyle
        var time = dateFormatter.stringFromDate(selectedTime)
        setPropertyInModel(value: time, propertyInModel: &self.snack.time)
        //setPropertyInModel(dateValue: selectedTime, datePropertyInModel: &self.snack.time)
    }
    //MARK: Alert View methods
    func showAlertForPropertyInput(title: String, buttonValues: [String],  inout modelProperty: String?){
        
        let cancel = "Cancel"
        
        // create controller
        let alertController = UIAlertController(title: nil, message: title, preferredStyle: .ActionSheet)
        
        //let button = sender as! UIButton
        
        let cancelAction = UIAlertAction(title: "Cancel", style: .Cancel) { (action) in
            // ...
        }
        alertController.addAction(cancelAction)
        var a: String? = "a"
        
        var b:String? = ""
        for i in 0 ..< buttonValues.count {
            
            var buttonIndex = i
            
            var action = UIAlertAction(title: buttonValues[i], style: .Default, handler: {
                (alert: UIAlertAction!) -> Void in
                self.setPropertyInModel(value: buttonValues[i], propertyInModel: &self.snack.parentInitials)//modelProperty)
                //self.setPropertyInModel(value: b!, propertyInModel: &b)//modelProperty)//&self.snack.parentInitials)
                self.tableView.reloadData()
            })
            
            alertController.addAction(action)
        }
        
        self.tableviewController.presentViewController(alertController, animated: true, completion: nil)
        
    }
    func showAlertForSaveValidation(title: String, buttonValues: [String]){
        
        let cancel = "Cancel"
        
        var message: String = ""
        
        for i in 0 ..< buttonValues.count {
            var newLine = "\n \(buttonValues[i])"
            message += newLine
        }
        
        // create controller
        let alertController = UIAlertController(title: "Meal Log Not Complete", message: message, preferredStyle: .ActionSheet)
        
        //let button = sender as! UIButton
        
        let cancelAction = UIAlertAction(title: "Cancel", style: .Cancel) { (action) in
            // ...
        }
        alertController.addAction(cancelAction)
        
        let saveAnywayAction = UIAlertAction(title: "Save Anyway", style: .Default)  {
            (alert: UIAlertAction!) -> Void in
            self.dataStore.saveSnack_Today(self.snack, snackTime: self.snackTime)
            
            self.tableviewController.navigationController?.popViewControllerAnimated(true)
        }
        alertController.addAction(saveAnywayAction)
        self.tableviewController.presentViewController(alertController, animated: true, completion: nil)
    }
    
    //MARK: Save button
    func saveButtonTapped() {//-> ValidationResult {
        //validate
        let result = self.snack.validateWithSnackMenuCategoryEnum()
        
        switch result{
        case .Success:
            // send save message to data store
            //dismiss view
            dataStore.saveSnack_Today(self.snack, snackTime: self.snackTime)
            tableviewController.navigationController?.popViewControllerAnimated(true)
            
        case let .Failure(errorCodes):
            showAlertForSaveValidation("Save Error", buttonValues: errorCodes)
        }
        
    }
    
}
