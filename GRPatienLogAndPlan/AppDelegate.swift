
//
//  AppDelegate.swift
//  GRPatienLogAndPlan
//
//  Created by Jim Klein on 2/25/15.
//  Copyright (c) 2015 ObjectPrism Corp. All rights reserved.
//

import UIKit
import CoreData

@UIApplicationMain

class AppDelegate: UIResponder, UIApplicationDelegate {

    //Array that holds Food Journal Log Item
    var dataArray = [AnyObject]()

    var window: UIWindow?
    
    var todaysDate: String!
    
    lazy var coreDataStack = CoreDataStack()

    var dataStore: DataStore!
    
    static let printService: PrintSevice =  PrintSevice()

    func application(application: UIApplication, didFinishLaunchingWithOptions launchOptions: [NSObject: AnyObject]?) -> Bool {
        // Override point for customization after application launch.        
        dataStore = DataStore(managedContext: coreDataStack.context)
        todaysDate = dataStore.today
        
        //dataStore.managedContext = coreDataStack.context
        
        //dataArray = dataStore.buildDetailViewArray()
        
        
        let storyboard = UIStoryboard(name: "Main", bundle: nil)
        
        // instantiate nav controller for Track tab and set data
        let contentNavController = storyboard.instantiateViewControllerWithIdentifier("TrackNavController") as! UINavigationController
        
        let trackMenuController = storyboard.instantiateViewControllerWithIdentifier("TrackMenuController") as! UINavigationController
        
        let trackController = storyboard.instantiateViewControllerWithIdentifier("Track") as! SWRevealViewController
        
        //set up delegates for selecting items in the menu

        let detailTableViewController = contentNavController.viewControllers[0] as! TrackTableViewController
        detailTableViewController.dataStore = dataStore
        
        let menuTableViewController = trackMenuController.viewControllers[0] as! MenuTrackTableViewController
        
        menuTableViewController.menuItemSelectionHandler = dataStore
        dataStore.updateDetailViewDelegate = detailTableViewController
        
        trackController.frontViewController = contentNavController
        trackController.rearViewController = trackMenuController
       
//        var homeViewController = storyboard.instantiateViewControllerWithIdentifier("Home") as! HomeViewController
        
        let homeNaveController = storyboard.instantiateViewControllerWithIdentifier("HomeNavController") as! UINavigationController
        
        
        let newTrackTableVC =  storyboard.instantiateViewControllerWithIdentifier("FoodJournalTableViewController") as! FoodJournalTableViewController
        newTrackTableVC.appDelegate = self
        
        let newTrackNav = storyboard.instantiateViewControllerWithIdentifier("FoodJournalNavController") as! UINavigationController
        menuTableViewController.menuItemSelectionHandler = dataStore
        
        let profileTableVC =  storyboard.instantiateViewControllerWithIdentifier("ProfileTableViewController") as! ProfileTableViewController
        let profileNav = storyboard.instantiateViewControllerWithIdentifier("ProfileNavController") as! UINavigationController
        profileTableVC.appDelegate = self
        profileTableVC.dataStore = dataStore
        
        let printTableVC =  storyboard.instantiateViewControllerWithIdentifier("PrintViewController") as! PrintViewController
        let printNavVC = storyboard.instantiateViewControllerWithIdentifier("PrintViewNavController") as! UINavigationController
        printTableVC.appDelegate = self
        
        // set up Tab Bar Controller
        let tabBarController = HomeTabBarController()
        
        tabBarController.viewControllers?.removeAll(keepCapacity: false)
        
        // tab bar target view controllers added in order here:
        let controllers = [ homeNaveController , newTrackNav , printNavVC, profileNav ]
        //let controllers = [ homeNaveController , detailTableViewController, trackController , menuTableViewController]

        tabBarController.viewControllers = controllers
        //TODO:  hook up proper Profile and Single Day View controller destinations
        // set tab bar icon and text here
        newTrackNav.tabBarItem =  UITabBarItem(title: "Track", image: UIImage(named: "calendar_day-16"), selectedImage: nil)
        homeNaveController.tabBarItem =  UITabBarItem(title: "Home", image: UIImage(named: "home-16"), selectedImage: nil)
        
        printNavVC.tabBarItem =  UITabBarItem(title: "Print", image: UIImage(named: "print-16"), selectedImage: nil)
        profileNav.tabBarItem =  UITabBarItem(title: "Profile", image: UIImage(named: "profile_user-16"), selectedImage: nil)
        
        window?.rootViewController = tabBarController
        
        return true
    }

    
    
    func applicationWillResignActive(application: UIApplication) {
        // Sent when the application is about to move from active to inactive state. This can occur for certain types of temporary interruptions (such as an incoming phone call or SMS message) or when the user quits the application and it begins the transition to the background state.
        // Use this method to pause ongoing tasks, disable timers, and throttle down OpenGL ES frame rates. Games should use this method to pause the game.
    }

    func applicationDidEnterBackground(application: UIApplication) {
        // Use this method to release shared resources, save user data, invalidate timers, and store enough application state information to restore your application to its current state in case it is terminated later.
        // If your application supports background execution, this method is called instead of applicationWillTerminate: when the user quits.
        
        coreDataStack.saveContext()
    }
    

    func applicationWillEnterForeground(application: UIApplication) {
        // Called as part of the transition from the background to the inactive state; here you can undo many of the changes made on entering the background.
        //dataStore.initializeJournalEntryForCurrentDay()
        //println("ApplicationDelegate: appWillEnterForeground Called.")

    }

    func applicationDidBecomeActive(application: UIApplication) {
        // Reset the currentJournalEntry.
        //println("ApplicationDelegate: appDidBecomeActive Called.")
        dataStore.mealState = MealState.getMealState(NSDate())

        if self.todaysDate != dataStore.today {
            todaysDate = dataStore.today
            dataStore.initializeTodayJournalEntryForCurrentDay()
        }
        
    }

    func applicationWillTerminate(application: UIApplication) {
        // Called when the application is about to terminate. Save data if appropriate. See also applicationDidEnterBackground:.
        coreDataStack.saveContext()
    }


}

