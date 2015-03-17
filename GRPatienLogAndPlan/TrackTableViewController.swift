//
//  TrackTableViewController.swift
//  GRPatienLogAndPlan
//
//  Created by Jim Klein on 2/25/15.
//  Copyright (c) 2015 ObjectPrism Corp. All rights reserved.
//

import UIKit

class TrackTableViewController: UITableViewController, UpdateDetailViewDelegate {

    @IBOutlet weak var menuButton: UIBarButtonItem!
    
    var dataArray: [AnyObject]?
    
    var detailDisplayItem: DetailDisplayItem?
    
    var sectionData: [[AnyObject]] = [[AnyObject]]()
    
    //MARK: - Journal Item properties
    var headerTitles = [String]()
    
    var itemSelectedHeaderTitles = [String]()
    
    var rowArrays: [ [ String]] = [Array<String>]()
    
    var foodItems = [FoodItem]()
    
    


    
    override func viewDidLoad() {
        super.viewDidLoad()

        // add menu button to nav bar and set action
        if self.revealViewController() != nil {
            menuButton.target = self.revealViewController()
            menuButton.action = "revealToggle:"
            self.view.addGestureRecognizer(self.revealViewController().panGestureRecognizer())
        }
        
        //access data array in appDelegate
        //TODO - Needs to be a call to the DataStore that gets current Journal Item
        if let appDelegate = UIApplication.sharedApplication().delegate as? AppDelegate{
            
        dataArray = appDelegate.dataArray
        
        updateDetailViewHandler(self.detailDisplayItem!)

        var c = dataArray!.count
        }
        else
        {
            println("AppDelegate = nil")
        }
    }
    
    func updateDetailViewHandler(detailItem: DetailDisplayItem) {
        
        sectionData.removeAll(keepCapacity: false)
        
        switch detailItem {
        case let detailItem as BreakfastItems:
            headerTitles = detailItem.headerTitles
            itemSelectedHeaderTitles = detailItem.itemSelectedHeaderTitles
            sectionData.append(detailItem.breakfastChoice)
            sectionData.append(detailItem.fruit)
            sectionData.append(detailItem.mealDetails)
            
        case let detailItem as LunchItems:
            headerTitles = detailItem.headerTitles
            itemSelectedHeaderTitles = detailItem.itemSelectedHeaderTitles
            sectionData.append(detailItem.lunchChoice)
            sectionData.append(detailItem.fruitChoice)
            sectionData.append(detailItem.mealDetails)

        case let detailItem as DinnerItems:
            headerTitles = detailItem.headerTitles
            itemSelectedHeaderTitles = detailItem.itemSelectedHeaderTitles
            sectionData.append(detailItem.meat)
            sectionData.append(detailItem.starch)
            sectionData.append(detailItem.oil)
            sectionData.append(detailItem.vegetable)
            sectionData.append(detailItem.requiredItems)
            sectionData.append(detailItem.mealDetails)
            
        default:
            println("error")

        }
        
        self.tableView.reloadData()
    
    }
    
    override func viewWillAppear(animated: Bool) {
        
        //var dinnerItems: DinnerItems = (DinnerItem(), foodItems )
        //self.dataArray = DataStore().buildDetailViewArray()
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
                if currentItem.choiceItems.count > 2 {
                    //smaller segments when multiple choices
                    segControl.setWidth(60, forSegmentAtIndex: i)
                }
                else{
                    segControl.setWidth(110.0, forSegmentAtIndex: i)
                }
            }
            return cell
            
        case let currentItem as ParentInitials:
            let cell = tableView.dequeueReusableCellWithIdentifier("ParentInitialsCell", forIndexPath: indexPath) as ParentInitialsTableViewCell
            cell.titleLabel?.text = "Parent Initials"
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
            let cell = tableView.dequeueReusableCellWithIdentifier("Cell", forIndexPath: indexPath)  as UITableViewCell
            
            //if let newCell = cell as? UITableViewCell {
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
            if section < headerTitles.count
            {
            return headerTitles[section]
            }
            else{
                return "Error More sections than section Header Titles"
            }
        }
        
    }
    
    
    override func tableView(tableView: UITableView, didSelectRowAtIndexPath indexPath: NSIndexPath) {
        
        //TODO: Fix it so Additional Info Items never get deleted.  Hook up Status indicator when necessary items have been selected.
        var selectedRow = indexPath.row
        var selectedSection = indexPath.section
        
        var currentData = self.sectionData[indexPath.section]
        
        //TODO: send update meal item message to DataStore
        var currentItem: DetailDisplayItem = detailDisplayItem!
        var itemsArray = self.sectionData[indexPath.section]
        //switch on type here
        //var currentItem = self.detailDisplayItem
        switch currentItem {
        case let currentItem as BreakfastItems:
                if indexPath.section == 0 {
                    currentItem.item?.foodChoice = itemsArray[indexPath.row] as? FoodItem
                }
                else if indexPath.section == 1{
                    currentItem.item?.fruitChoice = itemsArray[indexPath.row] as? FoodItem
                }
        case let currentItem as LunchItems:
            if indexPath.section == 0 {
                currentItem.item?.meatChoice = itemsArray[indexPath.row] as? FoodItem
            }
            else {
                currentItem.item?.fruitChoice = itemsArray[indexPath.row] as? FoodItem
            }
        case let currentItem as DinnerItems:
            if indexPath.section == 0 {
                currentItem.dinnerItem.meat = itemsArray[indexPath.row] as? FoodItem
            }
            else if indexPath.section == 1{
                currentItem.dinnerItem.starch = itemsArray[indexPath.row] as? FoodItem
            }
            if indexPath.section == 2 {
                currentItem.dinnerItem.oil = itemsArray[indexPath.row] as? FoodItem
            }
            else if indexPath.section == 3 {
                currentItem.dinnerItem.vegetable = itemsArray[indexPath.row] as? FoodItem
            }
            if indexPath.section == 4 {
                currentItem.dinnerItem.requiredItems = itemsArray[indexPath.row] as? FoodItem
            }
            else if indexPath.section == 5 {
                //currentItem.dinnerItem.requiredItems = itemsArray[indexPath.row] as? FoodItem
            }


            /*
            var meat: FoodItem?
            var startch: FoodItem?
            var oil: FoodItem?
            var vegetable: FoodItem?
            var requiredItems: FoodItem?
            var mealDetails: FoodItem?
            */
            
        default:
            //handle other items here
            println("unimplemented code for non-meal items encountered")
        }
       
        var originalCountRowsInSection = sectionData[indexPath.section].count //rowArrays[selectedSection].count

        //collapse data
        //Remove data items --  need to remove data item as well as deleting rows from table
        deleteRowsInDataSource( originalCountRowsInSection , selectedRow: selectedRow,  selectedSection: selectedSection)
        
        // removed unselected cells in tableview section
        animateRowDeletion(selectedRow, rowsOriginallyInSection: originalCountRowsInSection, selectedSection: selectedSection)
        
    }
    
    func deleteRowsInDataSource ( originalCountRowsInSection: Int , selectedRow: Int, selectedSection: Int ){
        if originalCountRowsInSection > 0 {
            var index = originalCountRowsInSection
            while index >  0 {
                var positionInArray = index - 1
                if selectedRow != positionInArray {
                    sectionData[selectedSection].removeAtIndex(positionInArray)
                }
                index--
            }
        }
    }
    
    
    func animateRowDeletion ( selectedRow: Int, rowsOriginallyInSection: Int , selectedSection: Int){
        let rowsToDelete = indexPathForRowsToDelete(
            selectedRow,
            rowsOriginallyInSection: rowsOriginallyInSection,
            selectedSection: selectedSection
        )
        
        tableView.beginUpdates()
        tableView.deleteRowsAtIndexPaths(rowsToDelete, withRowAnimation: UITableViewRowAnimation.Automatic)
        tableView.endUpdates()
    }
    
    
    func indexPathForRowsToDelete (selectedRow: Int , rowsOriginallyInSection: Int, selectedSection: Int) -> [NSIndexPath] {
        
        var indexPathArray: [NSIndexPath] =  [NSIndexPath]()
        
        
        if rowsOriginallyInSection > 1 {
            for index in 0 ..< rowsOriginallyInSection {
                if selectedRow != index {
                    var indexPath = NSIndexPath(forRow: index , inSection: selectedSection)
                    indexPathArray.append(indexPath)
                }
            }
        }
        return indexPathArray
        
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
