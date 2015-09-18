//
//  HomeViewController.swift
//  GRPatienLogAndPlan
//
//  Created by James Klein on 3/9/15.
//  Copyright (c) 2015 ObjectPrism Corp. All rights reserved.
//

import UIKit


class HomeViewController: UIViewController, UITableViewDataSource, UITableViewDelegate, UIPopoverPresentationControllerDelegate {

    var timer: NSTimer!
    
    var dataStore: DataStore!
    var appDelegate: AppDelegate!
    @IBOutlet weak var summaryTextView: UITextView!
    
    @IBOutlet weak var dayLabel: UILabel!
    @IBOutlet weak var mealTitle: UILabel!
    override func viewDidLoad() {
        super.viewDidLoad()
        if let aDelegate = UIApplication.sharedApplication().delegate as? AppDelegate{
            //set local property to data array in appDelegate
                dataStore = aDelegate.dataStore
                appDelegate = aDelegate
                appDelegate.todaysDate = dataStore.today
             }
        
        self.navigationController?.navigationBar.barTintColor = UIColor(red: 150.0/255.0, green: 185.0/255.0, blue: 118.0/255.0, alpha: 1.0)

//        //Timer for updating meal state
//        let timerPeriod = 10//dataStore.mealState.timeRemainingInCurrentTimeRange()
//        
//        self.timer = NSTimer.scheduledTimerWithTimeInterval(NSTimeInterval(timerPeriod), target: self, selector: "updateMealState", userInfo: nil, repeats: false)
        
        NSNotificationCenter.defaultCenter().addObserver(self, selector: Selector("applicationDidBecomeActive:"), name: UIApplicationDidBecomeActiveNotification, object: nil)
    
    }

    func displayInitialSetup () {
        let vc : ProfileTableViewController = self.storyboard?.instantiateViewControllerWithIdentifier("ProfileTableViewController") as! ProfileTableViewController
        
        vc.navigationItem.title = "Initial Setup"
        vc.initialSetup = true
        
        vc.preferredContentSize = CGSizeMake(100, 100);
        
        var navigationController = UINavigationController(rootViewController: vc)
        navigationController.preferredContentSize = CGSizeMake(100, 100);
        //presentViewController(navigationController, animated: true, completion: nil)
//        let identifier = QOS_CLASS_BACKGROUND
//        let queue = dispatch_get_global_queue(identifier, 0)
        //dispatch_async(queue) { self.showController(self.tabBarController!, navController: navigationController ) }
        
        //dispatch_async_f(
        //dispatch_async_f( dispatch_get_global_queue(identifier, 0), nil, showController(self.tabBarController!, navigationController) )
        self.navigationController!.presentViewController(navigationController, animated: true, completion: nil)
    }

    func showController ( tabBarController: UITabBarController,  navController: UINavigationController ) {
        tabBarController.presentViewController(navController, animated: true, completion: nil)
    }
    override func viewWillDisappear(animated: Bool) {
        if timer != nil {
            timer.invalidate()
            timer = nil
        }
    }
    func applicationDidBecomeActive(notification: NSNotification) {
        if let topController = UIApplication.topViewController()
        {
            if let currentVC = topController as? HomeViewController {
                dataStore.mealState = MealState.getMealState(NSDate())
                dataStore.currentJournalEntry = dataStore.getJournalEntry_Today()
                dataStore.initializeMealDataItems(dataStore.getJournalEntry_Today())
                var dateFormatter = NSDateFormatter()
                dateFormatter.dateFormat = "EEEE, MMMM d"
                
                dayLabel.text = dateFormatter.stringFromDate(NSDate())
                mealTitle.text = dataStore.mealState.mealName()
//                println(mealTitle.text)

                summaryTextView.text = getMealStateValidationStatus(dataStore.mealState)
                
                //Timer for updating meal state
                let timerPeriod = dataStore.mealState.timeRemainingInCurrentTimeRange()
                
                self.timer = NSTimer.scheduledTimerWithTimeInterval(NSTimeInterval(timerPeriod), target: self, selector: "updateMealInfo", userInfo: nil, repeats: false)

            }
        }
        
 
        
    }

    override func viewWillAppear(animated: Bool) {

        dataStore.currentJournalEntry = dataStore.getJournalEntry_Today()
        dataStore.updateMealCategoryEnumsAndProfileFields()
        dataStore.initializeMealDataItems(dataStore.currentJournalEntry)
        
        let ms = MealState.getMealState(NSDate())
        dataStore.mealState = ms
        mealTitle.text = ms.mealName()
        //println("View Will Appear: \(mealTitle.text)")
        var dateFormatter = NSDateFormatter()
        dateFormatter.dateFormat = "EEEE, MMMM d"
        
        dayLabel.text = dateFormatter.stringFromDate(NSDate())

        summaryTextView.text = getMealStateValidationStatus(ms)
        
        //Timer for updating meal state
        let timerPeriod = dataStore.mealState.timeRemainingInCurrentTimeRange()
        
        self.timer = NSTimer.scheduledTimerWithTimeInterval(NSTimeInterval(timerPeriod), target: self, selector: "applicationDidBecomeActive:", userInfo: nil, repeats: false)

    }
    
    override func  viewDidAppear(animated: Bool) {
        let defaults = NSUserDefaults.standardUserDefaults()
        
        if let profile = defaults.valueForKey("profileIsValid") as? Bool  {
            if profile == true { // profile incomplete, so display profile vc
                return
            }
            else
            {  // setup incomplete
                displayInitialSetup()
            }
        }
        else  // key doesn't exist:  display profile vc
        {
            displayInitialSetup()
        }
        
    }
    
    func getMealStateValidationStatus(mealState: MealState) -> String {
        dataStore.currentJournalEntry = dataStore.todayJournalEntry
        dataStore.initializeMealDataItems(dataStore.currentJournalEntry)
        return statusStringForCurrentMeal(mealState.mealName(), validationResult: checkMealStateValidationStatus(mealState, dataStore: dataStore))
        
//        switch mealState{
//        case .Breakfast:
//            let status = VMBreakfast(fromDataObject: dataStore.currentJournalEntry.breakfast).validate()
//            return statusStringForCurrentMeal(mealState.mealName(), validationResult: status)
//        case .MorningSnack:
//            let status = dataStore.getSnack_Today(SnackTime.Morning).validate()
//            return statusStringForCurrentMeal(mealState.mealName(), validationResult: status)
//        case .Lunch:
//            let status = dataStore.getLunch_Today().validate()
//            return statusStringForCurrentMeal(mealState.mealName(), validationResult: status)
//        case .AfternoonSnack:
//            let snack = dataStore.getSnack_Today(SnackTime.Afternoon)
//            let status = snack.validate()
//            return statusStringForCurrentMeal(mealState.mealName(), validationResult: status)
//        case .Dinner:
//            let status = dataStore.getDinner_Today().validate()
//            return statusStringForCurrentMeal(mealState.mealName(), validationResult: status)
//        case .EveningSnack:
//            let status = dataStore.getSnack_Today(SnackTime.Evening).validate()
//            return statusStringForCurrentMeal(mealState.mealName(), validationResult: status)
//        }
    }
    
    func statusStringForCurrentMeal(mealName: String, validationResult: ValidationResult) -> String{
        switch validationResult{
        case .Failure:
            return "\(mealName) Log Incomplete."
        case .Success:
            return "\(mealName) Log Complete."
        }
    }
    
    func updateMealInfo () {
        dataStore.mealState.next()
        timer.invalidate()
        let fullPeriodToNextUpdate = dataStore.mealState.timeRangeLength()
        timer = NSTimer.scheduledTimerWithTimeInterval(NSTimeInterval(fullPeriodToNextUpdate), target: self, selector: "updateMealInfo", userInfo: nil, repeats: false)
        mealTitle.text = dataStore.mealState.mealName()
        summaryTextView.text = getMealStateValidationStatus(dataStore.mealState)
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
            as! HomeLogItemTableViewCell
            
        cell.parent = self
        return cell
        }
        else{
            let cell = tableView.dequeueReusableCellWithIdentifier("Home_DetailedEntryCell", forIndexPath: indexPath)
                as! DetailedJournalEntryTableViewCell
            return cell
        }
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
        dataStore.currentJournalEntry = dataStore.getJournalEntry_Today()
        let meal = dataStore.mealState!
        switch meal {
        case .Breakfast:
            let breakfastVM = BreakfastVM(dataStore: self.dataStore)
            //breakfastVM.targetOPBreakfast = self.dataStore.todayJournalEntry.breakfast
            showVC(meal.mealName(), mealVMDelegage: breakfastVM as MealViewModelDelegate)
            
        case .MorningSnack:
            let mSnack: MealViewModelDelegate = SnackVM(dataStore: self.dataStore, snackTime: SnackTime.Morning) as MealViewModelDelegate
            showVC(meal.mealName(), mealVMDelegage: mSnack)
            
        case .Lunch:
            let lunch: MealViewModelDelegate = LunchVM(dataStore: self.dataStore) as MealViewModelDelegate
            showVC(meal.mealName(), mealVMDelegage: lunch)
            
        case .AfternoonSnack:
            let mSnack: MealViewModelDelegate = SnackVM(dataStore: self.dataStore, snackTime: SnackTime.Afternoon) as MealViewModelDelegate
            showVC(meal.mealName(), mealVMDelegage: mSnack)
            
        case .Dinner:
            let dinner: MealViewModelDelegate = DinnerVM(dataStore: self.dataStore) as MealViewModelDelegate
            showVC(meal.mealName(), mealVMDelegage: dinner)
            
        case .EveningSnack:
            let mSnack: MealViewModelDelegate = SnackVM(dataStore: self.dataStore, snackTime: SnackTime.Evening) as MealViewModelDelegate
            showVC(meal.mealName(), mealVMDelegage: mSnack)
        }

    }
    func showVC (navBarTitle: String, mealVMDelegage: MealViewModelDelegate){
        let vc : MealTrackingTableViewController = self.storyboard?.instantiateViewControllerWithIdentifier("MealTrackingVC") as! MealTrackingTableViewController
        vc.navigationItem.title = navBarTitle
        vc.vm = mealVMDelegage
        vc.vm.tableView = vc.tableView
        vc.vm.tableviewController = vc
        self.showViewController(vc as UIViewController, sender: vc)
    }

    override func prepareForSegue(segue: UIStoryboardSegue, sender: AnyObject?) {
        if segue.identifier == "MyMealsRecipesSegue" {
            if let navc = segue.destinationViewController as? UINavigationController {
                if let vc = navc.viewControllers[0] as? MyMealsRecipesTableViewController {
                    vc.navigationItem.title = "My Meals"
                    var b = UIBarButtonItem(title: "< Back", style: .Plain, target: self, action:"simpleBackButtonPressed:")
                    vc.navigationItem.leftBarButtonItem = b
                    // hide nav bar on pushed view
                    navc.hidesBottomBarWhenPushed = true
                    
                    //TODO: Implement Save for Save Button, current: just Pops VC
                    var sb = UIBarButtonItem(title: "Save", style: UIBarButtonItemStyle.Plain, target: self, action: "simpleBackButtonPressed:")
                    
                    vc.navigationItem.rightBarButtonItem = sb
                }
            }
        }
    }
    
    // MARK: - NavBar Actions
    func backButtonPressed (sender: UIBarButtonItem ){
        let testString = "\u{2022}  Status:  Lunch Log Complete" +
        "\n\u{2022}  Tuna Sandwich " +
        "\n\u{2022}  Apple" +
            "\n\u{2022}  Time:  11:15" +
            "\n\u{2022}  Parent Intials:  A.B." +
            "\n\u{2022}  Place: Kitchen"
        self.summaryTextView.text = testString
        self.navigationController?.popViewControllerAnimated(true)
    }
   
    func simpleBackButtonPressed (sender: UIBarButtonItem ){
       
        self.navigationController?.popViewControllerAnimated(true)
    }

    func saveButtonPressed (sender: UIBarButtonItem ){
        
        
    }
    
    deinit {
        NSNotificationCenter.defaultCenter().removeObserver(self)
    }
}
