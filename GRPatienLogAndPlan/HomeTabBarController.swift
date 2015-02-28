//
//  HomeTabBarController.swift
//  GRPatienLogAndPlan
//
//  Created by Jim Klein on 2/27/15.
//  Copyright (c) 2015 ObjectPrism Corp. All rights reserved.
//

import UIKit

class HomeTabBarController: UITabBarController {

    override func viewDidLoad() {
        super.viewDidLoad()
        
        var dataStore = DataStore()
        dataStore.loadFoodItems()
        

        // Do any additional setup after loading the view.
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    

    /*
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepareForSegue(segue: UIStoryboardSegue, sender: AnyObject?) {
        // Get the new view controller using segue.destinationViewController.
        // Pass the selected object to the new view controller.
    }
    */

}
