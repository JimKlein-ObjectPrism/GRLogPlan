//
//  MenuTrackTableViewController.swift
//  GRPatienLogAndPlan
//
//  Created by Jim Klein on 2/25/15.
//  Copyright (c) 2015 ObjectPrism Corp. All rights reserved.
//

import UIKit

class MenuTrackTableViewController: UITableViewController {

    var dataArray: [AnyObject]!
    
    var menuItemSelectionHandler: MenuItemSelectedDelegate?
    
    

    override func viewDidLoad() {
        super.viewDidLoad()

        // Uncomment the following line to preserve selection between presentations
        // self.clearsSelectionOnViewWillAppear = false

        // Uncomment the following line to display an Edit button in the navigation bar for this view controller.
        // self.navigationItem.rightBarButtonItem = self.editButtonItem()
        let appDelegate = UIApplication.sharedApplication().delegate as AppDelegate
        self.navigationController?.navigationBar.barTintColor = UIColor(red: 150.0/255.0, green: 185.0/255.0, blue: 118.0/255.0, alpha: 1.0)
        
        dataArray = appDelegate.dataArray

        
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }

    // MARK: - Table view data source

    override func numberOfSectionsInTableView(tableView: UITableView) -> Int {
        // #warning Potentially incomplete method implementation.
        // Return the number of sections.
        return 1
    }
    
    override func tableView(tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        
        return self.dataArray.count
        
    }
    func handleSegmentedControlSelectionChanged(sender: UISegmentedControl)
    {
        var selectedIndex = sender.selectedSegmentIndex
    }
    
    override func tableView(tableView: UITableView, cellForRowAtIndexPath indexPath: NSIndexPath) -> UITableViewCell {
        
        var item: (AnyObject) = dataArray[indexPath.row]
        
                switch item {
        case let mealItem as BreakfastItems:
            var cell = tableView.dequeueReusableCellWithIdentifier("MenuCell", forIndexPath: indexPath) as MenuCellTableViewCell
            cell.titleLabel.text = "Breakfast"
            //cell.statusDisplayView.backgroundColor = UIColor.greenColor()
            return cell
            
        case let mealItem as LunchItems:
            var cell = tableView.dequeueReusableCellWithIdentifier("MenuCell", forIndexPath: indexPath) as MenuCellTableViewCell
            cell.titleLabel.text = "Lunch"
            return cell
            
        case let mealItem as DinnerItems:
            var cell = tableView.dequeueReusableCellWithIdentifier("MenuCell", forIndexPath: indexPath) as MenuCellTableViewCell
            cell.titleLabel.text = "Dinner"
            return cell
        case let mealItem as Snack:
            var cell = tableView.dequeueReusableCellWithIdentifier("MenuCell", forIndexPath: indexPath) as MenuCellTableViewCell
            cell.titleLabel.text = mealItem.menuDisplayName
            return cell
            
            
            
            //            case let mealItem as MenuDisplayCell:
            //                var cell = tableView.dequeueReusableCellWithIdentifier("MenuCell", forIndexPath: indexPath) as MenuCellTableViewCell
            //                //if let menuItem = item as? MenuDisplayCell {
            //                    cell.titleLabel.text = menu
            //                //}
            //                return cell
            
        default:
            var cell = tableView.dequeueReusableCellWithIdentifier("MenuCell", forIndexPath: indexPath) as MenuCellTableViewCell
            if let menuItem = item as? MenuDisplayCell {
                cell.titleLabel.text = menuItem.menuDisplayName
                return cell
            } else{
                return cell
                
            }
        }
    }

    override func tableView(tableView: UITableView, didSelectRowAtIndexPath indexPath: NSIndexPath) {
        
        //Fill the detail view controller with the choices for the currently selected item.
        var selectedIndex = indexPath.row
        
        switch selectedIndex {
        case 0:
            menuItemSelectionHandler?.menuItemSelectedHandler(Breakfast())
        case 1:
            menuItemSelectionHandler?.menuItemSelectedHandler(Lunch())
            // skipping Snack!
        case 3:
            menuItemSelectionHandler?.menuItemSelectedHandler(Dinner())
            
        default:
            println("Unfinished implementation")
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
