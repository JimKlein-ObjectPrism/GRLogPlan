//
//  VMDataStructs.swift
//  GRPatienLogAndPlan
//
//  Created by James Klein on 5/19/15.
//  Copyright (c) 2015 ObjectPrism Corp. All rights reserved.
//

import Foundation

//validation helper functions
func testNil (stringProperty: String?) -> Bool {
    if stringProperty == nil {
        return true
    }
    else {
        return false
    }
}

enum ValidationResult {
    case Success,
    Failure([String])
}

enum BreakfastValidationError: Int {
    case NilValueFoodChoice = 0,
    NilValueFruitChoice,
    AddOnNotConsumed,
    MedicineNotTaken
    
    static let values: [BreakfastValidationError] = [BreakfastValidationError.NilValueFoodChoice, BreakfastValidationError.NilValueFruitChoice, BreakfastValidationError.AddOnNotConsumed, BreakfastValidationError.MedicineNotTaken]
    static func count ()  -> Int {
        return values.count
    }
    
    func message() -> String{
        
        switch self{
        case NilValueFoodChoice:
            return "A Food Item has not been selected."
        case NilValueFruitChoice:
            return "A Fruit Item has not been selected."
        case AddOnNotConsumed:
            return "An Add On has not been recorded."
        case MedicineNotTaken:
            return "Medicine has not been taken."
        }
    }
}

struct VMBreakfast {
    
    var foodChoice: String?
    var fruitChoice: String?
    var addOnRequired: Bool = true
    var addOnText: String? = "Yogurt"
    var addOnConsumed: Bool? = false
    var meidicineRequired: Bool = true
    var medicineText: String? = "Zinc"
    var medicineConsumed: Bool? = false
    var parentInitials: String?
    var location: String?
    var time: NSDate?
    
    func validateRequiredFields ( ) -> ValidationResult {
        var errorMessages = [String]()
        for i in 0 ..< BreakfastValidationError.count() {
            let errorCondition = BreakfastValidationError.values[i]
            switch errorCondition {
            case BreakfastValidationError.NilValueFoodChoice:
                if testNil(foodChoice)  {
                    errorMessages.append(BreakfastValidationError.NilValueFoodChoice.message())
                }
            case .NilValueFruitChoice:
                if testNil(fruitChoice)  {
                    errorMessages.append(BreakfastValidationError.NilValueFruitChoice.message())
                }
            case .AddOnNotConsumed:
                if addOnRequired {
                    if (addOnConsumed == false) {
                        errorMessages.append(BreakfastValidationError.AddOnNotConsumed.message())
                    }
                }
            case .MedicineNotTaken:
                if meidicineRequired {
                    if (medicineConsumed == false) {
                        errorMessages.append(BreakfastValidationError.MedicineNotTaken.message())
                    }
                }
            }
        }
        if errorMessages.count == 0 {
            return ValidationResult.Success
        } else {
            return ValidationResult.Failure(errorMessages)
        }
        
    }
    
    func validateWithBreakfastMenuCategoryEnum () -> ValidationResult {
        var errorMessages = [String]()
        //this next line isn't necessary when datastore initialized enum
        //BreakfastMenuCategory.configureMenuChoice(OPProfile())
        
        //iterate over each section on the breakfast menu.  if an item is not required, it will not be part of the Breakfast  Categories enum and code below for that item will never be called.
        for i in 0 ..< BreakfastMenuCategory.count(){
            switch BreakfastMenuCategory(value: i)!{
            case BreakfastMenuCategory.FoodChoice:
                if testNil(foodChoice)  {
                    errorMessages.append(BreakfastValidationError.NilValueFoodChoice.message())
                }
            case BreakfastMenuCategory.Fruit:
                if testNil(fruitChoice)  {
                    errorMessages.append(BreakfastValidationError.NilValueFruitChoice.message())
                }
                
            case BreakfastMenuCategory.AddOn:
                if addOnConsumed != nil {
                    if !addOnConsumed! {
                        errorMessages.append(BreakfastValidationError.AddOnNotConsumed.message())
                    }
                }
            case BreakfastMenuCategory.Medicine:
                if medicineConsumed != nil {
                    if !medicineConsumed! {
                        errorMessages.append(BreakfastValidationError.MedicineNotTaken.message())
                    }
                }
            case .AdditionalInfo:
                continue
            }
        }
        
        if errorMessages.count == 0 {
            return ValidationResult.Success
        } else {
            return ValidationResult.Failure(errorMessages)
        }
        
    }
    
}
