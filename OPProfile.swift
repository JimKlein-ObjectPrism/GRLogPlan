//
//  OPProfile.swift
//  
//
//  Created by James Klein on 6/9/15.
//
//

import Foundation
import CoreData
@objc(OPProfile)
public class OPProfile: NSManagedObject {

    @NSManaged var eveningSnackRequired: NSNumber
    @NSManaged var firstAndLastName: String!
    @NSManaged var morningSnackRequired: NSNumber
    @NSManaged var addOns: NSSet
    @NSManaged var medicineLIst: NSSet
    @NSManaged var parents: NSSet
    @NSManaged var patientRecord: OPPatientRecord

}
