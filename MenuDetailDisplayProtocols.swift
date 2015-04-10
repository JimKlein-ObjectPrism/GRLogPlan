//
//  MenuDetailDisplayProtocols.swift
//  GRPatienLogAndPlan
//
//  Created by James Klein on 3/11/15.
//  Copyright (c) 2015 ObjectPrism Corp. All rights reserved.
//

import Foundation

protocol DetailItemSelectedDelegate {
    func detailItemSelectedHandler()
}

protocol UpdateDetailViewDelegate {
    func updateDetailViewHandler(detailItem: DetailDisplayItem)
}

protocol MenuItemSelectedDelegate {
    func menuItemSelectedHandler(menudisplayType: MenuDisplayCell)
}

protocol ChoiceItemSelectedDelegate {
    func choiceItemSelectedHandler(childItemIndex: Int, indexPathSection: Int, indexPathRow: Int)
}

