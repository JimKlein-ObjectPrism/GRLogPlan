//
//  MedicineTableViewCell.swift
//  GRPatienLogAndPlan
//
//  Created by James Klein on 5/12/15.
//  Copyright (c) 2015 ObjectPrism Corp. All rights reserved.
//

import UIKit

public class MedicineTableViewCell: UITableViewCell {

    public static let cellIdentifer = "MedicineCell"
    
    var medicineTakenHander: MedicineItemSelectedDelegate!
    
    @IBOutlet weak var medicineListingLable: UILabel!
    
    @IBOutlet weak var medicineSwitch: UISwitch!
    
    override public func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }

    override public func setSelected(selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }

    @IBAction func selectionChanged_Switch(sender: AnyObject) {
        if let medsTaken = sender as? UISwitch {
            medicineTakenHander.choiceItemSelectedHandler(medicineSwitch.on)
        }        
    }
}
