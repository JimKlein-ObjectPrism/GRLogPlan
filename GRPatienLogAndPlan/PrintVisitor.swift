//
//  PrintVisitor.swift
//  GRPatienLogAndPlan
//
//  Created by James Klein on 4/1/15.
//  Copyright (c) 2015 ObjectPrism Corp. All rights reserved.
//

import Foundation

class PrintVisitor: JournalEntryItemVisitor {
    var stringsArray: [NSMutableAttributedString] = []
    
    func formatMealItemName(s: String) -> NSMutableAttributedString {

        let myString = NSAttributedString(string: s)
        let headerStart: Int = 0
        let headerEnd: Int = myString.length
        let mutableAttrString: NSMutableAttributedString = NSMutableAttributedString(attributedString: myString)
        let newLine = NSMutableAttributedString(string: "\n")
        mutableAttrString.appendAttributedString(newLine)
        mutableAttrString.addAttribute(NSFontAttributeName, value: UIFont.systemFontOfSize(18.0), range: NSRange(location: headerStart, length: headerEnd))
        return mutableAttrString
        
    }

    
    func formatBulletItem(s: String) -> NSMutableAttributedString {
        //var myMutableString = NSMutableAttributedString()
        let myString = NSAttributedString(string: s)
        //myMutableString.addAttribute(NSFontAttributeName, value: UIFont(name: "Georgia", size: 36.0)!, range: NSRange(location: 0, length: 1))
        //let headerStart: Int = 0
        //let headerEnd: Int = myString.length
        let mutableAttrString: NSMutableAttributedString = NSMutableAttributedString(attributedString: myString)
        let bullet = NSMutableAttributedString(string: "\n\u{2022}  ")
        bullet.appendAttributedString(mutableAttrString)//x.appenAttributedString(NSAttributedString("\n\u{2022}  "))
        let newLine = NSMutableAttributedString(string: "\n")
        
        bullet.appendAttributedString(newLine)
        //bullet.addAttribute(NSFontAttributeName, value: UIFont.boldSystemFontOfSize(18.0), range: NSMakeRange(headerStart, headerEnd))
        
        return bullet
        
    }
    func formatBulletItemTimePlaceInitials(s: String) -> NSMutableAttributedString {
        //var myMutableString = NSMutableAttributedString()
        let myString = NSAttributedString(string: s)
        //myMutableString.addAttribute(NSFontAttributeName, value: UIFont(name: "Georgia", size: 36.0)!, range: NSRange(location: 0, length: 1))
//      let headerStart: Int = 0
        //let headerEnd: Int = myString.length
        let mutableAttrString: NSMutableAttributedString = NSMutableAttributedString(attributedString: myString)
        let bullet = NSMutableAttributedString(string: "\n\u{2022}  ")
        bullet.appendAttributedString(mutableAttrString)//x.appenAttributedString(NSAttributedString("\n\u{2022}  "))
        let newLine = NSMutableAttributedString(string: "\n\n")
        
        bullet.appendAttributedString(newLine)
        //bullet.addAttribute(NSFontAttributeName, value: UIFont.boldSystemFontOfSize(18.0), range: NSMakeRange(headerStart, headerEnd))
        
        return bullet
        
    }
    
    func setFontFor(attrString: NSAttributedString) -> NSMutableAttributedString {
        let mutableAttrString: NSMutableAttributedString = NSMutableAttributedString(attributedString: attrString)
//        let headerStart: Int = 0
//        let headerEnd: Int = attrString.length
        let bullet = NSMutableAttributedString(string: "\n\u{2022}  ")
        bullet.appendAttributedString(mutableAttrString)//x.appenAttributedString(NSAttributedString("\n\u{2022}  "))
        let newLine = NSMutableAttributedString(string: "\n")
        bullet.appendAttributedString(newLine)
        //bullet.addAttribute(NSFontAttributeName, value: UIFont.boldSystemFontOfSize(18.0), range: NSMakeRange(headerStart, headerEnd))
        
        return bullet
    }
    
    func reduceStringsArray ( xs: [NSMutableAttributedString] ) -> NSMutableAttributedString {
        let ms: NSMutableAttributedString = NSMutableAttributedString()
        for x in xs {
            ms.appendAttributedString(x)
        }    
        return ms
    }
    
    func visit(journalItem: JournalItem){
        let s = NSMutableAttributedString(string: journalItem.title)
        let newLine = NSMutableAttributedString(string: "\n")
        s.appendAttributedString(newLine)
        let headerStart: Int = 0
        let headerEnd: Int = s.length
        s.addAttribute(NSFontAttributeName, value: UIFont.boldSystemFontOfSize(22.0), range: NSMakeRange(headerStart, headerEnd))
        self.stringsArray.append(s)
        
        
        for i in 0..<journalItem.count() {
            journalItem[i]?.accept(self)
            }
        
    }
    
    func appendTimePlaceInitials ( time: String, place: String, initials: String) -> String {
        return "Time: \(time), Place: \(place), Parent Initials: \(initials)"
    }
    
    func visit(journalItem: Breakfast){
        stringsArray.append(formatMealItemName(journalItem.menuDisplayName))
        
        if let s = journalItem.foodChoice?.name {
            stringsArray.append(formatBulletItem(s))
        }
        
        if let s = journalItem.fruitChoice?.name {
            stringsArray.append(formatBulletItem(s))
        }
        
//        let t = "8:00"
//        var pi = journalItem.parentInitials?.defaultInitials
//        var place = journalItem.place?.mealLocation!
        
        let otherInfo = appendTimePlaceInitials("8:00", place: "Kitchen", initials: "B.C.")
        stringsArray.append(formatBulletItemTimePlaceInitials(otherInfo))
        
    }
    
    func visit(journalItem: Lunch){
        stringsArray.append(formatMealItemName(journalItem.menuDisplayName))
        
        if let s = journalItem.meatChoice?.name {
            stringsArray.append(formatBulletItem(s))
        }
        
        if let s = journalItem.fruitChoice?.name {
            stringsArray.append(formatBulletItem(s))
        }
        let otherInfo = appendTimePlaceInitials("12:15", place: "Kitchen", initials: "A.B.")
        stringsArray.append(formatBulletItemTimePlaceInitials(otherInfo))
        
        stringsArray.append(formatMealItemName("Afternoon Snack"))
        stringsArray.append(formatBulletItem("Cheese, Crackers and Fruit"))
        let otherInfoS = appendTimePlaceInitials("3:00", place: "Kitchen", initials: "A.B.")
        stringsArray.append(formatBulletItemTimePlaceInitials(otherInfoS))
        
        stringsArray.append(formatMealItemName("Dinner"))
        stringsArray.append(formatBulletItem("Chicken"))
        stringsArray.append(formatBulletItem("Rice"))
        stringsArray.append(formatBulletItem("Olive Oil"))
        stringsArray.append(formatBulletItem("Brocoli"))
        stringsArray.append(formatBulletItem("Milk"))
        stringsArray.append(formatBulletItem("Salad"))
        
        let otherInfoD = appendTimePlaceInitials("6:00", place: "Kitchen", initials: "A.B.")
        stringsArray.append(formatBulletItemTimePlaceInitials(otherInfoD))

    }
    func visit(journalItem: Dinner){
        
    }
    
    func visit(journalItem: Snack){
        
    }
    
    func visit(journalItem: Activity){
        
    }
    func visit(journalItem: Medicine){
        
    }
    func visit(journalItem: AddOn){
        
    }
}