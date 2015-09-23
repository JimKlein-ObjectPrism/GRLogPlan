//
//  HomeTabBarController.swift
//  GRPatienLogAndPlan
//
//  Created by Jim Klein on 2/27/15.
//  Copyright (c) 2015 ObjectPrism Corp. All rights reserved.
//

import UIKit

class HomeTabBarController: UITabBarController {

    @IBOutlet weak var homeTabBar: UITabBar!
    //Array that holds Food Journal Log Item
    var dataArray = [AnyObject]()
    //var dataStore = DataStore()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        //homeTabBar
        
        //dataStore.loadFoodItems()
 
        
        // Do any additional setup after loading the view.
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    

    
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepareForSegue(segue: UIStoryboardSegue, sender: AnyObject?) {
        // Get the new view controller using segue.destinationViewController.
        // Pass the selected object to the new view controller.

        
        
    }
    
    override func tabBar(tabBar: UITabBar, didSelectItem item: UITabBarItem) {
        if item.title == "Track" {
            
  
            if self.viewControllers?.count > 1 {
                if let containerController  = self.viewControllers![1] as? SWRevealViewController {
                    
                    let trackViewNAVController =  containerController.frontViewController as! UINavigationController
                    
                    let appDelegate = UIApplication.sharedApplication().delegate as! AppDelegate
                    
                    dataArray = appDelegate.dataArray
                    
                    let trackViewController = trackViewNAVController.viewControllers[0] as! TrackTableViewController
                    
                    //set full day display type in order to generate the correct button in nav bar
                    trackViewController.displayType = MealItemSelectionDisplayType.FullDayEntryWithMenu
                    
                    // initialize and set dataArray on TrackVC
                    trackViewController.dataArray = [AnyObject]()
                    
                    if let d = dataArray[0] as? DetailDisplayItem {
                        trackViewController.detailDisplayItem = d
                    }
                    
                //}
                
            }
            else{
                
                }
            
            }
        }
    }
    

}
