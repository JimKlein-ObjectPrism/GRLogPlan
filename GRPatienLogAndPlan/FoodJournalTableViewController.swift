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
    public static func configureMeals(entry: OPJournalEntry){
        mealArray.removeAll(keepCapacity: false)
        mealArray.append(Meals.Breakfast)
        if  entry.morningSnack != nil {
            mealArray.append(Meals.MorningSnack)
        }
        mealArray.append(Meals.Lunch)
        mealArray.append(Meals.AfternoonSnack)
        mealArray.append(Meals.Dinner)
        if entry.eveningSnack  != nil {
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

    public static func defaultMealTime (meal: Meals) -> String {
        switch meal {
        case .Breakfast:
            return "7:00 AM"
        case .MorningSnack:
            return "10:00 AM"
        case .Lunch:
            return "12:00 PM"
        case .AfternoonSnack:
            return "2:00 PM"
        case .Dinner:
            return "6:00 PM"
        case .EveningSnack:
            return "9:00 PM"
        }
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
    
    func menuItemSelectionComplete ( currentJournalEntry: OPJournalEntry) -> Bool {
        switch self {
        case .Breakfast:
            let breakfast = VMBreakfast(fromDataObject: currentJournalEntry.breakfast)
            let result = breakfast.validate()
            switch result {
            case .Success:
                return true
            case .Failure:
                return false
            }
            
        case .MorningSnack:
            let mSnack = VMSnack(fromDataObject: currentJournalEntry.morningSnack)
            let result = mSnack.validate()
            switch result {
            case .Success:
                return true
            case .Failure:
                return false
            }

        case .Lunch:
            let lunch = VMLunch(fromDataObject: currentJournalEntry.lunch)
            let result = lunch.validate()
            switch result {
            case .Success:
                return true
            case .Failure:
                return false
            }

        case .AfternoonSnack:
            let aSnack = VMSnack(fromDataObject: currentJournalEntry.afternoonSnack)
            let result = aSnack.validate()
            switch result {
            case .Success:
                return true
            case .Failure:
                return false
            }
        case .Dinner:
            let dinner = VMDinner(fromDataObject: currentJournalEntry.dinner)
            let result = dinner.validate()
            switch result {
            case .Success:
                return true
            case .Failure:
                return false
            }

        case .EveningSnack:
            let eSnack = VMSnack(fromDataObject: currentJournalEntry.eveningSnack)
            let result = eSnack.validate()
            switch result {
            case .Success:
                return true
            case .Failure:
                return false
            }

        }
    }
    
}

class FoodJournalTableViewController: UITableViewController {
    
    let dates = ["Wednesday, May 27, 2015","Tuesday, May 26, 2015","Monday, May 25, 2015","Sunday, May 24, 2015","Saturday, May 23, 2015", "Friday, May 22, 2015", "Thursday, May 21, 2015"]
    var currentDateIndex = 0
    var currentDateHeader: String!
    
    var selectedDate: String!
    
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
//        if currentDateHeader != dataStore.currentJournalEntry.date {
//        }
        getJournalEntryForDay(currentDateHeader)
        dataStore.updateMealCategoryEnumsAndProfileFields(dataStore.currentJournalEntry)
        // if currentDateHeader = today.
        self.tableView.reloadData()
    }
    func getJournalEntryForDay(day: String) -> String {
        let result = dataStore.getJournalEntry(day)
        //let a = entry.
        switch result {
        case .Success(let entry):
            if entry.date == dataStore.today {
                dataStore.currentJournalEntry = entry
                // update meal categories and meal item fiels
                dataStore.updateMealCategoryEnumsAndProfileFields()
                dataStore.initializeMealDataItems(dataStore.currentJournalEntry)
            } else {
                dataStore.currentJournalEntry = entry
                dataStore.initializeMealDataItems(dataStore.currentJournalEntry)
            }
            return entry.date
        case .WrongTypeOfEntryFound:
            print("Error encountered accessing Core Data.", terminator: "")
            return "Error."
        case .EntryDoesNotExist:
            dataStore.currentJournalEntry = dataStore.getNewJournalEntry(day)
            dataStore.initializeMealDataItems(dataStore.currentJournalEntry)
            dataStore.initializeMealCategoryEnumsAndProfileFields()
            return dataStore.currentJournalEntry.date
        case .Error:
            print("Error encountered accessing Core Data.", terminator: "")
            return "Error."
        }
    }
    
  
    func previousDay() -> String {
        returnPreviousDay(currentDateHeader)
        //let newCurrentJournalEntry = dataStore.selectPreviousDayJournalEntry()
        return currentDateHeader
    }
    
    @IBAction func nextDay(sender: AnyObject) {
        //currentDateHeader = dataStore.selectNextDayJournalEntry()
        returnNextDay(currentDateHeader)
        dataStore.updateMealCategoryEnumsAndProfileFields(dataStore.currentJournalEntry)
       tableView.reloadData()
    }
    
    func returnNextDay(currentlySelectedDate: String)  {
        
        let currentSelection = getDateFromString(currentlySelectedDate)
        let dayAfterCurrentSelectedDate = getDayFromOffSet(1, date: currentSelection)
        //let dStore = DataStore()
        let todaysDate = getDateFromString(dataStore.today)
        
        if currentSelection.compare(todaysDate) == NSComparisonResult.OrderedSame {
            // do nothing, reset to today's date
            currentDateHeader = getJournalEntryForDay(currentlySelectedDate)
            //return dStore.getJournalEntryForDate(todaysDate)
        } else if currentSelection.compare(todaysDate) == NSComparisonResult.OrderedAscending {
            //currentlySelectedDate occurs before today's date, so test
            currentDateHeader = getJournalEntryForDay(dayAfterCurrentSelectedDate)
        } else {
            //return today's date, the given date is out of range, return today's entry
            //fatalError("Index Out of Range")
            currentDateHeader = getJournalEntryForDay(currentlySelectedDate)
        }
    }
    func returnPreviousDay(currentlySelectedDate: String)  {
        
        let currentSelection = getDateFromString(currentlySelectedDate)
        let dayBeforeCurrentSelectedDate = getDayFromOffSet(-1, date: currentSelection)
        //let dStore = DataStore()
//        let todaysDate = getDateFromString(dataStore.today)
        
        currentDateHeader = getJournalEntryForDay(dayBeforeCurrentSelectedDate)
//        if currentSelection.compare(todaysDate) == NSComparisonResult.OrderedSame {
//            // do nothing, reset to today's date
//            currentDateHeader = getJournalEntryForDay(currentlySelectedDate)
//            //return dStore.getJournalEntryForDate(todaysDate)
//        } else if currentSelection.compare(todaysDate) == NSComparisonResult.OrderedAscending {
//            //currentlySelectedDate occurs before today's date, so test
//            currentDateHeader = getJournalEntryForDay(dayBeforeCurrentSelectedDate)
//        } else {
//            //return today's date, the given date is out of range, return today's entry
//            //fatalError("Index Out of Range")
//            currentDateHeader = getJournalEntryForDay(currentlySelectedDate)
//        }
    }

    
    func getDateFromString(dateStr:String) -> NSDate {
        let dateFmt = NSDateFormatter()
        dateFmt.dateFormat = "EEEE, MMMM d, yyyy"
        
        let newDate = dateFmt.dateFromString(dateStr)!
        
//        let date = NSDate()
//        let dateFormatter = NSDateFormatter()
        
        
        //dateFormatter.timeZone = NSTimeZone()
//        let localDate = dateFormatter.stringFromDate(date)
        
        
        return newDate
    }
    func getDayFromOffSet (offset: Int, date: NSDate) -> String{
        let dateFormatter = NSDateFormatter()
        dateFormatter.dateFormat = "EEEE, MMMM d, yyyy"
        dateFormatter.dateStyle = .FullStyle
        dateFormatter.stringFromDate(date)
        
        
        let calendar = NSCalendar.currentCalendar()
        let components = NSDateComponents()
        
        
        components.day = offset
        return dateFormatter.stringFromDate(calendar.dateByAddingComponents(components, toDate: date, options: [])!)
    }
    
    @IBAction func showPreviousDateButton(sender: AnyObject) {
        currentDateHeader = previousDay()
        dataStore.updateMealCategoryEnumsAndProfileFields(dataStore.currentJournalEntry)

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
        Meals.configureMeals(dataStore.currentJournalEntry)
        return Meals.count()
    }
    
    override func tableView(tableView: UITableView, titleForHeaderInSection section: Int) -> String? {
        return self.currentDateHeader
    }
    
    override func tableView(tableView: UITableView, cellForRowAtIndexPath indexPath: NSIndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCellWithIdentifier("Cell", forIndexPath: indexPath) 
        //configures Meals enum to reflect required snacks in current journal entry
        Meals.configureMeals(dataStore.currentJournalEntry)
        
        //let c = meal
        cell.textLabel!.text = Meals(rawValue: indexPath.row)?.mealName()
        cell.textLabel?.textColor = UIColor.blackColor()
        cell.detailTextLabel?.text = "reset"
        cell.detailTextLabel?.textColor = UIColor.clearColor()
        //println(BreakfastMenuCategory.count())

        
        switch checkMealStateValidationStatus(indexPath.row)
        {
        case .Success:
            cell.detailTextLabel!.text = "Complete"
            cell.detailTextLabel?.textColor = UIColor(red: 150.0/255.0, green: 185.0/255.0, blue: 118.0/255.0, alpha: 1.0)
            
        case .Failure:
            cell.textLabel?.textColor = UIColor.blackColor()
            
         }
        return cell

    }
    func checkMealStateValidationStatus(row: Int) -> ValidationResult {
        if let result = Meals(rawValue: row) {
        switch result{
            case .Breakfast:
                BreakfastMenuCategory.configureMenuChoice(dataStore.currentJournalEntry)
                //return dataStore.breakfast.validate()
                return  VMBreakfast(fromDataObject: dataStore.currentJournalEntry.breakfast).validate()
                //return dataStore.getBreakfast_Today().validate()
                
            case .MorningSnack:
                //return dataStore.morningSnack.validate()
                return VMSnack(fromDataObject: dataStore.currentJournalEntry.morningSnack).validate()// dataStore.getSnack_Today(SnackTime.Morning).validate()
                
            case .Lunch:
                //return dataStore.lunch.validate()
                return dataStore.getLunch_Today().validate()
                
            case .AfternoonSnack:
                //return dataStore.afternoonSnack.validate()
                return VMSnack(fromDataObject: dataStore.currentJournalEntry.afternoonSnack).validate()//dataStore.getSnack_Today(SnackTime.Afternoon).validate()
               
            case .Dinner:
                //return dataStore.dinner.validate()
                return dataStore.getDinner_Today().validate()
                
            case .EveningSnack:
                //return dataStore.eveningSnack.validate()
                return VMSnack(fromDataObject: dataStore.currentJournalEntry.eveningSnack).validate()//dataStore.getSnack_Today(SnackTime.Evening).validate()
                
        }
        }
        return ValidationResult.Failure([])
    }
    
    func showVC (navBarTitle: String, mealVMDelegage: MealViewModelDelegate, defaultMealTime: String){
        let vc : MealTrackingTableViewController = self.storyboard?.instantiateViewControllerWithIdentifier("MealTrackingVC") as! MealTrackingTableViewController
        vc.navigationItem.title = navBarTitle
        vc.vm = mealVMDelegage
        vc.vm.tableView = vc.tableView
        vc.vm.tableviewController = vc
        if let mealViewModel = vc.vm as? MealViewModel {
            mealViewModel.defaultMealTime = defaultMealTime
        }
        dataStore.updateMealCategoryEnumsAndProfileFields(dataStore.currentJournalEntry)
        self.showViewController(vc as UIViewController, sender: vc)
    }
    override func tableView(tableView: UITableView, didSelectRowAtIndexPath indexPath: NSIndexPath) {
        //Fill the detail view controller with the choices for the currently selected item.
        let selectedIndex = indexPath.row
        let meal = Meals(rawValue: selectedIndex)!
//        if let a = dataStore.currentJournalEntry.morningSnack {
//            let b = "b"
//        }
        
        //var meal = Meals.RawValue(selectedIndex)
        switch meal {
        case .Breakfast:
            let breakfastVM = BreakfastVM(dataStore: self.dataStore)
            breakfastVM.targetOPBreakfast = self.dataStore.currentJournalEntry.breakfast
            
            
            //set time to default when you set the target.  make default time a type method
            showVC("Breakfast", mealVMDelegage: breakfastVM as MealViewModelDelegate, defaultMealTime: Meals.defaultMealTime(meal))

           
        case .MorningSnack:
            let mSnack: MealViewModelDelegate = SnackVM(dataStore: self.dataStore, snackTime: SnackTime.Morning) as MealViewModelDelegate
            showVC("Morning Snack", mealVMDelegage: mSnack, defaultMealTime: Meals.defaultMealTime(meal))

        case .Lunch:
            let lunch: MealViewModelDelegate = LunchVM(dataStore: self.dataStore) as MealViewModelDelegate
            showVC("Lunch", mealVMDelegage: lunch, defaultMealTime: Meals.defaultMealTime(meal))
           
        case .AfternoonSnack:
            let mSnack: MealViewModelDelegate = SnackVM(dataStore: self.dataStore, snackTime: SnackTime.Afternoon) as MealViewModelDelegate
            showVC("Afternoon Snack", mealVMDelegage: mSnack, defaultMealTime: Meals.defaultMealTime(meal))
           
        case .Dinner:
            let dinner: MealViewModelDelegate = DinnerVM(dataStore: self.dataStore) as MealViewModelDelegate
            showVC("Dinner", mealVMDelegage: dinner, defaultMealTime: Meals.defaultMealTime(meal))

        case .EveningSnack:
            let mSnack: MealViewModelDelegate = SnackVM(dataStore: self.dataStore, snackTime: SnackTime.Evening) as MealViewModelDelegate
            showVC("Evening Snack", mealVMDelegage: mSnack, defaultMealTime: Meals.defaultMealTime(meal))
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
