//
//  OPProfile.swift
//  GRPatienLogAndPlan
//
//  Created by James Klein on 5/27/15.
//  Copyright (c) 2015 ObjectPrism Corp. All rights reserved.
//

import Foundation
import CoreData
@objc(OPProfile)
class OPProfile: NSManagedObject {

    @NSManaged var firstName: String
    @NSManaged var lastName: String
    @NSManaged var morningSnackRequired: NSNumber
    @NSManaged var eveningSnackRequired: NSNumber
    @NSManaged var addOns: NSSet
    @NSManaged var medicineLIst: NSSet
    @NSManaged var parents: NSSet
    @NSManaged var patientRecord: OPPatientRecord

}
