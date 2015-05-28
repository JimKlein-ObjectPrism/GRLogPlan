//
//  OPDinner.swift
//  GRPatienLogAndPlan
//
//  Created by James Klein on 5/27/15.
//  Copyright (c) 2015 ObjectPrism Corp. All rights reserved.
//

import Foundation
import CoreData

class OPDinner: NSManagedObject {

    @NSManaged var clinicProvidedMeal: NSNumber
    @NSManaged var meat: String
    @NSManaged var note: String
    @NSManaged var oil: String
    @NSManaged var parentInitials: String
    @NSManaged var place: String
    @NSManaged var recipe: String
    @NSManaged var requiredItems: NSNumber
    @NSManaged var starch: String
    @NSManaged var time: NSDate
    @NSManaged var vegetable: String
    @NSManaged var journalEntry: OPJournalEntry

}
