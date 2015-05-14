//
//  LocationTableViewCell.swift
//  GRPatienLogAndPlan
//
//  Created by James Klein on 5/13/15.
//  Copyright (c) 2015 ObjectPrism Corp. All rights reserved.
//

import UIKit

class LocationTableViewCell: UITableViewCell {
    static let cellIdentifer = "LocationCell"
    var locationButtonHandler: LocationSelectedDelegate?

    @IBOutlet weak var locationButton: UIButton!
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }

    override func setSelected(selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }


    @IBAction func locationButtonTapped(sender: AnyObject) {
        locationButtonHandler?.locationSelectedHandler()
    }
}
