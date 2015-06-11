//
//  TableCellInputProtocols.swift
//  GRPatienLogAndPlan
//
//  Created by James Klein on 5/13/15.
//  Copyright (c) 2015 ObjectPrism Corp. All rights reserved.
//

import Foundation

//REFACTOR: Use single protocol with multiple method declarations?  

protocol ChoiceItemSelectedDelegate {
    func choiceItemSelectedHandler(childItemIndex: Int, indexPath: NSIndexPath)
}
protocol MedicineItemSelectedDelegate {
    func choiceItemSelectedHandler(medicineConsumed: Bool)
}
protocol RequiredItemsSelectedDelegate {
    func requiredItemSwitchSelectedHandler(requiredItemConsumed: Bool)
}
protocol AddOnItemSelectedDelegate {
    func addOnItemSelectedHandler(addOnConsumed: Bool)
}
protocol ParentInitialsSelectedDelegate {
    func parentInitialsSelectedHandler()
}
protocol LocationSelectedDelegate {
    func locationSelectedHandler()
}
protocol TimeSelectedDelegate {
    func timeSelectedHandler(selectedTime : NSDate)
}


