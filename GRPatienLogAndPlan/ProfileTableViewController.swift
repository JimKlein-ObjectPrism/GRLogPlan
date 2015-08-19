//
//  ProfileTableViewController.swift
//  GRPatienLogAndPlan
//
//  Created by James Klein on 4/28/15.
//  Copyright (c) 2015 ObjectPrism Corp. All rights reserved.
//

import UIKit

enum ProfileVCSection: Int {
    case RequiredItems = 0,
    AdditionalInfo
}
enum RequiredItem: Int {
    case FirstAndLastName = 0,
    Parents
}
enum AdditionalItems: Int {
    case Medicines = 0,
    AddOns,
    MorningSnackRequired,
    EveningSnackRequired

}


class ProfileTableViewController: UITableViewController, UITextFieldDelegate {
    var appDelegate: AppDelegate!
    
    var dataArray: [AnyObject]!
    
    var initialSetup: Bool = false
    
    var dataStore: DataStore!
    var profile: OPProfile!

    @IBOutlet weak var firstNameTextField: UITextField!
    @IBOutlet weak var lastNameTextField: UITextField!
    @IBOutlet weak var morningSnackSwitch: UISwitch!
    @IBOutlet weak var eveningSnackSwitch: UISwitch!
    
    override func viewDidLoad() {
        super.viewDidLoad()
    
        firstNameTextField.delegate = self
        //lastNameTextField.delegate = self
        if let appDelegate = UIApplication.sharedApplication().delegate as? AppDelegate{
            //set local property to data array in appDelegate
            self.appDelegate = appDelegate
            dataStore = appDelegate.dataStore
            profile = dataStore.currentRecord.profile
            
            
        }

        if let name = dataStore.currentRecord.profile.firstAndLastName {
            firstNameTextField.text = name
        }
        morningSnackSwitch.setOn(profile.morningSnackRequired.boolValue, animated: false)
        eveningSnackSwitch.setOn(profile.eveningSnackRequired.boolValue, animated: false)
        
        self.navigationController?.navigationBar.barTintColor = UIColor(red: 150.0/255.0, green: 185.0/255.0, blue: 118.0/255.0, alpha: 1.0)
        
        self.appDelegate = UIApplication.sharedApplication().delegate as? AppDelegate
        
        if initialSetup {
            var sb = UIBarButtonItem(title: "Done", style: UIBarButtonItemStyle.Plain, target: self, action: "doneButtonPressed:")
            
            self.navigationItem.rightBarButtonItem = sb
            initialSetup = false

        }
        

    }
    func doneButtonPressed (sender: UIBarButtonItem ){
        view.endEditing(true)
        let parents = dataStore.getParents()
        let profile = dataStore.currentProfile
        
        if firstNameTextField.text != "" {
            
        
        var fullName = firstNameTextField.text
        var fullNameArr = split(fullName) {$0 == " "}
        var firstName: String = fullNameArr[0]
        var lastName: String? = fullNameArr.count > 1 ? fullNameArr[fullNameArr.count - 1] : nil

        if firstNameTextField.text == "Patient First and Last Name" {
            displayErrorAlert("Patient Name Required.", message: "Please enter Patient First and Last Name.")
        }
        else if firstNameTextField.text == nil{
            displayErrorAlert("Patient Name is Required", message: "Please add Patient First and Last Name.")
        
        }
        else if fullNameArr.count < 2 {
            displayErrorAlert("Patient First and Last Name are Required", message: "Please enter Patient First and Last Name, separated by a space.")
            
        }

        else if parents.count == 1 && parents[0].firstName == "" {
            displayErrorAlert("Parent Names Required", message: "Please add Parent Names.")
            // An empty parent object is going to be there.
            
        }

        else {
            //save patient name
            dataStore.savePatientName(firstNameTextField.text)
            navigationController?.dismissViewControllerAnimated(true, completion: nil)
            
            let defaults = NSUserDefaults.standardUserDefaults()
            
            defaults.setBool(true, forKey: "profileIsValid")
            
        }
            
        } else {
            displayErrorAlert("Patient Name Required.", message: "Please enter Patient First and Last Name.")
        }
   }
    

//    func displayErrorAlert(title: String, message: String) {
//        let alertController = UIAlertController(title: title, message: message, preferredStyle: .Alert)
//        
//        //            let cancelAction = UIAlertAction(title: "Cancel", style: .Cancel) { (action) in
//        //                // ...
//        //            }
//        //            alertController.addAction(cancelAction)
//        
//        let OKAction = UIAlertAction(title: "OK", style: .Default) { (action) in
//            // ...
//        }
//        alertController.addAction(OKAction)
//        
//        self.presentViewController(alertController, animated: true) {
//            // ...
//        }
//
//    }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    //MARK: Switch Actions
   
    @IBAction func morningSnackSwitchValeChanged(sender: UISwitch) {
        dataStore.setMorningSnackRequired(sender.on)
    }
    @IBAction func eveningSnackSwitchSet(sender: UISwitch) {
        dataStore.setEveningSnackRequired(sender.on)
    }
    
    //MARK: UITextFieldDelegate
    func textFieldShouldReturn(textField: UITextField) -> Bool {
        firstNameTextField.resignFirstResponder()
        //lastNameTextField.resignFirstResponder()
        return true
    }
    func DismissKeyboard(){
        //Causes the view (or one of its embedded text fields) to resign the first responder status.
        view.endEditing(true)
    }
    
    func textFieldShouldBeginEditing(textField: UITextField) -> Bool {
        //Looks for single or multiple taps.
        var tap: UITapGestureRecognizer = UITapGestureRecognizer(target: self, action: "DismissKeyboard")
        view.addGestureRecognizer(tap)

        return true
    }
    
    func textFieldDidEndEditing(textField: UITextField) {
//        let nameInput = textField.text
//        let myArray: [String] = nameInput.componentsSeparatedByString(" ")
//        var firstName: String? = myArray.first
//        if myArray.count > 1 {
//            var lastName: String? = myArray.last
//            tableViewCellDelegate!.nameEntered(parentItemIndexInProfileSet!, firstName: firstName, lastName: lastName)
//        } else {
//            tableViewCellDelegate!.nameEntered(parentItemIndexInProfileSet!, firstName: firstName, lastName: nil)
//        }

        
        
        dataStore.savePatientName(self.firstNameTextField.text)

        if view.gestureRecognizers?.count > 0 {
            view.gestureRecognizers?.removeAll(keepCapacity: true)
        }

    }
    
    
    // MARK: - Table view data source

    override func numberOfSectionsInTableView(tableView: UITableView) -> Int {
        // #warning Potentially incomplete method implementation.
        // Return the number of sections.
        return 2
    }

    override func tableView(tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        // #warning Incomplete method implementation.
        // Return the number of rows in the section.
        switch section{
        case 0:
            return 2
        case 1:
            return 4
        default:
            return 0
        }
        
    }
    
    override func tableView(tableView: UITableView, didSelectRowAtIndexPath indexPath: NSIndexPath) {
        let section = indexPath.section
        let sectionName = ProfileVCSection(rawValue: section)
        
        let row = indexPath.row
        
        switch sectionName! {
        case ProfileVCSection.RequiredItems:
            
            let rowName = RequiredItem(rawValue: row)
            switch rowName! {
            case RequiredItem.FirstAndLastName:
                return
            case RequiredItem.Parents:
                pushParentsVC()
            }
        case ProfileVCSection.AdditionalInfo:
            let rowName = AdditionalItems(rawValue: row)
            switch rowName! {
            case AdditionalItems.Medicines:
                pushMedicineVC()
            case AdditionalItems.AddOns:
                pushAddOnsVC()
            case RequiredItem.MorningSnackRequired:
                return
            case RequiredItem.EveningSnackRequired:
                return

            }
        }
    }
    func pushParentsVC() {
        
        let vc : ParentViewController = self.storyboard?.instantiateViewControllerWithIdentifier("ParentViewController") as! ParentViewController
        vc.navigationItem.title = "Parents"
        vc.currentDisplayType = ParentViewControllerDisplayType.Parents
        
        //set delegate property
        vc.parents = dataStore.getParents()
        vc.dataStoreDelegate = dataStore
        
        self.showViewController(vc as UIViewController, sender: vc)
    }
    func pushMedicineVC() {
        //var profile = dataStore.getCurrentProfile()
        let vc : ParentViewController = self.storyboard?.instantiateViewControllerWithIdentifier("ParentViewController") as! ParentViewController
        
        vc.navigationItem.title = "Medicines"
        vc.currentDisplayType = ParentViewControllerDisplayType.Medicines
        
        // set addOns property
        vc.medicines = dataStore.getMedicines()
        
        //set delegate property
        vc.dataStoreDelegate = dataStore
        
        self.showViewController(vc as UIViewController, sender: vc)
    }
    
    func pushAddOnsVC() {
        //var profile = dataStore.getCurrentProfile()
        //var profileAddOns = dataStore.currentRecord.profile.addOns
        
        let vc : ParentViewController = self.storyboard?.instantiateViewControllerWithIdentifier("ParentViewController") as! ParentViewController
        
        vc.navigationItem.title = "AddOns"
        vc.currentDisplayType = ParentViewControllerDisplayType.AddOns
        
        // set addOns property
        vc.addOns = dataStore.getAddOns()
        
        //set delegate property
        vc.dataStoreDelegate = dataStore
        
        self.showViewController(vc as UIViewController, sender: vc)
        
    }


  }
