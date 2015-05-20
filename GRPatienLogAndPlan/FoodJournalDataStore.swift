//
//  FoodJournalDataStore.swift
//  FoodItemDataStoreTest
//
//  Created by Jim Klein on 2/17/15.
//  Copyright (c) 2015 ObjectPrism Corp. All rights reserved.
//

import Foundation

import CoreData

class DataStore: NSObject, NSXMLParserDelegate,  MenuItemSelectedDelegate, ChoiceItemSelectedDelegate {
    
    var managedContext: NSManagedObjectContext!
    
    // Items that define or are used to define the contents of the Food Journal Log item
    var logEntryItems = [AnyObject]()
    
    //MARK: Data Objects for View Model
    var breakfast: VMBreakfast?
    
    //MARK: Parsing Variables
    var currentElementName = ""
    
    var currentElementValue = ""
    
    var foodItemArray = [FoodItem]()
    
    var foodItemStackArray = [FoodItem]()
    
    var currentFoodItem: FoodItem?
    
    var currentFoodItemWithChoice: FoodItemWithChoice?
    
    var currentMealItem: MealItem?
    
    //Stack variables
    var currentIndexOfTopStackItem: Int = 0
    
    var stackIndexValue: Int = 0
    
    //MARK: Delegates - currently only used method
    var updateDetailViewDelegate: UpdateDetailViewDelegate!
    
    override init() {
        //configure with placeholder until CoreData working
        BreakfastMenuCategory.configureMenuChoice(OPProfile())
        
        //initialize Data Objects
        if self.breakfast == nil {
            self.breakfast = VMBreakfast()
        }
    }
    
    //MARK:  Get food item array
    func buildFoodItemArray ( mealItem: FoodItem?, filterString: String ) -> [FoodItem]{
        
        var fItems: [FoodItem] = [FoodItem]()
        /*
        The food item array has 1 or n entries
        1, if item has been selected
        n, if not
        */
        if  (mealItem != nil) {
            //copy pre-selected food item to array
            fItems.append(mealItem!)
            
        } else {
            // get subtype of food items for selection
            let items = foodItems.filter({m in
                m.menuItemType == filterString
            })
            fItems = items
        }
        return fItems
    }
    
    //MARK:  Data Object API
    func getBreakfast_Today() -> VMBreakfast {
        return self.breakfast!//initialized in init
    }
    
    func saveBreakfast_Today(breakfast: VMBreakfast){
        self.breakfast = breakfast
    }
    
    
    //MARK: Data Update Delgate Methods
    func choiceItemSelectedHandler(childItemIndex: Int, indexPath: NSIndexPath){
        //update current meal item
        println("l'")
        currentMealItem = Lunch()
        
        switch currentMealItem {
        case let x as Breakfast:
            println("breaky")
        case let x as Lunch:
            switch indexPath.row{
            case 0:
                x.meat = ""
                
            case 1:
                x.fruitChoice?.name = ""
            default:
                println("index out of range")
            }
        default:
            println("index out of range")
            assertionFailure("index out of range")
        }
        //update viewmodel
        
        
    }
    
    func setValueForChoiceMealItem() {
        // get meal item from view model
        
        // concatenate parent.name , chosenchild.name
        
        //set value in model object
    }
    
    
    //MARK: CoreData Methods
    
    //func getNew
    
    
    //MARK: Array Assembly Items
    
    var foodItems = [FoodItem]()
    
    func buildJournalEntry ( profile: PatientProfile ) -> JournalItem{
        return JournalItem(itemTitle: "test jounal entry")// itemTitle: "test journal item")
        
    }
    
    func loadProfile() -> PatientProfile {
        var profile = PatientProfile()
        return profile
    }
    

    
   
    func buildDetailViewArray() -> [AnyObject]{
        
        var profile = self.loadProfile()
        var journalItem = self.buildJournalEntry(profile)
        
        //var logEntryItems = [Any]()
        
        //foodItems Array used by all foodItems
        self.foodItems = self.loadFoodItems()
        
        logEntryItems.append(buildBreakfastItems(profile, journalItem: journalItem))
        logEntryItems.append(self.buildLunchItems(profile, journalItem: journalItem))
        logEntryItems.append(Snack())
        logEntryItems.append(self.buildDinnerItems(profile, journalItem: journalItem))
        logEntryItems.append(Medicine())
        logEntryItems.append(Activity())
        //TODO:  Load additional meal items
        
        return logEntryItems
    }
    
    func updateMealItems (mealItem: MealItem, section: Int, row: Int, foodItem: FoodItem) {
        
        switch mealItem {
        case let mealItem as Breakfast:
            if section == 0 {
                mealItem.foodChoice = foodItem
            } else {
                mealItem.fruitChoice = foodItem
            }
            
        case let mealItem as Lunch:
            
            if section == 0 {
            
            }
            
        default:
            println("error")
        }
        
    }
    func buildFoodItemArray (#filterString: String ) -> [FoodItem]{
        
       // get subtype of food items for selection
        let fItems = foodItems.filter({m in
            m.menuItemType == filterString
        })
        
        return fItems
    }

    
    func menuItemSelectedHandler(menudisplayType: MenuDisplayCell){
        switch menudisplayType{
        case let menudisplayType as Breakfast:
            updateDetailViewDelegate.updateDetailViewHandler(self.buildBreakfastItems(loadProfile(), journalItem: buildJournalEntry(loadProfile())))
            
        case let menudisplayType as Lunch:
            updateDetailViewDelegate.updateDetailViewHandler(
                self.buildLunchItems(loadProfile(), journalItem: buildJournalEntry(loadProfile()))
                )
        case let menudisplayType as Dinner:
            updateDetailViewDelegate.updateDetailViewHandler(
                self.buildDinnerItems(loadProfile(), journalItem: buildJournalEntry(loadProfile())
                ))
            
        default:
            println("rest of menu Item Selection Handler not written yet")
            
        }
    }
    
    func buildMealDetailsArray (parentInitials: ParentInitials, place: Place, time: Time, note: Note ) -> [AnyObject]{
        //TODO: Refactor to take optional paramters like buildFoodItemArray
        return [parentInitials, place, time, note]
    }
    
    func buildBreakfastItems ( patientProfile: PatientProfile, journalItem: JournalItem ) -> BreakfastItems {
      
        // build breakfastChoice food item array
        let breakfastChoiceItems = self.buildFoodItemArray(journalItem.breakfastChoice.foodChoice, filterString: "BreakfastItem")
        let breakfastFruitChoice = self.buildFoodItemArray(journalItem.breakfastChoice.fruitChoice, filterString: "FruitItem")
        let mealDetails = buildMealDetailsArray(ParentInitials(initialsArray: ["J.D.", "A.D."], defaultInitials: "A.D."), place: Place(location: "Kitchen"), time: Time(), note: Note())
        
        let headerTitles = ["Choose One", "And A Serving of Fruit", "Additional Info"]
        let itemSelectedHeaderTitles = ["Breakfast Item", "Fruit Item" , "Additional Info"]
        
        let breakfast: BreakfastItems = BreakfastItems(
            breakfastItem: journalItem.breakfastChoice,
            headerTitles:  headerTitles,
            itemSelectedHeaderTitles: itemSelectedHeaderTitles,
            breakfastChoice:  breakfastChoiceItems,
            fruitChoice: breakfastFruitChoice,
            mealDetails: mealDetails)
        
        return breakfast
    }
    func buildSnackItems ( patientProfile: PatientProfile, journalItem: JournalItem ) -> BreakfastItems {
        
        // build breakfastChoice food item array
        let breakfastChoiceItems = self.buildFoodItemArray(journalItem.breakfastChoice.foodChoice, filterString: "SnackItem")
        let breakfastFruitChoice = self.buildFoodItemArray(journalItem.breakfastChoice.fruitChoice, filterString: "FruitItem")
        let mealDetails = buildMealDetailsArray(ParentInitials(initialsArray: ["J.D.", "A.D."], defaultInitials: "A.D."), place: Place(location: "Kitchen"), time: Time(), note: Note())
        
        let headerTitles = ["Choose One", "And A Serving of Fruit", "Additional Info"]
        let itemSelectedHeaderTitles = ["Snack Item", "Fruit Item" , "Additional Info"]
        
        let breakfast: BreakfastItems = BreakfastItems(
            breakfastItem: journalItem.breakfastChoice,
            headerTitles:  headerTitles,
            itemSelectedHeaderTitles: itemSelectedHeaderTitles,
            breakfastChoice:  breakfastChoiceItems,
            fruitChoice: breakfastFruitChoice,
            mealDetails: mealDetails)
        
        return breakfast
    }
    func buildLunchItems ( patientProfile: PatientProfile, journalItem: JournalItem ) -> LunchItems {
        
        // build lunchChoice food item array
        let lunchChoiceItems = self.buildFoodItemArray(journalItem.lunchItem.meatChoice, filterString: "LunchItem")
        let fruitChoice = self.buildFoodItemArray(journalItem.lunchItem.fruitChoice, filterString: "FruitItem")
        let mealDetails = buildMealDetailsArray(ParentInitials(initialsArray: ["J.D.", "A.D."], defaultInitials: "A.D."), place: Place(location: "Kitchen"), time: Time(), note: Note())
        
        let headerTitles = ["2 Pieces of Bread With", "And A Serving of Fruit", "Additional Info"]
        let itemSelectedHeaderTitles = ["Sandwich Item", "Fruit Item", "Additional Info"]
        
        let lunch: LunchItems = LunchItems(
            item: journalItem.lunchItem,
            headerTitles: headerTitles,
            itemSelectedHeaderTitles: itemSelectedHeaderTitles,
            lunchChoice: lunchChoiceItems,
            fruitChoice: fruitChoice,
            mealDetails: mealDetails
        )
         return lunch
    }
    
    func buildDinnerItems ( patientProfile: PatientProfile, journalItem: JournalItem ) -> DinnerItems {
        
        // build lunchChoice food item array
        let meat = self.buildFoodItemArray(journalItem.dinner.meat, filterString: "MeatDinnerItem")
        let starch = self.buildFoodItemArray(journalItem.dinner.starch, filterString: "StarchDinnerItem")
        let oil = self.buildFoodItemArray(journalItem.dinner.oil, filterString: "OilDinnerItem")
        let vegetable = self.buildFoodItemArray(journalItem.dinner.vegetable, filterString: "VegetableItem")
        let requiredItems = self.buildFoodItemArray(journalItem.dinner.requiredItems, filterString: "RequiredDinnerItem")
        let mealDetails = buildMealDetailsArray(ParentInitials(initialsArray: ["J.D.", "A.D."], defaultInitials: "A.D."), place: Place(location: "Kitchen"), time: Time(), note: Note())
        
        let headerTitles = ["Choose One", "Choose One", "Choose One", "1 1/2 c Vegetables", "Required Items", "Additional Info"]
        let itemSelectedHeaderTitles = ["Choose One", "Choose One", "Choose One", "1 1/2 c Vegetables", "Required Items", "Additional Info"]
        
        let mealEvent: DinnerItems = DinnerItems(
            dinnerItem: journalItem.dinner,
            headerTitles: headerTitles,
            itemSelectedHeaderTitles: itemSelectedHeaderTitles,
            meat: meat,
            starch: starch,
            oil: oil,
            vegetable: vegetable,
            requiredItems: requiredItems,

            mealDetails: mealDetails
        )
        return mealEvent
    }
    
    func foodItemsPath() -> String {
        return NSBundle.mainBundle().pathForResource("MealItems", ofType: "xml")!
    }

    func getDinnerChoiceItems() -> [Any]{
        var choiceItems = [Any]()
        // Get MeatChoiceItems
        
        return choiceItems
    }
    
    
    
    func activitiesPath() -> String {
        return NSBundle.mainBundle().pathForResource("TestV1", ofType: "xml")!
    }
    
    func loadFoodItems() -> [FoodItem] {

        parseFile()
        return foodItemArray
    }
    func parseFile ()
    {
        var xmlPath = foodItemsPath()
        // TODO:  unwrap this
        let url: NSURL! = NSBundle.mainBundle().URLForResource("MealItems", withExtension: "xml")
        let xmlParser = NSXMLParser(contentsOfURL: url)
        xmlParser!.delegate = self
        var success:Bool = xmlParser!.parse()
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
    func parser(parser: NSXMLParser, didStartElement elementName: String, namespaceURI: String?, qualifiedName qName: String?, attributes attributeDict: [NSObject: AnyObject]) {
        
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

    func parser(parser: NSXMLParser, didEndElement elementName: String, namespaceURI: String?, qualifiedName qName: String?) {
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

    func parser(parser: NSXMLParser,foundCharacters string: String?) {
        currentElementValue = string!
    }

    func parser(parser: NSXMLParser, parseErrorOccurred parseError: NSError) {
        println(parseError)
    }
    
//    func addJournalItem(activity: JournalItem) {
//        // TODO: Implement me!
//        println("addActivity called... but it's not implemented yet!")
//}

}