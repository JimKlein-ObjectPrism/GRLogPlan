//
//  DataTypes.swift
//  GRPatienLogAndPlan
//
//  Created by Jim Klein on 2/27/15.
//  Copyright (c) 2015 ObjectPrism Corp. All rights reserved.
//

import Foundation



//MARK: Journal Data Types
class JournalItem : JournalEntryItem{
    var title = ""
    var date: NSDate
    var friendlyDate = ""
    var isComplete = false
    
    var breakfastChoice: Breakfast
    var morningSnack: Snack?
    var lunchItem: Lunch
    var afternoonSnack: Snack
    var dinner: Dinner
    var eveningSnack: Snack?
    var addOn: AddOn?
    var meds: Medicine?
    var activity: Activity?
    var note: Note?
    
    init()
    {
        breakfastChoice = Breakfast()
        lunchItem = Lunch()
        dinner = Dinner()
        date = NSDate()
        afternoonSnack = Snack()
    }
    convenience init(itemTitle: String){
        self.init()
        title = itemTitle
    }
    
    func accept(journalItemVisitor: JournalEntryItemVisitor){
        journalItemVisitor.visit(self)
    }

}

class NamedMeal {
    var title = ""
    
    var breakfastChoice: Breakfast?
    var morningSnack: Snack?
    var lunchItem: Lunch?
    var afternoonSnack: Snack?
    var dinner: Dinner?
    var eveningSnack: Snack?
    var addOns: [AddOn]?
    
}

class BreakfastItems: DetailDisplayItem {
    var item: Breakfast?
    var breakfastChoice = [AnyObject]()
    var fruit = [AnyObject]()
    var mealDetails = [AnyObject]()
    var headerTitles: [String]
    var itemSelectedHeaderTitles: [String]
    
    
    
    init( breakfastItem: Breakfast?,
        headerTitles: [String] ,
        itemSelectedHeaderTitles: [String] ,
        breakfastChoice: [FoodItem],
        fruitChoice: [FoodItem],
        mealDetails: [AnyObject])
    {
        item = breakfastItem
        self.breakfastChoice = breakfastChoice
        self.fruit = fruitChoice
        self.headerTitles = headerTitles
        self.itemSelectedHeaderTitles = itemSelectedHeaderTitles
        self.mealDetails = mealDetails
        
//        otherItems = [ Person(firstName: "test", lastName: "placeholder", nicName: "placeholder"), Place(),
//        Time() ]
    }
    
}

class LunchItems: DetailDisplayItem  {
    var item: Lunch?
    var lunchChoice: [FoodItem]
    var fruitChoice: [FoodItem]
    
    var mealDetails: [AnyObject]
    var headerTitles: [String]
    var itemSelectedHeaderTitles: [String]
    
    init( item: Lunch?,
        headerTitles: [String] ,
        itemSelectedHeaderTitles: [String],
        lunchChoice: [FoodItem],
        fruitChoice: [FoodItem],
        mealDetails: [AnyObject])
    {
        self.item = item
        self.lunchChoice = lunchChoice
        self.fruitChoice = fruitChoice
        self.headerTitles = headerTitles
        self.itemSelectedHeaderTitles = itemSelectedHeaderTitles
        self.mealDetails = mealDetails
    }

}

// super class used in passing data to display in Track detail view
@objc protocol DetailDisplayItem {
    

}


class  DinnerItems: DetailDisplayItem {
    var dinnerItem: Dinner
    var meat: [FoodItem]
    var starch: [FoodItem]
    var oil: [FoodItem]
    var vegetable: [FoodItem]
    var requiredItems: [FoodItem]
    
    var mealDetails: [AnyObject]
    var headerTitles: [String]
    var itemSelectedHeaderTitles: [String]

    init( dinnerItem: Dinner,
        headerTitles: [String] ,
        itemSelectedHeaderTitles: [String],
        meat: [FoodItem],
        starch: [FoodItem],
        oil: [FoodItem],
        vegetable: [FoodItem],
        requiredItems: [FoodItem],
        mealDetails: [AnyObject])
        
    {
        self.dinnerItem = dinnerItem
        self.meat = meat
        self.starch = starch
        self.oil = oil
        self.vegetable = vegetable
        self.requiredItems = requiredItems
        self.headerTitles = headerTitles
        self.itemSelectedHeaderTitles = itemSelectedHeaderTitles
        self.mealDetails = mealDetails
    }
}


class Person: NSObject {
    var firstName: String = ""
    var lastName: String = ""
    var nicName: String = ""
    
    
    
    init( firstName: String, lastName: String, nicName: String){
        self.firstName = firstName
        self.lastName = lastName
        self.nicName = nicName
    }
}
class PatientProfile {
    //TODO:  add firstname, lastName nicName fields
    
    var patientName: Person!
    var parents: [Person] = []
    
    var treatmentPhase: TreatmentPhase = TreatmentPhase.DTU
    
    var medicines: [Medicine]? = []
    var activity: Activity?
    
    var addOns: [AddOn]?
    
    //named Meals
    
    init(){
        var person = Person(firstName: "Hannah", lastName: "Doe", nicName: "")
        patientName = person
        
        var father = Person(firstName: "John", lastName: "Doe", nicName: "J.D.")
        var mother = Person(firstName: "Jane", lastName: "Doe", nicName: "")
        parents = [mother, father]
        
        
    }
    
}

enum TreatmentPhase: Int{
    /*
    Used to autofill meal requirements when in DTU and IOP options
    */
    case DTU
    case IOP
    case OutpatientCounseling
    case PostGraduation
}

enum MealEntryState {
    case Empty
    case Incomplete
    case Complete
    //case NotRequired
}

enum nonMealItemState {

    case Incomplete
    case Complete
    case NotRequired
 
}

// There is a collection of these objects in profile
class Medicine: DetailDisplayItem, MenuDisplayCell {
    var name:String = ""
    var dose:String = ""
    var instructions:String = ""
    var didTakeMedsForDay: Bool = false
    
    //MenuDisplayCell properties
    var menuDisplayName: String
    //this property can be nil, since it is not applicable to all menu items
    var mealEntryState: MealEntryState!

    init()
    {
        menuDisplayName = "Medicines"
        mealEntryState = MealEntryState.Empty
    }
}

/*
JournalEntryItem
func accept(journalItemVisitor: JournalEntryItemVisitor)
*/

class Activity: DetailDisplayItem, MenuDisplayCell, JournalEntryItem {
    var location: String?
    var description: String = ""
    var didPerscribedActivityForDay = false
    var supervisedBy: Person?
    
    var menuDisplayName: String
    //this property can be nil, since it is not applicable to all menu items
    var mealEntryState: MealEntryState!
    
    init()
    {
        menuDisplayName = "Activity Log"
        mealEntryState = MealEntryState.Empty
    }
    
    func accept(journalItemVisitor: JournalEntryItemVisitor){
        journalItemVisitor.visit(self)
    }

}

class AddOn: JournalEntryItem{
    //Add-ons are added to meals or snacks, so store weak reference to avoid strong reference cycle issues
    var addOnItem: String = ""
    var instructions: String = ""
    //TODO: Is an AddOn really a Meal item or just a child of a meal item
    weak var parentMealItem: MealItem!
    var wasConsumed: Bool?
    
    func accept(journalItemVisitor: JournalEntryItemVisitor){
        journalItemVisitor.visit(self)
    }

}

class MealItem: MenuDisplayCell {
    var time: Time?
    var place: Place?
    var note: Note?
    var addons: [AddOn]?
    
    var parentInitials: Person?
    
    // store users name here, not sure where this gets displayed...
    var namedMealName: String?
    
    var menuDisplayName: String
    //this property can be nil, since it is not applicable to all menu items
    var mealEntryState: MealEntryState!

    //var isComplete: Bool?
    //var specialCircumstance: SpecialCircumstance?
    
    init(){
        menuDisplayName = ""
        mealEntryState = nil
    }
}

class Time {
    var mealTime: NSDate?
    init(){
        
    }
}
class Place {
    var mealLocation: String?
    init()
    {
        
    }
    
}
class ParentInitials {
    var initialsArray: [String]
    init(initialsArray: [
        String] )
    {
        self.initialsArray  = initialsArray
    }
}

class Note {
    var text: String?
    init(){        
    }
}

class Snack: MealItem, DetailDisplayItem , JournalEntryItem {
    var snack: FoodItem?
    override init()
    {
        super.init()
        menuDisplayName = "Snack"
        mealEntryState = MealEntryState.Empty
    }
    func accept(journalItemVisitor: JournalEntryItemVisitor){
        journalItemVisitor.visit(self)
    }

}


class Breakfast: MealItem , JournalEntryItem{
    var foodChoice: FoodItem?
    var fruitChoice: FoodItem?
    
    override init()
    {
        super.init()
        menuDisplayName = "Breakfast"
        mealEntryState = MealEntryState.Empty
    }
    func accept(journalItemVisitor: JournalEntryItemVisitor){
        journalItemVisitor.visit(self)
    }

}

class Lunch : MealItem, JournalEntryItem{
    var meatChoice: FoodItem?
    var fruitChoice: FoodItem?
    //var mealEntryState: MealEntryState = MealEntryState.Empty
    override init()
    {
        super.init()
        menuDisplayName = "Lunch"
        mealEntryState = MealEntryState.Empty
    }
    func accept(journalItemVisitor: JournalEntryItemVisitor){
        journalItemVisitor.visit(self)
    }

}

class Dinner: MealItem, JournalEntryItem{
    
    //var kartiniRecipe: String?
    var meat: FoodItem?
    var starch: FoodItem?
    var oil: FoodItem?
    var vegetable: FoodItem?
    var requiredItems: FoodItem?
    var mealDetails: FoodItem?
    
    override init()
    {
        super.init()
        menuDisplayName = "Dinner"
        mealEntryState = MealEntryState.Empty
    }
    func accept(journalItemVisitor: JournalEntryItemVisitor){
        journalItemVisitor.visit(self)
    }

}

struct KartiniRecipe {
    let recipes: [String] = [
        "Baked Chicken with Rice",
        "Baked Fish with Rice",
        "Baked Fish",
        "Black Beans and Rice",
        "Bento",
        "Black Bean & Corn Salad with Thai Dressing",
        "Breakfast Burrito",
        "Ceasar Salad",
        "Chicken & White Bean Salad",
        "Chicken Pasta Salad",
        "Chicken Stew",
        "Chicken Yakisoba",
        "Creamy Cajun Chicken Pasta",
        "Garilic Pasta with Shrimp",
        "Egg Scramble",
        "Fajita Burrito",
        "Farmer's Breakfast Skillet",
        "Fettuccine Alfredo",
        "Greek Gyro",
        "Grilled Steak with Pepper Relish",
        "Indian Ground Turkey",
        "Lebanese Kabobs",
        "Malaysian Barbeque-glazed Salmon",
        "Nicoise Salad",
        "Pan-seared Halibut",
        "Pasta Primavera with Meat",
        "Pizza",
        "Roasted Fish with Mushroom, Leek, Arugula",
        "Salmon & Roast Vegetable Salad",
        "Sausage and Zucchini Italiano",
        "Sesame Chicken Noodle Salad",
        "Sesame Orange Shrimp",
        "Soft Taco",
        "Stir Fry & Fried Rice",
        "Taco Salad",
        "Thai Chicken and Mango Stir-fry",
        "Toasted APita & Bean Salad"
    ]
}





class ApprovedLunchItem {
    var recipeName: String = ""
    var foodItem: FoodItem?
}

class ApprovedDinnerItem {
    var recipeName: String = ""
    var foodItem: FoodItem?
}
class SpecialCircumstance {
    var note: String!
    init( noteText: String){
        note = noteText
    }
}

class Serving: NSObject {
    var measurement: Double = 0.0
    var unit: String = ""
    var servingDescription: String = ""
}

class FoodItem {
    var name = ""
    var itemDescription = ""
    var serving: Serving = Serving()
    var menuItemType = ""
}

class FoodItemWithChoice: FoodItem {
    var choiceItems = [FoodItem]()
    
}

