//
//  DinnerVM.swift
//  GRPatienLogAndPlan
//
//  Created by James Klein on 5/20/15.
//  Copyright (c) 2015 ObjectPrism Corp. All rights reserved.
//

import Foundation

enum DinnerMenuCategory {
    case Meat,
    Starch,
    Oil,
    Vegetable,
    RequiredItems,
    
    Medicine,
    AddOn,
    AdditionalInfo
    
    static var caseItems: [DinnerMenuCategory] = [DinnerMenuCategory]()
    
    static func count() -> Int { return caseItems.count }
    
    static func configureMenuChoice(profile: OPProfile){
        caseItems.removeAll(keepCapacity: false)
        caseItems.append(DinnerMenuCategory.Meat)
        caseItems.append(DinnerMenuCategory.Starch)
        caseItems.append(DinnerMenuCategory.Oil)
        caseItems.append(DinnerMenuCategory.Vegetable)
        caseItems.append(DinnerMenuCategory.RequiredItems)
        
        if profile.medicineRequired {
            caseItems.append(.Medicine)
        }
        if profile.addOnRequired {
            caseItems.append(.AddOn)
        }
        caseItems.append(.AdditionalInfo)
    }
    
    init?(value: Int){
        //fail if index out of bounds
        if value >= DinnerMenuCategory.caseItems.count || value < 0 { return nil }
        self = DinnerMenuCategory.caseItems[value]
    }
    
    func unselectedHeaderTitle() -> String {
        switch self {
        case .Meat:
            return "Choose one"
        case .Starch:
            return "Choose one"
        case .Oil:
            return "Choose one"
        case .Vegetable:
            return "Choose one"
        case .RequiredItems:
            return "Required Items"
        
        case .Medicine:
            return "Medicine"
        case .AddOn:
            return "Add On"
        case .AdditionalInfo:
            return "Additional Information"
        }
    }
}

public class DinnerVM: MealViewModel, MealViewModelDelegate, UITableViewDataSource, UITableViewDelegate, ChoiceItemSelectedDelegate, MedicineItemSelectedDelegate,
    AddOnItemSelectedDelegate, LocationSelectedDelegate, ParentInitialsSelectedDelegate, TimeSelectedDelegate, RequiredItemsSelectedDelegate
{
   
    let dataStore: DataStore
    
    let meatItemArray: [FoodItem]
    var currentMeatItemArray: [FoodItem] = [FoodItem]()
    let starchArray: [FoodItem]
    var currentStarchArray: [FoodItem]  = [FoodItem]()
    let oilArray: [FoodItem]
    var currentOilArray: [FoodItem]  = [FoodItem]()
    let vegetableArray: [FoodItem]
    var currentVegetableArray: [FoodItem]  = [FoodItem]()

    var dinner: VMDinner
    
    init(dataStore: DataStore)
    {
        
        self.dataStore = dataStore
        
        self.dinner = dataStore.getDinner_Today()
        self.meatItemArray = dataStore.buildFoodItemArray(filterString: "MeatDinnerItem")
        self.starchArray = dataStore.buildFoodItemArray(filterString: "StarchDinnerItem")
        self.oilArray = dataStore.buildFoodItemArray(filterString: "OilDinnerItem")
        self.vegetableArray = dataStore.buildFoodItemArray(filterString: "VegetableItem")
        
        super.init()
        
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
                return 150.0
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
                return 3
            }
        }
        else
        {
            //TODO: handle Index Out of Range error
            assert(false, "Unimplemented error handler for Index Out of Range.")
        }
    }
    
    
    @objc public func tableView(tableView: UITableView, cellForRowAtIndexPath indexPath: NSIndexPath) -> UITableViewCell {
        
        let menuSection = DinnerMenuCategory(value: indexPath.section)
        
        switch menuSection! {
        case .Meat:
            let cell = self.tableCell(tableView, cellForFoodItemAtIndexPath: indexPath, inArray: currentMeatItemArray)
            if let choiceCell = cell as? NewChoiceTableViewCell {
                //cellForFoodItemAtIndexPath returns a NewChoice... cell or a plain cell, add delegate only to choice cell
                choiceCell.segmentSelectionHandler = self
            }
            return cell
        case .Starch:
            let cell = self.tableCell(tableView, cellForFoodItemAtIndexPath: indexPath, inArray: currentStarchArray)
            if let choiceCell = cell as? NewChoiceTableViewCell {
                choiceCell.segmentSelectionHandler = self
            }
            return cell
        case .Oil:
            let cell = self.tableCell(tableView, cellForFoodItemAtIndexPath: indexPath, inArray: currentOilArray)
            if let choiceCell = cell as? NewChoiceTableViewCell {
                //cellForFoodItemAtIndexPath returns a NewChoice... cell or a plain cell, add delegate only to choice cell
                choiceCell.segmentSelectionHandler = self
            }
            return cell
        case .Vegetable:
            let cell = self.tableCell(tableView, cellForFoodItemAtIndexPath: indexPath, inArray: currentVegetableArray)
            if let choiceCell = cell as? NewChoiceTableViewCell {
                choiceCell.segmentSelectionHandler = self
            }
            return cell
        case .RequiredItems:
            let cell: RequiredItemTableViewCell = self.tableCell(tableView, cellForRequiredItemsItem: indexPath, switchState: dinner.requiredItemsConsumed!)
            cell.requiredItemsHandler = self
            return cell
        case .Medicine:
            let cell: MedicineTableViewCell = self.tableCell(tableView, cellForMedicineItem: indexPath, medicineText: dinner.medicineText!, switchState: self.dinner.medicineConsumed!)
            cell.medicineTakenHandler = self
            return cell
        case .AddOn:
            //let handler: AddOnItemSelectedDelegate = (self as? AddOnItemSelectedDelegate)!
            return tableCell(tableView, cellForAddOnItem: indexPath, addOnText: self.dinner.addOnText!, switchState: self.dinner.addOnConsumed!, switchSelectionHandler: self)
        case .AdditionalInfo:
            switch indexPath.row {
            case 0:
                let parentInitials: String? = self.dinner.parentInitials
                return tableCell(tableView, cellForParentInitialsItem: indexPath, parentInitialsText: parentInitials, parentSelectionHandler: self)
            case 1:
                if let location = self.dinner.location {
                    return tableCell(tableView , cellForLocationItem: indexPath, locationText: location, locationSelectionHandler: self)
                }
                else{
                    //set it to
                    var defaultLocation = LocationForMeal(rawValue: 0)?.name()
                    return tableCell(tableView , cellForLocationItem: indexPath, locationText: defaultLocation, locationSelectionHandler: self)
                }
            default:
                return tableCell(tableView, cellForTimeItem: indexPath, time: dinner.time, timeSelectionHandler: self)
                
            }
            
        default:
            let cell = tableView.dequeueReusableCellWithIdentifier("Cell", forIndexPath: indexPath) as! UITableViewCell
            return cell
        }
        
        
    }
    
    @objc public func didDeselectRowAtIndexPath (indexPath: NSIndexPath) {

        let menuSection = DinnerMenuCategory( value: indexPath.section)
        
        switch menuSection!{
        case .Meat:
            toggleSelectionArrayAndPropertyInModel(
                indexPath,
                mutableArray: &self.currentMeatItemArray,
                immutableArray: self.meatItemArray,
                propertyInModel: &dinner.meat
            )
        case .Starch:
            toggleSelectionArrayAndPropertyInModel(
                indexPath,
                mutableArray: &currentStarchArray,
                immutableArray: self.starchArray,
                propertyInModel: &dinner.starch
            )
        case .Oil:
            toggleSelectionArrayAndPropertyInModel(
                indexPath,
                mutableArray: &self.currentOilArray,
                immutableArray: self.oilArray,
                propertyInModel: &dinner.oil
            )
        case .Vegetable:
            toggleSelectionArrayAndPropertyInModel(
                indexPath,
                mutableArray: &currentVegetableArray,
                immutableArray: self.vegetableArray,
                propertyInModel: &dinner.vegetable
            )
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
            let itemNameAndSelectionName = self.getItemNameAndChoiceItemName(selectedIndexPath: indexPath, selectedSegment: childItemIndex, mutableArray: self.currentStarchArray)
            setPropertyInModel(value: itemNameAndSelectionName, propertyInModel: &self.dinner.starch)
        default:
            return
        }
    }
    func choiceItemSelectedHandler(medicineConsumed: Bool){
        setPropertyInModel(boolValue: medicineConsumed, boolPropertyInModel: &self.dinner.medicineConsumed)
    }
    func requiredItemSwitchSelectedHandler(requiredItemConsumed: Bool){
        setPropertyInModel(boolValue: requiredItemConsumed, boolPropertyInModel: &self.dinner.requiredItemsConsumed)
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
        let returnString: () = self.showAlertForPropertyInput(title, buttonValues: initialsArray, modelProperty: &self.dinner.parentInitials)
        
    }
    
    func timeSelectedHandler(selectedTime : NSDate){
        
        
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
                self.setPropertyInModel(value: buttonValues[i], propertyInModel: &self.dinner.parentInitials)//modelProperty)
                //self.setPropertyInModel(value: b!, propertyInModel: &b)//modelProperty)//&self.dinner.parentInitials)
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
            self.dataStore.saveDinner_Today(self.dinner)
            
            self.tableviewController.navigationController?.popViewControllerAnimated(true)
        }
        alertController.addAction(saveAnywayAction)
        self.tableviewController.presentViewController(alertController, animated: true, completion: nil)
    }
    
    //MARK: Save button
    func saveButtonTapped() {//-> ValidationResult {
        //validate
        let result = self.dinner.validateWithDinnerMenuCategoryEnum()
        
        switch result{
        case .Success:
            // send save message to data store
            //dismiss view
            dataStore.saveDinner_Today(self.dinner)
            tableviewController.navigationController?.popViewControllerAnimated(true)
            
        case let .Failure(errorCodes):
            showAlertForSaveValidation("Save Error", buttonValues: errorCodes)
        }
        
    }
    
}