//
//  BreakfastVM.swift
//  GRPatienLogAndPlan
//
//  Created by James Klein on 5/11/15.
//  Copyright (c) 2015 ObjectPrism Corp. All rights reserved.
//

import Foundation

public class TempProfile {
    var addOnRequired = true
    var medicineRequired = true
    var morningSnackRequired = true
    var eveningSnackRequired = true
    var parentInitials = "A.B"
    let location = "Kitchen"
    let time = NSDate()
    var medicine: Int?
    var parents: [String] = ["Joe Smith", "Jane Doe"]
}

public class BreakfastVM: MealViewModel, MealViewModelDelegate, UITableViewDataSource, UITableViewDelegate, ChoiceItemSelectedDelegate, MedicineItemSelectedDelegate,
    AddOnItemSelectedDelegate, LocationSelectedDelegate, ParentInitialsSelectedDelegate, TimeSelectedDelegate, NoteChangedDelegate
     {
    //let dataStore: DataStore
    var targetOPBreakfast: OPBreakfast?
    
    let foodItemArray: [FoodItem]
    var currentFoodItemArray: [FoodItem] = [FoodItem]()
    let fruitArray: [FoodItem]
    var currentFruitArray: [FoodItem]  = [FoodItem]()
    
    var breakfast: VMBreakfast
    
    var noteText: String? { return breakfast.note }

    override init(dataStore: DataStore)
    {
        //dataStore = dataStore
        dataStore.updateMealCategoryEnumsAndProfileFields()

        if let entry = dataStore.currentJournalEntry {
            self.breakfast = VMBreakfast(fromDataObject: entry.breakfast)
        } else {
            self.breakfast = dataStore.getBreakfast_Today()
        }
        
        // Set up variables to keep track of togging from lists of choices
        // These may be moved to the Presenter in a VIPER refactor
        
        self.foodItemArray = dataStore.buildFoodItemArray(filterString: "BreakfastItem")
        self.fruitArray = dataStore.buildFoodItemArray(filterString: "FruitItem")
        
        super.init(dataStore: dataStore)
        
        if breakfast.foodChoice != nil {
            currentFoodItemArray = getFoodItem(breakfast.foodChoice!, foodItemArray: foodItemArray)
        }
        else {
            currentFoodItemArray = foodItemArray
        }
        
        if breakfast.fruitChoice != nil {
            currentFruitArray = getFoodItem(breakfast.fruitChoice!, foodItemArray: fruitArray)
        }
        else {
            currentFruitArray  = fruitArray
        }

        //TODO: Get time at init, i
        dataStore.updateMealCategoryEnumsAndProfileFields()

    }
    
    public func numberOfSectionsInTableView(tableView: UITableView) -> Int {
        return BreakfastMenuCategory.count()
    }
    public func tableView(tableView: UITableView, titleForHeaderInSection section: Int) -> String? {
        if let menuSection = BreakfastMenuCategory(value: section){
            return menuSection.unselectedHeaderTitle()
        } else {
            //TODO: handle Index Out of Range error
            return nil
        }
    }
    

    @objc public func tableView(tableView: UITableView, numberOfRowsInSection section: Int) -> Int {

        if let menuSection = BreakfastMenuCategory(value: section){
            
            switch menuSection {
            case .FoodChoice:
                return self.currentFoodItemArray.count
            case .Fruit:
                return self.currentFruitArray.count
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
            //assert(false, "Unimplemented error handler for Index Out of Range.")
            return 0
        }
    }
    
    
    @objc public func tableView(tableView: UITableView, cellForRowAtIndexPath indexPath: NSIndexPath) -> UITableViewCell {
        
        let menuSection = BreakfastMenuCategory(value: indexPath.section)
            
            switch menuSection! {
            case .FoodChoice:
                let cell = self.tableCell(tableView, cellForFoodItemAtIndexPath: indexPath, inArray: currentFoodItemArray, foodItemName: self.breakfast.foodChoice, viewModel: self)
                if let choiceCell = cell as? NewChoiceTableViewCell {
                    //cellForFoodItemAtIndexPath returns a NewChoice... cell or a plain cell, add delegate only to choice cell
                    choiceCell.segmentSelectionHandler = self
                    if let v = self.breakfast.foodChoice {
                        //let indexString =
                        let myArray: [String] = v.componentsSeparatedByString(",")
                        var indexString: String? = myArray.last
                        let indexValue = indexString?.toInt()
                        choiceCell.choiceSegmentControl.selectedSegmentIndex = indexValue!
                    }
                }
                return cell
            case .Fruit:
                let cell = self.tableCell(tableView, cellForFoodItemAtIndexPath: indexPath, inArray: currentFruitArray, foodItemName: self.breakfast.foodChoice, viewModel: self)
                if let choiceCell = cell as? NewChoiceTableViewCell {
                    choiceCell.segmentSelectionHandler = self
                }
                return cell
            case .Medicine:
                let cell: MedicineTableViewCell = self.tableCell(tableView, cellForMedicineItem: indexPath, medicineText: breakfast.medicineText!, switchState: self.breakfast.medicineConsumed!)
                cell.medicineTakenHandler = self
                return cell
            case .AddOn:
                //let handler: AddOnItemSelectedDelegate = (self as? AddOnItemSelectedDelegate)!
                return tableCell(tableView, cellForAddOnItem: indexPath, addOnText: self.breakfast.addOnText!, switchState: self.breakfast.addOnConsumed!, switchSelectionHandler: self)
            case .AdditionalInfo:
                switch indexPath.row {
                case 0:
                    return tableCell(tableView, cellForParentInitialsItem: indexPath, parentInitialsText: &self.breakfast.parentInitials, parentSelectionHandler: self)
                case 1:
                    return tableCell(tableView , cellForLocationItem: indexPath, locationText: &self.breakfast.location, locationSelectionHandler: self)
                case 2:
                    return tableCell(tableView, cellForTimeItem: indexPath, time: &breakfast.time , timeSelectionHandler: self)
                default:
                    return tableCell(tableView, cellForNoteItem: indexPath)
                    
                }
                
            default:
                let cell = tableView.dequeueReusableCellWithIdentifier("Cell", forIndexPath: indexPath) as! UITableViewCell
                return cell
            }
        

    }
    
    @objc public func didDeselectRowAtIndexPath (indexPath: NSIndexPath, viewController: UIViewController) {
        //selectedItemTitle = dataSource[indexPath.row]
        let menuSection = BreakfastMenuCategory( value: indexPath.section)
            
            switch menuSection!{
            case .FoodChoice:
                toggleSelectionArrayAndPropertyInModel(
                    indexPath,
                    mutableArray: &self.currentFoodItemArray,
                    immutableArray: self.foodItemArray,
                    propertyInModel: &breakfast.foodChoice
                )
            case .Fruit:
                toggleSelectionArrayAndPropertyInModel(
                    indexPath,
                    mutableArray: &currentFruitArray,
                    immutableArray: self.fruitArray,
                    propertyInModel: &breakfast.fruitChoice
                )
            case .AdditionalInfo:
                if indexPath.row == 3 {
                    let vc : NoteViewController = viewController.storyboard?.instantiateViewControllerWithIdentifier("NoteViewController") as! NoteViewController
                    //vc.navigationItem.title = navBarTitle
                    vc.vm = self
                    vc.noteDelegate = self
                    //vc.vm.tableView = vc.tableView
                    //vc.vm.tableviewController = vc
                    //vc.textView.text = breakfast.note ?? ""
                    
                    viewController.showViewController(vc as UIViewController, sender: vc)

                    
                }
                return
            default:
                return
            }
    }

    //MARK: Data Update Delgate Methods
    func choiceItemSelectedHandler(childItemIndex: Int, indexPath: NSIndexPath){
        //update current meal item
        
        let menuSection = BreakfastMenuCategory(value: indexPath.section)
        
        switch menuSection! {
        case .FoodChoice:
            self.toggleSelectionArrayAndPropertyInModelForSegmentedControl(selectedIndexPath: indexPath, selectedSegment: childItemIndex, mutableArray: &self.currentFoodItemArray, immutableArray: self.foodItemArray, propertyInModel: &self.breakfast.foodChoice)
        case .Fruit:
            let itemNameAndSelectionName = self.getItemNameAndChoiceItemIndex(selectedIndexPath: indexPath, selectedSegment: childItemIndex, mutableArray: self.currentFruitArray)
            setPropertyInModel(value: itemNameAndSelectionName, propertyInModel: &self.breakfast.fruitChoice)
        default:
            return
        }
    }
    //Note Handler
    func noteHandler(noteText: String){
        setPropertyInModel(value: noteText, propertyInModel: &self.breakfast.note)
    }

    //Medicine Switch Selection Handler
    func choiceItemSelectedHandler(medicineConsumed: Bool){
        setPropertyInModel(boolValue: medicineConsumed, boolPropertyInModel: &self.breakfast.medicineConsumed)
    }
    //MARK: Cell entry delegates
    func addOnItemSelectedHandler(addOnConsumed: Bool)
    {
        setPropertyInModel(boolValue: addOnConsumed, boolPropertyInModel: &self.breakfast.addOnConsumed)
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
                        //button.titleLabel?.text = buttonList[s]
                        newTitle = buttonList[s]
                        self.setPropertyInModel(value: newTitle, propertyInModel: &self.breakfast.location)
                        self.tableView.reloadData()
                    })
                    
                    alertController.addAction(action)
                }
        
                self.tableviewController.presentViewController(alertController, animated: true, completion: nil)
    }
    
    func parentInitialsSelectedHandler(){
        
        let title = "Parent Initials"
        let initialsArray = getParentInitials()
        //let b = self.showAlertForPropertyInput(title, buttonValues: initialsArray, modelProperty: &<#String#>)
        let returnString: () = self.showAlertForPropertyInput(title, buttonValues: initialsArray, modelProperty: &self.breakfast.parentInitials)
        
        }
    
    func timeSelectedHandler(selectedTime : NSDate){
        var dateFormatter = NSDateFormatter()
        dateFormatter.timeStyle = .ShortStyle
        var time = dateFormatter.stringFromDate(selectedTime)

        setPropertyInModel(value: time, propertyInModel: &self.breakfast.time)
        //self.breakfast.time = selectedTime
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
                self.setPropertyInModel(value: buttonValues[i], propertyInModel: &self.breakfast.parentInitials)//modelProperty)
                //self.setPropertyInModel(value: b!, propertyInModel: &b)//modelProperty)//&self.breakfast.parentInitials)
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
            self.dataStore.saveBreakfast(self.breakfast)//, modelBreakfast: &self.targetOPBreakfast!)

            self.tableviewController.navigationController?.popViewControllerAnimated(true)
        }
        alertController.addAction(saveAnywayAction)
        self.tableviewController.presentViewController(alertController, animated: true, completion: nil)        
    }

    //MARK: Save button
    func saveButtonTapped() {//-> ValidationResult {
        //validate
        let result = self.breakfast.validate()
        
        switch result{
        case .Success:
            // send save message to data store
            //dismiss view
            dataStore.saveBreakfast(self.breakfast)//, modelBreakfast: &self.targetOPBreakfast!)
            tableviewController.navigationController?.popViewControllerAnimated(true)

        case let .Failure(errorCodes):
            showAlertForSaveValidation("Save Error", buttonValues: errorCodes)
        }
        
    }

}