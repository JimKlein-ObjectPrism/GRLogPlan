//
//  OPAfternoonSnack.swift
//  
//
//  Created by James Klein on 6/7/15.
//
//

import Foundation
import CoreData
@objc(OPAfternoonSnack)
public class OPAfternoonSnack: NSManagedObject {

    @NSManaged var addOnConsumed: NSNumber?
    @NSManaged var addOnRequired: NSNumber
    @NSManaged var addOnText: String?
    @NSManaged var fruitChoice: String?
    @NSManaged var location: String?
    @NSManaged var medicineConsumed: NSNumber?
    @NSManaged var medicineRequired: NSNumber
    @NSManaged var medicineText: String?
    @NSManaged var note: String?
    @NSManaged var parentInitials: String?
    @NSManaged var snackChoice: String?
    @NSManaged var time: String?
    @NSManaged var journalEntry: OPJournalEntry

}
