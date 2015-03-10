//
//  HomeTabBarController.swift
//  GRPatienLogAndPlan
//
//  Created by Jim Klein on 2/27/15.
//  Copyright (c) 2015 ObjectPrism Corp. All rights reserved.
//

import UIKit

class HomeTabBarController: UITabBarController {

    //Array that holds Food Journal Log Item 
    var dataArray = [AnyObject]()
    
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
    

    
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepareForSegue(segue: UIStoryboardSegue, sender: AnyObject?) {
        // Get the new view controller using segue.destinationViewController.
        // Pass the selected object to the new view controller.
        let appDelegate = UIApplication.sharedApplication().delegate as AppDelegate
        
        dataArray = appDelegate.dataArray
        
        
    }
    
    override func tabBar(tabBar: UITabBar, didSelectItem item: UITabBarItem!) {
        if item.title == "One" {
            println("hello \(self.viewControllers!.count)")
  
            if self.viewControllers!.count > 1 {
            if let containerController  = self.viewControllers![1] as? SWRevealViewController {
                println("vc found \(containerController.frontViewController!.title)")
                let trackViewController =  containerController.frontViewController as TrackViewController
                //containerController.rearViewController!.viewControllers.count
                //println(containerController.rearViewController.)
                
                //containerController.setRearViewController(contentViewController, animated: false)
//                if containerController.frontViewController != nil {
//                    println("non-nil rear controller")
//                }
//                if let foodItemDisplayController = containerController.rearViewController!   as? UINavigationController{//TrackTableViewController {
//                    
//                    println("accessed menu nav controller!")
//                }
                
            }
            else{
                
                }
            
            }
        }
    }
    

}
