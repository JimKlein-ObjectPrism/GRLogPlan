//
//  MenuCatagories.swift
//  GRPatienLogAndPlan
//
//  Created by James Klein on 6/5/15.
//  Copyright (c) 2015 ObjectPrism Corp. All rights reserved.
//

import Foundation

public struct MenuCategoryEnumHelper {
    public static func matchAddOnPrescribedTime(mealOrSnackName: String, profile: OPProfile) -> (isMatch: Bool, addOnName: String) {
        //case for add on is simpler because only one add on allowed per meal
        var addOnName = ""
        for o in profile.addOns  {
            if let addOn = o as? OPAddOn {
                let pTime = PrescribedTimeForAction(rawValue: addOn.targetMealOrSnack.integerValue)!
                switch pTime {
                case PrescribedTimeForAction.BreakfastTime:
                    if mealOrSnackName == pTime.name() {
                        return (true, AddOnListItem(rawValue: addOn.addOnItem.integerValue)!.name)
                    }
                case .MorningSnack:
                    if mealOrSnackName == pTime.name() {
                        return (true, AddOnListItem(rawValue: addOn.addOnItem.integerValue)!.name)
                    }
                case .LunchTime:
                    if mealOrSnackName == pTime.name() {
                        return (true, AddOnListItem(rawValue: addOn.addOnItem.integerValue)!.name)
                    }
                case .AfternoonSnack:
                    if mealOrSnackName == pTime.name() {
                        return (true, AddOnListItem(rawValue: addOn.addOnItem.integerValue)!.name)
                    }
                case .DinnerTime:
                    if mealOrSnackName == pTime.name() {
                        return (true, AddOnListItem(rawValue: addOn.addOnItem.integerValue)!.name)
                    }
                case .EveningSnack:
                    if mealOrSnackName == pTime.name() {
                        return (true, AddOnListItem(rawValue: addOn.addOnItem.integerValue)!.name)
                    }
                }
            }
        }
        return (false, addOnName)
    }
    public static func matchMedicinePrescribedTime(mealOrSnackName: String, profile: OPProfile) -> (isMatch: Bool, medicineName: String) {
        var isMatch = false
        var medicineNameText = ""
        
        func setValues (timeForAction: Int) {
            isMatch = true
            if medicineNameText == "" {
                medicineNameText = Medicines(rawValue: timeForAction)!.name
            } else {
                medicineNameText = medicineNameText + ", " + Medicines(rawValue: timeForAction)!.name
            }

        }
        
        for o in profile.medicineLIst  {
            var medicineText = ""
            if let item = o as? OPMedicine {
                let pTime = PrescribedTimeForAction(rawValue: item.targetTimePeriodToTake.integerValue)!
                switch pTime {
                case PrescribedTimeForAction.BreakfastTime:
                    if mealOrSnackName == pTime.name() {
                        setValues(item.name.integerValue)
                     }
                case .MorningSnack:
                    if mealOrSnackName == pTime.name() {
                        setValues(item.name.integerValue)
                    }
                case .LunchTime:
                    if mealOrSnackName == pTime.name() {
                        setValues(item.name.integerValue)
                    }
                case .AfternoonSnack:
                    if mealOrSnackName == pTime.name() {
                        setValues(item.name.integerValue)
                    }
                case .DinnerTime:
                    if mealOrSnackName == pTime.name() {
                        setValues(item.name.integerValue)
                    }
                case .EveningSnack:
                    if mealOrSnackName == pTime.name() {
                        setValues(item.name.integerValue)
                    }
                }//end switch
            }//end if let
            

        }//end for
        return (isMatch, medicineNameText)
    }

}
public enum BreakfastMenuCategory {
    case FoodChoice,
    Fruit,
    Medicine,
    AddOn,
    AdditionalInfo
    
    public static var caseItems: [BreakfastMenuCategory] = [BreakfastMenuCategory]()
    
    public static func count() -> Int { return caseItems.count }
    
    public static func configureMenuChoice(profile: OPProfile, inout journalEntry: OPJournalEntry){
        caseItems.removeAll(keepCapacity: false)
        caseItems.append(BreakfastMenuCategory.FoodChoice)
        caseItems.append(BreakfastMenuCategory.Fruit)
        let addOnMatch = MenuCategoryEnumHelper.matchAddOnPrescribedTime("Breakfast", profile: profile)
        if addOnMatch.isMatch {
            caseItems.append(BreakfastMenuCategory.AddOn)
            journalEntry.breakfast.addOnRequired = true
            journalEntry.breakfast.addOnText = addOnMatch.addOnName

        } else {
            //append no item
        }
        
        
        let medicineMatch = MenuCategoryEnumHelper.matchMedicinePrescribedTime("Breakfast", profile: profile)
        if medicineMatch.isMatch {
            //if the profile contains a medicine, then add enum item, and set isRequired and medicineName fields in the meal object
            caseItems.append(.Medicine)
            journalEntry.breakfast.medicineRequired = true
            journalEntry.breakfast.medicineText = medicineMatch.medicineName
        }
        caseItems.append(.AdditionalInfo)
    }
    
    public init?(value: Int){
        //fail if index out of bounds
        if value >= BreakfastMenuCategory.caseItems.count || value < 0 { return nil }
        self = BreakfastMenuCategory.caseItems[value]
    }
    
    public func unselectedHeaderTitle() -> String {
        switch self {
        case .FoodChoice:
            return "Breakfast Item"
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
//public struct MorningSnackMenuCategory {
//    let snackMenuCategory: SnackMenuCategory?
//    
//    //mimic enum failable initializer in enum
//    public init(value: Int) {
//        snackMenuCategory = SnackMenuCategory(value: value)
//    }
//    
//    public static var caseItems: [SnackMenuCategory] = [SnackMenuCategory]()
//    
//    public static func count() -> Int { return caseItems.count }
//    
//    public static func configureMenuChoice(profile: OPProfile, journalEntry: OPJournalEntry){
//        caseItems.removeAll(keepCapacity: false)
//        caseItems.append(.SnackChoice)
//        caseItems.append(.Fruit)
//        
//        let addOnMatch = MenuCategoryEnumHelper.matchAddOnPrescribedTime("Dinner", profile: profile)
//        if addOnMatch.isMatch {
//            caseItems.append(.AddOn)
//            journalEntry.dinner.addOnRequired = true
//            journalEntry.dinner.addOnText = addOnMatch.addOnName
//        }
//        
//        let medicineMatch = MenuCategoryEnumHelper.matchMedicinePrescribedTime("Dinner", profile: profile)
//        if medicineMatch.isMatch {
//            //if the profile contains a medicine, then add enum item, and set isRequired and medicineName fields in the meal object
//            caseItems.append(.Medicine)
//            journalEntry.dinner.medicineRequired = true
//            journalEntry.dinner.medicineText = medicineMatch.medicineName
//        }
//        caseItems.append(.AdditionalInfo)
//    }
//
//}

public enum SnackMenuCategory {
    case SnackChoice,
    //Fruit,
    Medicine,
    AddOn,
    AdditionalInfo
    
    public static var morningSnackCaseItems: [SnackMenuCategory] = [SnackMenuCategory]()
    public static var afternoonSnackCaseItems: [SnackMenuCategory] = [SnackMenuCategory]()
    public static var eveningSnackCaseItems: [SnackMenuCategory] = [SnackMenuCategory]()
    //public static var caseItems: [SnackMenuCategory] = [SnackMenuCategory]()
    
    public static func count(snackTime: SnackTime) -> Int {
        switch snackTime {
        case .Morning:
            return morningSnackCaseItems.count
        case .Afternoon:
            return afternoonSnackCaseItems.count
        case .Evening:
            return eveningSnackCaseItems.count
        }
        
    }
    
    public static func configureMenuChoice(profile: OPProfile, journalEntry: OPJournalEntry){
        func configureMorningSnackMenuChoice(profile: OPProfile, journalEntry: OPJournalEntry){
            if profile.morningSnackRequired.boolValue {
                morningSnackCaseItems.removeAll(keepCapacity: false)
                
                morningSnackCaseItems.append(.SnackChoice)
                //morningSnackCaseItems.append(.Fruit)
                
                let addOnMatch = MenuCategoryEnumHelper.matchAddOnPrescribedTime("Morning Snack", profile: profile)
                if addOnMatch.isMatch {
                    morningSnackCaseItems.append(.AddOn)
                    journalEntry.morningSnack.addOnRequired = true
                    journalEntry.morningSnack.addOnText = addOnMatch.addOnName
                }
                
                let medicineMatch = MenuCategoryEnumHelper.matchMedicinePrescribedTime("Morning Snack", profile: profile)
                if medicineMatch.isMatch {
                    //if the profile contains a medicine, then add enum item, and set isRequired and medicineName fields in the meal object
                    morningSnackCaseItems.append(.Medicine)
                    journalEntry.morningSnack.medicineRequired = true
                    journalEntry.morningSnack.medicineText = medicineMatch.medicineName
                }
                morningSnackCaseItems.append(.AdditionalInfo)
            }
        }
        func configureAfternoonSnackMenuChoice(profile: OPProfile, journalEntry: OPJournalEntry){
            afternoonSnackCaseItems.removeAll(keepCapacity: false)
            
            afternoonSnackCaseItems.append(.SnackChoice)
            //afternoonSnackCaseItems.append(.Fruit)
            
            let addOnMatch = MenuCategoryEnumHelper.matchAddOnPrescribedTime("Afternoon Snack", profile: profile)
            if addOnMatch.isMatch {
                afternoonSnackCaseItems.append(.AddOn)
                journalEntry.afternoonSnack.addOnRequired = true
                journalEntry.afternoonSnack.addOnText = addOnMatch.addOnName
            }
            
            let medicineMatch = MenuCategoryEnumHelper.matchMedicinePrescribedTime("Afternoon Snack", profile: profile)
            if medicineMatch.isMatch {
                //if the profile contains a medicine, then add enum item, and set isRequired and medicineName fields in the meal object
                afternoonSnackCaseItems.append(.Medicine)
                journalEntry.afternoonSnack.medicineRequired = true
                journalEntry.afternoonSnack.medicineText = medicineMatch.medicineName
            }
            afternoonSnackCaseItems.append(.AdditionalInfo)

        }
        func configureEveningSnackMenuChoice(profile: OPProfile, journalEntry: OPJournalEntry){
            if profile.eveningSnackRequired.boolValue {
                if profile.morningSnackRequired.boolValue {
                    eveningSnackCaseItems.removeAll(keepCapacity: false)
                    
                    eveningSnackCaseItems.append(.SnackChoice)
                    //eveningSnackCaseItems.append(.Fruit)
                    
                    let addOnMatch = MenuCategoryEnumHelper.matchAddOnPrescribedTime("Evening Snack", profile: profile)
                    if addOnMatch.isMatch {
                        eveningSnackCaseItems.append(.AddOn)
                        journalEntry.eveningSnack.addOnRequired = true
                        journalEntry.eveningSnack.addOnText = addOnMatch.addOnName
                    }
                    
                    let medicineMatch = MenuCategoryEnumHelper.matchMedicinePrescribedTime("Evening Snack", profile: profile)
                    if medicineMatch.isMatch {
                        //if the profile contains a medicine, then add enum item, and set isRequired and medicineName fields in the meal object
                        eveningSnackCaseItems.append(.Medicine)
                        journalEntry.eveningSnack.medicineRequired = true
                        journalEntry.eveningSnack.medicineText = medicineMatch.medicineName
                    }
                    eveningSnackCaseItems.append(.AdditionalInfo)
                }
            }
        }
        configureMorningSnackMenuChoice(profile, journalEntry)
        configureAfternoonSnackMenuChoice(profile, journalEntry)
        configureEveningSnackMenuChoice(profile, journalEntry)
        
//        caseItems.removeAll(keepCapacity: false)
//        
//        caseItems.append(.SnackChoice)
//        caseItems.append(.Fruit)
//        
//        let addOnMatch = MenuCategoryEnumHelper.matchAddOnPrescribedTime("Dinner", profile: profile)
//        if addOnMatch.isMatch {
//            caseItems.append(.AddOn)
//            journalEntry.dinner.addOnRequired = true
//            journalEntry.dinner.addOnText = addOnMatch.addOnName
//        }
//        
//        let medicineMatch = MenuCategoryEnumHelper.matchMedicinePrescribedTime("Dinner", profile: profile)
//        if medicineMatch.isMatch {
//            //if the profile contains a medicine, then add enum item, and set isRequired and medicineName fields in the meal object
//            caseItems.append(.Medicine)
//            journalEntry.dinner.medicineRequired = true
//            journalEntry.dinner.medicineText = medicineMatch.medicineName
//        }
//        caseItems.append(.AdditionalInfo)
    }
    
    public init?(value: Int, snackTime: SnackTime){
        
        switch snackTime{
        case .Morning:
            //fail if index out of bounds
            if value >= SnackMenuCategory.morningSnackCaseItems.count || value < 0 { return nil }
            self = SnackMenuCategory.morningSnackCaseItems[value]
        case .Afternoon:
            //fail if index out of bounds
            if value >= SnackMenuCategory.afternoonSnackCaseItems.count || value < 0 { return nil }
            self = SnackMenuCategory.afternoonSnackCaseItems[value]
        case .Evening:
            //fail if index out of bounds
            if value >= SnackMenuCategory.eveningSnackCaseItems.count || value < 0 { return nil }
            self = SnackMenuCategory.eveningSnackCaseItems[value]
        }
        
    }
    
    public func unselectedHeaderTitle() -> String {
        switch self {
        case .SnackChoice:
            return "Snack Choice"
//        case .Fruit:
//            return "Fruit Choice"
        case .Medicine:
            return "Medicine"
        case .AddOn:
            return "Add On"
        case .AdditionalInfo:
            return "Additional Information"
        }
    }
}

public enum LunchMenuCategory {
    case LunchChoice,
    Fruit,
    Medicine,
    AddOn,
    AdditionalInfo
    
    public static var caseItems: [LunchMenuCategory] = [LunchMenuCategory]()
    
    public static func count() -> Int { return caseItems.count }
    
    public static func configureMenuChoice(profile: OPProfile, inout journalEntry: OPJournalEntry){
        caseItems.removeAll(keepCapacity: false)
        caseItems.append(LunchMenuCategory.LunchChoice)
        caseItems.append(LunchMenuCategory.Fruit)
        let addOnMatch = MenuCategoryEnumHelper.matchAddOnPrescribedTime("Lunch", profile: profile)
        if addOnMatch.isMatch {
            caseItems.append(.AddOn)
            journalEntry.lunch.addOnRequired = true
            journalEntry.lunch.addOnText = addOnMatch.addOnName
        }
        
        let medicineMatch = MenuCategoryEnumHelper.matchMedicinePrescribedTime("Lunch", profile: profile)
        if medicineMatch.isMatch {
            //if the profile contains a medicine, then add enum item, and set isRequired and medicineName fields in the meal object
            caseItems.append(.Medicine)
            journalEntry.lunch.medicineRquired = true
            journalEntry.lunch.medicineText = medicineMatch.medicineName
        }
        caseItems.append(.AdditionalInfo)
    }
    
    public init?(value: Int){
        //fail if index out of bounds
        if value >= LunchMenuCategory.caseItems.count || value < 0 { return nil }
        self = LunchMenuCategory.caseItems[value]
    }
    
    public func unselectedHeaderTitle() -> String {
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


public enum DinnerMenuCategory {
    case Meat,
    Starch,
    Oil,
    Vegetable,
    RequiredItems,
    
    Medicine,
    AddOn,
    AdditionalInfo
    
    public static var caseItems: [DinnerMenuCategory] = [DinnerMenuCategory]()
    
    public static func count() -> Int { return caseItems.count }
    
    public static func configureMenuChoice(profile: OPProfile,  inout journalEntry: OPJournalEntry){
        caseItems.removeAll(keepCapacity: false)
        caseItems.append(DinnerMenuCategory.Meat)
        caseItems.append(DinnerMenuCategory.Starch)
        caseItems.append(DinnerMenuCategory.Oil)
        caseItems.append(DinnerMenuCategory.Vegetable)
        caseItems.append(DinnerMenuCategory.RequiredItems)
        
        let addOnMatch = MenuCategoryEnumHelper.matchAddOnPrescribedTime("Dinner", profile: profile)
        if addOnMatch.isMatch {
            caseItems.append(.AddOn)
            journalEntry.dinner.addOnRequired = true
            journalEntry.dinner.addOnText = addOnMatch.addOnName
        }
        
        let medicineMatch = MenuCategoryEnumHelper.matchMedicinePrescribedTime("Dinner", profile: profile)
        if medicineMatch.isMatch {
            //if the profile contains a medicine, then add enum item, and set isRequired and medicineName fields in the meal object
            caseItems.append(.Medicine)
            journalEntry.dinner.medicineRequired = true
            journalEntry.dinner.medicineText = medicineMatch.medicineName
        }
        caseItems.append(.AdditionalInfo)
    }
    
    public init?(value: Int){
        //fail if index out of bounds
        if value >= DinnerMenuCategory.caseItems.count || value < 0 { return nil }
        self = DinnerMenuCategory.caseItems[value]
    }
    
    public func unselectedHeaderTitle() -> String {
        switch self {
        case .Meat:
            return "Choose one"
        case .Starch:
            return "Choose one"
        case .Oil:
            return "Choose one"
        case .Vegetable:
            return "Choose one"
        case .RequiredItems:
            return "Required Items"
            
        case .Medicine:
            return "Medicine"
        case .AddOn:
            return "Add On"
        case .AdditionalInfo:
            return "Additional Information"
        }
    }
}
