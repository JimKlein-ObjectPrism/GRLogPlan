//
//  PrintViewController.swift
//  GRPatienLogAndPlan
//
//  Created by James Klein on 4/1/15.
//  Copyright (c) 2015 ObjectPrism Corp. All rights reserved.
//

import UIKit

class PrintViewController: UIViewController, UITableViewDataSource, UITableViewDelegate, UITextViewDelegate,
UIScrollViewDelegate{
    
    var dataStore: DataStore!
    var appDelegate: AppDelegate?
    
    var selectedItemDateString: String?

    @IBOutlet weak var tableView: UITableView!
    var oldX: CGFloat = 0.0

    @IBOutlet weak var scrollView: UIScrollView!
    
    @IBOutlet weak var webView: UIWebView!
    var journalEntries: [String]!
    var selectedJournalEntryIdentifiers: [String] = [String]()
 
    //var selectedCellDateValue: String!
    

    
    override func viewDidLoad() {
        super.viewDidLoad()

        self.navigationController?.navigationBar.barTintColor = UIColor(red: 150.0/255.0, green: 185.0/255.0, blue: 118.0/255.0, alpha: 1.0)
        self.appDelegate = UIApplication.sharedApplication().delegate as? AppDelegate
        
        if  self.appDelegate != nil {
            dataStore = appDelegate!.dataStore
            journalEntries = dataStore.getListOfDatePropertyValuesForExisitingJournalEntries()
        }
        
    }
    override func viewWillAppear(animated: Bool) {
        journalEntries = dataStore.getListOfDatePropertyValuesForExisitingJournalEntries()
        tableView.reloadData()
        
    }

    func logEntryFormattedForPrinting(date: String) -> String {
        
        var printService = PrintSevice()
        
//        if self.selectedJournalEntryIdentifiers.count > 0 {
//            let dateString = self.selectedJournalEntryIdentifiers[0]
            //TODO: MAKE FOLLOWING METHOD RETURN OPTIONAL STRING
            return printService.getStringToPrint(date)
//        }
//        return ""
        }
    
    @IBAction func printJournalEntry(sender: AnyObject) {
        if self.selectedJournalEntryIdentifiers.count > 0 {
        // 1 get the print controller
        let printController = UIPrintInteractionController.sharedPrintController()!
        // 2 set up job info
        let printInfo = UIPrintInfo(dictionary:nil)!
        printInfo.outputType = UIPrintInfoOutputType.General
        printInfo.jobName = "Print Job"
        printController.printInfo = printInfo
        
        // 3  pass text to formatter
        let formatter = UIMarkupTextPrintFormatter(markupText: logEntryFormattedForPrinting(selectedJournalEntryIdentifiers[0]))
        formatter.contentInsets = UIEdgeInsets(top: 72, left: 72, bottom: 72, right: 72) // 1" margins
        printController.printFormatter = formatter
        
        // 4 present the print interface
        printController.presentAnimated(true, completionHandler: nil)
        }
    }
    
    @IBAction func previewPrintJob(sender: AnyObject) {
        
        if selectedItemDateString != nil {
            let htmlString = logEntryFormattedForPrinting(selectedItemDateString!)
            webView.loadHTMLString(htmlString, baseURL: nil)
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
        let logEntryIdentifier = journalEntries[indexPath.row]
        //only supporting single selection for now
        
        selectedItemDateString = journalEntries[indexPath.row]
        //self.selectedJournalEntryIdentifiers.insert(logEntryIdentifier, atIndex: indexPath.row)
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

    //MARK: ScrollView Delegate
    func scrollViewDidScroll(scrollView: UIScrollView) {
        //prevents horizontal scrolling of UIWebView:
        scrollView.setContentOffset(CGPointMake(oldX, scrollView.contentOffset.y), animated: false)
    }
}
