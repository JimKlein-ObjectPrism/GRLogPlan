//
//  EmailComposer.swift
//  GRPatienLogAndPlan
//
//  Created by James Klein on 9/25/15.
//  Copyright © 2015 ObjectPrism Corp. All rights reserved.
//

import Foundation
import MessageUI

class EmailComposer: NSObject, MFMailComposeViewControllerDelegate {
    // Did this in order to mitigate needing to import MessageUI in my View Controller
    func canSendMail() -> Bool {
        return MFMailComposeViewController.canSendMail()
    }
    
    func configuredMailComposeViewController(toRecipients: [String], subjectText: String, messageBody: String, fileName: String, pdfFilePath: String) -> MFMailComposeViewController {
        let mailComposerVC = MFMailComposeViewController()
        mailComposerVC.mailComposeDelegate = self
        
        mailComposerVC.setToRecipients(toRecipients)
        mailComposerVC.setSubject(subjectText)
        mailComposerVC.setMessageBody(messageBody, isHTML: false)
        
        if let fileData = NSData(contentsOfFile: pdfFilePath) {
            //println("File data loaded.")
            
            mailComposerVC.addAttachmentData(fileData, mimeType: "application/pdf", fileName: fileName)
            
        }

        
        return mailComposerVC
    }
    
    // MARK: MFMailComposeViewControllerDelegate Method
    func mailComposeController(controller: MFMailComposeViewController, didFinishWithResult result: MFMailComposeResult, error: NSError?) {
        controller.dismissViewControllerAnimated(true, completion: nil)
    }
}
