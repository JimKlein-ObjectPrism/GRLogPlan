//
//  JournalItemProtocols.swift
//  GRPatienLogAndPlan
//
//  Created by James Klein on 3/19/15.
//  Copyright (c) 2015 ObjectPrism Corp. All rights reserved.
//

import Foundation

protocol JournalEntryItem {
    func accept(journalItemVisitor: JournalEntryItemVisitor)
}

protocol JournalEntryItemVisitor {
    func visit(journalItem: JournalItem) -> ()
    
    
    func visit(journalItem: Breakfast) -> ()
    func visit(journalItem: Lunch) -> ()
    func visit(journalItem: Dinner) -> ()
    
    func visit(journalItem: Snack) -> ()
    
    func visit(journalItem: Activity) -> ()
    func visit(journalItem: Medicine) -> ()
    func visit(journalItem: AddOn) -> ()

}