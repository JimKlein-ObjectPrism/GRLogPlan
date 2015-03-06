//
//  FoodJournalDataStore.swift
//  FoodItemDataStoreTest
//
//  Created by Jim Klein on 2/17/15.
//  Copyright (c) 2015 ObjectPrism Corp. All rights reserved.
//

import Foundation

class DataStore: NSObject, NSXMLParserDelegate  {
    
    
    var currentElementName = ""
    
    var currentElementValue = ""
    
    var foodItemArray = [FoodItem]()
    
    var foodItemStackArray = [FoodItem]()
    
    var currentFoodItem: FoodItem?
    
    var currentFoodItemWithChoice: FoodItemWithChoice?
    
    //Stack variables
    var currentIndexOfTopStackItem: Int = 0
    
    var stackIndexValue: Int = 0
    
    func buildJournalEntry ( profile: PatientProfile ){
        
        
    }
    
    func buildDetailViewArray( foodItems: [FoodItem]){
        let breakFastItems = foodItems.filter({m in
        m.menuItemType == "BreakfastItem"
        })
    }
    
    
    func foodItemsPath() -> String {
        return NSBundle.mainBundle().pathForResource("MealItems", ofType: "xml")!
    }
    
    func loadProfile() -> PatientProfile {
        var profile = PatientProfile()
        return profile
    }
    
    func loadFoodItems() -> [FoodItem] {
        
        parseFile()
        return foodItemArray
    }
    func parseFile ()
    {
        var xmlPath = foodItemsPath()
        
        var xmlData: AnyObject = NSData.dataWithContentsOfMappedFile(xmlPath)!
        let xmlParser = NSXMLParser.init(data: xmlData as NSData)
        xmlParser.delegate = self
        var success:Bool = xmlParser.parse()
        println(success)
        
        
    }
    
    
    func resetLocalVariablesForNewFoodItem ()
    {
        //currentFoodItem = nil only do this when Popping FoodItem
        currentElementName = ""
        currentElementValue = ""
    }
    
    // MARK: Stack Methods
    func PushFoodItem ( foodItem: FoodItemWithChoice)
    {
        currentFoodItemWithChoice = foodItem
        currentFoodItem = foodItem
        foodItemArray.append(foodItem)
        foodItemStackArray.append(foodItem)
        currentIndexOfTopStackItem++
        
    }
    
    func PushFoodItem (foodItem: FoodItem) {
        //TODO: update for FoodItemWithChoice
        
        //handle FoodItem case
        if currentIndexOfTopStackItem == 0 {
            //handle empty stack case:  this is an ordinary FoodItem
            
            foodItemArray.append(foodItem)
            foodItemStackArray.append(foodItem)
            currentFoodItem = foodItem
            currentIndexOfTopStackItem++
        } else {
            //handle non-nil case: this is a child food item of a FoodItemWithChoice
            if let foodItemWithChoice = foodItemStackArray[0] as? FoodItemWithChoice {
                //add to choice items and push on stack
                foodItemWithChoice.choiceItems.append(foodItem)
                currentFoodItem = foodItem
                foodItemStackArray.append(foodItem)
                currentIndexOfTopStackItem++
            } else {
                println("error:  non-nil currentItem encountered")
            }
            
        }
        
    }
    
    func PopFoodItem () {
        
        //set currentFoodItem to top of  stack, unless stack is empty, in which case set current FoodItem to nil
        if foodItemStackArray.count > 0 {
            
            //remove top, set next item to current item
            foodItemStackArray.removeLast()
            currentIndexOfTopStackItem--
            
            if currentIndexOfTopStackItem > 0{
                currentFoodItem = foodItemStackArray.last
            }
            else {
                currentFoodItem = nil
            }
            
        }
        
        
    }
    
    //MARK: Set Properties
    func setPropertyOnFoodItem (){
        switch currentElementName {
        case "name":
            currentFoodItem!.name = currentElementValue
        case "itemDescription":
            currentFoodItem!.itemDescription = currentElementValue
        case "measurement":
            var m: Double = (currentElementName as NSString).doubleValue
            currentFoodItem!.serving.measurement = m
        case "unit":
            currentFoodItem!.serving.unit = currentElementValue
        case "servingDescription":
            currentFoodItem!.serving.servingDescription = currentElementValue
        case "menuItemType":
            currentFoodItem!.menuItemType = currentElementValue
        default:
            println("default reached in error for set PropertyOnFoodItem \(currentElementName), \(currentElementValue)")
        }
    }
    
    // MARK: NSXMLParser Delegate
    func parser(parser: NSXMLParser!,didStartElement elementName: String!, namespaceURI: String!, qualifiedName : String!, attributes attributeDict: NSDictionary!) {
        
        //TODO:  should be a simle If statement
        switch elementName {
        case "foodItem":
            var foodItem = FoodItem()
            PushFoodItem(foodItem)
        case "foodItemWithChoice":
            var foodItem = FoodItemWithChoice()
            PushFoodItem(foodItem)
            
        default:
            currentElementName = elementName
            println(elementName)
        }
        
    }
    
    func parser(parser: NSXMLParser!, didEndElement elementName: String!, namespaceURI: String!, qualifiedName qName: String!) {
        switch elementName {
        case "foodItem" :
            PopFoodItem()
        case "foodItemWithChoice":
            PopFoodItem()
        case "root":
            println(elementName)
        case  "choiceItems" :
            println(elementName)
        case "serving":
            println(elementName)
        default:
            setPropertyOnFoodItem()
        }
        
        resetLocalVariablesForNewFoodItem()
        
    }
    
    func parser(parser: NSXMLParser!, foundCharacters string: String!) {
        currentElementValue = string
    }
    
    func parser(parser: NSXMLParser!, parseErrorOccurred parseError: NSError!) {
        println(parseError)
    }
    
    //    func addJournalItem(activity: JournalItem) {
    //        // TODO: Implement me!
    //        println("addActivity called... but it's not implemented yet!")
    //}
    
}