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

}