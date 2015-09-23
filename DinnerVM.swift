//
//  DinnerVM.swift
//  GRPatienLogAndPlan
//
//  Created by James Klein on 5/20/15.
//  Copyright (c) 2015 ObjectPrism Corp. All rights reserved.
//

import Foundation

public class DinnerVM: MealViewModel, MealViewModelDelegate, UITableViewDataSource, UITableViewDelegate, ChoiceItemSelectedDelegate, MedicineItemSelectedDelegate,
    AddOnItemSelectedDelegate, LocationSelectedDelegate, ParentInitialsSelectedDelegate, TimeSelectedDelegate, RequiredItemsSelectedDelegate, NoteChangedDelegate
{
   
    //let dataStore: DataStore
    
    let meatItemArray: [FoodItem]
    var currentMeatItemArray: [FoodItem] = [FoodItem]()
    let starchArray: [FoodItem]
    var currentStarchArray: [FoodItem]  = [FoodItem]()
    let oilArray: [FoodItem]
    var currentOilArray: [FoodItem]  = [FoodItem]()
    let vegetableArray: [FoodItem]
    var currentVegetableArray: [FoodItem]  = [FoodItem]()

    var dinner: VMDinner
    var noteText: String? { return dinner.note }
    override init(dataStore: DataStore)
    {
        
        //self.dataStore = dataStore
        if let entry = dataStore.currentJournalEntry {
            self.dinner = VMDinner(fromDataObject: entry.dinner)
        } else {
            self.dinner = dataStore.getDinner_Today()
        }
        self.meatItemArray = dataStore.buildFoodItemArray(filterString: "MeatDinnerItem")
        self.starchArray = dataStore.buildFoodItemArray(filterString: "StarchDinnerItem")
        self.oilArray = dataStore.buildFoodItemArray(filterString: "OilDinnerItem")
        self.vegetableArray = dataStore.buildFoodItemArray(filterString: "VegetableItem")
        
        super.init(dataStore: dataStore)
        
        if dinner.meat != nil {
            currentMeatItemArray = getFoodItem(dinner.meat!, foodItemArray: meatItemArray)
        }
        else {
            currentMeatItemArray = meatItemArray
        }
        
        if dinner.starch != nil {
            currentStarchArray = getFoodItem(dinner.starch!, foodItemArray: starchArray)
        }
        else {
            currentStarchArray  = starchArray
        }
        if dinner.oil != nil {
            currentOilArray = getFoodItem(dinner.oil!, foodItemArray: oilArray)
        }
        else {
            currentOilArray = oilArray
        }
        
        if dinner.vegetable != nil {
            currentVegetableArray = getFoodItem(dinner.vegetable!, foodItemArray: vegetableArray)
        }
        else {
            currentVegetableArray  = vegetableArray
        }
        
        //TODO: Initialize Parent Array from Profile.  No do this in the datastore
        
    }
    
    //MARK: TableView delegate
    
    public func tableView(tableView: UITableView, heightForRowAtIndexPath indexPath: NSIndexPath) -> CGFloat {
        
        if let menuSection = DinnerMenuCategory(value: indexPath.section){
            
            switch menuSection {
            case .RequiredItems:
                return 50.0
            default:
                return 44.0
            }
        }

        return 50.0
    }

    public func numberOfSectionsInTableView(tableView: UITableView) -> Int {
        return DinnerMenuCategory.count()
    }
    public func tableView(tableView: UITableView, titleForHeaderInSection section: Int) -> String? {
        if let menuSection = DinnerMenuCategory(value: section){
            return menuSection.unselectedHeaderTitle()
        } else {
            //TODO: handle Index Out of Range error
            return nil
        }
    }
    
    
    @objc public func tableView(tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        
        if let menuSection = DinnerMenuCategory(value: section){
            
            switch menuSection {
            case .Meat:
                return self.currentMeatItemArray.count
            case .Starch:
                return self.currentStarchArray.count
            case .Oil:
                return self.currentOilArray.count
            case .Vegetable:
                return self.currentVegetableArray.count
            case .RequiredItems:
                return 1
            case .Medicine:
                return 1
            case .AddOn:
                return 1
            case .AdditionalInfo:
                return 4
            }
        }
        else
        {
            //TODO: handle Index Out of Range error
            return 0
            //assert(false, "Unimplemented error handler for Index Out of Range.")
        }
    }
    
    
    @objc public func tableView(tableView: UITableView, cellForRowAtIndexPath indexPath: NSIndexPath) -> UITableViewCell {
        
        let menuSection = DinnerMenuCategory(value: indexPath.section)
        
        switch menuSection! {
        case .Meat:
            let cell = self.tableCell(tableView, cellForFoodItemAtIndexPath: indexPath, inArray: currentMeatItemArray, foodItemName: self.dinner.meat, viewModel: self)
            if let choiceCell = cell as? NewChoiceTableViewCell {
                //cellForFoodItemAtIndexPath returns a NewChoice... cell or a plain cell, add delegate only to choice cell
                choiceCell.segmentSelectionHandler = self
            }
            return cell
        case .Starch:
            let cell = self.tableCell(tableView, cellForFoodItemAtIndexPath: indexPath, inArray: currentStarchArray, foodItemName: self.dinner.starch, viewModel: self)
            if let choiceCell = cell as? NewChoiceTableViewCell {
                choiceCell.segmentSelectionHandler = self
            }
            return cell
        case .Oil:
            let cell = self.tableCell(tableView, cellForFoodItemAtIndexPath: indexPath, inArray: currentOilArray, foodItemName: self.dinner.oil, viewModel: self)
            if let choiceCell = cell as? NewChoiceTableViewCell {
                //cellForFoodItemAtIndexPath returns a NewChoice... cell or a plain cell, add delegate only to choice cell
                choiceCell.segmentSelectionHandler = self
            }
            return cell
        case .Vegetable:
            let cell = self.tableCell(tableView, cellForFoodItemAtIndexPath: indexPath, inArray: currentVegetableArray, foodItemName: self.dinner.vegetable, viewModel: self)
            if let choiceCell = cell as? NewChoiceTableViewCell {
                choiceCell.segmentSelectionHandler = self
            }
            return cell
        case .RequiredItems:
            let cell: RequiredItemTableViewCell = self.tableCell(tableView, cellForRequiredItemsItem: indexPath, switchState: dinner.requiredItemsConsumed)
            cell.requiredItemsHandler = self
            return cell
        case .Medicine:
            let cell: MedicineTableViewCell = self.tableCell(tableView, cellForMedicineItem: indexPath, medicineText: dinner.medicineText, switchState: self.dinner.medicineConsumed)
            cell.medicineTakenHandler = self
            return cell
        case .AddOn:
            //let handler: AddOnItemSelectedDelegate = (self as? AddOnItemSelectedDelegate)!
            let addOnConsumed = self.dinner.addOnConsumed ?? false
            return tableCell(tableView, cellForAddOnItem: indexPath, addOnText: self.dinner.addOnText!, switchState: addOnConsumed, switchSelectionHandler: self)
        case .AdditionalInfo:
            switch indexPath.row {
            case 0:
                return tableCell(tableView, cellForParentInitialsItem: indexPath, parentInitialsText: &self.dinner.parentInitials, parentSelectionHandler: self)
            case 1:
//                if let location = self.lunch.location {
                    return tableCell(tableView , cellForLocationItem: indexPath, locationText: &self.dinner.location, locationSelectionHandler: self)
//                }
//                else{
//                    //set it to
//                    var defaultLocation = LocationForMeal(rawValue: 0)?.name()
//                    return tableCell(tableView , cellForLocationItem: indexPath, locationText: defaultLocation, locationSelectionHandler: self)
//                }
            case 2:
                return tableCell(tableView, cellForTimeItem: indexPath, time: &dinner.time, timeSelectionHandler: self)
            default:
                return tableCell(tableView, cellForNoteItem: indexPath)
                
            }
            
//        default:
//            let cell = tableView.dequeueReusableCellWithIdentifier("Cell", forIndexPath: indexPath) 
//            return cell
        }
        
        
    }
    
    @objc public func didDeselectRowAtIndexPath (indexPath: NSIndexPath, viewController: UIViewController, choiceTableCell: NewChoiceTableViewCell?) {

        let menuSection = DinnerMenuCategory( value: indexPath.section)
        
        switch menuSection!{
        case .Meat:
            toggleSelectionArrayAndPropertyInModel(
                indexPath,
                mutableArray: &self.currentMeatItemArray,
                immutableArray: self.meatItemArray,
                propertyInModel: &dinner.meat,
                choiceCell: choiceTableCell
            )
        case .Starch:
            toggleSelectionArrayAndPropertyInModel(
                indexPath,
                mutableArray: &currentStarchArray,
                immutableArray: self.starchArray,
                propertyInModel: &dinner.starch,
                choiceCell: choiceTableCell
            )
        case .Oil:
            toggleSelectionArrayAndPropertyInModel(
                indexPath,
                mutableArray: &self.currentOilArray,
                immutableArray: self.oilArray,
                propertyInModel: &dinner.oil,
                choiceCell: choiceTableCell
            )
        case .Vegetable:
            toggleSelectionArrayAndPropertyInModel(
                indexPath,
                mutableArray: &currentVegetableArray,
                immutableArray: self.vegetableArray,
                propertyInModel: &dinner.vegetable,
                choiceCell: choiceTableCell
            )
        case .AdditionalInfo:
            if indexPath.row == 3 {
                let vc : NoteViewController = viewController.storyboard?.instantiateViewControllerWithIdentifier("NoteViewController") as! NoteViewController
                vc.vm = self
                vc.noteDelegate = self
                
                viewController.showViewController(vc as UIViewController, sender: vc)
            }

        default:
            return
        }
    }
    
    //MARK: Data Update Delgate Methods
    func choiceItemSelectedHandler(childItemIndex: Int, indexPath: NSIndexPath){
        //update current meal item
        
        let menuSection = DinnerMenuCategory(value: indexPath.section)
        
        switch menuSection! {
        case .Meat:
            self.toggleSelectionArrayAndPropertyInModelForSegmentedControl(selectedIndexPath: indexPath, selectedSegment: childItemIndex, mutableArray: &self.currentMeatItemArray, immutableArray: self.meatItemArray, propertyInModel: &self.dinner.meat)
        case .Starch:
            let itemNameAndSelectionName = self.getItemNameAndChoiceItemIndex(selectedIndexPath: indexPath, selectedSegment: childItemIndex, mutableArray: self.currentStarchArray)
            setPropertyInModel(value: itemNameAndSelectionName, propertyInModel: &self.dinner.starch)
        default:
            return
        }
    }
    func choiceItemSelectedHandler(medicineConsumed: Bool){
        setPropertyInModel(boolValue: medicineConsumed, boolPropertyInModel: &self.dinner.medicineConsumed)
    }
    func requiredItemSwitchSelectedHandler(requiredItemConsumed: Bool){
        dinner.requiredItemsConsumed = requiredItemConsumed
        //setPropertyInModel(boolValue: requiredItemConsumed, boolPropertyInModel: &self.dinner.requiredItemsConsumed)
    }
    //MARK: Cell entry delegates
    func addOnItemSelectedHandler(addOnConsumed: Bool)
    {
        setPropertyInModel(boolValue: addOnConsumed, boolPropertyInModel: &self.dinner.addOnConsumed)
    }
    
    func locationSelectedHandler(){
        
        let locations = Location.place
        
        let buttonList = locations
        let title = "Location"
        let cancel = "Cancel"
//        let firstButtonItem = buttonList[0]
        
        // create controller
        let alertController = UIAlertController(title: nil, message: title, preferredStyle: .ActionSheet)
        
        //let button = sender as! UIButton
        let cancelAction = UIAlertAction(title: cancel, style: .Cancel) { (action) in
            // ...
        }
        alertController.addAction(cancelAction)
        
        var newTitle : String = ""
        
        // add Action buttons for each set of initials in the list
        for s in 0..<buttonList.count {
            
//            var buttonIndex = s
            
            let action = UIAlertAction(title: buttonList[s], style: .Default, handler: {
                (alert: UIAlertAction) -> Void in
                //send initials updated event
                newTitle = buttonList[s]
                self.setPropertyInModel(value: newTitle, propertyInModel: &self.dinner.location)
                self.tableView.reloadData()
            })
            
            alertController.addAction(action)
        }
        
        self.tableviewController.presentViewController(alertController, animated: true, completion: nil)
    }
    
    func parentInitialsSelectedHandler(){
        
        let title = "Parent Initials"
        let initialsArray = getParentInitials()
        self.showAlertForPropertyInput(title, buttonValues: initialsArray, modelProperty: &self.dinner.parentInitials)
        
    }
    
    func timeSelectedHandler(selectedTime : NSDate){
        let dateFormatter = NSDateFormatter()
        dateFormatter.timeStyle = .ShortStyle
        let time = dateFormatter.stringFromDate(selectedTime)
        
        setPropertyInModel(value: time, propertyInModel: &self.dinner.time)

        //setPropertyInModel(dateValue: selectedTime, datePropertyInModel: &self.dinner.time)
    }
    //Note Handler
    func noteHandler(noteText: String){
        setPropertyInModel(value: noteText, propertyInModel: &self.dinner.note)
    }
    
    //MARK: Alert View methods
    func showAlertForPropertyInput(title: String, buttonValues: [String],  inout modelProperty: String?){
        
        let cancel = "Cancel"
        
        // create controller
        let alertController = UIAlertController(title: nil, message: title, preferredStyle: .ActionSheet)
        
        //let button = sender as! UIButton
        
        let cancelAction = UIAlertAction(title: cancel, style: .Cancel) { (action) in
            // ...
        }
        alertController.addAction(cancelAction)
        for i in 0 ..< buttonValues.count {
            
            let action = UIAlertAction(title: buttonValues[i], style: .Default, handler: {
                (alert: UIAlertAction) -> Void in
                self.setPropertyInModel(value: buttonValues[i], propertyInModel: &self.dinner.parentInitials)//modelProperty)
                //self.setPropertyInModel(value: b!, propertyInModel: &b)//modelProperty)//&self.dinner.parentInitials)
                self.tableView.reloadData()
            })
            
            alertController.addAction(action)
        }
        
        self.tableviewController.presentViewController(alertController, animated: true, completion: nil)
        
    }
    func showAlertForSaveValidation(title: String, buttonValues: [String]){
        
        var message: String = ""
        
        for i in 0 ..< buttonValues.count {
            let newLine = "\n \(buttonValues[i])"
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
            (alert: UIAlertAction) -> Void in
            self.dataStore.saveDinner(self.dinner)
            
            self.tableviewController.navigationController?.popViewControllerAnimated(true)
        }
        alertController.addAction(saveAnywayAction)
        self.tableviewController.presentViewController(alertController, animated: true, completion: nil)
    }
    
    //MARK: Save button
    func saveButtonTapped() {//-> ValidationResult {
        //validate
        let result = self.dinner.validate()
        
        switch result{
        case .Success:
            // send save message to data store
            //dismiss view
            dataStore.saveDinner(self.dinner)
            tableviewController.navigationController?.popViewControllerAnimated(true)
            
        case let .Failure(errorCodes):
            showAlertForSaveValidation("Save Error", buttonValues: errorCodes)
        }
        
    }
    
}
