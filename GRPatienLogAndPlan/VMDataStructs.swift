//
//  VMDataStructs.swift
//  GRPatienLogAndPlan
//
//  Created by James Klein on 5/19/15.
//  Copyright (c) 2015 ObjectPrism Corp. All rights reserved.
//

import Foundation

//MARK: Meal Item types
class VMProfile {
    /*
var addOnRequired = false
var medicineRequired = false
var parentInitials = "A.B"
let location = "Kitchen"
let time = NSDate()
var medicine: Int?
var parents: [String] = ["Joe Smith", "Jane Doe"]
*/

    //required Items
    var patientFirstName: String?
    var patientLastName: String?
    var morningSnackRequired: Bool = false
    var eveningSnackRequired: Bool = false
    var parents: [VMParent] = [VMParent]()
    
    
    //optional items
    var medicines: [Medicine] = []
    var addOns: [VMAddOn] = [VMAddOn]()
    
    
    //named Meals - NOT  IMPLEMENTED
    var namedMeals: [NamedMeal] = []
    
    
    init(morningSnackRequired: Bool, eveningSnackRequired: Bool){
        self.morningSnackRequired = morningSnackRequired
        self.eveningSnackRequired = eveningSnackRequired
    }
    
}
struct VMAddOn {
    //Add-ons are added to meals or snacks, so store weak reference to avoid strong reference cycle issues
    var addOnItem: String = ""
    var instructions: String = ""
    //TODO: Is an AddOn really a Meal item or just a child of a meal item
    //weak var parentMealItem: MealItem!
    var wasConsumed: Bool?
}

class VMParent: NSObject {
    var firstName: String?
    var lastName: String?
}

class VMMedicine: NSObject {
    
    var name:String = ""
//var dose:String = ""
   // var instructions:String = ""
    //var didTakeMedsForDay: Bool = false
    
    //MenuDisplayCell properties
    //@objc var menuDisplayName: String
    //this property can be nil, since it is not applicable to all menu items
    var mealEntryState: MealEntryState!
    

    
}

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
    var medicineRequired: Bool = true
    var medicineText: String? = "Zinc"
    var medicineConsumed: Bool? = false
    
    var parentInitials: String?
    var location: String?
    var time: NSDate?
    init(){
        
    }
    
    init(fromDataObject: OPBreakfast){
        
        self.foodChoice = fromDataObject.foodChoice
        self.fruitChoice = fromDataObject.fruitChoice
        self.addOnRequired = fromDataObject.addOnRequired.boolValue
        self.addOnConsumed = fromDataObject.addOnConsumed?.boolValue
        self.addOnText = fromDataObject.addOnText
        self.medicineRequired = fromDataObject.medicineRequired.boolValue
        self.medicineConsumed = fromDataObject.medicineConsumed?.boolValue
        self.medicineText = fromDataObject.medicineText
        
        //parent initials are set by VM using data from DataStore
        if let pi = fromDataObject.parentInitials {
            self.parentInitials = fromDataObject.parentInitials
        }
        
        self.location = fromDataObject.location ?? LocationForMeal.defaultLocation()
        //time is set at the point that the cell is created by VM
        if let t = fromDataObject.time {
            self.time = t
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
    
    //var dinnerChoice: String?
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
