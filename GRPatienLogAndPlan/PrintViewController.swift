//
//  PrintViewController.swift
//  GRPatienLogAndPlan
//
//  Created by James Klein on 4/1/15.
//  Copyright (c) 2015 ObjectPrism Corp. All rights reserved.
//

import UIKit

class PrintViewController: UIViewController, UITableViewDataSource, UITableViewDelegate, UITextViewDelegate {
    
    var dataStore: DataStore!
    var appDelegate: AppDelegate?

    
    var selectedCellDateValue: String!
    
    var journalEntries: [String]!
//    = [
//        
//        
//        ("Wednesday, May 27, 2015", "Status: Complete"),
//        ("Tuesday, May 26, 2015", "Status: Complete"),
//        ("Monday, May 25, 2015", "Status: Complete"),
//        ("Sunday, May 24, 2015", "Status: Complete"),
//        ("Saturday, May 23, 2015", "Status: Complete"),
//        ("Friday, May 22, 2015", "Status: Complete"),
//        ("Thursday, May 21, 2015", "Status: Complete"),
//        
//    ]
    
    @IBAction func printJournalEntry(sender: AnyObject) {
        // 1
        let printController = UIPrintInteractionController.sharedPrintController()!
        // 2
        let printInfo = UIPrintInfo(dictionary:nil)!
        printInfo.outputType = UIPrintInfoOutputType.General
        printInfo.jobName = "Print Job"
        printController.printInfo = printInfo
        
        // 3
        let formatter = UIMarkupTextPrintFormatter(markupText: previewTextView.text)
        formatter.contentInsets = UIEdgeInsets(top: 72, left: 72, bottom: 72, right: 72)
        printController.printFormatter = formatter
        
        // 4
        printController.presentAnimated(true, completionHandler: nil)
    }
    @IBOutlet weak var previewTextView: UITextView!
    
    @IBAction func previewPrintJob(sender: AnyObject) {
        var printVisitor = PrintVisitor()
        
        var jItem = JournalItem(itemTitle: selectedCellDateValue)
        var newItem = jItem.getTestJournalItem(selectedCellDateValue)
        
        newItem.accept(printVisitor)
        
        previewTextView.attributedText = printVisitor.reduceStringsArray(printVisitor.stringsArray)
        
    }
    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view, typically from a nib.
        previewTextView.delegate = self
        self.navigationController?.navigationBar.barTintColor = UIColor(red: 150.0/255.0, green: 185.0/255.0, blue: 118.0/255.0, alpha: 1.0)
        self.appDelegate = UIApplication.sharedApplication().delegate as? AppDelegate

        if  self.appDelegate != nil {
            dataStore = appDelegate!.dataStore
            journalEntries = dataStore.getPastWeekOfDates()
            //self.currentDateHeader = dataStore.today
        }

    }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    func numberOfSectionsInTableView(tableView: UITableView) -> Int {
        // #warning Potentially incomplete method implementation.
        // Return the number of sections.
        return 1
    }
    
    func tableView(tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        // #warning Incomplete method implementation.
        // Return the number of rows in the section.
        return journalEntries.count
    }
    
    
    func tableView(tableView: UITableView, cellForRowAtIndexPath indexPath: NSIndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCellWithIdentifier("PrintCell", forIndexPath: indexPath) as! UITableViewCell
        
        cell.textLabel?.text = journalEntries[indexPath.row]
        //use commented out code to display status in detail area of cell
        cell.detailTextLabel?.text = "" //journalEntries[indexPath.row].1
        
        return cell
    }
    func tableView(tableView: UITableView, didDeselectRowAtIndexPath indexPath: NSIndexPath) {
        println("test")
    }
    
    func tableView(tableView: UITableView, didSelectRowAtIndexPath indexPath: NSIndexPath) {
        selectedCellDateValue = journalEntries[indexPath.row].0
    }

    func textViewShouldBeginEditing(textView: UITextView) -> Bool {
        return false
    }
    /*
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepareForSegue(segue: UIStoryboardSegue, sender: AnyObject?) {
        // Get the new view controller using segue.destinationViewController.
        // Pass the selected object to the new view controller.
    }
    */

}
