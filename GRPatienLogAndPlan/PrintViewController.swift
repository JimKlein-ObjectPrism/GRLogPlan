//
//  PrintViewController.swift
//  GRPatienLogAndPlan
//
//  Created by James Klein on 4/1/15.
//  Copyright (c) 2015 ObjectPrism Corp. All rights reserved.
//

import UIKit

class PrintViewController: UIViewController, UITableViewDataSource, UITableViewDelegate, UITextViewDelegate {
    
    var selectedCellDateValue = "Thursday, April 30"
    
    let journalEntries: [(String, String)] = [
        
        ("Thursday, April 30, 2015", "Status: Complete"),
        ("Wednesday, April 29, 2015", "Status: Complete"),
        ("Tuesday, April 28, 2015", "Status: Complete"),
        ("Monday, April 27, 2015", "Status: Complete"),
        ("Sunday, April 26, 2015", "Status: Complete"),
        ("Saturday, April 25, 2015", "Status: Complete"),
        ("Friday, April 24, 2015", "Status: Complete")
        
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
        self.navigationController?.navigationBar.barTintColor = UIColor(red: 150.0/255.0, green: 185.0/255.0, blue: 118.0/255.0, alpha: 1.0)
        
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
