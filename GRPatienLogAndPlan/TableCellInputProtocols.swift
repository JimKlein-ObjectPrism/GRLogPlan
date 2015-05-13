//
//  TableCellInputProtocols.swift
//  GRPatienLogAndPlan
//
//  Created by James Klein on 5/13/15.
//  Copyright (c) 2015 ObjectPrism Corp. All rights reserved.
//

import Foundation

protocol ChoiceItemSelectedDelegate {
    func choiceItemSelectedHandler(childItemIndex: Int, indexPath: NSIndexPath)
}

protocol MedicineItemSelectedDelegate {
    func choiceItemSelectedHandler(medicineConsumed: Bool)
}
