//
//  OPLunch.swift
//  GRPatienLogAndPlan
//
//  Created by James Klein on 5/27/15.
//  Copyright (c) 2015 ObjectPrism Corp. All rights reserved.
//

import Foundation
import CoreData

class OPLunch: NSManagedObject {

    @NSManaged var addOnRequired: NSNumber
    @NSManaged var fruitChoice: String
    @NSManaged var lunchChoice: String
    @NSManaged var note: String
    @NSManaged var parentInitials: String
    @NSManaged var location: String
    @NSManaged var time: NSDate
    @NSManaged var addOnConsumed: NSNumber
    @NSManaged var addOnText: String
    @NSManaged var medicineRquired: NSNumber
    @NSManaged var medicineText: String
    @NSManaged var medicineConsumed: NSNumber
    @NSManaged var journalEntry: OPJournalEntry

}
