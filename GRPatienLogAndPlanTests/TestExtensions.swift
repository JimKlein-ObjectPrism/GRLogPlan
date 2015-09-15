//
//  TestExtensions.swift
//  GRPatienLogAndPlan
//
//  Created by James Klein on 9/9/15.
//  Copyright (c) 2015 ObjectPrism Corp. All rights reserved.
//

import Foundation
import XCTest
import CoreData
import GRPatienLogAndPlan
extension XCTestCase {
    
    func setupMedicineAndAddOnDummyData ( profile: OPProfile,  dataStore: DataStore, coreDataStack: CoreDataStack) {
        //Medicine test setup
        //create new OPMedicine entity in the managed context
        let medicineEntity = NSEntityDescription.entityForName("OPMedicine",
            inManagedObjectContext: coreDataStack.context)
        
        var med: OPMedicine = OPMedicine(entity: medicineEntity!,
            insertIntoManagedObjectContext: coreDataStack.context)
        med.profile = profile
        med.name = 0
        
        med.targetTimePeriodToTake = 0
        
        //AddOn test setup
        //create new OPAddOn entity in the managed context
        let addOnEntity = NSEntityDescription.entityForName("OPAddOn",
            inManagedObjectContext: coreDataStack.context)
        
        var addOn: OPAddOn = OPAddOn(entity: addOnEntity!,
            insertIntoManagedObjectContext: coreDataStack.context)
        addOn.profile = profile
        addOn.addOnItem = NSNumber(integer: 0)
        
        addOn.targetMealOrSnack = NSNumber(integer: 0)

    }
}