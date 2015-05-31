//
//  OPJournalEntry.swift
//  GRPatienLogAndPlan
//
//  Created by James Klein on 5/28/15.
//  Copyright (c) 2015 ObjectPrism Corp. All rights reserved.
//

import Foundation
import CoreData
@objc(OPJournalEntry)
class OPJournalEntry: NSManagedObject {

    @NSManaged var date: String
    @NSManaged var afternoonSnack: OPAfternoonSnack
    @NSManaged var breakfast: OPBreakfast
    @NSManaged var dinner: OPDinner
    @NSManaged var eveningSnack: OPEveningSnack
    @NSManaged var lunch: OPLunch
    @NSManaged var morningSnack: OPMorningSnack
    @NSManaged var patientRecord: OPPatientRecord
    

}
