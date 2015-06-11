//
//  OPDinner.swift
//  
//
//  Created by James Klein on 6/7/15.
//
//

import Foundation
import CoreData
@objc(OPDinner)
public class OPDinner: NSManagedObject {

    @NSManaged var addOnConsumed: NSNumber?
    @NSManaged var addOnRequired: NSNumber
    @NSManaged var addOnText: String?
    @NSManaged var clinicProvidedMeal: NSNumber?
    @NSManaged var meat: String?
    @NSManaged var medicineConsumed: NSNumber?
    @NSManaged var medicineRequired: NSNumber
    @NSManaged var medicineText: String?
    @NSManaged var note: String?
    @NSManaged var oil: String?
    @NSManaged var parentInitials: String?
    @NSManaged var place: String?
    @NSManaged var recipe: String?
    @NSManaged var requiredItems: NSNumber
    @NSManaged var starch: String?
    @NSManaged var time: String?
    @NSManaged var vegetable: String?
    @NSManaged var journalEntry: OPJournalEntry

}
