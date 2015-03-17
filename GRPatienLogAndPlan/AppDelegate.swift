//
//  AppDelegate.swift
//  GRPatienLogAndPlan
//
//  Created by Jim Klein on 2/25/15.
//  Copyright (c) 2015 ObjectPrism Corp. All rights reserved.
//

import UIKit

@UIApplicationMain
class AppDelegate: UIResponder, UIApplicationDelegate {

    //Array that holds Food Journal Log Item
    var dataArray = [AnyObject]()

    var window: UIWindow?

    var dataStore: DataStore!

    func application(application: UIApplication, didFinishLaunchingWithOptions launchOptions: [NSObject: AnyObject]?) -> Bool {
        // Override point for customization after application launch.
        
        dataStore = DataStore()
        dataArray = dataStore.buildDetailViewArray()
        
        
        let storyboard = UIStoryboard(name: "Main", bundle: nil)
        
        // instantiate nav controller for Track tab and set data
        var contentNavController = storyboard.instantiateViewControllerWithIdentifier("TrackNavController") as UINavigationController
        
        var trackMenuController = storyboard.instantiateViewControllerWithIdentifier("TrackMenuController") as UINavigationController
        
        var trackController = storyboard.instantiateViewControllerWithIdentifier("Track") as SWRevealViewController
        
        //set up delegates for selecting items in the menu

        let detailTableViewController = contentNavController.viewControllers[0] as TrackTableViewController
        let menuTableViewController = trackMenuController.viewControllers[0] as MenuTrackTableViewController
        
        menuTableViewController.menuItemSelectionHandler = dataStore
        dataStore.updateDetailViewDelegate = detailTableViewController
        
        trackController.frontViewController = contentNavController
        trackController.rearViewController = trackMenuController
       
        var homeViewController = storyboard.instantiateViewControllerWithIdentifier("Home") as HomeViewController
        
        let homeNaveController = storyboard.instantiateViewControllerWithIdentifier("HomeNavController") as UINavigationController
        
        //let homeViewController = homeNaveController.viewControllers[0] as HomeViewController
        
        ////BUG:
        
        
        let tabBarController = HomeTabBarController()
        
        tabBarController.viewControllers?.removeAll(keepCapacity: false)
        
        let controllers = [ homeNaveController , trackController ]

        tabBarController.viewControllers = controllers
        
        window?.rootViewController = tabBarController
        trackController.tabBarItem =  UITabBarItem(title: "Track", image: UIImage(named: "Track-16"), selectedImage: nil)
        homeNaveController.tabBarItem =  UITabBarItem(title: "Home", image: UIImage(named: "home-16"), selectedImage: nil)
        return true
    }

    func applicationWillResignActive(application: UIApplication) {
        // Sent when the application is about to move from active to inactive state. This can occur for certain types of temporary interruptions (such as an incoming phone call or SMS message) or when the user quits the application and it begins the transition to the background state.
        // Use this method to pause ongoing tasks, disable timers, and throttle down OpenGL ES frame rates. Games should use this method to pause the game.
    }

    func applicationDidEnterBackground(application: UIApplication) {
        // Use this method to release shared resources, save user data, invalidate timers, and store enough application state information to restore your application to its current state in case it is terminated later.
        // If your application supports background execution, this method is called instead of applicationWillTerminate: when the user quits.
    }

    func applicationWillEnterForeground(application: UIApplication) {
        // Called as part of the transition from the background to the inactive state; here you can undo many of the changes made on entering the background.
    }

    func applicationDidBecomeActive(application: UIApplication) {
        // Restart any tasks that were paused (or not yet started) while the application was inactive. If the application was previously in the background, optionally refresh the user interface.
    }

    func applicationWillTerminate(application: UIApplication) {
        // Called when the application is about to terminate. Save data if appropriate. See also applicationDidEnterBackground:.
    }


}

