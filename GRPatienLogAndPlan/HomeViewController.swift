//
//  HomeViewController.swift
//  GRPatienLogAndPlan
//
//  Created by James Klein on 3/9/15.
//  Copyright (c) 2015 ObjectPrism Corp. All rights reserved.
//

import UIKit

class HomeViewController: UIViewController, UITableViewDataSource, UITableViewDelegate, UIPopoverPresentationControllerDelegate {

    
    override func viewDidLoad() {
        super.viewDidLoad()

        //self.tableView.rowHeight = 44.0
        // Do any additional setup after loading the view.
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    // MARK: - Table view data source
    
    func numberOfSectionsInTableView(tableView: UITableView) -> Int {
        // #warning Potentially incomplete method implementation.
        // Return the number of sections.
        return 1
    }
    
    func tableView(tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        tableView.rowHeight = 150
        return 2//self.sectionData[section].count
        
    }

    
    
    func tableView(tableView: UITableView, cellForRowAtIndexPath indexPath: NSIndexPath) -> UITableViewCell {
        var section = indexPath.section
        
        if indexPath.row == 0 {
        let cell = tableView.dequeueReusableCellWithIdentifier("HomeLogItemCell", forIndexPath: indexPath)
            as HomeLogItemTableViewCell
            
        cell.parent = self
        return cell
        }
        else{
            let cell = tableView.dequeueReusableCellWithIdentifier("Home_DetailedEntryCell", forIndexPath: indexPath)
                as DetailedJournalEntryTableViewCell
            return cell
        }
        
        
        
//        var currentItemsArray = sectionData[indexPath.section]
//        
//        var row = indexPath.row
//        
//        
//        let currentItem: AnyObject = currentItemsArray[indexPath.row]
//        
//        switch currentItem {
//        case let currentItem as FoodItemWithChoice:
//            //handle fooditemwithchoice
//            //currentItemsArray must be [FoodItems]
//            var foodItemArray = currentItemsArray as [FoodItem]
//            var cell = tableView.dequeueReusableCellWithIdentifier("ChoiceCell", forIndexPath: indexPath) as ChoiceItemsTableViewCell
//            cell.choiceLabel?.text = foodItemArray[indexPath.row].itemDescription
//            cell.choiceSegmentControl.addTarget(self, action: "handleSegmentedControlSelectionChanged:", forControlEvents: .ValueChanged)
//            //cell.choiceSegmentControl.numberOfSegments = foodItem.choiceItems.count
//            
//            for i in 0 ..< currentItem.choiceItems.count {
//                if i  < 2 {
//                    var choiceItem = currentItem.choiceItems[i]
//                    cell.choiceSegmentControl.setTitle(choiceItem.itemDescription, forSegmentAtIndex: i)
//                }
//                else{
//                    cell.choiceSegmentControl.insertSegmentWithTitle(currentItem.choiceItems[i].itemDescription, atIndex: i, animated: false)
//                }
//                cell.choiceSegmentControl.setWidth(110.0, forSegmentAtIndex: i)
//            }
//            return cell
//            
//        case let currentItem as ParentInitials:
//            let cell = tableView.dequeueReusableCellWithIdentifier("ParentInitialsCell", forIndexPath: indexPath) as ParentInitialsTableViewCell
//            cell.textLabel?.text = "Parent Initials"
//            return cell
//            
//        case let currentItem as Time:
//            let cell = tableView.dequeueReusableCellWithIdentifier("TimeEntryCell", forIndexPath: indexPath) as TimeEntryTableViewCell
//            cell.textLabel?.text = "Time"
//            return cell
//            
//        case let currentItem as Place:
//            let cell = tableView.dequeueReusableCellWithIdentifier("PlaceEntryCell", forIndexPath: indexPath) as PlaceEntryTableViewCell
//            cell.textLabel?.text = "Place"
//            return cell
//            
//        case let currentItem as Note:
//            let cell = tableView.dequeueReusableCellWithIdentifier("NoteCell", forIndexPath: indexPath) as NoteTableViewCell
//            cell.textLabel?.text = "Note"
//            return cell
//            
//        default:
//            //handle plain FoodItem
//            //currentItemsArray must be [FoodItems]
//            var foodItemArray = currentItemsArray as [FoodItem]
//            let cell = tableView.dequeueReusableCellWithIdentifier("Cell", forIndexPath: indexPath) as UITableViewCell
//            cell.textLabel?.text = foodItemArray[indexPath.row].name
//            cell.detailTextLabel?.text = foodItemArray[indexPath.row].itemDescription
//            return cell
//        }
    }
    
    func tableView(tableView: UITableView, titleForHeaderInSection section: Int) -> String? {
        
        //if self.sectionData[section].count == 1{
        return "Quick Log Entry: Tuesday, March 12, Dinner"
       //
           // return headerTitles[section]
        
        
    }
    
    

    @IBAction func showPopover(sender: AnyObject) {
        
        
    }
    
    
    @IBAction func showMealSelectionView(sender: AnyObject) {
        let vc : TrackTableViewController = self.storyboard?.instantiateViewControllerWithIdentifier("TrackVC") as TrackTableViewController
        
        /*
        //TODO: Code here should be hiding the tab bar, but its not
        if let tabVC = self.tabBarController{
           tabVC.hidesBottomBarWhenPushed = true
        }
        */
        
        let appDelegate = UIApplication.sharedApplication().delegate as AppDelegate
        
        // initialize and set dataArray on TrackVC
        vc.dataArray = [AnyObject]()
        
        if let d = appDelegate.dataArray[0] as? DetailDisplayItem {
            vc.detailDisplayItem = d
            //TODO: Remove hard coded Nav Bar title
            vc.navigationItem.title = "Breakfast"
        }
        
        //set full day display type in order to generate the correct button in nav bar
        vc.displayType = MealItemSelectionDisplayType.FullDayEntryWithMenu
        
        self.showViewController(vc as UIViewController, sender: vc)
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
