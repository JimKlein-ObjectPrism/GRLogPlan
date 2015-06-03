//
//  ProfileTableViewController.swift
//  GRPatienLogAndPlan
//
//  Created by James Klein on 4/28/15.
//  Copyright (c) 2015 ObjectPrism Corp. All rights reserved.
//

import UIKit

class ProfileTableViewController: UITableViewController {
    var appDelegate: AppDelegate!
    
    var dataArray: [AnyObject]!
    
    var dataStore: DataStore!

    override func viewDidLoad() {
        super.viewDidLoad()

        self.navigationController?.navigationBar.barTintColor = UIColor(red: 150.0/255.0, green: 185.0/255.0, blue: 118.0/255.0, alpha: 1.0)
        
        self.appDelegate = UIApplication.sharedApplication().delegate as? AppDelegate
        

    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
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
            return 3
        case 1:
            return 2
        default:
            return 0
        }
        
    }
    
    
    
    func pushAddOnsVC() {
        var profile = dataStore.getCurrentProfile()
        var profileAddOns = currentRecord.profile.addOns
        
        var addOns = [OPAddOn]()
        
        for x in profileAddOns {
            addOns.append( x as! OPAddOn)
        }
        
        let vc : ParentViewController = self.storyboard?.instantiateViewControllerWithIdentifier("ParentViewController") as! ParentViewController
        
        vc.navigationItem.title = "AddOns"
        vc.currentDisplayType = ParentViewControllerDisplayType.AddOns
        
        // set addOns property
        vc.addOns = addOns
        
        //set delegate property
        vc.dataStoreDelegate = AppDelegate.dataStore
        
        self.showViewController(vc as UIViewController, sender: vc)
        
    }


  }
