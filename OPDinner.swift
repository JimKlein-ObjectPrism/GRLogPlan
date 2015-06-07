//
//  OPDinner.swift
//  
//
//  Created by James Klein on 6/6/15.
//
//

import Foundation
import CoreData

public class OPDinner: NSManagedObject {

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
    @NSManaged var addOnRequired: NSNumber
    @NSManaged var addOnText: String
    @NSManaged var addOnConsumed: NSNumber
    @NSManaged var medicineRequired: NSNumber
    @NSManaged var medicineConsumed: NSNumber
    @NSManaged var medicineText: String
    @NSManaged var journalEntry: OPJournalEntry

}
