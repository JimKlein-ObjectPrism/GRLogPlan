//
//  VMDataStructs.swift
//  GRPatienLogAndPlan
//
//  Created by James Klein on 5/19/15.
//  Copyright (c) 2015 ObjectPrism Corp. All rights reserved.
//

import Foundation

//MARK: Meal Item types
public class VMProfile {
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
    
    
    public init(morningSnackRequired: Bool, eveningSnackRequired: Bool){
        self.morningSnackRequired = morningSnackRequired
        self.eveningSnackRequired = eveningSnackRequired
    }
    
}
public struct VMAddOn {
    //Add-ons are added to meals or snacks, so store weak reference to avoid strong reference cycle issues
    var addOnItem: String = ""
    var instructions: String = ""
    //TODO: Is an AddOn really a Meal item or just a child of a meal item
    //weak var parentMealItem: MealItem!
    var wasConsumed: Bool?
}

public class VMParent: NSObject {
    var firstName: String?
    var lastName: String?
}

public class VMMedicine: NSObject {
    
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
public func testNil (stringProperty: String?) -> Bool {
    if stringProperty == nil {
        return true
    }
    else {
        return false
    }
}



public enum ValidationResult {
    case Success,
    Failure([String])
}

public enum BreakfastValidationError: Int {
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

public struct VMBreakfast {
    
    public var foodChoice: String?
    public var fruitChoice: String?
    
    public var addOnRequired: Bool = true
    public var addOnText: String? = "Yogurt"
    public var addOnConsumed: Bool? = false
    public var medicineRequired: Bool = true
    public var medicineText: String? = "Zinc"
    public var medicineConsumed: Bool? = false
    
    public var parentInitials: String?
    public var location: String?
    public var time: String?
    
    public var note: String?

    public init(){
        
    }
    
    public init(fromDataObject: OPBreakfast){
        
        self.foodChoice = fromDataObject.foodChoice
        self.fruitChoice = fromDataObject.fruitChoice
        self.addOnRequired = fromDataObject.addOnRequired.boolValue
        self.medicineRequired = fromDataObject.medicineRequired.boolValue

        //conditionally set properties from Data Object if they exist
        if let addOnT = fromDataObject.addOnText {
            self.addOnText = addOnT
        }
        if let aC = fromDataObject.addOnConsumed {
            self.addOnConsumed = aC.boolValue
        }
        if let mC = fromDataObject.medicineConsumed {
            self.medicineConsumed = mC.boolValue
        }
        if let mT = fromDataObject.medicineText {
            self.medicineText = mT
        }

        //parent initials are set by VM using data from DataStore
        if let pi = fromDataObject.parentInitials {
            self.parentInitials = pi
        }
        
        self.location = fromDataObject.location ?? LocationForMeal.defaultLocation()
        //time is set at the point that the cell is created by VM
        if let t = fromDataObject.time {
            self.time = t
        }
    }
    public func validateWithBreakfastMenuCategoryEnum () -> ValidationResult {
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

public struct VMLunch {
    
    public var lunchChoice: String?
    public var fruitChoice: String?
    
    public  var addOnRequired: Bool = false
    public var addOnText: String? = "Yogurt"
    public var addOnConsumed: Bool? = false
    public var medicineRequired: Bool = false
    public var medicineText: String? = "Zinc"
    public var medicineConsumed: Bool? = false
    
    public var parentInitials: String?
    public var location: String?
    public var time: String?
    
    public var note: String?

    public init(){
        
    }
    public init(fromDataObject: OPLunch){
        
        self.lunchChoice = fromDataObject.lunchChoice
        self.fruitChoice = fromDataObject.fruitChoice
        self.addOnRequired = fromDataObject.addOnRequired.boolValue
        self.medicineRequired = fromDataObject.medicineRquired.boolValue
        
        //conditionally set properties from Data Object if they exist
        if let addOnT = fromDataObject.addOnText {
            self.addOnText = addOnT
        }
        if let aC = fromDataObject.addOnConsumed {
            self.addOnConsumed = aC.boolValue
        }
        if let mC = fromDataObject.medicineConsumed {
            self.medicineConsumed = mC.boolValue
        }
        if let mT = fromDataObject.medicineText {
            self.medicineText = mT
        }
        
        //parent initials are set by VM using data from DataStore
        if let pi = fromDataObject.parentInitials {
            self.parentInitials = pi
        }
        
        self.location = fromDataObject.location ?? LocationForMeal.defaultLocation()
        //time is set at the point that the cell is created by VM
        if let t = fromDataObject.time {
            self.time = t
        }
    }

    
    public func validateWithLunchMenuCategoryEnum () -> ValidationResult {
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
public enum LunchValidationError: Int {
    case NilValueLunchChoice = 0,
    NilValueFruitChoice,
    AddOnNotConsumed,
    MedicineNotTaken
    
    public static let values: [LunchValidationError] = [.NilValueLunchChoice, .NilValueFruitChoice, .AddOnNotConsumed, .MedicineNotTaken]
    public static func count ()  -> Int {
        return values.count
    }
    
    public func message() -> String{
        
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


public enum SnackValidationError: Int {
    case NilValueSnackChoice = 0,
    NilValueFruitChoice,
    AddOnNotConsumed,
    MedicineNotTaken
    
    public static let values: [SnackValidationError] = [.NilValueSnackChoice, .NilValueFruitChoice, .AddOnNotConsumed, .MedicineNotTaken]
    public static func count ()  -> Int {
        return values.count
    }
    
    public func message() -> String{
        
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

public enum SnackTime: Int {
    case Morning = 0,
    Afternoon,
    Evening
}


public struct VMSnack {
    
    public var snackChoice: String?
    public var fruitChoice: String?
    
    public var snackTime: Int?
    
    public var addOnRequired: Bool = false
    public var addOnText: String? = "Yogurt"
    public var addOnConsumed: Bool? = false
    public var medicineRequired: Bool = false
    public var medicineText: String? = "Zinc"
    public var medicineConsumed: Bool? = false
    
    public var parentInitials: String?
    public var location: String?
    public var time: String?
    
    public var note: String?

    public init(){
        
    }
    
    public init (fromSnackTime: SnackTime) {
                self.snackTime = fromSnackTime.rawValue
            }
    
    public init (fromDataObject: OPMorningSnack) {
        self.snackTime = 0
        self.snackChoice = fromDataObject.snackChoice
        self.fruitChoice = fromDataObject.fruitChoice
        self.addOnRequired = fromDataObject.addOnRequired.boolValue
        self.medicineRequired = fromDataObject.medicineRequired.boolValue
        
        //conditionally set properties from Data Object if they exist
        if let addOnT = fromDataObject.addOnText {
            self.addOnText = addOnT
        }
        if let aC = fromDataObject.addOnConsumed {
            self.addOnConsumed = aC.boolValue
        }
        if let mC = fromDataObject.medicineConsumed {
            self.medicineConsumed = mC.boolValue
        }
        if let mT = fromDataObject.medicineText {
            self.medicineText = mT
        }
        
        //parent initials are set by VM using data from DataStore
        if let pi = fromDataObject.parentInitials {
            self.parentInitials = pi
        }
        
        self.location = fromDataObject.location ?? LocationForMeal.defaultLocation()
        //time is set at the point that the cell is created by VM
        if let t = fromDataObject.time {
            self.time = t
        }

    }
    
    public init (fromDataObject: OPAfternoonSnack) {
        self.snackTime = 1
        self.snackChoice = fromDataObject.snackChoice
        self.fruitChoice = fromDataObject.fruitChoice
        self.addOnRequired = fromDataObject.addOnRequired.boolValue
        self.medicineRequired = fromDataObject.medicineRequired.boolValue
        
        //conditionally set properties from Data Object if they exist
        if let addOnT = fromDataObject.addOnText {
            self.addOnText = addOnT
        }
        if let aC = fromDataObject.addOnConsumed {
            self.addOnConsumed = aC.boolValue
        }
        if let mC = fromDataObject.medicineConsumed {
            self.medicineConsumed = mC.boolValue
        }
        if let mT = fromDataObject.medicineText {
            self.medicineText = mT
        }
        
        //parent initials are set by VM using data from DataStore
        if let pi = fromDataObject.parentInitials {
            self.parentInitials = pi
        }
        
        self.location = fromDataObject.location ?? LocationForMeal.defaultLocation()
        //time is set at the point that the cell is created by VM
        if let t = fromDataObject.time {
            self.time = t
        }

    }
    
    public init (fromDataObject: OPEveningSnack) {
        self.snackTime = 2
        self.snackChoice = fromDataObject.snackChoice
        self.fruitChoice = fromDataObject.fruitChoice
        self.addOnRequired = fromDataObject.addOnRequired.boolValue
        self.medicineRequired = fromDataObject.medicineRequired.boolValue
        
        //conditionally set properties from Data Object if they exist
        if let addOnT = fromDataObject.addOnText {
            self.addOnText = addOnT
        }
        if let aC = fromDataObject.addOnConsumed {
            self.addOnConsumed = aC.boolValue
        }
        if let mC = fromDataObject.medicineConsumed {
            self.medicineConsumed = mC.boolValue
        }
        if let mT = fromDataObject.medicineText {
            self.medicineText = mT
        }
        
        //parent initials are set by VM using data from DataStore
        if let pi = fromDataObject.parentInitials {
            self.parentInitials = pi
        }
        
        self.location = fromDataObject.location ?? LocationForMeal.defaultLocation()
        //time is set at the point that the cell is created by VM
        if let t = fromDataObject.time {
            self.time = t
        }

    }
    
    
    
    public func validateWithSnackMenuCategoryEnum () -> ValidationResult {
        var errorMessages = [String]()
        //iterate over each section on the breakfast menu.  if an item is not required, it will not be part of the Breakfast  Categories enum and code below for that item will never be called.
        for i in 0 ..< SnackMenuCategory.count(SnackTime(rawValue: self.snackTime!)!){
            switch SnackMenuCategory(value: i, snackTime: SnackTime(rawValue: self.snackTime!)!)!{
            case .SnackChoice:
                if testNil(snackChoice)  {
                    errorMessages.append(SnackValidationError.NilValueSnackChoice.message())
                }
//            case .Fruit:
//                if testNil(fruitChoice)  {
//                    errorMessages.append(SnackValidationError.NilValueFruitChoice.message())
//                }
                
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

public enum DinnerValidationError: Int {
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


public struct VMDinner {
    
    //var dinnerChoice: String?
    public var meat: String?
    
   
    public var starch: String?
    public var oil: String?
    public var vegetable: String?
    public  var requiredItemsText: String = "8 oz Milk and Salad"
    public var requiredItemsSubtext: String = "1 T Dressing or substitute"
    public var requiredItemsConsumed: Bool = false

    
    public var addOnRequired: Bool = false
    public var addOnText: String?
    public var addOnConsumed: Bool? = false
    public var medicineRequired: Bool = false
    public var medicineText: String?
    public var medicineConsumed: Bool? = false
    
    public var parentInitials: String?
    public var location: String?
    public var time: String?
    
    public var note: String?
    
    public init (){
        
    }
    
    public init(fromDataObject: OPDinner){
        self.meat = fromDataObject.meat
        self.oil = fromDataObject.oil
        self.starch = fromDataObject.starch
        self.vegetable = fromDataObject.vegetable
        self.addOnRequired = fromDataObject.addOnRequired.boolValue
        self.medicineRequired = fromDataObject.medicineRequired.boolValue
        if fromDataObject.addOnConsumed != nil {
            self.addOnConsumed = fromDataObject.addOnConsumed!.boolValue
        }
        self.addOnText = fromDataObject.addOnText
        self.medicineConsumed = fromDataObject.medicineConsumed?.boolValue
        self.medicineText = fromDataObject.medicineText
        self.parentInitials = fromDataObject.parentInitials
        self.location = fromDataObject.place
        self.time = fromDataObject.time

        self.requiredItemsConsumed = fromDataObject.requiredItems.boolValue
    }
    
    public func validateWithDinnerMenuCategoryEnum () -> ValidationResult {
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
                    if !requiredItemsConsumed {
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
