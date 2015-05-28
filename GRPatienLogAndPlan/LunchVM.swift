//
//  LunchVM.swift
//  GRPatienLogAndPlan
//
//  Created by James Klein on 5/20/15.
//  Copyright (c) 2015 ObjectPrism Corp. All rights reserved.
//

import Foundation

enum LunchMenuCategory {
    case LunchChoice,
    Fruit,
    Medicine,
    AddOn,
    AdditionalInfo
    
    static var caseItems: [LunchMenuCategory] = [LunchMenuCategory]()
    
    static func count() -> Int { return caseItems.count }
    
    static func configureMenuChoice(profile: TempProfile){
        caseItems.removeAll(keepCapacity: false)
        caseItems.append(LunchMenuCategory.LunchChoice)
        caseItems.append(LunchMenuCategory.Fruit)
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
        if value >= LunchMenuCategory.caseItems.count || value < 0 { return nil }
        self = LunchMenuCategory.caseItems[value]
    }
    
    func unselectedHeaderTitle() -> String {
        switch self {
        case .LunchChoice:
            return "Sandwich Item: 2 Pieces of Bread with"
        case .Fruit:
            return "Fruit Choice"
        case .Medicine:
            return "Medicine"
        case .AddOn:
            return "Add On"
        case .AdditionalInfo:
            return "Additional Information"
        }
    }
}

public class LunchVM: MealViewModel, MealViewModelDelegate, UITableViewDataSource, UITableViewDelegate, ChoiceItemSelectedDelegate, MedicineItemSelectedDelegate,
    AddOnItemSelectedDelegate, LocationSelectedDelegate, ParentInitialsSelectedDelegate, TimeSelectedDelegate
{
    let dataStore: DataStore
    
    let lunchItemArray: [FoodItem]
    var currentLunchItemArray: [FoodItem] = [FoodItem]()
    let fruitArray: [FoodItem]
    var currentFruitArray: [FoodItem]  = [FoodItem]()
    
    var lunch: VMLunch
    
    init(dataStore: DataStore)
    {
        self.dataStore = dataStore
        
        self.lunch = dataStore.getLunch_Today()
        self.lunchItemArray = dataStore.buildFoodItemArray(filterString: "LunchItem")
        self.fruitArray = dataStore.buildFoodItemArray(filterString: "FruitItem")
        
        super.init()
        
        if lunch.lunchChoice != nil {
            currentLunchItemArray = getFoodItem(lunch.lunchChoice!, foodItemArray: lunchItemArray)
        }
        else {
            currentLunchItemArray = lunchItemArray
        }
        
        if lunch.fruitChoice != nil {
            currentFruitArray = getFoodItem(lunch.fruitChoice!, foodItemArray: fruitArray)
        }
        else {
            currentFruitArray  = fruitArray
        }
        
        //TODO: Initialize Parent Array from Profile.  No do this in the datastore
        
    }
    
    public func numberOfSectionsInTableView(tableView: UITableView) -> Int {
        return LunchMenuCategory.count()
    }
    public func tableView(tableView: UITableView, titleForHeaderInSection section: Int) -> String? {
        if let menuSection = LunchMenuCategory(value: section){
            return menuSection.unselectedHeaderTitle()
        } else {
            //TODO: handle Index Out of Range error
            return nil
        }
    }
    
    
    @objc public func tableView(tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        
        if let menuSection = LunchMenuCategory(value: section){
            
            switch menuSection {
            case .LunchChoice:
                return self.currentLunchItemArray.count
            case .Fruit:
                return self.currentFruitArray.count
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
        
        let menuSection = LunchMenuCategory(value: indexPath.section)
        
        switch menuSection! {
        case .LunchChoice:
            let cell = self.tableCell(tableView, cellForFoodItemAtIndexPath: indexPath, inArray: currentLunchItemArray, foodItemName: self.lunch.lunchChoice, viewModel: self)
            if let choiceCell = cell as? NewChoiceTableViewCell {
                //cellForFoodItemAtIndexPath returns a NewChoice... cell or a plain cell, add delegate only to choice cell
                choiceCell.segmentSelectionHandler = self
            }
            return cell
        case .Fruit:
            let cell = self.tableCell(tableView, cellForFoodItemAtIndexPath: indexPath, inArray: currentFruitArray, foodItemName: self.lunch.fruitChoice, viewModel: self)
            if let choiceCell = cell as? NewChoiceTableViewCell {
                choiceCell.segmentSelectionHandler = self
            }
            return cell
        case .Medicine:
            let cell: MedicineTableViewCell = self.tableCell(tableView, cellForMedicineItem: indexPath, medicineText: lunch.medicineText!, switchState: self.lunch.medicineConsumed!)
            cell.medicineTakenHandler = self
            return cell
        case .AddOn:
            //let handler: AddOnItemSelectedDelegate = (self as? AddOnItemSelectedDelegate)!
            return tableCell(tableView, cellForAddOnItem: indexPath, addOnText: self.lunch.addOnText!, switchState: self.lunch.addOnConsumed!, switchSelectionHandler: self)
        case .AdditionalInfo:
            switch indexPath.row {
            case 0:
                let parentInitials: String? = self.lunch.parentInitials
                return tableCell(tableView, cellForParentInitialsItem: indexPath, parentInitialsText: parentInitials, parentSelectionHandler: self)
            case 1:
                if let location = self.lunch.location {
                    return tableCell(tableView , cellForLocationItem: indexPath, locationText: location, locationSelectionHandler: self)
                }
                else{
                    //set it to
                    var defaultLocation = LocationForMeal(rawValue: 0)?.name()
                    return tableCell(tableView , cellForLocationItem: indexPath, locationText: defaultLocation, locationSelectionHandler: self)
                }
            default:
                return tableCell(tableView, cellForTimeItem: indexPath, time: lunch.time, timeSelectionHandler: self)
                
            }
            
        default:
            let cell = tableView.dequeueReusableCellWithIdentifier("Cell", forIndexPath: indexPath) as! UITableViewCell
            return cell
        }
        
        
    }
    
    @objc public func didDeselectRowAtIndexPath (indexPath: NSIndexPath) {
        //selectedItemTitle = dataSource[indexPath.row]
        let menuSection = LunchMenuCategory( value: indexPath.section)
        
        switch menuSection!{
        case .LunchChoice:
            toggleSelectionArrayAndPropertyInModel(
                indexPath,
                mutableArray: &self.currentLunchItemArray,
                immutableArray: self.lunchItemArray,
                propertyInModel: &lunch.lunchChoice
            )
        case .Fruit:
            toggleSelectionArrayAndPropertyInModel(
                indexPath,
                mutableArray: &currentFruitArray,
                immutableArray: self.fruitArray,
                propertyInModel: &lunch.fruitChoice
            )
        default:
            return
        }
    }
    
    //MARK: Data Update Delgate Methods
    func choiceItemSelectedHandler(childItemIndex: Int, indexPath: NSIndexPath){
        //update current meal item
        
        let menuSection = LunchMenuCategory(value: indexPath.section)
        
        if currentLunchItemArray.count == 0 {
            currentLunchItemArray = lunchItemArray
        }
        
        switch menuSection! {
        case .LunchChoice:
            self.toggleSelectionArrayAndPropertyInModelForSegmentedControl(selectedIndexPath: indexPath, selectedSegment: childItemIndex, mutableArray: &self.currentLunchItemArray, immutableArray: self.lunchItemArray, propertyInModel: &self.lunch.lunchChoice)
        case .Fruit:
            let itemNameAndSelectionName = self.getItemNameAndChoiceItemIndex(selectedIndexPath: indexPath, selectedSegment: childItemIndex, mutableArray: self.currentFruitArray)
            setPropertyInModel(value: itemNameAndSelectionName, propertyInModel: &self.lunch.fruitChoice)
        default:
            return
        }
    }
    func choiceItemSelectedHandler(medicineConsumed: Bool){
        setPropertyInModel(boolValue: medicineConsumed, boolPropertyInModel: &self.lunch.medicineConsumed)
    }
    //MARK: Cell entry delegates
    func addOnItemSelectedHandler(addOnConsumed: Bool)
    {
        setPropertyInModel(boolValue: addOnConsumed, boolPropertyInModel: &self.lunch.addOnConsumed)
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
                self.setPropertyInModel(value: newTitle, propertyInModel: &self.lunch.location)
                self.tableView.reloadData()
            })
            
            alertController.addAction(action)
        }
        
        self.tableviewController.presentViewController(alertController, animated: true, completion: nil)
    }
    
    func parentInitialsSelectedHandler(){
        
        let title = "Parent Initials"
        let initialsArray = getParentInitials()
        let returnString: () = self.showAlertForPropertyInput(title, buttonValues: initialsArray, modelProperty: &self.lunch.parentInitials)
        
    }
    
    func timeSelectedHandler(selectedTime : NSDate){
        setPropertyInModel(dateValue: selectedTime, datePropertyInModel: &self.lunch.time)

        
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
                self.setPropertyInModel(value: buttonValues[i], propertyInModel: &self.lunch.parentInitials)//modelProperty)
                //self.setPropertyInModel(value: b!, propertyInModel: &b)//modelProperty)//&self.lunch.parentInitials)
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
            self.dataStore.saveLunch_Today(self.lunch)
            
            self.tableviewController.navigationController?.popViewControllerAnimated(true)
        }
        alertController.addAction(saveAnywayAction)
        self.tableviewController.presentViewController(alertController, animated: true, completion: nil)
    }
    
    //MARK: Save button
    func saveButtonTapped() {//-> ValidationResult {
        //validate
        let result = self.lunch.validateWithLunchMenuCategoryEnum()
        
        switch result{
        case .Success:
            // send save message to data store
            //dismiss view
            dataStore.saveLunch_Today(self.lunch)
            tableviewController.navigationController?.popViewControllerAnimated(true)
            
        case let .Failure(errorCodes):
            showAlertForSaveValidation("Save Error", buttonValues: errorCodes)
        }
        
    }
    
}
