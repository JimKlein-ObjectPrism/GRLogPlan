//
//  OPAfternoonSnack.swift
//  GRPatienLogAndPlan
//
//  Created by James Klein on 5/27/15.
//  Copyright (c) 2015 ObjectPrism Corp. All rights reserved.
//

import Foundation
import CoreData

class OPAfternoonSnack: NSManagedObject {

    @NSManaged var snackChoice: String
    @NSManaged var parentInitials: String
    @NSManaged var location: String
    @NSManaged var time: NSDate
    @NSManaged var fruitChoice: String
    @NSManaged var note: String
    @NSManaged var addOnRequired: NSNumber
    @NSManaged var addOnConsumed: NSNumber
    @NSManaged var addOnText: String
    @NSManaged var medicineRequired: NSNumber
    @NSManaged var medicineConsumed: NSNumber
    @NSManaged var medicineText: String
    @NSManaged var journalEntry: OPJournalEntry

}
