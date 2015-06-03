//
//  ParentViewController.swift
//  CoreDataTest
//
//  Created by James Klein on 4/16/15.
//  Copyright (c) 2015 James Klein. All rights reserved.
//

import UIKit
import CoreData

enum ParentViewControllerDisplayType {
    case Parents,
    AddOns,
    Medicines
}

class ParentViewController: UIViewController, UITextFieldDelegate, UITableViewDataSource, UITableViewDelegate, TableViewCellDelegate	 {

    //var parents: OPParents!
    var parents: [OPParent]?
    
    //Add Ons
    var addOns: [OPAddOn]?
    
    // Meds
    var medicines: [OPMedicine]?
    
    //Model Fields - Parent Only, other model objects sent from view controllers to data store
    var firstNameParent: String?
    var lastNameParent: String?
    
    
    var currentDisplayType: ParentViewControllerDisplayType!
    
    @IBOutlet weak var cellFirstNameTextField: UITextField!
    //handle datastore calls delegage
    var dataStoreDelegate: ProfileDataStoreDelegate!
    
    @IBOutlet weak var mostCommonSupervisorUISwitch: UISwitch!
    
    @IBOutlet weak var firstNameTextField: UITextField!
    @IBOutlet weak var lastNameTextField: UITextField!
    var mostCommonSupervisingParent: Int =  0
    
    
    
    @IBOutlet weak var tableView: UITableView!
    override func viewDidLoad() {
        super.viewDidLoad()

        switch currentDisplayType! {
        case  ParentViewControllerDisplayType.Parents:
            var sb = UIBarButtonItem(title: "Done", style: UIBarButtonItemStyle.Plain, target: self, action: "doneButtonTapped")
            self.navigationItem.rightBarButtonItem = sb
            //Looks for single or multiple taps.
            var tap: UITapGestureRecognizer = UITapGestureRecognizer(target: self, action: "DismissKeyboard")
            view.addGestureRecognizer(tap)

        case .AddOns:
            println("addon")
            var sb = UIBarButtonItem(title: "Add", style: UIBarButtonItemStyle.Plain, target: self, action: "addButtonTapped:")
            self.navigationItem.rightBarButtonItem = sb
        case .Medicines:
            tableView.delegate = self
            tableView.dataSource = self
            var sb = UIBarButtonItem(title: "Add", style: UIBarButtonItemStyle.Plain, target: self, action: "addButtonTapped:")
            self.navigationItem.rightBarButtonItem = sb
            
        }
        
        //Looks for single or multiple taps.
        var tap: UITapGestureRecognizer = UITapGestureRecognizer(target: self, action: "DismissKeyboard")
        view.addGestureRecognizer(tap)

    }
    
    
    func DismissKeyboard(){
        //Causes the view (or one of its embedded text fields) to resign the first responder status.
        view.endEditing(true)
    }
    override func viewWillAppear(animated: Bool) {


        switch currentDisplayType! {
        case  ParentViewControllerDisplayType.Medicines:
            medicines = dataStoreDelegate.getMedicines()
            if view.gestureRecognizers?.count > 0 {
                view.gestureRecognizers?.removeAll(keepCapacity: true)
            }

        case .AddOns:
            println()
        case .Parents:
            println()
        }
        
        self.tableView.reloadData()
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    func textFieldShouldReturn(textField: UITextField) -> Bool {
        
        textField.resignFirstResponder()
        return true
    }
    
//    override func touchesBegan(touches: NSSet, withEvent event: UIEvent) {
//        //forces keyboard to hide on touch to view
//        view.endEditing(true)
//        
//        super.touchesBegan(touches, withEvent: event)
//    }
    //MARK: TableViewCellDelegate Methods
    func parentItemDeleted(toDeleteItem: Int) {
        //let index = (toDoItems as NSArray).indexOfObject(toDoItem)
        //if index == NSNotFound { return }
        parents!.removeAtIndex(toDeleteItem)
        // could removeAtIndex in the loop but keep it here for when indexOfObject works
        //toDoItems.removeAtIndex(index)
        
        // use the UITableView to animate the removal of this row
        tableView.beginUpdates()
        let indexPathForRow = NSIndexPath(forRow: toDeleteItem, inSection: 0)
        tableView.deleteRowsAtIndexPaths([indexPathForRow], withRowAnimation: .Fade)
        tableView.endUpdates()
        
        //Update Model
        
        
    }
    func nameEntered(atIndex: Int, firstName: String?, lastName: String?){
        view.endEditing(true)
        /*
        If error or errors, display alert
        else, Call add or edit
        */
        let result = dataStoreDelegate.updateParentInModel(atIndex, firstName: firstName, lastName: lastName)
        
        if result.errorArray.count == 1 {
            let errorItem = result.errorArray[0]
            switch errorItem{
            case ParentProfileValidation.Success:
                parents?.removeAll(keepCapacity: false)
                //self.tableView.deleteRowsAtIndexPaths([IndexPath(], withRowAnimation: <#UITableViewRowAnimation#>), withRowAnimation: <#UITableViewRowAnimation#>
                self.parents? = dataStoreDelegate.getParents()
                self.tableView.reloadData()
                //self.parents? = dataStoreDelegate.getParents()
//                parents?.removeAll(keepCapacity: false)
            default:
                println(errorItem.rawValue)
            }
        }
        else
        {
            for x in result.errorArray {
                println(x.rawValue)
            }
        }
        
        

    }

    
    // MARK: - Table view data source
    
    func numberOfSectionsInTableView(tableView: UITableView) -> Int {
        // #warning Potentially incomplete method implementation.
        // Return the number of sections.
        return 1
    }
    
    func tableView(tableView: UITableView, heightForRowAtIndexPath indexPath: NSIndexPath) -> CGFloat {
        if currentDisplayType == ParentViewControllerDisplayType.Parents {
        return 102.0
        }
        else {
            return 80.0
        }
    }
    func tableView(tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        // #warning Incomplete method implementation.
        // Return the number of rows in the section.
        
        switch currentDisplayType! {
        case  ParentViewControllerDisplayType.Parents:
            return parents!.count
        case .AddOns:
            return addOns!.count
        case .Medicines:
            return medicines!.count
        }

    }
    
    //MARK: Delete functionality
    func tableView(tableView: UITableView,
        canEditRowAtIndexPath indexPath: NSIndexPath) -> Bool {
            return true
            
    }
    
    func tableView(tableView: UITableView,
        commitEditingStyle
        editingStyle: UITableViewCellEditingStyle,
        forRowAtIndexPath indexPath: NSIndexPath) {
            
            if editingStyle == UITableViewCellEditingStyle.Delete {
                
                switch self.currentDisplayType!{
                case ParentViewControllerDisplayType.Parents:
                    
                 let result = self.dataStoreDelegate.deleteParent(indexPath.row)
                    if result.coreDataError == nil {
                        self.parents!.removeAtIndex(indexPath.row)
                    } else {
                        //TODO: handle error here.
                    }
                    
                case .AddOns:
                    println()
                case .Medicines:
                    let result = self.dataStoreDelegate.deleteMedicine(indexPath.row)
                    if result.coreDataError == nil {
                        self.medicines!.removeAtIndex(indexPath.row)
                    } else {
                        //TODO: handle error here.
                    }

                }
                
                //animate cell delete
                tableView.deleteRowsAtIndexPaths([indexPath],
                    withRowAnimation: UITableViewRowAnimation.Automatic)
            }
    }

    
    func tableView(tableView: UITableView, cellForRowAtIndexPath indexPath: NSIndexPath) -> UITableViewCell {
        let row = indexPath.row
        
        
        switch currentDisplayType! {
        case  ParentViewControllerDisplayType.Parents:
            let cell = tableView.dequeueReusableCellWithIdentifier("ParentTableViewCell", forIndexPath: indexPath) as! ParentViewTableViewCell
            let parent = parents![row]
            if row == 0 {
                //Feels llike a hack, but the new cell is always added at the top of the array and view
                cell.nameTextField.text = "First and Last Name"
            }
            if parent.firstName != "" && parent.lastName != ""{
                let name = "\(parent.firstName) \(parent.lastName)"
                cell.nameTextField.text = name
            }
            cell.nameTextField.textColor = UIColor.blueColor()
            cell.selectionStyle = .None
            cell.delegate = self
            cell.dataStoreDelegate = self.dataStoreDelegate
            cell.tableViewCellDelegate = self
            cell.parentItemIndexInProfileSet = row
            
            return cell
        case .AddOns:
                let row = indexPath.row
                //var title: String = ProfileChoice(rawValue: row)?.name
                let cell = tableView.dequeueReusableCellWithIdentifier("AddOnMedicineCell", forIndexPath: indexPath) as! UITableViewCell
                
                if addOns?.count > 0{
                    let addOn = addOns![row]
                    //TODO:  finish implementing code here
                    cell.textLabel?.text = "placeholder" //addOn.addOnItem
                    //cell.accessoryType = UITableViewCellAccessoryType.
                }
                
                return cell

        case .Medicines:
            let row = indexPath.row
            //var title: String = ProfileChoice(rawValue: row)?.name
            let cell = tableView.dequeueReusableCellWithIdentifier("AddOnMedicineCell", forIndexPath: indexPath) as! UITableViewCell//MedsAddOnTableViewCell
            if medicines?.count > 0 {
                if let med = medicines?[row] {
                //TODO:  finish implementing code here
                cell.textLabel?.text = Medicines(rawValue: row )?.name
                cell.detailTextLabel?.text = PrescribedTimeForAction(rawValue: row)?.name
                
                //cell.accessoryType = UITableViewCellAccessoryType.DisclosureIndicator
            
                }
            }
            //cell.delegate(self)
            return cell

        }
    }
    
    func tableView(tableView: UITableView, didSelectRowAtIndexPath indexPath: NSIndexPath) {
        //TODO:  Add code for editing selected entry
        switch self.currentDisplayType! {
        case  ParentViewControllerDisplayType.Parents:
            println()
        case .AddOns:
            pushAddOnsVC()
        case .Medicines:
            pushMedicinesVC(true, medicine: self.medicines?[indexPath.row])
        }
    }
//    func tableView(tableView: UITableView, titleForHeaderInSection section: Int) -> String? {
//        return "Parents"
//    }

    @IBAction func addButtonTapped(sender: AnyObject) {

//        var result = dataStoreDelegate.addParent(self.firstNameTextField.text, lastName: self.lastNameTextField.text, mostCommonSupervisor: self.mostCommonSupervisorUISwitch.selected)//, bindData)
//        
        switch self.currentDisplayType! {
        case  ParentViewControllerDisplayType.Parents:
            println("When parents are displayed, this button is not shown")
        case .AddOns:
            pushAddOnsVC()
        case .Medicines:
            pushMedicinesVC(false, medicine: nil)
        }
    }
    func bindData(parents: [OPParent], indexOfMostCommonParentSupervisor: Int) -> Bool {
        currentDisplayType = ParentViewControllerDisplayType.Parents
        
        self.firstNameTextField.text = ""
        self.lastNameTextField.text = ""
        
        
        
        self.parents = parents
        tableView.reloadData()
        return true
    }
    func bindData(addOns: [OPAddOn]) -> Bool {
        
        currentDisplayType = ParentViewControllerDisplayType.AddOns
        self.addOns = addOns
        tableView.reloadData()
        
        return true
    }
//    func bindData(medicines: [OPMedicine]) -> Bool {
//        
//        currentDisplayType = ParentViewControllerDisplayType.Medicines
//        self.medicines = medicines
//        tableView.reloadData()
//        
//        return true
//    }
//    
    

    @IBAction func editButtonTapped(sender: AnyObject) {
        
    }
    @IBAction func deleteButtonTapped(sender: AnyObject) {
        //TODO:
    }
    
    func doneButtonTapped(){
        view.endEditing(true)

        
        //Add the last one
        //dataStoreDelegate.addParent(self.firstNameTextField.text, lastName: "Smith")
        
//        let nameInput = self.firstNameTextField.text
//        let myArray: [String] = nameInput.componentsSeparatedByString(" ")
//        dataStoreDelegate.addParent(myArray.first, lastName: myArray.last)
    }
        
    //MARK: Push Methods
    func pushAddOnsVC() {
        
        let vc : AOnTableViewController = self.storyboard?.instantiateViewControllerWithIdentifier("AOnTableViewController") as! AOnTableViewController
        
        vc.navigationItem.title = "AddOn"
        vc.dataStoreDelegate = self.dataStoreDelegate
        
        self.showViewController(vc as UIViewController, sender: vc)
    }
    func pushMedicinesVC(isUpdate: Bool, medicine: OPMedicine?) {
        
        let vc : MedicineTableViewController = self.storyboard?.instantiateViewControllerWithIdentifier("MedicineTableViewController") as! MedicineTableViewController

        vc.navigationItem.title = "Medicine"
        vc.dataStoreDelegate = self.dataStoreDelegate

        self.showViewController(vc as UIViewController, sender: vc)
    }


}
