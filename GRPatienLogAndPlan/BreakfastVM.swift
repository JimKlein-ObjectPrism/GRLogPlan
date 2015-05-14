//
//  BreakfastVM.swift
//  GRPatienLogAndPlan
//
//  Created by James Klein on 5/11/15.
//  Copyright (c) 2015 ObjectPrism Corp. All rights reserved.
//

import Foundation


enum BreakfastMenuCategory {
    case FoodChoice,
    Fruit,
    Medicine,
    AddOn,
    AdditionalInfo
    
    static var caseItems: [BreakfastMenuCategory] = [BreakfastMenuCategory]()
    
    static func count() -> Int { return caseItems.count }
    
    static func configureMenuChoice(profile: OPProfile){
        caseItems.append(BreakfastMenuCategory.FoodChoice)
        caseItems.append(BreakfastMenuCategory.Fruit)
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
        if value >= BreakfastMenuCategory.caseItems.count || value < 0 { return nil }
        self = BreakfastMenuCategory.caseItems[value]
    }
}


class OPProfile {
    var addOnRequired = true
    var medicineRequired = true
    var medicine: Int?
    var parents: [String] = ["Joe Smith", "Jane Doe"]
}

class OPBreakfast {
    
    var foodChoice: String?
    var fruitChoice: String?
    var addOn: Int? = 0
    var addOnText = "Yogurt"
    var addOnConsumed: Bool? = false
    var medicine: Int? = 0
    var medicineText = "Zinc"
    var parentInitials: String?
    var location: String?
    var time: NSDate?

    var medicineConsumed: Bool? = false
}

public class BreakfastVM: MealViewModel, UITableViewDataSource, UITableViewDelegate, ChoiceItemSelectedDelegate, MedicineItemSelectedDelegate,
    AddOnItemSelectedDelegate, LocationSelectedDelegate
     {
    
    let foodItemArray: [FoodItem]
    var currentFoodItemArray: [FoodItem] = [FoodItem]()
    let fruitArray: [FoodItem]
    var currentFruitArray: [FoodItem]  = [FoodItem]()
    
    var breakfast: OPBreakfast

    init( profile : OPProfile, breakfast: OPBreakfast, dataStore: DataStore)
    {
        
        self.breakfast = breakfast
        self.foodItemArray = dataStore.buildFoodItemArray(filterString: "BreakfastItem")
        self.fruitArray = dataStore.buildFoodItemArray(filterString: "FruitItem")
        
        super.init()
        
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

        //TODO: Initialize Parent Array from Profile
    }
    
    public func numberOfSectionsInTableView(tableView: UITableView) -> Int {
        return BreakfastMenuCategory.count()
    }
    public func tableView(tableView: UITableView, titleForHeaderInSection section: Int) -> String? {
        if let menuSection = BreakfastMenuCategory(value: section){
            
            switch menuSection {
            case BreakfastMenuCategory.FoodChoice:
                return "Breakfast Item"
            case BreakfastMenuCategory.Fruit:
                return "Fruit Choice"
            case .Medicine:
                return "Medicine"
            case .AddOn:
                return "Add On"
            case .AdditionalInfo:
                return "Additional Information"
            }
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
        
        let menuSection = BreakfastMenuCategory(value: indexPath.section)
            
            switch menuSection! {
            case .FoodChoice:
                let cell = self.tableCell(tableView, cellForFoodItemAtIndexPath: indexPath, inArray: currentFoodItemArray)
                if let choiceCell = cell as? NewChoiceTableViewCell {
                    //cellForFoodItemAtIndexPath returns a NewChoice... cell or a plain cell, add delegate only to choice cell
                    choiceCell.segmentSelectionHandler = self
                }
                return cell
            case .Fruit:
                let cell = self.tableCell(tableView, cellForFoodItemAtIndexPath: indexPath, inArray: currentFruitArray)
                if let choiceCell = cell as? NewChoiceTableViewCell {
                    choiceCell.segmentSelectionHandler = self
                }
                return cell
            case .Medicine:
                let cell: MedicineTableViewCell = self.tableCell(tableView, cellForMedicineItem: indexPath, medicineText: breakfast.medicineText, switchState: false)
                cell.medicineTakenHandler = self
                return cell
            case .AddOn:
                //let handler: AddOnItemSelectedDelegate = (self as? AddOnItemSelectedDelegate)!
                return tableCell(tableView, cellForAddOnItem: indexPath, addOnText: self.breakfast.addOnText, switchState: self.breakfast.addOnConsumed!, switchSelectionHandler: self)
            case .AdditionalInfo:
                
                if let location = self.breakfast.location {
                    return tableCell(tableView , cellForLocationItem: indexPath, locationText: location, locationSelectionHandler: self)
                }
                else{
                    //set it to
                    var defaultLocation = LocationForMeal(rawValue: 0)?.name()
                    return tableCell(tableView , cellForLocationItem: indexPath, locationText: defaultLocation, locationSelectionHandler: self)
                }
                
            default:
                let cell = tableView.dequeueReusableCellWithIdentifier("Cell", forIndexPath: indexPath) as! UITableViewCell
                return cell
            }
        

    }
    
    @objc public func didDeselectRowAtIndexPath (indexPath: NSIndexPath) {
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
//            let itemNameAndSelectionName = self.getItemNameAndChoiceItemName(selectedIndexPath: indexPath, selectedSegment: childItemIndex, mutableArray: self.currentFoodItemArray)
//            setPropertyInModel(itemNameAndSelectionName, propertyInModel: &self.breakfast.foodChoice)
        case .Fruit:
            let itemNameAndSelectionName = self.getItemNameAndChoiceItemName(selectedIndexPath: indexPath, selectedSegment: childItemIndex, mutableArray: self.currentFruitArray)
            setPropertyInModel(value: itemNameAndSelectionName, propertyInModel: &self.breakfast.fruitChoice)
        default:
            return
        }
    }
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
                let choiceMenu = UIAlertController(title: nil, message: title, preferredStyle: .ActionSheet)
        
                //let button = sender as! UIButton
        
                var newTitle : String = ""
        
                // add Action buttons for each set of initials in the list
                for s in 0..<buttonList.count {
        
                    var buttonIndex = s
        
                    var action = UIAlertAction(title: buttonList[s], style: .Default, handler: {
                        (alert: UIAlertAction!) -> Void in
                        //send initials updated event
                        //button.titleLabel?.text = buttonList[s]
                        newTitle = buttonList[s]
                        //self.parentInitials = buttonList[s]
        
                    })
                    
                    choiceMenu.addAction(action)
                }
        
                self.tableviewController.presentViewController(choiceMenu, animated: true, completion: nil)
    }
    
    func parentInitialsSelectedHandler(){
        let initialsArray = getParentInitials()
        
        let title = "Parent Initials"
        let cancel = "Cancel"
        //let firstButtonItem = buttonList[0]

        // create controller
        let choiceMenu = UIAlertController(title: nil, message: title, preferredStyle: .ActionSheet)

        //let button = sender as! UIButton
        
        var newTitle : String = ""
        

        for i in 0 ..< initialsArray.count {
            
            var buttonIndex = i
            
            var action = UIAlertAction(title: initialsArray[i], style: .Default, handler: {
                (alert: UIAlertAction!) -> Void in
                newTitle = initialsArray[i]
            })
            
            choiceMenu.addAction(action)
        }
        
        self.tableviewController.presentViewController(choiceMenu, animated: true, completion: nil)
    }
    
    

    
    func blah ()
    {
//        let buttonList = ["A.B." , "B.C."]
//        let title = "Parent Initials"
//        let cancel = "Cancel"
//        let firstButtonItem = buttonList[0]
//        
//        // create controller
//        let choiceMenu = UIAlertController(title: nil, message: title, preferredStyle: .ActionSheet)
//        
//        let button = sender as! UIButton
//        
//        var newTitle : String = ""
//        
//        // add Action buttons for each set of initials in the list
//        for s in 0..<buttonList.count {
//            
//            var buttonIndex = s
//            
//            var action = UIAlertAction(title: buttonList[s], style: .Default, handler: {
//                (alert: UIAlertAction!) -> Void in
//                //send initials updated event
//                button.titleLabel?.text = buttonList[s]
//                newTitle = buttonList[s]
//                //self.parentInitials = buttonList[s]
//                
//            })
//            
//            choiceMenu.addAction(action)
//        }
//        
//        self.presentViewController(choiceMenu, animated: true, completion: nil)

    }

}