//
//  MyMealsRecipesTableViewController.swift
//  GRPatienLogAndPlan
//
//  Created by James Klein on 3/30/15.
//  Copyright (c) 2015 ObjectPrism Corp. All rights reserved.
//

import UIKit

class MyMealsRecipesTableViewController: UITableViewController, UITableViewDataSource, UITableViewDelegate{

    var dataSource: [String] = []
    var selectedItemTitle: String = ""
        let myMeals: [String] = [
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
   
    let recipes: [String] = [
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

    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        dataSource = myMeals
        
        

        // Uncomment the following line to preserve selection between presentations
        // self.clearsSelectionOnViewWillAppear = false

        // Uncomment the following line to display an Edit button in the navigation bar for this view controller.
        // self.navigationItem.rightBarButtonItem = self.editButtonItem()
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }

    // MARK: - Table view data source

    override func numberOfSectionsInTableView(tableView: UITableView) -> Int {
        // #warning Potentially incomplete method implementation.
        // Return the number of sections.
        return 1
    }

    override func tableView(tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        // #warning Incomplete method implementation.
        // Return the number of rows in the section.
        return dataSource.count
    }

   
    override func tableView(tableView: UITableView, cellForRowAtIndexPath indexPath: NSIndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCellWithIdentifier("Cell", forIndexPath: indexPath) as UITableViewCell

        cell.textLabel?.text = dataSource[indexPath.row]
        

        return cell
    }
    
    override func tableView(tableView: UITableView, didSelectRowAtIndexPath indexPath: NSIndexPath) {
        selectedItemTitle = dataSource[indexPath.row]
    }

    /*
    // Override to support conditional editing of the table view.
    override func tableView(tableView: UITableView, canEditRowAtIndexPath indexPath: NSIndexPath) -> Bool {
        // Return NO if you do not want the specified item to be editable.
        return true
    }
    */

    /*
    // Override to support editing the table view.
    override func tableView(tableView: UITableView, commitEditingStyle editingStyle: UITableViewCellEditingStyle, forRowAtIndexPath indexPath: NSIndexPath) {
        if editingStyle == .Delete {
            // Delete the row from the data source
            tableView.deleteRowsAtIndexPaths([indexPath], withRowAnimation: .Fade)
        } else if editingStyle == .Insert {
            // Create a new instance of the appropriate class, insert it into the array, and add a new row to the table view
        }    
    }
    */

    /*
    // Override to support rearranging the table view.
    override func tableView(tableView: UITableView, moveRowAtIndexPath fromIndexPath: NSIndexPath, toIndexPath: NSIndexPath) {

    }
    */

    /*
    // Override to support conditional rearranging of the table view.
    override func tableView(tableView: UITableView, canMoveRowAtIndexPath indexPath: NSIndexPath) -> Bool {
        // Return NO if you do not want the item to be re-orderable.
        return true
    }
    */

    /*
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepareForSegue(segue: UIStoryboardSegue, sender: AnyObject?) {
        // Get the new view controller using [segue destinationViewController].
        // Pass the selected object to the new view controller.
    }
    */

    
}
