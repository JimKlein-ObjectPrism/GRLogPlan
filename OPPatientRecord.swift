//
//  OPPatientRecord.swift
//  GRPatienLogAndPlan
//
//  Created by James Klein on 5/27/15.
//  Copyright (c) 2015 ObjectPrism Corp. All rights reserved.
//

import Foundation
import CoreData

class OPPatientRecord: NSManagedObject {

    @NSManaged var journalEntries: NSOrderedSet
    @NSManaged var profile: OPProfile

}
