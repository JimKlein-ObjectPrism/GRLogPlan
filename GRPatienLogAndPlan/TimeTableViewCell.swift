//
//  TimeTableViewCell.swift
//  GRPatienLogAndPlan
//
//  Created by James Klein on 5/13/15.
//  Copyright (c) 2015 ObjectPrism Corp. All rights reserved.
//

import UIKit

class TimeTableViewCell: UITableViewCell {

    static let cellIdentifer = "TimeCell"
    
    var timeSelectedHandler: TimeSelectedDelegate?

    @IBOutlet weak var timeTextField: UITextField!
    @IBOutlet weak var timeUIPicker: UIDatePicker!
    
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
        
    }

    override func setSelected(selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }

    @IBAction func timeTextSelected(sender: UITextField) {
        var datePickerView  : UIDatePicker = UIDatePicker()
        datePickerView.datePickerMode = UIDatePickerMode.Time
        datePickerView.minuteInterval = 15
        sender.inputView = datePickerView

        datePickerView.addTarget(self, action: "handleDatePicker:", forControlEvents: UIControlEvents.AllEvents)
    }
    @IBAction func timePickerSelected(sender: UIDatePicker) {
        
    }
    func handleDatePicker( sender: UIDatePicker) {
        var dateFormatter = NSDateFormatter()
        dateFormatter.dateFormat = "HH:mm"
        
        timeTextField.text = dateFormatter.stringFromDate(sender.date)
        timeSelectedHandler?.timeSelectedHandler(sender.date)
    }
}
