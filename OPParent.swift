//
//  OPParent.swift
//  GRPatienLogAndPlan
//
//  Created by James Klein on 5/27/15.
//  Copyright (c) 2015 ObjectPrism Corp. All rights reserved.
//

import Foundation
import CoreData
@objc(OPParent)
public class OPParent: NSManagedObject {

    @NSManaged public var firstName: String
    @NSManaged public var lastName: String
    @NSManaged public var profile: OPProfile

}
