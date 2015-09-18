//
//  MealTrackingTableViewController.swift
//  GRPatienLogAndPlan
//
//  Created by James Klein on 5/11/15.
//  Copyright (c) 2015 ObjectPrism Corp. All rights reserved.
//

import UIKit


class MealTrackingTableViewController: UITableViewController {

    var vm : MealViewModelDelegate!
    
    override func viewDidLoad() {
        super.viewDidLoad()
       
        //Save Button
        var sb = UIBarButtonItem(title: "Save", style: UIBarButtonItemStyle.Plain, target: self, action: "saveButtonTapped")
        self.navigationItem.rightBarButtonItem = sb

        //MARK: back button
        var b = UIBarButtonItem(title: "< Back", style: .Plain, target: self, action:"backButtonPressed:")
        self.navigationItem.leftBarButtonItem = b
        self.hidesBottomBarWhenPushed = true
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }

    // MARK: - Table view data source

    override func numberOfSectionsInTableView(tableView: UITableView) -> Int {
        // #warning Potentially incomplete method implementation.
        // Return the number of sections.
        return vm.numberOfSectionsInTableView(self.tableView)
        
    }

    override func tableView(tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        // #warning Incomplete method implementation.
        // Return the number of rows in the section.
        return vm.tableView(tableView , numberOfRowsInSection: section)
    }

    override func tableView(tableView: UITableView, cellForRowAtIndexPath indexPath: NSIndexPath) -> UITableViewCell {
        return vm.tableView(tableView , cellForRowAtIndexPath: indexPath)
    }

    override func tableView(tableView: UITableView, titleForHeaderInSection section: Int) -> String? {
        return vm.tableView(tableView , titleForHeaderInSection: section)
    }
    
    override func tableView(tableView: UITableView, didSelectRowAtIndexPath indexPath: NSIndexPath) {
        //let selectedCell = tableView(self.tableView, cellForRowAtIndexPath, indexPath: indexPath) //as NewChoiceTableViewCell //{
            //selectedCell
        //}
        let cell = self.tableView(tableView, cellForRowAtIndexPath: indexPath) as? NewChoiceTableViewCell
        //vm.tableView(tableView, didDeselectRowAtIndexPath: indexPath)
//        if let vModel = vm as? MealViewModel {
//            if  cell != nil && !vModel.choiceCellSelectedState {
//                cell!.clearChoiceInSegmentControl()
//                //cell!.choiceLabel.text = "Pow"
//            }
//        }
        vm.didDeselectRowAtIndexPath( indexPath, viewController: self , choiceTableCell: cell)
//        if let vModel = vm as? MealViewModel {
//            if  cell != nil && !vModel.choiceCellSelectedState {
////            tableView.reloadData()
//            }
//        }
//        let section = indexPath.section
//        let rowsInSection = self.tableView(self.tableView, numberOfRowsInSection: section)
//        for row in 0..<rowsInSection {
//            let iPath = NSIndexPath(forRow: row, inSection: section)
//            let cell2 = self.tableView(tableView, cellForRowAtIndexPath: iPath) as? NewChoiceTableViewCell
//            if let choiceCell = cell2 {
//                println("Selected Index \(choiceCell.choiceLabel.text): \(choiceCell.selectedIndex)")
//                choiceCell.clearChoiceInSegmentControl()
//            }
//        }

    }
    
    override func tableView(tableView: UITableView, heightForRowAtIndexPath indexPath: NSIndexPath) -> CGFloat {
        if let dinnerVC = self.vm as? DinnerVM {
            return dinnerVC.tableView(dinnerVC.tableView, heightForRowAtIndexPath: indexPath)
        } else {
            return 44.0
        }
        
    }

    
    func backButtonPressed (sender: UIBarButtonItem ){
        self.navigationController?.popViewControllerAnimated(true)
    }

    func saveButtonTapped() {
        vm.saveButtonTapped()
    }
    
}
