//
//  Extensions.swift
//  GRPatienLogAndPlan
//
//  Created by James Klein on 8/14/15.
//  Copyright (c) 2015 ObjectPrism Corp. All rights reserved.
//

import Foundation

extension UIViewController {
    func displayErrorAlert(title: String, message: String) {
        let alertController = UIAlertController(title: title, message: message, preferredStyle: .Alert)
        
        let OKAction = UIAlertAction(title: "OK", style: .Default) { (action) in
            // ...
        }
        alertController.addAction(OKAction)
        
        self.presentViewController(alertController, animated: true) {
            // ...
        }
    }
    func displayErrorAlert(title: String, messages: [String]) {
        
        let message = messages.reduce("") { (initial, subsequentMessage) in  initial + "\n" + subsequentMessage }
        //.reduce(0) { (total, number) in total + number }
        let alertController = UIAlertController(title: title, message: message, preferredStyle: .Alert)
        
        let OKAction = UIAlertAction(title: "OK", style: .Default) { (action) in
            // ...
        }
        alertController.addAction(OKAction)
        
        self.presentViewController(alertController, animated: true) {
            // ...
        }
    }
    func checkMealStateValidationStatus(mealState: MealState, dataStore: DataStore) -> ValidationResult {
            switch mealState{
            case .Breakfast:
                //return dataStore.breakfast.validate()
                return  VMBreakfast(fromDataObject: dataStore.currentJournalEntry.breakfast).validate()
                //return dataStore.getBreakfast_Today().validate()
                
            case .MorningSnack:
                //return dataStore.morningSnack.validate()
                return VMSnack(fromDataObject: dataStore.currentJournalEntry.morningSnack).validate()// dataStore.getSnack_Today(SnackTime.Morning).validate()
                
            case .Lunch:
                //return dataStore.lunch.validate()
                return dataStore.getLunch_Today().validate()
                
            case .AfternoonSnack:
                //return dataStore.afternoonSnack.validate()
                return VMSnack(fromDataObject: dataStore.currentJournalEntry.afternoonSnack).validate()//dataStore.getSnack_Today(SnackTime.Afternoon).validate()
                
            case .Dinner:
                //return dataStore.dinner.validate()
                return dataStore.getDinner_Today().validate()
                
            case .EveningSnack:
                //return dataStore.eveningSnack.validate()
                return VMSnack(fromDataObject: dataStore.currentJournalEntry.eveningSnack).validate()//dataStore.getSnack_Today(SnackTime.Evening).validate()
            }
    }

    //MARK: View Transition Methods
    func testDateOfCurrentJournalEntry( date: String, journalEntry: OPJournalEntry ) -> Bool {
        return date == journalEntry.date
    }
    
}

//MARK: Top View Controller
extension UIApplication {
    class func topViewController(base: UIViewController? = UIApplication.sharedApplication().keyWindow?.rootViewController) -> UIViewController? {
        if let nav = base as? UINavigationController {
            return topViewController(base: nav.visibleViewController)
        }
        if let tab = base as? UITabBarController {
            if let selected = tab.selectedViewController {
                return topViewController(base: selected)
            }
        }
        if let presented = base?.presentedViewController {
            return topViewController(base: presented)
        }
        return base
    }
}
// TODO: Update using where clause [FoodItem] for swift 2
extension Array {
    func getIndexInArray (item: String?) -> Int {
        var itemIndex: Int = 0
        if let itemValue = item {
            for i in 0..<self.count {
                if let foodItem = self[i] as? FoodItem{
                    if foodItem.name == itemValue {
                    itemIndex = i
                    break
                    }
                }
                if let foodItem = self[i] as? FoodItemWithChoice {
                    let foodItemFullName = foodItem.name
                    let myArray: [String] = itemValue.componentsSeparatedByString(",")
                    let foodItemName = myArray.first ?? ""
 
                    if foodItemFullName == foodItemName {
                        itemIndex = i
                        break
                    }
                }
            }
        }
            return itemIndex
    }
}

//MARK: UIButtonBarItem convenience initializer
//extension UIBarButtonItem {
//    //let a = UIBarButtonItem(
//    convenience init(title: String,
//        style: UIBarButtonItemStyle,
//        target: AnyObject?,
//        buttonAction: (UIBarButtonItem) -> () ){
//        self.init()
//            self.title = title
//            self.style = style
//            self.target = target
//            action = buttonAction
//    }
//}