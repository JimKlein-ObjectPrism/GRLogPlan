//
//  HomeLogItemTableViewCell.swift
//  GRPatienLogAndPlan
//
//  Created by James Klein on 3/12/15.
//  Copyright (c) 2015 ObjectPrism Corp. All rights reserved.
//

import UIKit

class HomeLogItemTableViewCell: UITableViewCell, UIPopoverPresentationControllerDelegate, UIPopoverControllerDelegate  {

    @IBOutlet weak var myItemsButton: UIButton!
    @IBOutlet weak var selectedItemLabel: UILabel!
    
    var parent: UIViewController?
    
    let items: [String] = [
        "Baked Chicken with Rice",
        "Baked Fish with Rice",
        "Baked Fish",
        "Black Beans and Rice",
        "Bento",
        "Black Bean & Corn Salad with Thai Dressing",
        "Breakfast Burrito",
        "Ceasar Salad",
        "Chicken & White Bean Salad",
        "Chicken Pasta Salad",
        "Chicken Stew",
        "Chicken Yakisoba",
        "Creamy Cajun Chicken Pasta",
        "Garilic Pasta with Shrimp",
        "Egg Scramble",
        "Fajita Burrito",
        "Farmer's Breakfast Skillet",
        "Fettuccine Alfredo",
        "Greek Gyro",
        "Grilled Steak with Pepper Relish",
        "Indian Ground Turkey",
        "Lebanese Kabobs",
        "Malaysian Barbeque-glazed Salmon",
        "Nicoise Salad",
        "Pan-seared Halibut",
        "Pasta Primavera with Meat",
        "Pizza",
        "Roasted Fish with Mushroom, Leek, Arugula",
        "Salmon & Roast Vegetable Salad",
        "Sausage and Zucchini Italiano",
        "Sesame Chicken Noodle Salad",
        "Sesame Orange Shrimp",
        "Soft Taco",
        "Stir Fry & Fried Rice",
        "Taco Salad",
        "Thai Chicken and Mango Stir-fry",
        "Toasted APita & Bean Salad"
    ]

    
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }

    override func setSelected(selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }

    @IBAction func showPopoverForMyDinnerItems(sender: AnyObject) {
        //PopoverTableView
        let storyboard: UIStoryboard = UIStoryboard(name: "Main", bundle: nil)
        
        let contentViewController: PopoverTableViewController = storyboard.instantiateViewControllerWithIdentifier("PopoverTableView") as PopoverTableViewController
        
        contentViewController.items = items
        
        contentViewController.modalPresentationStyle = UIModalPresentationStyle.Popover
        
        var detailPopover : UIPopoverPresentationController = contentViewController.popoverPresentationController!
        
        detailPopover.sourceView = self.myItemsButton as UIButton
        
        detailPopover.permittedArrowDirections = UIPopoverArrowDirection.Any
        
        detailPopover.delegate = self
        
        //self..presentationController(<#controller: UIPresentationController#>, viewControllerForAdaptivePresentationStyle: <#UIModalPresentationStyle#>)
        parent?.presentViewController(contentViewController, animated: true, completion: nil)
    }
    func adaptivePresentationStyleForPresentationController( controller: UIPresentationController!) -> UIModalPresentationStyle {
        return UIModalPresentationStyle.None
    }
    
    func presentationController(controller: UIPresentationController, viewControllerForAdaptivePresentationStyle style: UIModalPresentationStyle) -> UIViewController? {
        let navController = UINavigationController(rootViewController:
            controller.presentedViewController)
        return navController
    }
    
}
