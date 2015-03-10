//
//  TrackTableViewController.swift
//  GRPatienLogAndPlan
//
//  Created by Jim Klein on 2/25/15.
//  Copyright (c) 2015 ObjectPrism Corp. All rights reserved.
//

import UIKit

class TrackTableViewController: UITableViewController {

    @IBOutlet weak var menuButton: UIBarButtonItem!
    
    var dataArray: [AnyObject]?
    
    //MARK: - Journal Item properties
    var headerTitles = [String]()
    
    var itemSelectedHeaderTitles = [String]()
    
    var rowArrays: [ [ String]] = [Array<String>]()
    
    var foodItems = [FoodItem]()
    
    
    var sectionData: [[AnyObject]] = [[AnyObject]]()

    
    override func viewDidLoad() {
        super.viewDidLoad()

        if self.revealViewController() != nil {
            menuButton.target = self.revealViewController()
            menuButton.action = "revealToggle:"
            self.view.addGestureRecognizer(self.revealViewController().panGestureRecognizer())
        }
        
        let appDelegate = UIApplication.sharedApplication().delegate as AppDelegate
        
        dataArray = appDelegate.dataArray

        var c = dataArray!.count
        
    }
    
    override func viewWillAppear(animated: Bool) {
        
        //var dinnerItems: DinnerItems = (DinnerItem(), foodItems )
        self.dataArray = DataStore().buildDetailViewArray()
        
        
        if let bItem = self.dataArray![0] as? BreakfastItems {
            //          currentBreakfastItem = bItem
            headerTitles = bItem.headerTitles
            itemSelectedHeaderTitles = bItem.itemSelectedHeaderTitles
            sectionData.append(bItem.breakfastChoice)
            sectionData.append(bItem.fruit)
            sectionData.append(bItem.mealDetails)
        }
        
        if let lItem = self.dataArray![0] as? LunchItems {
            headerTitles = lItem.headerTitles
            itemSelectedHeaderTitles = lItem.itemSelectedHeaderTitles
            sectionData.append(lItem.lunchChoice)
            sectionData.append(lItem.fruitChoice)
            sectionData.append(lItem.mealDetails)
        }
        if let dItem = self.dataArray![0] as? DinnerItems {
            headerTitles = dItem.headerTitles
            itemSelectedHeaderTitles = dItem.itemSelectedHeaderTitles
            sectionData.append(dItem.meat)
            sectionData.append(dItem.starch)
            sectionData.append(dItem.oil)
            sectionData.append(dItem.vegetable)
            sectionData.append(dItem.requiredItems)
            sectionData.append(dItem.mealDetails)
            
        }
        
        
    }


    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }

    // MARK: - Table view data source

    override func numberOfSectionsInTableView(tableView: UITableView) -> Int {
        // #warning Potentially incomplete method implementation.
        // Return the number of sections.
        return self.sectionData.count
    }
    
    override func tableView(tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        
        return self.sectionData[section].count
        
    }
    func handleSegmentedControlSelectionChanged(sender: UISegmentedControl)
    {
        var selectedIndex = sender.selectedSegmentIndex
    }
    
    override func tableView(tableView: UITableView, cellForRowAtIndexPath indexPath: NSIndexPath) -> UITableViewCell {
        var section = indexPath.section
        
        var currentItemsArray = sectionData[indexPath.section]
        
        var row = indexPath.row
        
        
        let currentItem: AnyObject = currentItemsArray[indexPath.row]
        
        switch currentItem {
        case let currentItem as FoodItemWithChoice:
            //handle fooditemwithchoice
            //currentItemsArray must be [FoodItems]
            var foodItemArray = currentItemsArray as [FoodItem]
            var cell = tableView.dequeueReusableCellWithIdentifier("ChoiceCell", forIndexPath: indexPath) as ChoiceItemsTableViewCell
            cell.choiceLabel?.text = foodItemArray[indexPath.row].itemDescription
            
            
            var segControl = cell.choiceSegmentControl as UISegmentedControl
           
            
            segControl.addTarget(self, action: "handleSegmentedControlSelectionChanged:", forControlEvents: .ValueChanged)
            
            
            for i in 0 ..< currentItem.choiceItems.count {
                if i  < 2 {
                    var choiceItem = currentItem.choiceItems[i]
                    segControl.setTitle(choiceItem.itemDescription, forSegmentAtIndex: i)
                }
                else{
                    segControl.insertSegmentWithTitle(currentItem.choiceItems[i].itemDescription, atIndex: i, animated: false)
                }
                segControl.setWidth(110.0, forSegmentAtIndex: i)
            }
            return cell
            
        case let currentItem as ParentInitials:
            let cell = tableView.dequeueReusableCellWithIdentifier("ParentInitialsCell", forIndexPath: indexPath) as ParentInitialsTableViewCell
            cell.textLabel?.text = "Parent Initials"
            return cell
            
        case let currentItem as Time:
            let cell = tableView.dequeueReusableCellWithIdentifier("TimeEntryCell", forIndexPath: indexPath) as TimeEntryTableViewCell
            cell.textLabel?.text = "Time"
            return cell
            
        case let currentItem as Place:
            let cell = tableView.dequeueReusableCellWithIdentifier("PlaceEntryCell", forIndexPath: indexPath) as PlaceEntryTableViewCell
            cell.textLabel?.text = "Place"
            return cell
            
        case let currentItem as Note:
            let cell = tableView.dequeueReusableCellWithIdentifier("NoteCell", forIndexPath: indexPath) as NoteTableViewCell
            cell.textLabel?.text = "Note"
            return cell
            
        default:
            //handle plain FoodItem
            //currentItemsArray must be [FoodItems]
            var foodItemArray = currentItemsArray as [FoodItem]
            let cell = tableView.dequeueReusableCellWithIdentifier("Cell", forIndexPath: indexPath) as UITableViewCell
            cell.textLabel?.text = foodItemArray[indexPath.row].name
            cell.detailTextLabel?.text = foodItemArray[indexPath.row].itemDescription
            return cell
        }
    }
    
    override func tableView(tableView: UITableView, titleForHeaderInSection section: Int) -> String? {
        
        if self.sectionData[section].count == 1{
            return self.itemSelectedHeaderTitles[section]
        }
        else {
            return headerTitles[section]
        }
        
    }
    /*
    override func tableView(tableView: UITableView, cellForRowAtIndexPath indexPath: NSIndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCellWithIdentifier("reuseIdentifier", forIndexPath: indexPath) as UITableViewCell

        // Configure the cell...

        return cell
    }
    */

    /*
    // Override to support conditional editing of the table view.
    override func tableView(tableView: UITableView, canEditRowAtIndexPath indexPath: NSIndexPath) -> Bool {
        // Return NO if you do not want the specified item to be editable.
        return true
    }
    */

    /*
    // Override to support editing the table view.
    override func tableView(tableView: UITableView, commitEditingStyle editingStyle: UITableViewCellEditingStyle, forRowAtIndexPath indexPath: NSIndexPath) {
        if editingStyle == .Delete {
            // Delete the row from the data source
            tableView.deleteRowsAtIndexPaths([indexPath], withRowAnimation: .Fade)
        } else if editingStyle == .Insert {
            // Create a new instance of the appropriate class, insert it into the array, and add a new row to the table view
        }    
    }
    */

    /*
    // Override to support rearranging the table view.
    override func tableView(tableView: UITableView, moveRowAtIndexPath fromIndexPath: NSIndexPath, toIndexPath: NSIndexPath) {

    }
    */

    /*
    // Override to support conditional rearranging of the table view.
    override func tableView(tableView: UITableView, canMoveRowAtIndexPath indexPath: NSIndexPath) -> Bool {
        // Return NO if you do not want the item to be re-orderable.
        return true
    }
    */

    /*
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepareForSegue(segue: UIStoryboardSegue, sender: AnyObject?) {
        // Get the new view controller using [segue destinationViewController].
        // Pass the selected object to the new view controller.
    }
    */

}
