//
//  OPMedicine.swift
//  
//
//  Created by James Klein on 6/2/15.
//
//

import Foundation
import CoreData
@objc(OPMedicine)
public class OPMedicine: NSManagedObject {

    @NSManaged public var name: NSNumber
    @NSManaged public var targetTimePeriodToTake: NSNumber
    @NSManaged public var profile: OPProfile

}
