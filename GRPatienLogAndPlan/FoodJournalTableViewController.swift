//
//  FoodJournalTableViewController.swift
//  CoreDataTest
//
//  Created by James Klein on 4/29/15.
//  Copyright (c) 2015 James Klein. All rights reserved.
//

import UIKit

public enum Meals {
    case Breakfast,
    MorningSnack,
    Lunch,
    AfternoonSnack ,
    Dinner,
    EveningSnack
    
    public static func configureMeals(profile: OPProfile){
        mealArray.removeAll(keepCapacity: false)
        mealArray.append(Meals.Breakfast)
        if profile.morningSnackRequired.boolValue {
            mealArray.append(Meals.MorningSnack)
        }
        mealArray.append(Meals.Lunch)
        mealArray.append(Meals.AfternoonSnack)
        mealArray.append(Meals.Dinner)
        if profile.eveningSnackRequired.boolValue {
            mealArray.append(Meals.EveningSnack)
        }
    }
    public static func count() -> Int { return mealArray.count }
    
    static var mealArray: [Meals] = [Meals]()
    
    static func all() -> [Meals] {
        return mealArray
    }
    
    public init?(rawValue: Int){
        //fail if index out of bounds
        if rawValue >= Meals.mealArray.count || rawValue < 0 { return nil }
        self = Meals.mealArray[rawValue]
    }

    
    func mealName () -> String {
        switch self{
        case .Breakfast:
            return "Breakfast"
        case .MorningSnack:
            return "Morning Snack"
        case .Lunch:
            return "Lunch"
        case .AfternoonSnack:
            return "Afternoon Snack"
        case .Dinner:
            return "Dinner"
        case .EveningSnack:
            return "Evening Snack"
        }
    }
    
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
        //dataArray = appDelegate!.dataArray
        dataStore = appDelegate!.dataStore
        self.currentDateHeader = dataStore.today
        }
    }
    override func viewWillAppear(animated: Bool) {
        
        self.tableView.reloadData()
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
    }
    
    @IBAction func nextDay(sender: AnyObject) {
        currentDateHeader = dataStore.selectNextDayJournalEntry()
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
        return Meals.count()
    }
    
    override func tableView(tableView: UITableView, titleForHeaderInSection section: Int) -> String? {
        return self.currentDateHeader
    }
    
    override func tableView(tableView: UITableView, cellForRowAtIndexPath indexPath: NSIndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCellWithIdentifier("Cell", forIndexPath: indexPath) as! UITableViewCell
        cell.textLabel!.text = Meals(rawValue: indexPath.row)?.mealName()
        return cell

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
