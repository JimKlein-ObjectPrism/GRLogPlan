//
//  FoodJournalTableViewController.swift
//  CoreDataTest
//
//  Created by James Klein on 4/29/15.
//  Copyright (c) 2015 James Klein. All rights reserved.
//

import UIKit

enum Meals: Int {
    case Breakfast = 0,
    MorningSnack,
    Lunch,
    AfternoonSnack ,
    Dinner,
    EveningSnack
}

class FoodJournalTableViewController: UITableViewController {

    let dates = ["Thursday, April 30, 2015", "Wednesday, April 29, 2015","Tuesday, April 28, 2015","Monday, April 27, 2015","Sunday, April 26, 2015","Saturday, April 25, 2015", "Friday, April 24, 2015"]
    var currentDateIndex = 0
    var currentDateHeader = "Thursday, April 30, 2015"
    
    var dataArray: [AnyObject]!
    
    var dataStore: DataStore!
    //MARK: Delegates
    var updateDetailViewDelegate: UpdateDetailViewDelegate!
    var menuItemSelectionHandler: MenuItemSelectedDelegate?
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        let appDelegate = UIApplication.sharedApplication().delegate as AppDelegate
        self.navigationController?.navigationBar.barTintColor = UIColor(red: 150.0/255.0, green: 185.0/255.0, blue: 118.0/255.0, alpha: 1.0)
        
        dataArray = appDelegate.dataArray
        dataStore = appDelegate.dataStore
        
    }
  
    func previousDay() -> String {
        if currentDateIndex < dates.count - 1 {
            currentDateIndex++
            return dates[currentDateIndex]
        } else {
            //return last day in array
            return dates[currentDateIndex]
        }
    }
    
    @IBAction func nextDay(sender: AnyObject) {
        // Use show Previous naminig convention
        if currentDateIndex > 0 {
            currentDateIndex--
            currentDateHeader = dates[currentDateIndex]
        } else {
            //return last day in array
            currentDateHeader = dates[currentDateIndex]
        }
        tableView.reloadData()
    }

    @IBAction func showPreviousDateButton(sender: AnyObject) {
        currentDateHeader = previousDay()
        tableView.reloadData()
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
        // #warning Incomplete method implementation.
        // Return the number of rows in the section.
        return 6
    }
    
    override func tableView(tableView: UITableView, titleForHeaderInSection section: Int) -> String? {
        return self.currentDateHeader
    }
    
    override func tableView(tableView: UITableView, didSelectRowAtIndexPath indexPath: NSIndexPath) {
        
        //Fill the detail view controller with the choices for the currently selected item.
        let selectedIndex = indexPath.row
        let meal = Meals(rawValue: selectedIndex)!
        
        //var meal = Meals.RawValue(selectedIndex)
        switch meal {
        case .Breakfast:
            var vc : TrackTableViewController = self.storyboard?.instantiateViewControllerWithIdentifier("TrackVC") as TrackTableViewController
            vc.navigationItem.title = "Breakfast"
            var breakfastItem: BreakfastItems = dataStore.buildBreakfastItems(dataStore.loadProfile(), journalItem: dataStore.buildJournalEntry(dataStore.loadProfile()))
            vc.detailDisplayItem = breakfastItem
            self.showViewController(vc as UIViewController, sender: self)
            
        case .MorningSnack:
            menuItemSelectionHandler?.menuItemSelectedHandler(Lunch())
            // skipping Snack!
        case .Lunch:
            var vc : TrackTableViewController = self.storyboard?.instantiateViewControllerWithIdentifier("TrackVC") as TrackTableViewController
            vc.navigationItem.title = "Lunch"
            var lunchItem: LunchItems = dataStore.buildLunchItems(dataStore.loadProfile(), journalItem: dataStore.buildJournalEntry(dataStore.loadProfile()))
            vc.detailDisplayItem = lunchItem
            self.showViewController(vc as UIViewController, sender: self)
            
        case .AfternoonSnack:
            menuItemSelectionHandler?.menuItemSelectedHandler(Lunch())
            // skipping Snack!
        case .Dinner:
            var vc : TrackTableViewController = self.storyboard?.instantiateViewControllerWithIdentifier("TrackVC") as TrackTableViewController
            vc.navigationItem.title = "Dinner"
            var dinnerItem: DinnerItems = dataStore.buildDinnerItems(dataStore.loadProfile(), journalItem: dataStore.buildJournalEntry(dataStore.loadProfile()))
            vc.detailDisplayItem = dinnerItem
            self.showViewController(vc as UIViewController, sender: self)
            

        default:
            println("Unfinished implementation")
        }
    }
    
    func pushDetailsVC(displayItem: DetailDisplayItem, navItemTitle: String) {
        
        //var parents =  AppDelegate.profileDataStore.getParents()
        let vc : TrackTableViewController = self.storyboard?.instantiateViewControllerWithIdentifier("TrackNavController") as TrackTableViewController
        vc.navigationItem.title = "Breakfast"
        //vc.currentDisplayType = ParentViewControllerDisplayType.Parents
        
        //set delegate property
        //vc.parents = parents
        //vc.dataStoreDelegate = AppDelegate.profileDataStore
        
        self.showViewController(vc as UIViewController, sender: vc)
        
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
