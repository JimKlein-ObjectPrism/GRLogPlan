//
//  OPBreakfast.swift
//  GRPatienLogAndPlan
//
//  Created by James Klein on 5/27/15.
//  Copyright (c) 2015 ObjectPrism Corp. All rights reserved.
//

import Foundation
import CoreData
@objc(OPBreakfast)
public class OPBreakfast: NSManagedObject {

    @NSManaged var fruitChoice: String?
    @NSManaged var foodChoice: String?
    @NSManaged var note: String?
    @NSManaged var parentInitials: String?
    @NSManaged var location: String?
    @NSManaged var time: NSDate?
    @NSManaged var addOnRequired: NSNumber
    @NSManaged var addOnText: String?
    @NSManaged var addOnConsumed: NSNumber?
    @NSManaged var medicineText: String?
    @NSManaged var medicineRequired: NSNumber
    @NSManaged var medicineConsumed: NSNumber?
    @NSManaged var journalEntry: OPJournalEntry

}
