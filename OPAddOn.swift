//
//  OPAddOn.swift
//  GRPatienLogAndPlan
//
//  Created by James Klein on 5/27/15.
//  Copyright (c) 2015 ObjectPrism Corp. All rights reserved.
//

import Foundation
import CoreData

class OPAddOn: NSManagedObject {

    @NSManaged var targetMealOrSnack: NSNumber
    @NSManaged var addOnItem: String
    @NSManaged var profile: OPProfile

}
