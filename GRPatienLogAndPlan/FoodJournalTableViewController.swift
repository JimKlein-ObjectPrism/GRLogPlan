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

    let dates = ["Wednesday, May 27, 2015","Tuesday, May 26, 2015","Monday, May 25, 2015","Sunday, May 24, 2015","Saturday, May 23, 2015", "Friday, May 22, 2015", "Thursday, May 21, 2015"]
    var currentDateIndex = 0
    var currentDateHeader = "Wednesday, May 27, 2015"
    
    var appDelegate: AppDelegate?
    
    var dataArray: [AnyObject]!
    
    var dataStore: DataStore!
    //MARK: Delegates
    var updateDetailViewDelegate: UpdateDetailViewDelegate!
    var menuItemSelectionHandler: MenuItemSelectedDelegate?
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        self.appDelegate = UIApplication.sharedApplication().delegate as? AppDelegate
        self.navigationController?.navigationBar.barTintColor = UIColor(red: 150.0/255.0, green: 185.0/255.0, blue: 118.0/255.0, alpha: 1.0)
        
        if  self.appDelegate != nil {
        dataArray = appDelegate!.dataArray
        dataStore = appDelegate!.dataStore
        self.currentDateHeader = dataStore.today
        }
    }
    
    func getLast7Days(){
        let calendar = NSCalendar.currentCalendar()
        let date = NSDate()
        
        let components = NSDateComponents()
        components.day = 1
        
        
        println("1 day ago: \(calendar.dateByAddingComponents(components, toDate: date, options: nil))")
    }
  
    func previousDay() -> String {
        return dataStore.selectPreviousDayJournalEntry()
//        if currentDateIndex < dates.count - 1 {
//            currentDateIndex++
//            return dates[currentDateIndex]
//        } else {
//            //return last day in array
//            return dates[currentDateIndex]
//        }
    }
    
    @IBAction func nextDay(sender: AnyObject) {
        currentDateHeader = dataStore.selectNextDayJournalEntry()
//        // Use show Previous naminig convention
//        if currentDateIndex > 0 {
//            currentDateIndex--
//            currentDateHeader = dates[currentDateIndex]
//        } else {
//            //return last day in array
//            currentDateHeader = dates[currentDateIndex]
//        }
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
        return 1
    }

    override func tableView(tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return 6
    }
    
    override func tableView(tableView: UITableView, titleForHeaderInSection section: Int) -> String? {
        return self.currentDateHeader
    }
    
    func showVC (navBarTitle: String, mealVMDelegage: MealViewModelDelegate){
        let vc : MealTrackingTableViewController = self.storyboard?.instantiateViewControllerWithIdentifier("MealTrackingVC") as! MealTrackingTableViewController
        vc.navigationItem.title = navBarTitle
        vc.vm = mealVMDelegage
        vc.vm.tableView = vc.tableView
        vc.vm.tableviewController = vc
        self.showViewController(vc as UIViewController, sender: vc)
    }
    override func tableView(tableView: UITableView, didSelectRowAtIndexPath indexPath: NSIndexPath) {
        
        //Fill the detail view controller with the choices for the currently selected item.
        let selectedIndex = indexPath.row
        let meal = Meals(rawValue: selectedIndex)!
        
        //var meal = Meals.RawValue(selectedIndex)
        switch meal {
        case .Breakfast:
            let breakfastVM = BreakfastVM(dataStore: self.dataStore)
            breakfastVM.targetOPBreakfast = self.dataStore.currentJournalEntry.breakfast
            
            showVC("Breakfast", mealVMDelegage: breakfastVM as MealViewModelDelegate)

//            let vc : MealTrackingTableViewController = self.storyboard?.instantiateViewControllerWithIdentifier("MealTrackingVC") as! MealTrackingTableViewController
//            
//            vc.navigationItem.title = "Breakfast"
//            let vm: BreakfastVM =  BreakfastVM (dataStore: appDelegate!.dataStore)
//            
//            
//            vc.vm = vm
//            vm.tableView = vc.tableView
//            vm.tableviewController = vc
//            self.showViewController(vc as UIViewController, sender: vc)
            
        case .MorningSnack:
            let mSnack: MealViewModelDelegate = SnackVM(dataStore: self.dataStore, snackTime: SnackTime.Morning) as MealViewModelDelegate
            showVC("Morning Snack", mealVMDelegage: mSnack)

        case .Lunch:
            let lunch: MealViewModelDelegate = LunchVM(dataStore: self.dataStore) as MealViewModelDelegate
            showVC("Lunch", mealVMDelegage: lunch)
           
        case .AfternoonSnack:
            let mSnack: MealViewModelDelegate = SnackVM(dataStore: self.dataStore, snackTime: SnackTime.Afternoon) as MealViewModelDelegate
            showVC("Afternoon Snack", mealVMDelegage: mSnack)
           
        case .Dinner:
            let dinner: MealViewModelDelegate = DinnerVM(dataStore: self.dataStore) as MealViewModelDelegate
            showVC("Dinner", mealVMDelegage: dinner)

        case .EveningSnack:
            let mSnack: MealViewModelDelegate = SnackVM(dataStore: self.dataStore, snackTime: SnackTime.Evening) as MealViewModelDelegate
            showVC("Evening Snack", mealVMDelegage: mSnack)
        }
    }
    
    func pushDetailsVC(displayItem: DetailDisplayItem, navItemTitle: String) {
        
        //var parents =  AppDelegate.profileDataStore.getParents()
        let vc : TrackTableViewController = self.storyboard?.instantiateViewControllerWithIdentifier("TrackNavController") as! TrackTableViewController
        vc.navigationItem.title = "Breakfast"
        //vc.currentDisplayType = ParentViewControllerDisplayType.Parents
        
        //set delegate property
        //vc.parents = parents
        //vc.dataStoreDelegate = AppDelegate.profileDataStore
        
        self.showViewController(vc as UIViewController, sender: vc)
        
    }


}
