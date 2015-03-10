//
//  ViewController.swift
//  FoodItemDataStoreTest
//
//  Created by Jim Klein on 2/17/15.
//  Copyright (c) 2015 ObjectPrism Corp. All rights reserved.
//

import UIKit

class TrackViewController: UIViewController, UITableViewDataSource, UITableViewDelegate, UIPopoverPresentationControllerDelegate {
    
    //var popoverController: MenuTableViewController!
    var dataArray = [AnyObject]()

    //MARK: - Journal Item properties
    var headerTitles = [String]()
    
    var itemSelectedHeaderTitles = [String]()
    
    var rowArrays: [ [ String]] = [Array<String>]()
    
    var foodItems = [FoodItem]()
    
    
    var sectionData: [[AnyObject]] = [[AnyObject]]()

    
    override func viewDidLoad() {
        super.viewDidLoad()
        // In this test project, function calls and property setters in viewDidLoad would normally be handled in the prepareforSegue method in the Home View Controller.
    
        
    }
    
    override func viewWillAppear(animated: Bool) {

//        //var dinnerItems: DinnerItems = (DinnerItem(), foodItems )
//        self.dataArray = DataStore().buildDetailViewArray()
//        
//        
//        if let bItem = self.dataArray[0] as? BreakfastItems {
////          currentBreakfastItem = bItem
//            headerTitles = bItem.headerTitles
//            itemSelectedHeaderTitles = bItem.itemSelectedHeaderTitles
//            sectionData.append(bItem.breakfastChoice)
//            sectionData.append(bItem.fruit)
//            sectionData.append(bItem.mealDetails)
//        }
//        
//        if let lItem = self.dataArray[0] as? LunchItems {
//            headerTitles = lItem.headerTitles
//            itemSelectedHeaderTitles = lItem.itemSelectedHeaderTitles
//            sectionData.append(lItem.lunchChoice)
//            sectionData.append(lItem.fruitChoice)
//            sectionData.append(lItem.mealDetails)
//        }
//        if let dItem = self.dataArray[0] as? DinnerItems {
//            headerTitles = dItem.headerTitles
//            itemSelectedHeaderTitles = dItem.itemSelectedHeaderTitles
//            sectionData.append(dItem.meat)
//            sectionData.append(dItem.starch)
//            sectionData.append(dItem.oil)
//            sectionData.append(dItem.vegetable)
//            sectionData.append(dItem.requiredItems)
//            sectionData.append(dItem.mealDetails)
//
//        }
//        
        
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }

    // MARK: - Table view data source
    
    func numberOfSectionsInTableView(tableView: UITableView) -> Int {
        // #warning Potentially incomplete method implementation.
        // Return the number of sections.
        return self.sectionData.count
    }
    
    func tableView(tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        
        return self.sectionData[section].count
        
    }
    func handleSegmentedControlSelectionChanged(sender: UISegmentedControl)
    {
        var selectedIndex = sender.selectedSegmentIndex
    }
    
    func tableView(tableView: UITableView, cellForRowAtIndexPath indexPath: NSIndexPath) -> UITableViewCell {
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
                cell.choiceSegmentControl.addTarget(self, action: "handleSegmentedControlSelectionChanged:", forControlEvents: .ValueChanged)
                //cell.choiceSegmentControl.numberOfSegments = foodItem.choiceItems.count
                
                for i in 0 ..< currentItem.choiceItems.count {
                    if i  < 2 {
                        var choiceItem = currentItem.choiceItems[i]
                        cell.choiceSegmentControl.setTitle(choiceItem.itemDescription, forSegmentAtIndex: i)
                     }
                    else{
                        cell.choiceSegmentControl.insertSegmentWithTitle(currentItem.choiceItems[i].itemDescription, atIndex: i, animated: false)
                    }
                    cell.choiceSegmentControl.setWidth(110.0, forSegmentAtIndex: i)
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
    
    func tableView(tableView: UITableView, titleForHeaderInSection section: Int) -> String? {

        if self.sectionData[section].count == 1{
            return self.itemSelectedHeaderTitles[section]
            }
        else {
            return headerTitles[section]
            }

    }
    
    func tableView(tableView: UITableView, didSelectRowAtIndexPath indexPath: NSIndexPath) {
        
        //TODO: Fix it so Additional Info Items never get deleted.  Hook up Status indicator when necessary items have been selected.
        var selectedRow = indexPath.row
        var selectedSection = indexPath.section
        
        var currentData = self.sectionData[indexPath.section]
        
        if let breakfastItem = dataArray[0] as? BreakfastItems {
            var itemsArray = self.sectionData[indexPath.section]
            if indexPath.section == 0 {
            breakfastItem.item?.foodChoice = itemsArray[indexPath.row] as? FoodItem
            }
            else {
                breakfastItem.item?.fruitChoice = itemsArray[indexPath.row] as? FoodItem
            }
            
            if let foodChoice = breakfastItem.item?.foodChoice  {
                println(foodChoice.name)
            }
            if let fruitChoice = breakfastItem.item?.fruitChoice  {
                println(fruitChoice.name)
            }
        }
        
        var originalCountRowsInSection = sectionData[indexPath.section].count //rowArrays[selectedSection].count
        
        //collapse data
        //Remove data items --  need to remove data item as well as deleting rows from table
        if originalCountRowsInSection > 0 {
            var index = originalCountRowsInSection
            while index >  0 {
                var positionInArray = index - 1
                if selectedRow != positionInArray {
                    sectionData[indexPath.section].removeAtIndex(positionInArray)
                }
                index--
            }
        }
        var test = sectionData[indexPath.section].count

        // removed unselected cells in tableview section
        let rowsToDelete = indexPathForRowsToDelete(selectedRow, rowsOriginallyInSection: originalCountRowsInSection, selectedSection: selectedSection)
        
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
    // Override to support conditional editing of the table view.

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
    
    
    // MARK: - Navigation
    
    // In a storyboard-based application, you will often want to do a little preparation before navigation
//    override func prepareForSegue(segue: UIStoryboardSegue, sender: AnyObject?) {
//        
//        if let controller = segue.destinationViewController as? MenuTableViewController {
//            //set data source property
//            controller.dataArray = dataArray
//            //set delegate so it calls the adaptivePresentationStyle... method
//            controller.popoverPresentationController!.delegate = self
//            //set size
//            controller.preferredContentSize = CGSize(width: 320, height: 486)
//        }
//        

        
//        // if multiple segues are present test for Segue Identifier
//        
//        
//        let storyboard: UIStoryboard = UIStoryboard(name: "Main", bundle: nil)
//        
//        // This is the view that is displayed in the popover
//        //alternatively, you could use segue.destinationViewController
//        var contentViewController = storyboard.instantiateViewControllerWithIdentifier("TableView") as MenuTableViewController
//        
//        contentViewController.modalPresentationStyle = UIModalPresentationStyle.Popover
//        
//        //This view launches the popover and contains the button that the popover is anchored to
//        var detailPopover: UIPopoverPresentationController = contentViewController.popoverPresentationController!
//        
//        detailPopover.barButtonItem = sender as UIBarButtonItem
//        
//        detailPopover.permittedArrowDirections = UIPopoverArrowDirection.Any
//        
//        //detailPopover.delegate = self
//        
//        presentViewController( contentViewController, animated: true, completion: nil)
//        
        
//    }
    
    func adaptivePresentationStyleForPresentationController( controller: UIPresentationController!) -> UIModalPresentationStyle {
        return UIModalPresentationStyle.None
    }

//    func tableView(tableView: UITableView, didSelectRowAtIndexPath indexPath: NSIndexPath) {
//        
//        //Fill the detail view controller with the choices for the currently selected item.
////        var selectedIndex = indexPath.row
////        
////        switch selectedIndex {
////        case 0:
////            
////            if let delegate = detailViewDelegate{
////                var breakfast = Breakfast()
////                breakfast.foodChoice = BreakfastFoodChoice.CerealMilkEggs
////                delegate.detailViewShowContent(breakfast)
////            }
////            else{
////                println("No delegate")
////                
////            }
////            
////            
////            
////        default:
////            println("reached default in error")
////        }
////    }
//
//}
    //MARK: Actions
    @IBAction func showPopup(sender: AnyObject) {
        
        //prepareForSegue(UIStoryboardSegue( "ShowPopover", self, ) , sender: sender)
    }
  

}