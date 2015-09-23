//
//  RegEx.swift
//  GRPatienLogAndPlan
//
//  Created by James Klein on 8/12/15.
//  Copyright (c) 2015 ObjectPrism Corp. All rights reserved.
//

import Foundation
import UIKit

class Regex {
    let internalExpression: NSRegularExpression
    let pattern: String
    
    init(_ pattern: String) {
        self.pattern = pattern
//        var error: NSError?
        self.internalExpression = try! NSRegularExpression(pattern: pattern, options: .CaseInsensitive)
    }
    
    func test(input: String) -> Bool {
        let matches = self.internalExpression.matchesInString(input, options: [], range:NSMakeRange(0, input.characters.count))
        return matches.count > 0
    }
}