//
//  TrackTableViewController.swift
//  GRPatienLogAndPlan
//
//  Created by Jim Klein on 2/25/15.
//  Copyright (c) 2015 ObjectPrism Corp. All rights reserved.
//

import UIKit

class TrackTableViewController: UITableViewController, UpdateDetailViewDelegate, UIActionSheetDelegate {

    //@IBOutlet weak var menuButton: UIBarButtonItem!
    
    var dataStore: DataStore!
    
    var dataArray: [AnyObject]?
    
    var detailDisplayItem: DetailDisplayItem?
    
    var sectionData: [[AnyObject]] = [[AnyObject]]()
    
    //MARK: - Journal Item properties
    var headerTitles = [String]()
    
    var itemSelectedHeaderTitles = [String]()
    
    var rowArrays: [ [ String]] = [Array<String>]()
    
    var foodItems = [FoodItem]()
    //
    var displayType: MealItemSelectionDisplayType = MealItemSelectionDisplayType.SingleMealEntryWithBackButton

    //closure to update Home screen text box
    var updateTextClosure: ((sender: UIBarButtonItem) -> ())?

    //Parent Initials value holder
    var parentInitials: String?
    
    override func viewDidLoad() {
        super.viewDidLoad()

        let dType = displayType
            switch dType{
            case .FullDayEntryWithMenu:
                // add menu button to nav bar and set action
                if self.revealViewController() != nil {
                    let bb = UIBarButtonItem(image: UIImage(named: "menu"), style: UIBarButtonItemStyle.Plain, target: self.revealViewController(), action: "revealToggle:")
                    self.navigationItem.leftBarButtonItem = bb
                    self.view.addGestureRecognizer(self.revealViewController().panGestureRecognizer())
                }
            case .SingleMealEntryWithBackButton:
                // back button
                let b = UIBarButtonItem(title: "< Back", style: .Plain, target: self, action:"backButtonPressed:")
                self.navigationItem.leftBarButtonItem = b
//                if let item = detailDisplayItem {
//                    //self.navigationItem.title = item.
//                }
                //Save Button
                let sb = UIBarButtonItem(title: "Done", style: UIBarButtonItemStyle.Plain, target: self, action: "saveButtonPressed:")

                self.navigationItem.rightBarButtonItem = sb
                
            }
        
        if let appDelegate = UIApplication.sharedApplication().delegate as? AppDelegate{
            //set local property to data array in appDelegate
            dataArray = appDelegate.dataArray
                
            //Set target for updateDetailViewHandler
            if self.detailDisplayItem != nil {
                updateDetailViewHandler(self.detailDisplayItem!)
            }
        }
        else
        {
            print("AppDelegate = nil. The impossible happened.")
        }
        self.navigationController?.navigationBar.barTintColor = UIColor(red: 150.0/255.0, green: 185.0/255.0, blue: 118.0/255.0, alpha: 1.0)
        
    }
    
    // MARK: - NavBar Actions
    func backButtonPressed (sender: UIBarButtonItem ){
        if  let c = updateTextClosure  {
            c(sender: sender)
        }
        
        self.navigationController?.popViewControllerAnimated(true)
    }
    func saveButtonPressed (sender: UIBarButtonItem ){
        
        self.navigationController?.popViewControllerAnimated(true)
    }

    
    // MARK: - Event Handlers
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
            print("error")

        }
        
        self.tableView.reloadData()
    
    }
    
    // MARK: - TableView delegate
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
        //var selectedIndex = sender.selectedSegmentIndex
    }
    
    override func tableView(tableView: UITableView, cellForRowAtIndexPath indexPath: NSIndexPath) -> UITableViewCell {
//        var section = indexPath.section
        
        var currentItemsArray = sectionData[indexPath.section]
        
//        var row = indexPath.row
        
        let currentItem: AnyObject = currentItemsArray[indexPath.row]
        
        switch currentItem {
        case let currentItem as FoodItemWithChoice:
            //handle fooditemwithchoice
            //currentItemsArray must be [FoodItems]
            var foodItemArray = currentItemsArray as! [FoodItem]
            let cell = tableView.dequeueReusableCellWithIdentifier(ChoiceItemsTableViewCell.cellIdentifier, forIndexPath: indexPath) as! ChoiceItemsTableViewCell
            cell.choiceLabel?.text = foodItemArray[indexPath.row].itemDescription
            cell.indexPath = indexPath
            //cell.indexPathRow  = indexPath.row
            if dataStore != nil {
            cell.segmentSelectionHandler = dataStore
            }
            
            let segControl = cell.choiceSegmentControl as UISegmentedControl
           
            //TODO:  for the redraw, handle pre-selected child item  FoodChoiceItem.selectedChildFoodItem?  by setting the selected index of segment control to value in FoodChoiceItem
            
                segControl.removeAllSegments()

            
                for i in 0 ..< currentItem.choiceItems.count {
                    if i  < 2 {
                        let choiceItem = currentItem.choiceItems[i]
                        segControl.insertSegmentWithTitle(choiceItem.itemDescription, atIndex: i, animated: false)
                        //segControl.setTitle(choiceItem.itemDescription, forSegmentAtIndex: i)
                        
                        // cell size apportionament, used below, requires cell to have width = 0
                        segControl.setWidth(0, forSegmentAtIndex: i)
                    }
                    else{
                        segControl.insertSegmentWithTitle(currentItem.choiceItems[i].itemDescription, atIndex: i, animated: false)
                        segControl.setWidth(0, forSegmentAtIndex: i)
                    }
                }
            
            segControl.apportionsSegmentWidthsByContent = true
            //next time this is read it will show that it is being reused
            cell.isReusedCell = true
            return cell
            
        case _ as ParentInitials:
            let cell = tableView.dequeueReusableCellWithIdentifier("ParentInitialsCell", forIndexPath: indexPath) as! ParentInitialsTableViewCell
            cell.titleLabel?.text = "Parent Initials"
            if self.parentInitials != nil{
            cell.initialsButton.titleLabel?.text = self.parentInitials
            }
            return cell
            
        case _ as Time:
            let cell = tableView.dequeueReusableCellWithIdentifier("TimeEntryCell", forIndexPath: indexPath) as! TimeEntryTableViewCell
            cell.titleTextLabel?.text = "Time"
            return cell
            
//        case let currentItem as Place:
//            let cell = tableView.dequeueReusableCellWithIdentifier("PlaceEntryCell", forIndexPath: indexPath) as! PlaceEntryTableViewCell
//            cell.titleLabel?.text  = "Place"
//            cell.placeButton.titleLabel?.text = "Kitchen"
//            return cell
            
        case _ as Note:
            let cell = tableView.dequeueReusableCellWithIdentifier("NoteCell", forIndexPath: indexPath) as! NoteTableViewCell
            cell.textLabel?.text = "Note"
            return cell
            
        default:
            //handle plain FoodItem
            //currentItemsArray must be [FoodItems]
            var foodItemArray = currentItemsArray as! [FoodItem]
            let cell = tableView.dequeueReusableCellWithIdentifier("Cell", forIndexPath: indexPath)  
            
            //if let newCell = cell as? UITableViewCell {
            cell.textLabel?.text = foodItemArray[indexPath.row].name
            cell.detailTextLabel?.text = foodItemArray[indexPath.row].itemDescription
                
            return cell
            
        }
    }
    override  func tableView(tableView: UITableView, heightForRowAtIndexPath indexPath: NSIndexPath) -> CGFloat {
        var currentItemsArray = sectionData[indexPath.section]

        let currentItem: AnyObject = currentItemsArray[indexPath.row]
        if  let _ = currentItem as? Time {
            return 200.0
        }
        return 50.0
    }
    override func tableView(tableView: UITableView, titleForHeaderInSection section: Int) -> String? {
        return self.itemSelectedHeaderTitles[section]
    }
    
    
    override func tableView(tableView: UITableView, didSelectRowAtIndexPath indexPath: NSIndexPath) {
        
        //TODO: Fix it so Additional Info Items never get deleted.  Hook up Status indicator when necessary items have been selected.
        let selectedRow = indexPath.row
        let selectedSection = indexPath.section
        
//        var currentData = self.sectionData[indexPath.section]
        
        //TODO: send update meal item message to DataStore
        let currentItem: DetailDisplayItem = detailDisplayItem!
        var itemsArray = self.sectionData[indexPath.section]
        //switch on type here
        //var currentItem = self.detailDisplayItem pendulum, ken,  michael, android, bjorn, built light, online teacher.  kevin, precision caset part.  web ios.  brian, ideependent. start ou  cdk brian,  ios-devleopers.io.  next ascent, todd, ebay, dhval, ebay classified. zabzab  pdx electrohacks.
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
           
        default:
            //handle other items here
            print("unimplemented code for non-meal items encountered")
        }
       
        let originalCountRowsInSection = sectionData[indexPath.section].count //rowArrays[selectedSection].count

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
                let positionInArray = index - 1
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
                    let indexPath = NSIndexPath(forRow: index , inSection: selectedSection)
                    indexPathArray.append(indexPath)
                }
            }
        }
        return indexPathArray
        
    }
    
    
    //MARK: Table Cell Actions

    
    @IBAction func showAlertForParentInitials(sender: AnyObject) {
        let buttonList = ["A.B." , "B.C."]
        let title = "Parent Initials"
//        let cancel = "Cancel"
//        let firstButtonItem = buttonList[0]
        
        // create controller
        let choiceMenu = UIAlertController(title: nil, message: title, preferredStyle: .ActionSheet)
        
        let button = sender as! UIButton
        
        //var newTitle : String = ""
        
        // add Action buttons for each set of initials in the list
        for s in 0..<buttonList.count {
            
//            var buttonIndex = s

            let action = UIAlertAction(title: buttonList[s], style: .Default, handler: {
                (alert: UIAlertAction) -> Void in
                //send initials updated event
                button.titleLabel?.text = buttonList[s]
                //newTitle = buttonList[s]
                self.parentInitials = buttonList[s]
                
            })
            
            choiceMenu.addAction(action)
        }
        
       self.presentViewController(choiceMenu, animated: true, completion: nil)

        
     }
    
    
    
    
    
    
    
    
    func actionSheet(actionSheet: UIActionSheet, clickedButtonAtIndex buttonIndex: Int) {
        //        switch buttonIndex {
        //
        //        }
        parentInitials = "/(buttonIndex)"
    }
}
