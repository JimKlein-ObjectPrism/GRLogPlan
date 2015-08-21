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

    @NSManaged public var addOnItem: NSNumber
    @NSManaged public var targetMealOrSnack: NSNumber
    @NSManaged public var profile: OPProfile

}
