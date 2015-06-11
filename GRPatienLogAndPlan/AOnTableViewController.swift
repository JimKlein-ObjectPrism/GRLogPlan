//
//  AOnTableViewController.swift
//  CoreDataTest
//
//  Created by James Klein on 4/24/15.
//  Copyright (c) 2015 James Klein. All rights reserved.
//

import UIKit

class AOnTableViewController: UITableViewController, UIPickerViewDataSource, UIPickerViewDelegate {

    //handle datastore calls delegage
    var dataStoreDelegate: ProfileDataStoreDelegate!
    var addOn: OPAddOn!
    var selectedIndex: Int?
    
    var isUpdate = false

    var addOnToUpdate: OPAddOn?

    @IBOutlet weak var addOnSegmentedControl: UISegmentedControl!
    @IBOutlet weak var prescribedTimeUIPicker: UIPickerView!
    //@IBOutlet weak var addOnSegmentedControl: UISegmentedControl!

    //@IBOutlet weak var prescribedTimeUIPicker: UIPickerView!

    override func viewDidLoad() {
        super.viewDidLoad()


        buildSegmentedControls()
        prescribedTimeUIPicker.delegate = self
        prescribedTimeUIPicker.dataSource = self
        if isUpdate {
            //addOnSegmentedControl.set
            addOnSegmentedControl.selectedSegmentIndex = addOnToUpdate!.addOnItem.integerValue
            prescribedTimeUIPicker.selectRow(addOnToUpdate!.targetMealOrSnack.integerValue, inComponent: 0, animated: false)
            var sb = UIBarButtonItem(title: "Done", style: UIBarButtonItemStyle.Plain, target: self, action: "doneButtonTapped_Update")
            self.navigationItem.rightBarButtonItem = sb
            
        } else {
            var sb = UIBarButtonItem(title: "Done", style: UIBarButtonItemStyle.Plain, target: self, action: "doneButtonTapped_Add")
            self.navigationItem.rightBarButtonItem = sb
        }

        
        self.tableView.reloadData()

    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    //MARK: - Delegates and data sources
    //MARK: Data Sources
    func numberOfComponentsInPickerView(pickerView: UIPickerView) -> Int {
        return 1
    }
    func pickerView(pickerView: UIPickerView, numberOfRowsInComponent component: Int) -> Int {
        return PrescribedTimeForAction.count()
    }
    
    //MARK: Delegates
    func pickerView(pickerView: UIPickerView, titleForRow row: Int, forComponent component: Int) -> String! {
        return PrescribedTimeForAction(rawValue: row)?.name()
    }
    
    func pickerView(pickerView: UIPickerView, didSelectRow row: Int, inComponent component: Int) {
        //myLabel.text = pickerData[row]
    }

    
    //MARK: Configuratino
    func buildSegmentedControls() {
        
        //Segment Control Code
        addOnSegmentedControl.removeAllSegments()
        for i in 0 ..< AddOnListItem.count() {
            addOnSegmentedControl.insertSegmentWithTitle(AddOnListItem(rawValue: i)!.name, atIndex: i, animated: false)
            addOnSegmentedControl.setWidth(0, forSegmentAtIndex: i)
        }
        addOnSegmentedControl.apportionsSegmentWidthsByContent = true
        
    }
    func configureForEditing(withOPAddOn: OPAddOn){
        //TODO:  CHANGED PROPERTY IN ADDON TO BE STRING NOT INT.  NEED TO LOOK UP INT HERE.
        //let row: Int = Int(withOPAddOn.addOnItem)
        //prescribedTimeUIPicker!.selectRow(row, inComponent: 0, animated: false)
        
    }
    func doneButtonTapped_Add()
    {
        // OK this is addon only onthe vc.
        let addOnSelection = self.addOnSegmentedControl.selectedSegmentIndex
        let timeSelection = prescribedTimeUIPicker.selectedRowInComponent(0)
//        let name = AddOnListItem(rawValue: addOnSelection)?.name
//        let time = PrescribedTimeForAction(rawValue: timeSelection)?.name
//        println("addON: \(name) \(addOnSelection), time: \(time) \(timeSelection)")
        dataStoreDelegate.addAddOn(addOnSelection, prescribedTimeForAction: timeSelection)
        self.navigationController?.popViewControllerAnimated(true)
    }
    func doneButtonTapped_Update()
    {
        dataStoreDelegate.updateAddOn(selectedIndex!, addOn: self.addOnSegmentedControl.selectedSegmentIndex, prescribedTimeForAction: self.prescribedTimeUIPicker.selectedRowInComponent(0))
        self.navigationController?.popViewControllerAnimated(true)
    }
}
