//
//  PrintViewController.swift
//  GRPatienLogAndPlan
//
//  Created by James Klein on 4/1/15.
//  Copyright (c) 2015 ObjectPrism Corp. All rights reserved.
//

import UIKit

class PrintViewController: UIViewController, UITableViewDataSource, UITableViewDelegate, UITextViewDelegate {
    
    var selectedCellDateValue = "Thursday, April 10"
    
    let journalEntries: [(String, String)] = [
        ("Friday, April 10, 2015", "Status: Partially Complete"),
        ("Thursday, April 9, 2015", "Status: Complete"),
        ("Wednesday, April 8, 2015", "Status: Complete"),
        ("Tuesday, April 7, 2015", "Status: Complete"),
        ("Monday, April 6, 2015", "Status: Complete"),
        ("Sunday, April 5, 2015", "Status: Complete"),
        ("Saturday, April 4, 2015", "Status: Complete"),
        ("Friday, April 3, 2015", "Status: Complete")
        
    ]
    
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
        let cell = tableView.dequeueReusableCellWithIdentifier("PrintCell", forIndexPath: indexPath) as UITableViewCell
        
        cell.textLabel?.text = journalEntries[indexPath.row].0
        cell.detailTextLabel?.text = journalEntries[indexPath.row].1
        
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
