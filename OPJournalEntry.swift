//
//  OPJournalEntry.swift
//  GRPatienLogAndPlan
//
//  Created by James Klein on 5/27/15.
//  Copyright (c) 2015 ObjectPrism Corp. All rights reserved.
//

import Foundation
import CoreData

class OPJournalEntry: NSManagedObject {

    @NSManaged var date: NSDate
    @NSManaged var afternoonSnack: OPAfternoonSnack
    @NSManaged var breakfast: OPBreakfast
    @NSManaged var dinner: OPDinner
    @NSManaged var eveningSnack: OPEveningSnack
    @NSManaged var lunch: OPLunch
    @NSManaged var morningSnack: OPMorningSnack
    @NSManaged var patientRecord: OPPatientRecord

}
