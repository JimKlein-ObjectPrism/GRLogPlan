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
    var addOnConsumed: Bool = false
    var medicine: Int? = 0
    var medicineText = "Zinc"

    var medicineConsumed: Bool? = false
}

public class BreakfastVM: MealViewModel, UITableViewDataSource, UITableViewDelegate, ChoiceItemSelectedDelegate, MedicineItemSelectedDelegate {
    
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
                let cell = self.tableCell(tableView, cellForMedicineItem: indexPath, medicineText: breakfast.medicineText, switchState: false)
                return cell
//            case .AddOn:
//                return 1
//            case .AdditionalInfo:
//                return 3
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
        //setPropertyInModel(boolValue: medicineConsumed, boolPropertyInModel: &self.breakfast.medicineConsumed)
//    self.set
        //self.setPropertyInModel(medicineConsumed, propertyInModel: &self.breakfast.medicineConsumed)
    //setPropertyInModel(medi, propertyInModel: &self.breakfast.fruitChoice)
    }
}