//
//  OPActivity.swift
//  GRPatienLogAndPlan
//
//  Created by James Klein on 5/27/15.
//  Copyright (c) 2015 ObjectPrism Corp. All rights reserved.
//

import Foundation
import CoreData
@objc(OPActivity)
class OPActivity: NSManagedObject {

    @NSManaged var activityDescription: String
    @NSManaged var completedPerscribedActivityForDay: NSNumber
    @NSManaged var location: String
    @NSManaged var supervisedBy: String

}
