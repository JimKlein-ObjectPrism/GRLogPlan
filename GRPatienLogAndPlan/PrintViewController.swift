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

    var oldX: CGFloat = 0.0

    @IBOutlet weak var scrollView: UIScrollView!
    
    @IBOutlet weak var webView: UIWebView!
    
    //var selectedCellDateValue: String!
    
    var journalEntries: [String]!
    var selectedJournalEntryIdentifiers: [String] = [String]()

    @IBAction func printJournalEntry(sender: AnyObject) {
        // 1 get the print controller
        let printController = UIPrintInteractionController.sharedPrintController()!
        // 2 set up job info
        let printInfo = UIPrintInfo(dictionary:nil)!
        printInfo.outputType = UIPrintInfoOutputType.General
        printInfo.jobName = "Print Job"
        printController.printInfo = printInfo
        
        // 3  pass text to formatter
        let formatter = UIMarkupTextPrintFormatter(markupText: previewTextView.text)
        formatter.contentInsets = UIEdgeInsets(top: 72, left: 72, bottom: 72, right: 72)
        printController.printFormatter = formatter
        
        // 4 present the print interface
        printController.presentAnimated(true, completionHandler: nil)
    }
    @IBOutlet weak var previewTextView: UITextView!
    
    @IBAction func previewPrintJob(sender: AnyObject) {
        
        var printService = PrintSevice()
        if selectedJournalEntryIdentifiers.count > 0 {
        let dateString = selectedJournalEntryIdentifiers[0]
        let logEntryFormattedForPrinting = printService.getStringToPrint(dateString)
        webView.loadHTMLString(logEntryFormattedForPrinting, baseURL: nil)
        }
        
    }
    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view, typically from a nib.
        //previewTextView.delegate = self
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
        let logEntryIdentifier = journalEntries[indexPath.row]
        //only supporting single selection for now
        self.selectedJournalEntryIdentifiers.insert(logEntryIdentifier, atIndex: 0)
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
        
        scrollView.setContentOffset(CGPointMake(oldX, scrollView.contentOffset.y), animated: false)
    }
}
