//
//  MedicineTableViewCell.swift
//  GRPatienLogAndPlan
//
//  Created by James Klein on 5/12/15.
//  Copyright (c) 2015 ObjectPrism Corp. All rights reserved.
//

import UIKit

class MedicineTableViewCell: UITableViewCell {

    static let cellIdentifer = "MedicineCell"
    
    var medicineTakenHandler: MedicineItemSelectedDelegate?
    
    @IBOutlet weak var medicineLabel: UILabel!
    @IBOutlet weak var medicineListingLable: UILabel!
    
    @IBOutlet weak var medicineSwitch: UISwitch!
    
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }

    override func setSelected(selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }

    @IBAction func selectionChanged_Switch(sender: AnyObject) {
        if let medsTaken = sender as? UISwitch {
            medicineTakenHandler!.choiceItemSelectedHandler(medicineSwitch.on)
        }
    }
}
