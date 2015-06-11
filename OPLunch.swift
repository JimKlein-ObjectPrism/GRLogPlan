//
//  OPLunch.swift
//  
//
//  Created by James Klein on 6/7/15.
//
//

import Foundation
import CoreData
@objc(OPLunch)
public class OPLunch: NSManagedObject {

    @NSManaged var addOnConsumed: NSNumber?
    @NSManaged var addOnRequired: NSNumber
    @NSManaged var addOnText: String?
    @NSManaged var fruitChoice: String?
    @NSManaged var location: String?
    @NSManaged var lunchChoice: String?
    @NSManaged var medicineConsumed: NSNumber?
    @NSManaged var medicineRquired: NSNumber
    @NSManaged var medicineText: String?
    @NSManaged var note: String?
    @NSManaged var parentInitials: String?
    @NSManaged var time: String?
    @NSManaged var journalEntry: OPJournalEntry

}
