//
//  OPAddOn.swift
//  
//
//  Created by James Klein on 6/2/15.
//
//

import Foundation
import CoreData
@objc(OPAddOn)
public class OPAddOn: NSManagedObject {

    @NSManaged var addOnItem: NSNumber
    @NSManaged var targetMealOrSnack: NSNumber
    @NSManaged var profile: OPProfile

}
