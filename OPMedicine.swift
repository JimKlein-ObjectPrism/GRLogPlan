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

    @NSManaged var name: NSNumber
    @NSManaged var targetTimePeriodToTake: NSNumber
    @NSManaged var profile: OPProfile

}
