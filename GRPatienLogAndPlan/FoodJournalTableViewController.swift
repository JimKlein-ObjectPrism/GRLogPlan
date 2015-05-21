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
    
    var appDelegate: AppDelegate?
    
    var dataArray: [AnyObject]!
    
    var dataStore: DataStore!
    //MARK: Delegates
    var updateDetailViewDelegate: UpdateDetailViewDelegate!
    var menuItemSelectionHandler: MenuItemSelectedDelegate?
    
//    init(appDelegate: AppDelegate){
//        self.appDelegate = appDelegate
//        super.init(style: UITableViewStyle.Grouped)
//    }
//
//    required init!(coder aDecoder: NSCoder!) {
//        fatalError("init(coder:) has not been implemented")
//    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        self.appDelegate = UIApplication.sharedApplication().delegate as? AppDelegate
        self.navigationController?.navigationBar.barTintColor = UIColor(red: 150.0/255.0, green: 185.0/255.0, blue: 118.0/255.0, alpha: 1.0)
        
        if  self.appDelegate != nil {
        dataArray = appDelegate!.dataArray
        dataStore = appDelegate!.dataStore
        }
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
            let vc : MealTrackingTableViewController = self.storyboard?.instantiateViewControllerWithIdentifier("MealTrackingVC") as! MealTrackingTableViewController
            
            vc.navigationItem.title = "Breakfast"
            let vm: BreakfastVM =  BreakfastVM (dataStore: appDelegate!.dataStore)
            
            
            vc.vm = vm
            vm.tableView = vc.tableView
            vm.tableviewController = vc
            self.showViewController(vc as UIViewController, sender: vc)
            
//            var vc : TrackTableViewController = self.storyboard?.instantiateViewControllerWithIdentifier("TrackVC") as! TrackTableViewController

//            var breakfastItem: BreakfastItems = dataStore.buildBreakfastItems(dataStore.loadProfile(), journalItem: dataStore.buildJournalEntry(dataStore.loadProfile()))
//            vc.detailDisplayItem = breakfastItem
//            self.showViewController(vc as UIViewController, sender: self)
//            
        case .MorningSnack:
            let mSnack: MealViewModelDelegate = SnackVM(dataStore: self.dataStore, snackTime: SnackTime.Morning) as MealViewModelDelegate
            showVC("Morning Snack", mealVMDelegage: mSnack)

//            var vc : TrackTableViewController = self.storyboard?.instantiateViewControllerWithIdentifier("TrackVC") as! TrackTableViewController
//            vc.navigationItem.title = "Morning Snack"
//            var breakfastItem: BreakfastItems = dataStore.buildSnackItems(dataStore.loadProfile(), journalItem: dataStore.buildJournalEntry(dataStore.loadProfile()))
//            vc.detailDisplayItem = breakfastItem
//            self.showViewController(vc as UIViewController, sender: self)

        case .Lunch:
            let lunch: MealViewModelDelegate = LunchVM(dataStore: self.dataStore) as MealViewModelDelegate
            showVC("Lunch", mealVMDelegage: lunch)
//            var vc : TrackTableViewController = self.storyboard?.instantiateViewControllerWithIdentifier("TrackVC") as! TrackTableViewController
//            vc.navigationItem.title = "Lunch"
//            var lunchItem: LunchItems = dataStore.buildLunchItems(dataStore.loadProfile(), journalItem: dataStore.buildJournalEntry(dataStore.loadProfile()))
//            vc.detailDisplayItem = lunchItem
//            self.showViewController(vc as UIViewController, sender: self)
            
        case .AfternoonSnack:
            let mSnack: MealViewModelDelegate = SnackVM(dataStore: self.dataStore, snackTime: SnackTime.Afternoon) as MealViewModelDelegate
            showVC("Afternoon Snack", mealVMDelegage: mSnack)
           
        case .Dinner:
            let dinner: MealViewModelDelegate = DinnerVM(dataStore: self.dataStore) as MealViewModelDelegate
            showVC("Dinner", mealVMDelegage: dinner)

            
//            var vc : TrackTableViewController = self.storyboard?.instantiateViewControllerWithIdentifier("TrackVC") as! TrackTableViewController
//            vc.navigationItem.title = "Dinner"
//            var dinnerItem: DinnerItems = dataStore.buildDinnerItems(dataStore.loadProfile(), journalItem: dataStore.buildJournalEntry(dataStore.loadProfile()))
//            vc.detailDisplayItem = dinnerItem
//            self.showViewController(vc as UIViewController, sender: self)
            

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
