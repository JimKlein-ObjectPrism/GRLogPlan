//
//  AddOnViewController.swift
//  CoreDataTest
//
//  Created by James Klein on 4/17/15.
//  Copyright (c) 2015 James Klein. All rights reserved.
//

import UIKit
import QuartzCore

class AddOnViewController: UIViewController, UIPickerViewDataSource, UIPickerViewDelegate, UITextViewDelegate {

    @IBOutlet weak var addOnSegmentedControl: UISegmentedControl!
    @IBOutlet weak var noteTextView: UITextView!
    @IBOutlet weak var prescribedTimeUIPicker: UIPickerView!
    override func viewDidLoad() {
        super.viewDidLoad()
        
        noteTextView.delegate = self

        buildSegmentedControls()
        prescribedTimeUIPicker.delegate = self
        prescribedTimeUIPicker.dataSource = self
        // Do any additional setup after loading the view.
        
        self.noteTextView.layer.borderWidth = 1.3
        self.noteTextView.layer.cornerRadius = 15
    }
    
    override func viewWillAppear(animated: Bool) {
        
        //Save Button
        var sb = UIBarButtonItem(title: "Save", style: UIBarButtonItemStyle.Plain, target: self, action: "saveButtonTapped")
        self.navigationItem.rightBarButtonItem = sb        
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
    /*
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepareForSegue(segue: UIStoryboardSegue, sender: AnyObject?) {
        // Get the new view controller using segue.destinationViewController.
        // Pass the selected object to the new view controller.
    }
    */
    
    //MARK
    func buildSegmentedControls() {
        
        //Segment Control Code
        addOnSegmentedControl.removeAllSegments()
        
        for i in 0 ..< AddOnListItem.count() {
            addOnSegmentedControl.insertSegmentWithTitle(AddOnListItem(rawValue: i)!.name, atIndex: i, animated: false)
            addOnSegmentedControl.setWidth(0, forSegmentAtIndex: i)
        }
        addOnSegmentedControl.apportionsSegmentWidthsByContent = true

    }
}
