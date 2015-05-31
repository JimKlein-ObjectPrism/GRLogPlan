//
//  OPMedicine.swift
//  GRPatienLogAndPlan
//
//  Created by James Klein on 5/27/15.
//  Copyright (c) 2015 ObjectPrism Corp. All rights reserved.
//

import Foundation
import CoreData
@objc(OPMedicine)
class OPMedicine: NSManagedObject {

    @NSManaged var targetTimePeriodToTake: NSNumber
    @NSManaged var name: String
    @NSManaged var profile: OPProfile

}
