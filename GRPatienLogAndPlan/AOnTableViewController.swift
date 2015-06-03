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

    @IBOutlet weak var addOnSegmentedControl: UISegmentedControl!

    @IBOutlet weak var prescribedTimeUIPicker: UIPickerView!

    override func viewDidLoad() {
        super.viewDidLoad()

        buildSegmentedControls()
        prescribedTimeUIPicker.delegate = self
        prescribedTimeUIPicker.dataSource = self

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
        return PrescribedTimeForAction(rawValue: row)?.name
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

}
