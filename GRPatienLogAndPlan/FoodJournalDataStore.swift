//
//  FoodJournalDataStore.swift
//  FoodItemDataStoreTest
//
//  Created by Jim Klein on 2/17/15.
//  Copyright (c) 2015 ObjectPrism Corp. All rights reserved.
//

import Foundation

import CoreData

enum JournalEntryResult {
    case Success(OPJournalEntry),
    EntryDoesNotExist,
    Error(NSError?)
    
}

public class DataStore: NSObject, NSXMLParserDelegate,  MenuItemSelectedDelegate, ChoiceItemSelectedDelegate, ProfileDataStoreDelegate {
    
    var managedContext: NSManagedObjectContext
    
    public var parentsArray: [String] = []

    var currentAddOns: [OPAddOn] = [OPAddOn]()
    var currentParents: [OPParent] = [OPParent]()
    var currentMedicines: [OPMedicine] = [OPMedicine]()

    
    var currentRecord: OPPatientRecord!
    var currentJournalEntry: OPJournalEntry!
    
    var todayJournalEntry: OPJournalEntry!
    
    var offsetNumberOfDaysFromCurrentDay: Int = 0
    
    var currentBreakfast: OPBreakfast!

    lazy var today: String = {
        var dateFormatter = NSDateFormatter()
        dateFormatter.dateFormat = "EEEE, MMM dd, yyyy"
        return dateFormatter.stringFromDate(NSDate())
    }()
    
    
    
    // Items that define or are used to define the contents of the Food Journal Log item
    var logEntryItems = [AnyObject]()
    
    //MARK: Parents Model
    public func getParents() -> [OPParent] {
        var profileparents = currentRecord.profile.parents
        currentParents = [OPParent]()
        
        // Create new Parent Object, then add to top of array sent to tableview
        let parentEntity = NSEntityDescription.entityForName("OPParent",
            inManagedObjectContext: managedContext)
        
        var parent: OPParent = OPParent(entity: parentEntity!,
            insertIntoManagedObjectContext: managedContext)
        parent.firstName = ""
        parent.lastName = ""
        currentParents.append(parent)
        
        for x in profileparents {
            currentParents.append( x as! OPParent)
        }
        
        return currentParents
        
    }
    
    public func addParentToModel ( firstName: String, lastName: String ) -> (OPParent?, NSError?) {
        
        let parentEntity = NSEntityDescription.entityForName("OPParent",
            inManagedObjectContext: managedContext)
        
        var parent: OPParent = OPParent(entity: parentEntity!,
            insertIntoManagedObjectContext: managedContext)
        
        parent.profile = currentRecord.profile
        
        parent.firstName = firstName
        parent.lastName = lastName
        
        
        var error: NSError?
        if !managedContext.save(&error) {
            println("Could not save: \(error)")
            return ( nil, error)
        }
        else{
            return (parent, nil)
        }
    }
    
    
    public func addParent( firstName: String?, lastName: String?) -> (parent: OPParent?, errorArray: [ParentProfileValidation]){
        var errors = [ParentProfileValidation]()
        
        if firstName == nil {
            errors.append(ParentProfileValidation.FirstNameIsNil)
        }
        if lastName == nil {
            errors.append(ParentProfileValidation.LastNameIsNil)
        }
        
        
        if errors.count == 0 {
            //forced unwrap OK because no errors encountered
            let result = addParentToModel(firstName!, lastName: lastName!)
            if let parent = result.0 {
                errors.append(ParentProfileValidation.Success)
                // return value with no errors
                return (parent, errors)
            } else {
                errors.append(ParentProfileValidation.CoreDataErrorEncountered)
            }
        }
        // return value when errors occur
        return (nil, errors)
    }
    
    public func validateParentInput (atIndex: Int, firstName: String?, lastName: String?) -> [ParentProfileValidation] {
        var errors = [ParentProfileValidation]()
        
        if firstName == nil {
            errors.append(ParentProfileValidation.FirstNameIsNil)
        }
        if lastName == nil {
            errors.append(ParentProfileValidation.LastNameIsNil)
        }
        if atIndex < 0 || atIndex > currentProfile().profile.parents.count  {
            errors.append(ParentProfileValidation.IndexOutOfRange)
        }
        
        return (errors)
        
    }
    public func updateParentInModel( atIndex: Int, firstName: String?, lastName: String?) -> (parent: OPParent?, errorArray: [ParentProfileValidation]){
        
        var validationResult = validateParentInput(atIndex, firstName: firstName, lastName: lastName)
        
        if validationResult.count == 0  {
            //forced unwrap OK because no errors encountered
            let result = updateParent(atIndex, firstName: firstName!, lastName: lastName!)
            if let parent = result.0 {
                // return value with no errors
                validationResult.append(ParentProfileValidation.Success)
                return (parent, validationResult)
            } else {
                validationResult.append(ParentProfileValidation.CoreDataErrorEncountered)
            }
        }
        else {
            //TODO: handle error message here
        }
        // return value when errors occur
        return (nil, validationResult)
    }
    
    
    func updateParent ( atIndex: Int, firstName: String, lastName: String) -> (OPParent?, NSError?)  {
        
        var parent: OPParent = self.currentParents[atIndex]
        
        parent.firstName = firstName
        parent.lastName = lastName
        
        //set relationship if this is top cell used for initial input
        if atIndex == 0 {
            parent.profile = currentRecord.profile
        }
        var error: NSError?
        if !managedContext.save(&error) {
            println("Could not save: \(error)")
            return (nil, error)
        }
        
        return ( parent, nil)
    }
    
    public func deleteParent(index: Int)-> (parent: OPParent?, coreDataError: NSError?) {
        let parentToDelete = self.currentParents[index]
        managedContext.deleteObject(parentToDelete)
        
        var error: NSError?
        if !managedContext.save(&error) {
            println("Could not save: \(error)")
            return (parentToDelete, error)
        }
        
        return (parentToDelete, nil)
    }
    
    //MARK: Medicine Model
    func getMedicines() -> [OPMedicine] {
        let profileMedicines = currentRecord.profile.medicineLIst
        currentMedicines = [OPMedicine]()
        for x in profileMedicines {
            currentMedicines.append( x as! OPMedicine)
        }
        return currentMedicines
    }

    func validateMedicineResult(medicine: Int, prescribedTimeForAction: Int) -> [MedicineValidation]{
        //TODO: Medicine Validation array:  What should be included?  No out of index range error if input is enum!
        var validationResult = [MedicineValidation]()
        
        
        return validationResult
    }
    
    public func addMedicine (medicine: Int, prescribedTimeForAction: Int) -> (medObject: OPMedicine?, errorArray: [MedicineValidation]) {
        // validate input
        var validationResult = validateMedicineResult(medicine , prescribedTimeForAction: prescribedTimeForAction)
        
        
        if validationResult.count == 0  {
            //forced unwrap OK because no errors encountered
            let result = addMedicineToModel(medicine, prescribedTimeForAction: prescribedTimeForAction)
            if let parent = result.0 {
                // return value with no errors
                validationResult.append(MedicineValidation.Success)
                return (parent, validationResult)
            } else {
                validationResult.append(MedicineValidation.CoreDataErrorEncountered)
            }
        }
        else {
            //TODO: handle error message here
        }
        // return value when errors occur
        return (nil, validationResult)
        
    }
    func addMedicineToModel(medicine: Int, prescribedTimeForAction: Int) -> (medObject: OPMedicine?, error: NSError?) {
        //create new OPMedicine entity in the managed context
        let medicineEntity = NSEntityDescription.entityForName("OPMedicine",
            inManagedObjectContext: managedContext)
        
        var med: OPMedicine = OPMedicine(entity: medicineEntity!,
            insertIntoManagedObjectContext: managedContext)
        med.profile = currentRecord.profile
        med.name = medicine
        
        med.targetTimePeriodToTake = prescribedTimeForAction
        
        var error: NSError?
        if !managedContext.save(&error) {
            println("Could not save: \(error)")
            return ( nil, error!)
        }
        else{
            return (med, nil)
        }
        
    }
    
    
    
    //    func updateMedicine (atIndex: Int, medicine: Medicines, prescribedTimeForAction: PrescribedTimeForAction) -> ( medObject: OPMedicine, errorArray: [MedicineValidation])
    func deleteMedicine (atIndex: Int) -> (medicine: OPMedicine?, coreDataError: NSError?)
    {
        let medicineToDelete = self.currentMedicines[atIndex]
        managedContext.deleteObject(medicineToDelete)
        
        var error: NSError?
        if !managedContext.save(&error) {
            println("Could not save: \(error)")
            return (nil, error)
        }
        
        return (medicineToDelete, nil)
    }
    
    func updateMedicine (atIndex: Int, medicine: Int, prescribedTimeForAction: Int) -> ( medObject: OPMedicine?, errorArray: [MedicineValidation])
    {
        // validate input
        var validationResult = validateMedicineResult(medicine , prescribedTimeForAction: prescribedTimeForAction)
        if validationResult.count == 0  {
            //forced unwrap OK because no errors encountered
            let result = updateMedicineInModel(atIndex, medicine: medicine, prescribedTimeForAction: prescribedTimeForAction)
            if let parent = result.0 {
                // return value with no errors
                validationResult.append(MedicineValidation.Success)
                return (parent, validationResult)
            } else {
                validationResult.append(MedicineValidation.CoreDataErrorEncountered)
                //TODO: handle Core Data error
            }
        }
        else {
            //TODO: handle error messages here
        }
        // return value when errors occur
        return (nil, validationResult)
    }
    
    func updateMedicineInModel (atIndex: Int, medicine: Int, prescribedTimeForAction: Int) -> ( medObject: OPMedicine?, error: NSError?){
        var currentMedicine: OPMedicine = self.currentMedicines[atIndex]
        
        currentMedicine.name = NSNumber(integer: medicine)
        currentMedicine.targetTimePeriodToTake = NSNumber(integer: prescribedTimeForAction)
        
        currentMedicine.profile = currentRecord.profile
        var error: NSError?
        if !managedContext.save(&error) {
            println("Could not save: \(error)")
            return (nil, error!)
        }
        
        return ( currentMedicine, nil)
        
    }
    
    
    //MARK:  AddOn Model
    func getAddOns() -> [OPAddOn] {
        let profileAddOns = currentRecord.profile.addOns
        currentAddOns.removeAll(keepCapacity: false)// = [OPAddOn]()
        for x in profileAddOns {
            currentAddOns.append( x as! OPAddOn)
        }
        return currentAddOns
    }
    
    public func validateAddOnResult(addOn: Int, prescribedTimeForAction: Int) -> [AddOnValidation]{
        //TODO: AddOn Validation array:  What should be included?  No out of index range error if input is enum!
        var validationResult = [AddOnValidation]()
        
        
        return validationResult
    }
    public func addAddOn (addOn: Int, prescribedTimeForAction: Int) -> (addOnObject: OPAddOn?, errorArray: [AddOnValidation]) {
        // validate input
        var validationResult = validateAddOnResult(addOn , prescribedTimeForAction: prescribedTimeForAction)
        
        
        if validationResult.count == 0  {
            //forced unwrap OK because no errors encountered
            let result = addAddOnToModel(addOn, prescribedTimeForAction: prescribedTimeForAction)
            if let parent = result.0 {
                // return value with no errors
                validationResult.append(AddOnValidation.Success)
                return (parent, validationResult)
            } else {
                validationResult.append(AddOnValidation.CoreDataErrorEncountered)
            }
        }
        else {
            //TODO: handle error message here
        }
        // return value when errors occur
        return (nil, validationResult)
        
    }
    func addAddOnToModel(addOn: Int, prescribedTimeForAction: Int) -> (addOnObject: OPAddOn?, error: NSError?) {
        //create new OPAddOn entity in the managed context
        let addOnEntity = NSEntityDescription.entityForName("OPAddOn",
            inManagedObjectContext: managedContext)
        
        var med: OPAddOn = OPAddOn(entity: addOnEntity!,
            insertIntoManagedObjectContext: managedContext)
        med.profile = currentRecord.profile
        med.addOnItem = NSNumber(integer: addOn)
        
        med.targetMealOrSnack = NSNumber(integer: prescribedTimeForAction)
        
        var error: NSError?
        if !managedContext.save(&error) {
            println("Could not save: \(error)")
            return ( nil, error!)
        }
        else{
            return (med, nil)
        }
        
    }
    
    
    
    //    func updateAddOn (atIndex: Int, AddOn: AddOns, prescribedTimeForAction: PrescribedTimeForAction) -> ( medObject: OPAddOn, errorArray: [AddOnValidation])
    func deleteAddOn (atIndex: Int) -> (addOnObject: OPAddOn?, coreDataError: NSError?)
    {
        let addOnToDelete = self.currentAddOns[atIndex]
        managedContext.deleteObject(addOnToDelete)
        
        var error: NSError?
        if !managedContext.save(&error) {
            println("Could not save: \(error)")
            return (nil, error)
        }
        
        return (addOnToDelete, nil)
    }
    
    func updateAddOn (atIndex: Int, addOn: Int, prescribedTimeForAction: Int) -> ( addOnObject: OPAddOn?, errorArray: [AddOnValidation])
    {
        // validate input
        var validationResult = validateAddOnResult(addOn , prescribedTimeForAction: prescribedTimeForAction)
        if validationResult.count == 0  {
            //forced unwrap OK because no errors encountered
            let result = updateAddOnInModel(atIndex, addOn: addOn, prescribedTimeForAction: prescribedTimeForAction)
            if let parent = result.0 {
                // return value with no errors
                validationResult.append(AddOnValidation.Success)
                return (parent, validationResult)
            } else {
                validationResult.append(AddOnValidation.CoreDataErrorEncountered)
                //TODO: handle Core Data error
            }
        }
        else {
            //TODO: handle error messages here
        }
        // return value when errors occur
        return (nil, validationResult)
    }
    
    func updateAddOnInModel (atIndex: Int, addOn: Int, prescribedTimeForAction: Int) -> ( addOnObject: OPAddOn?, error: NSError?){
        var currentAddOn: OPAddOn = self.currentAddOns[atIndex]
        
        currentAddOn.addOnItem = NSNumber(integer: addOn)
        currentAddOn.targetMealOrSnack = NSNumber(integer: prescribedTimeForAction)
        
        currentAddOn.profile = currentRecord.profile
        var error: NSError?
        if !managedContext.save(&error) {
            println("Could not save: \(error)")
            return (nil, error!)
        }
        
        return ( currentAddOn, nil)
        
    }
    
    

    
    
    //MARK: Data Objects for View Model
    var breakfast: VMBreakfast! //= {
//        return VMBreakfast()
//    }()
    lazy var lunch: VMLunch = {
        return VMLunch()
        }()
    
    lazy var morningSnack: VMSnack = {
        return VMSnack()
        }()

    lazy var afternoonSnack: VMSnack = {
        return VMSnack()
    }()

    lazy var eveningSnack: VMSnack = {
        return VMSnack()
    }()

    lazy var dinner: VMDinner = {
        return VMDinner()
    }()
    
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
    
    var mealState: MealState!
    
    var profileIsValid: Bool = false
    
    
    //MARK: Delegates - currently only used method
    var updateDetailViewDelegate: UpdateDetailViewDelegate!
    
    init(managedContext: NSManagedObjectContext) {
        self.managedContext = managedContext
        
        super.init()
        
        let defaults = NSUserDefaults.standardUserDefaults()
        defaults.setBool(true, forKey: "profileIsValid")
        
        if let profile = defaults.valueForKey("profileIsValid") as? Bool  {
            if profile == true {
            
                //initialize Patient Record
                self.currentRecord = self.currentRecordAndProfile()
                
                //initialize Profile - use placeholder to initialize
                let profile = TempProfile()
                
                //initialize journal entry
                
                if let journalEntry = getJournalEntry_Today() {//?? getNewJournalEntry()
                    self.currentJournalEntry = journalEntry
                    
                    //initialize meal items from existing entry
                    
                    breakfast = VMBreakfast(fromDataObject: currentJournalEntry.breakfast)

                } else {
                    //create blank journal entries
                    self.currentJournalEntry = getNewJournalEntry(today)
                    
                    //initialize using Default values in VM Meal Items
                    self.breakfast = VMBreakfast()
                }
                //after configuring currentJournalEntry
                // initialize items dependent on profile
                parentsArray = getParentsArray(profile)
               
                //MARK:  Home Controller Meal State Init
                MealState.setUpMealMenuForProfile(profile)
                self.mealState = MealState.getMealState(NSDate())
                
                
                //MARK: View Model Initializations
                BreakfastMenuCategory.configureMenuChoice(profile)
                LunchMenuCategory.configureMenuChoice(profile )
                SnackMenuCategory.configureMenuChoice(profile)
                DinnerMenuCategory.configureMenuChoice(profile)
     

            } else {
            profileIsValid = false
            }
        }
        todayJournalEntry = currentJournalEntry
    }
    
    
    //Get Model Objects
    //Get Record and Profile
    //Get Log Entry
    
    
    func currentProfile() -> OPPatientRecord {
        // TODO: Implement me!
        //let managedCon = managedContext
        let recordEntity = NSEntityDescription.entityForName("OPPatientRecord",
            inManagedObjectContext: managedContext)
        let recordFetch = NSFetchRequest(entityName: "OPPatientRecord")
        
        var error: NSError?
        
        let result = managedContext.executeFetchRequest(recordFetch, error: &error) as! [OPPatientRecord]?
        
        if let records = result {
            
            if records.count == 0 {
                
                self.currentRecord = OPPatientRecord(entity: recordEntity!,
                    insertIntoManagedObjectContext: managedContext)
                
                //                currentRecord.firstName = "First Name"
                //                currentRecord.lastName = "Last Name"
                
                let profileEntity = NSEntityDescription.entityForName("OPProfile",
                    inManagedObjectContext: managedContext)
                
                currentRecord.profile = OPProfile(entity: profileEntity!,
                    insertIntoManagedObjectContext: managedContext)
                
                return currentRecord
                
            } else {
                currentRecord = records[0] //as OPPatientRecord
                
                return currentRecord
            }
            
            
        } else {
            println("Could not fetch: \(error)")
        }
        
        
        assert(false, "Unimplemented")
    }
    
    func getNewJournalEntry (dateIdentifier: String) -> OPJournalEntry {
        let profileEntity = NSEntityDescription.entityForName("OPJournalEntry",
            inManagedObjectContext: managedContext)
        
        let journalEntry =  OPJournalEntry(entity: profileEntity!,
            insertIntoManagedObjectContext: managedContext)
        
        journalEntry.patientRecord = currentRecord
        
        journalEntry.date = today
        
        let profileEntityBreakfast = NSEntityDescription.entityForName("OPBreakfast",
            inManagedObjectContext: managedContext)
        
        let breakfastEntry =  OPBreakfast(entity: profileEntityBreakfast!,
            insertIntoManagedObjectContext: managedContext)
        
        breakfastEntry.journalEntry = journalEntry
        
       
        return journalEntry
    }
    
    func getJournalEntry_Today ( ) -> OPJournalEntry? { // JournalItem{
        
        let journalEntryDate = today
        //  Fetch Request and Predicate:  array of args supports multiple days
        let jEntryFetch = NSFetchRequest(entityName: "OPJournalEntry")
        //jEntryFetch.predicate = NSPredicate(format: "date == %@", journalEntryDate)
        jEntryFetch.predicate = NSPredicate(format: "date == %@", argumentArray: [journalEntryDate])   //(format: "date IN %@", @[journalEntryDate])
        
        var error: NSError?
        
        let result = managedContext.executeFetchRequest(jEntryFetch, error: &error) as? [OPJournalEntry]
        
        if let entries = result {
            if entries.count > 0 {
                let entry = entries[0] as OPJournalEntry
                println(entry.date)
                return entries[0]
            } else {
                return nil
            }
        } else {
            println("Could not Fetch: \(error)")
            //TODO: handle error more gracefully
            assert(false, "Core Data Error fetching Journal Entry.")
        }
    }
    
    
    func getJournalEntry (dateIdentifier: String) -> JournalEntryResult { // JournalItem{
        
        let journalEntryDate = today
        //let jEntryFetch = NSFetchRequest(entityName: "OPJournalEntry")
        let jEntryFetch = NSFetchRequest(entityName: "OPJournalEntry")
        jEntryFetch.predicate = NSPredicate(format: "date == %@", dateIdentifier)
        //let recordFetch = NSFetchRequest(entityName: "OPJournalEntry")
        
        //recordFetch.predicate = NSPredicate(format: "date == %@", journalEntryDate)
        var error: NSError?
        
        let result = managedContext.executeFetchRequest(jEntryFetch, error: &error) as? [OPJournalEntry]  //(jEntryFetch, error: &error) as! [OPJournalEntry]?
        
        if let entries = result {
            if entries.count > 0 {
                let entry = entries[0] as OPJournalEntry
                println(entry.date)
                return JournalEntryResult.Success(entry)
                
            } else {
                return JournalEntryResult.EntryDoesNotExist
            }
        } else {
            
            return JournalEntryResult.Error(error)
        }
    }
    

    //MARK: Initialization Helper methods
    
    func getParentsArray(profile: TempProfile) -> [String] {
        return  ["Lisa Doe", "John Doe", "Jon Smith"]

    }
    func defaultParentInitials() -> String?{
        
        if parentsArray.count > 0 {
            
            let fullName = parentsArray[0]
            var fullNameArr = split(fullName) {$0 == " "}
            
            var firstName: String = fullNameArr[0]
            var lastName: String? = fullNameArr.count > 1 ? fullNameArr[fullNameArr.count-1] : nil
            
            var firstInitial = firstName[firstName.startIndex]
            var lastInitial = lastName?[lastName!.startIndex]
            
            return "\(firstInitial). \(lastInitial!)."
        }
        return nil
    }
    
    //MARK: Profile Input
    func getCurrentProfile() -> OPProfile {
        return self.currentRecord.profile
        
        
    }
    
    //MARK: Journal Item Selection
    
    func selectPreviousDayJournalEntry() -> String {
       // if offsetNumberOfDaysFromCurrentDay > 0 {
            offsetNumberOfDaysFromCurrentDay++
            return selectJournalEntry(-offsetNumberOfDaysFromCurrentDay)
       //return today
        
    }
    func selectNextDayJournalEntry() -> String {
        if offsetNumberOfDaysFromCurrentDay == 0 {
            return today
        } else {
            offsetNumberOfDaysFromCurrentDay--
            return selectJournalEntry(-offsetNumberOfDaysFromCurrentDay)
        }
    }
    
    func selectJournalEntry(offsetFromCurrentDay: Int) -> String {
        
        //increase offset from current Dat
        //offsetNumberOfDaysFromCurrentDay++
        
        
        //Get the date string for the selected day
        let calendar = NSCalendar.currentCalendar()
        let components = NSDateComponents()
        
        
        components.day = offsetFromCurrentDay
        let newDate = calendar.dateByAddingComponents(components, toDate: NSDate(), options: nil)
        let selectedDay = getFullStyleDateString(newDate!)

        
        // if core data holds journal entry for this day
        // else create new entry for selected day
        let journalEntry = getJournalEntry(selectedDay)
        
        switch journalEntry {
        case let .Success(entry):
            currentJournalEntry = entry
        case .EntryDoesNotExist:
            currentJournalEntry = getNewJournalEntry(selectedDay)
        case .Error:
            println("Core Data error encountered.")
        
        }
        
        return selectedDay
        
    }
    func getFullStyleDateString(date: NSDate) -> String {
        var dateFormatter = NSDateFormatter()
        dateFormatter.dateStyle = .FullStyle
        println(dateFormatter.stringFromDate(date))
        return dateFormatter.stringFromDate(date)
    }
    
    //MARK: CoreData Methods
    
    //Get Model Objects
    //Get Record and Profile
    //Get Log Entry
    
    
    func currentRecordAndProfile() -> OPPatientRecord {
        // TODO: Implement me!
        //let managedCon = managedContext
        let recordEntity = NSEntityDescription.entityForName("OPPatientRecord",
            inManagedObjectContext: managedContext)
        let recordFetch = NSFetchRequest(entityName: "OPPatientRecord")
        
        var error: NSError?
        
        let result = managedContext.executeFetchRequest(recordFetch, error: &error) as! [OPPatientRecord]?
        
        if let records = result {
            
            if records.count == 0 {
                
                self.currentRecord = OPPatientRecord(entity: recordEntity!,
                    insertIntoManagedObjectContext: managedContext)
                
                //                currentRecord.firstName = "First Name"
                //                currentRecord.lastName = "Last Name"
                
                let profileEntity = NSEntityDescription.entityForName("OPProfile",
                    inManagedObjectContext: managedContext)
                
                currentRecord.profile = OPProfile(entity: profileEntity!,
                    insertIntoManagedObjectContext: managedContext)
                
                //                let p = currentRecord.profile
                //                p.firstName = "Sarah"
                //                p.lastName = "Snythe"
                
                
                //                if !managedContext.save(&error) {
                //                    println("Could not save: \(error)")
                //                }
                
                return currentRecord
                
            } else {
                currentRecord = records[0] //as OPPatientRecord
                
                return currentRecord
            }
            
            
        } else {
            println("Could not fetch: \(error)")
        }
        
        
        assert(false, "Unimplemented")
    }
    
    
    
    
    
    
    
    func buildJournalEntry ( profile: PatientProfile ) -> JournalItem{
        return JournalItem(itemTitle: "test jounal entry")// itemTitle: "test journal item")
        
    }
    
    func loadProfile() -> PatientProfile {
        var profile = PatientProfile()
        return profile
    }
    

    func setJournalEntryToNewValue(numberOfDaysBeforeToday: Int) {
        
        
    }
    
    //MARK: Printing Methods
    func getPastWeekOfDates() -> [String] {
        //let todayTuple = (today, getFullStyleDateString(today))
        var dates = [String]()
        dates.append(getFullStyleDateString(NSDate()))
        let calendar = NSCalendar.currentCalendar()
        let components = NSDateComponents()
        
        for i in 1...6 {
            components.day = -i
            
            var newDate: NSDate = calendar.dateByAddingComponents(components, toDate: NSDate(), options: nil) ?? NSDate()
            let newString = getFullStyleDateString(newDate)

            dates.append(newString)
        }
        return dates
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
        return self.breakfast//initialized in init
    }
    
    func saveBreakfast(breakfast: VMBreakfast, inout modelBreakfast: OPBreakfast){
        //use helper method to set property for optional values
        self.breakfast = breakfast
        
        
        let mBreakfast =  modelBreakfast
        self.currentJournalEntry.breakfast.foodChoice = breakfast.foodChoice!
        
        if let value = breakfast.foodChoice  {
            mBreakfast.foodChoice = value
        }
        if let value = breakfast.fruitChoice  {
            mBreakfast.fruitChoice = value
        }
        
        mBreakfast.addOnRequired = NSNumber(bool: breakfast.addOnRequired)
        
        if let value = breakfast.addOnText  {
            mBreakfast.addOnText = value
        }
        if let value = breakfast.addOnConsumed  {
            mBreakfast.addOnConsumed = NSNumber(bool: value)
        }
        
        mBreakfast.medicineRequired = NSNumber(bool: breakfast.medicineRequired)
        
        if let value = breakfast.medicineText  {
            mBreakfast.medicineText = value
        }
        if let value = breakfast.medicineConsumed  {
            mBreakfast.medicineConsumed = value
        }
        if let value = breakfast.parentInitials  {
            mBreakfast.parentInitials = value
        }
        if let value = breakfast.location  {
            mBreakfast.location = value
        }
        if let value = breakfast.time  {
            
            mBreakfast.time = value
        }
        var error: NSError?
        if !managedContext.save(&error) {
            println("Could not save: \(error)")
        }

        
       println("medicine required:  \(mBreakfast.medicineRequired.boolValue)")
 
    }
    func setOptionalProperty( input: String? , inout property: String){
        if let stringValue = input {
            property = stringValue
        }
    }
    func setOptionalProperty( input: Bool? , inout property: Bool){
        if let stringValue = input {
            property = stringValue
        }
    }
    func setOptionalProperty( input: NSDate? , inout property: NSDate){
        if let stringValue = input {
            property = stringValue
        }
    }
    func getLunch_Today() -> VMLunch {
        return self.lunch//initialized in init
    }
    
    func saveLunch_Today(lunch: VMLunch){
        self.lunch = lunch
    }
    
    func getSnack_Today(snackTime: SnackTime) -> VMSnack {
        switch snackTime{
        case .Morning:
            return self.morningSnack
        case .Afternoon:
            return self.afternoonSnack
        case .Evening:
            return self.eveningSnack
        }
       // return self.snack!//initialized in init
        
    }
    func saveSnack_Today(snack: VMSnack, snackTime: SnackTime){
        switch snackTime{
        case .Morning:
            self.morningSnack = snack
        case .Afternoon:
            self.afternoonSnack = snack
        case .Evening:
            self.eveningSnack = snack
        }
        
    }
    func getDinner_Today() -> VMDinner {
        return self.dinner//initialized in init
    }

    func saveDinner_Today(dinner: VMDinner){
        self.dinner = dinner
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
    
    

    
    
    //MARK: Array Assembly Items
    
    var foodItems = [FoodItem]()
    
    
   
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
    public func parser(parser: NSXMLParser, didStartElement elementName: String, namespaceURI: String?, qualifiedName qName: String?, attributes attributeDict: [NSObject: AnyObject]) {
        
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

    public func parser(parser: NSXMLParser, didEndElement elementName: String, namespaceURI: String?, qualifiedName qName: String?) {
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

    public func parser(parser: NSXMLParser,foundCharacters string: String?) {
        currentElementValue = string!
    }

    public func parser(parser: NSXMLParser, parseErrorOccurred parseError: NSError) {
        println(parseError)
    }
    
//    func addJournalItem(activity: JournalItem) {
//        // TODO: Implement me!
//        println("addActivity called... but it's not implemented yet!")
//}

}