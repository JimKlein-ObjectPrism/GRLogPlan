//
//  MenuCatagories.swift
//  GRPatienLogAndPlan
//
//  Created by James Klein on 6/5/15.
//  Copyright (c) 2015 ObjectPrism Corp. All rights reserved.
//

import Foundation


public enum BreakfastMenuCategory {
    case FoodChoice,
    Fruit,
    Medicine,
    AddOn,
    AdditionalInfo
    
    public static var caseItems: [BreakfastMenuCategory] = [BreakfastMenuCategory]()
    
    public static func count() -> Int { return caseItems.count }
    
    public static func configureMenuChoice(profile: TempProfile){
        caseItems.removeAll(keepCapacity: false)
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

public enum SnackMenuCategory {
    case SnackChoice,
    Fruit,
    Medicine,
    AddOn,
    AdditionalInfo
    
    public static var caseItems: [SnackMenuCategory] = [SnackMenuCategory]()
    
    public static func count() -> Int { return caseItems.count }
    
    public static func configureMenuChoice(profile: TempProfile){
        caseItems.removeAll(keepCapacity: false)
        caseItems.append(.SnackChoice)
        caseItems.append(.Fruit)
        if profile.medicineRequired {
            caseItems.append(.Medicine)
        }
        if profile.addOnRequired {
            caseItems.append(.AddOn)
        }
        caseItems.append(.AdditionalInfo)
    }
    
    public init?(value: Int){
        //fail if index out of bounds
        if value >= SnackMenuCategory.caseItems.count || value < 0 { return nil }
        self = SnackMenuCategory.caseItems[value]
    }
    
    public func unselectedHeaderTitle() -> String {
        switch self {
        case .SnackChoice:
            return "Snack Choice"
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

public enum LunchMenuCategory {
    case LunchChoice,
    Fruit,
    Medicine,
    AddOn,
    AdditionalInfo
    
    public static var caseItems: [LunchMenuCategory] = [LunchMenuCategory]()
    
    public static func count() -> Int { return caseItems.count }
    
    public static func configureMenuChoice(profile: TempProfile){
        caseItems.removeAll(keepCapacity: false)
        caseItems.append(LunchMenuCategory.LunchChoice)
        caseItems.append(LunchMenuCategory.Fruit)
        if profile.medicineRequired {
            caseItems.append(.Medicine)
        }
        if profile.addOnRequired {
            caseItems.append(.AddOn)
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
    
    public static func configureMenuChoice(profile: TempProfile){
        caseItems.removeAll(keepCapacity: false)
        caseItems.append(DinnerMenuCategory.Meat)
        caseItems.append(DinnerMenuCategory.Starch)
        caseItems.append(DinnerMenuCategory.Oil)
        caseItems.append(DinnerMenuCategory.Vegetable)
        caseItems.append(DinnerMenuCategory.RequiredItems)
        
        if profile.medicineRequired {
            caseItems.append(.Medicine)
        }
        if profile.addOnRequired {
            caseItems.append(.AddOn)
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
