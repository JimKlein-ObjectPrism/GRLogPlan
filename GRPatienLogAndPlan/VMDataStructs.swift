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
    //      This function iterates over the list of error messages.  some message apply to optional information.  better approach is to iterate over
    //      list of items in menu and skip any that aren't required.  Keeping this for reference.  delete after beta release.
    //    func validateRequiredFields ( ) -> ValidationResult {
    //        var errorMessages = [String]()
    //        for i in 0 ..< BreakfastValidationError.count() {
    //            let errorCondition = BreakfastValidationError.values[i]
    //            switch errorCondition {
    //            case BreakfastValidationError.NilValueFoodChoice:
    //                if testNil(foodChoice)  {
    //                    errorMessages.append(BreakfastValidationError.NilValueFoodChoice.message())
    //                }
    //            case .NilValueFruitChoice:
    //                if testNil(fruitChoice)  {
    //                    errorMessages.append(BreakfastValidationError.NilValueFruitChoice.message())
    //                }
    //            case .AddOnNotConsumed:
    //                if addOnRequired {
    //                    if (addOnConsumed == false) {
    //                        errorMessages.append(BreakfastValidationError.AddOnNotConsumed.message())
    //                    }
    //                }
    //            case .MedicineNotTaken:
    //                if meidicineRequired {
    //                    if (medicineConsumed == false) {
    //                        errorMessages.append(BreakfastValidationError.MedicineNotTaken.message())
    //                    }
    //                }
    //            }
    //        }
    //        if errorMessages.count == 0 {
    //            return ValidationResult.Success
    //        } else {
    //            return ValidationResult.Failure(errorMessages)
    //        }
    //        
    //    }

}

struct VMLunch {
    
    var lunchChoice: String?
    var fruitChoice: String?
    
    var addOnRequired: Bool = false
    var addOnText: String? = "Yogurt"
    var addOnConsumed: Bool? = false
    var meidicineRequired: Bool = false
    var medicineText: String? = "Zinc"
    var medicineConsumed: Bool? = false
    
    var parentInitials: String?
    var location: String?
    var time: NSDate?
    
    
    func validateWithLunchMenuCategoryEnum () -> ValidationResult {
        var errorMessages = [String]()
        //this next line isn't necessary when datastore initialized enum
        //BreakfastMenuCategory.configureMenuChoice(OPProfile())
        
        //iterate over each section on the breakfast menu.  if an item is not required, it will not be part of the Breakfast  Categories enum and code below for that item will never be called.
        for i in 0 ..< LunchMenuCategory.count(){
            switch LunchMenuCategory(value: i)!{
            case .LunchChoice:
                if testNil(lunchChoice)  {
                    errorMessages.append(BreakfastValidationError.NilValueFoodChoice.message())
                }
            case .Fruit:
                if testNil(fruitChoice)  {
                    errorMessages.append(BreakfastValidationError.NilValueFruitChoice.message())
                }
                
            case .AddOn:
                if addOnConsumed != nil {
                    if !addOnConsumed! {
                        errorMessages.append(BreakfastValidationError.AddOnNotConsumed.message())
                    }
                }
            case .Medicine:
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
enum LunchValidationError: Int {
    case NilValueLunchChoice = 0,
    NilValueFruitChoice,
    AddOnNotConsumed,
    MedicineNotTaken
    
    static let values: [LunchValidationError] = [.NilValueLunchChoice, .NilValueFruitChoice, .AddOnNotConsumed, .MedicineNotTaken]
    static func count ()  -> Int {
        return values.count
    }
    
    func message() -> String{
        
        switch self{
        case NilValueLunchChoice:
            return "A Lunch Item has not been selected."
        case NilValueFruitChoice:
            return "A Fruit Item has not been selected."
        case AddOnNotConsumed:
            return "An Add On has not been recorded."
        case MedicineNotTaken:
            return "Medicine has not been taken."
        }
    }
}


enum SnackValidationError: Int {
    case NilValueSnackChoice = 0,
    NilValueFruitChoice,
    AddOnNotConsumed,
    MedicineNotTaken
    
    static let values: [SnackValidationError] = [.NilValueSnackChoice, .NilValueFruitChoice, .AddOnNotConsumed, .MedicineNotTaken]
    static func count ()  -> Int {
        return values.count
    }
    
    func message() -> String{
        
        switch self{
        case NilValueSnackChoice:
            return "A Snack Item has not been selected."
        case NilValueFruitChoice:
            return "A Fruit Item has not been selected."
        case AddOnNotConsumed:
            return "An Add On has not been recorded."
        case MedicineNotTaken:
            return "Medicine has not been taken."
        }
    }
}

enum SnackTime: Int {
    case Morning,
    Afternoon,
    Evening
}
struct VMSnack {
    
    var snackChoice: String?
    var fruitChoice: String?
    
    var snackTime: Int?
    
    var addOnRequired: Bool = false
    var addOnText: String? = "Yogurt"
    var addOnConsumed: Bool? = false
    var meidicineRequired: Bool = false
    var medicineText: String? = "Zinc"
    var medicineConsumed: Bool? = false
    
    var parentInitials: String?
    var location: String?
    var time: NSDate?
    
    
    func validateWithSnackMenuCategoryEnum () -> ValidationResult {
        var errorMessages = [String]()
        //iterate over each section on the breakfast menu.  if an item is not required, it will not be part of the Breakfast  Categories enum and code below for that item will never be called.
        for i in 0 ..< SnackMenuCategory.count(){
            switch SnackMenuCategory(value: i)!{
            case .SnackChoice:
                if testNil(snackChoice)  {
                    errorMessages.append(SnackValidationError.NilValueSnackChoice.message())
                }
            case .Fruit:
                if testNil(fruitChoice)  {
                    errorMessages.append(SnackValidationError.NilValueFruitChoice.message())
                }
                
            case .AddOn:
                if addOnConsumed != nil {
                    if !addOnConsumed! {
                        errorMessages.append(SnackValidationError.AddOnNotConsumed.message())
                    }
                }
            case .Medicine:
                if medicineConsumed != nil {
                    if !medicineConsumed! {
                        errorMessages.append(SnackValidationError.MedicineNotTaken.message())
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

enum DinnerValidationError: Int {
    case NilValueMeatChoice = 0,
    NilValueStarchChoice,
    NilValueOilChoice,
    NilValueVegetableChoice,
    RequiredItemsNotConsumed,
    AddOnNotConsumed,
    MedicineNotTaken
    
    static let values: [DinnerValidationError] = [.NilValueMeatChoice, .NilValueStarchChoice, .NilValueOilChoice, .NilValueVegetableChoice, .RequiredItemsNotConsumed, .AddOnNotConsumed, .MedicineNotTaken]
    static func count ()  -> Int {
        return values.count
    }
    
    func message() -> String{
        
        switch self{
        case NilValueMeatChoice:
            return "A Dinner Item has not been selected."
        case NilValueStarchChoice:
            return "A Starch Group Item has not been selected."
        case NilValueOilChoice:
            return "An Oil Item has not been selected."
        case NilValueVegetableChoice:
            return "A Vegetable Item has not been selected."
        case RequiredItemsNotConsumed:
            return "The Required Item Switch has not been set."
        case AddOnNotConsumed:
            return "An Add On has not been recorded."
        case MedicineNotTaken:
            return "Medicine has not been taken."
        }
    }
}


struct VMDinner {
    
    var dinnerChoice: String?
    var meat: String?
    
   
    var starch: String?
    var oil: String?
    var vegetable: String?
    var requiredItemsText: String = "8 oz Milk and Salad"
    var requiredItemsSubtext: String = "1 T Dressing or substitute"
    var requiredItemsConsumed: Bool? = false

    
    var addOnRequired: Bool = false
    var addOnText: String? = "Yogurt"
    var addOnConsumed: Bool? = false
    var meidicineRequired: Bool = false
    var medicineText: String? = "Zinc"
    var medicineConsumed: Bool? = false
    
    var parentInitials: String?
    var location: String?
    var time: NSDate?
    
    
    func validateWithDinnerMenuCategoryEnum () -> ValidationResult {
        var errorMessages = [String]()
        //iterate over each section on the breakfast menu.  if an item is not required, it will not be part of the Breakfast  Categories enum and code below for that item will never be called.
        for i in 0 ..< DinnerMenuCategory.count(){
            switch DinnerMenuCategory(value: i)!{
            case .Meat:
                if testNil(meat)  {
                    errorMessages.append(DinnerValidationError.NilValueMeatChoice.message())
                }
            case .Oil:
                if testNil(oil)  {
                    errorMessages.append(DinnerValidationError.NilValueOilChoice.message())
                }
                
            case .Starch:
                if testNil(meat)  {
                    errorMessages.append(DinnerValidationError.NilValueStarchChoice.message())
                }
            case .Vegetable:
                if testNil(oil)  {
                    errorMessages.append(DinnerValidationError.NilValueVegetableChoice.message())
                }
            case .RequiredItems:
                if addOnConsumed != nil {
                    if !requiredItemsConsumed! {
                        errorMessages.append(DinnerValidationError.RequiredItemsNotConsumed.message())
                    }
                }
            case .AddOn:
                if addOnConsumed != nil {
                    if !addOnConsumed! {
                        errorMessages.append(DinnerValidationError.AddOnNotConsumed.message())
                    }
                }
            case .Medicine:
                if medicineConsumed != nil {
                    if !medicineConsumed! {
                        errorMessages.append(DinnerValidationError.MedicineNotTaken.message())
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
