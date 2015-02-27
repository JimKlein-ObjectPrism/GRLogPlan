//
//  DataTypes.swift
//  GRPatienLogAndPlan
//
//  Created by Jim Klein on 2/27/15.
//  Copyright (c) 2015 ObjectPrism Corp. All rights reserved.
//

import Foundation


//MARK: Journal Data Types
class JournalItem {
    var title = ""
    var date: NSDate?
    var friendlyDate = ""
    var isComplete = false
    
    var breakfastChoice: Breakfast?
    var morningSnack: Snack?
    var lunchItem: Lunch?
    var afternoonSnack: Snack?
    var dinner: Dinner?
    var meds: Medicine?
    var activity: Activity?
    
    init()
    {
        //super.init()
        breakfastChoice = Breakfast()
        //breakfastChoice?.foodChoice  =  BreakfastFoodChoice.CerealMilkEggs
        
    }
    convenience init(itemTitle: String){
        self.init()
        title = itemTitle
        
    }
    
}

class person: NSObject {
    var firstName: String = ""
    var lastName: String = ""
    var nicName: String = ""
}
class PatientProfile {
    
    var treatmentPhase: TreatmentPhase = TreatmentPhase.DTU
    
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


// There is a collection of these objects in profile
class Medicine {
    var name:String = ""
    var dose:String = ""
    var instructions:String = ""
    var didTakeMedsForDay: Bool = false
}

class Activity {
    var description:String = ""
    var didPerscribedActivityForDay = false
}

class AddOn {
    var addOnItem: String = ""
}

class MealItem {
    var time: Time?
    var place: Place?
    var note: Note?
    
    var isComplete: Bool?
    var specialCircumstance: SpecialCircumstance?
    
    init(){
        
    }
}

class Time {
    var mealTime: NSDate?
}
class Place {
    var breadChoice: String?
}

class Snack: MealItem {
    var breadChoice: String?
}

class Note {
    var text: String?
}

class Breakfast: MealItem {
    var foodChoice: FoodItem?
    var fruitChoice: FoodItem?
    //    init(){
    //        super.init()
    //    }
    
}

class Lunch : MealItem{
    var meatChoice: FoodItem?
    var fruitChoice: FoodItem?
}

class Dinner: MealItem{
    var kartiniRecipe: String?
    var namedDinner: FoodItem?
    var breadChoice: FoodItem?
    var fruitChoice: FoodItem?
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

class FoodItemWithChoices: FoodItem {
    var choiceItems = [FoodItem]()
    
}

