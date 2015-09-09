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
    public 	var currentProfile: OPProfile!
    var currentJournalEntry: OPJournalEntry! {
        didSet(entry){
            println(entry.date)
        }
    }
    
    var todayJournalEntry: OPJournalEntry?
    
    var offsetNumberOfDaysFromCurrentDay: Int = 0
    
    var currentBreakfast: OPBreakfast!

    var currentTime: String = {
        var dateFormatter = NSDateFormatter()
        dateFormatter.timeStyle = .ShortStyle
        var time = dateFormatter.stringFromDate(NSDate())
        return time
    }()
    var today: String  {
        get {
            var dateFormatter = NSDateFormatter()
            dateFormatter.dateStyle = .FullStyle
            //println(dateFormatter.stringFromDate(NSDate()))
            return dateFormatter.stringFromDate(NSDate())
        }
    }
    
    
    
    // Items that define or are used to define the contents of the Food Journal Log item
    var logEntryItems = [AnyObject]()
    
    //MARK: Data Objects for View Model
    var breakfast: VMBreakfast!
    var lunch: VMLunch!
    var morningSnack: VMSnack!
    var afternoonSnack: VMSnack!
    var eveningSnack: VMSnack!
    var dinner: VMDinner!
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
    
//    public override init() {
//        //used for testing validation
//        self.managedContext = NSManagedObjectContext()
//    }
    
    public init(managedContext: NSManagedObjectContext) {
        self.managedContext = managedContext
        
        super.init()
        
        let defaults = NSUserDefaults.standardUserDefaults()
        
//        if let profile = defaults.valueForKey("profileIsValid") as? Bool  {
//            if profile == true {
//            
        
                //initialize journal entry
                //initializeJournalEntryForCurrentDay()
        //initialize Patient Record
        currentRecord = currentRecordAndProfile()
        
        //initialize Profile - use placeholder to initialize
        currentProfile = currentRecord.profile
        let profile = currentProfile
        
//        if let journalEntry = getJournalEntry_Today() {//?? getNewJournalEntry()
            self.currentJournalEntry = getJournalEntry_Today()//journalEntry
            todayJournalEntry = currentJournalEntry
            //initialize meal items from existing entry
            initializeMealDataItems(currentJournalEntry)
//            self.breakfast = VMBreakfast(fromDataObject: currentJournalEntry.breakfast)
//            self.morningSnack = VMSnack(fromDataObject: currentJournalEntry.morningSnack)
//            self.lunch = VMLunch(fromDataObject: currentJournalEntry.lunch)
//            self.afternoonSnack = VMSnack(fromDataObject: currentJournalEntry.afternoonSnack)
//            dinner = VMDinner(fromDataObject: currentJournalEntry.dinner)
//            self.eveningSnack = VMSnack(fromDataObject: currentJournalEntry.eveningSnack)
        
//        } else {
//            //create blank journal entries
//            self.currentJournalEntry = getJournalEntry_Today()
//            
//            //initialize using Default values in VM Meal Items
//            //TODO:  Initialize Other Meals to VM default values
//            self.breakfast = VMBreakfast()
//            self.morningSnack = VMSnack(fromSnackTime: SnackTime.Morning)
//            self.lunch = VMLunch()
//            self.afternoonSnack = VMSnack(fromSnackTime: SnackTime.Afternoon)
//            self.dinner = VMDinner()
//            self.eveningSnack = VMSnack(fromSnackTime: SnackTime.Evening)
//        }
        
        todayJournalEntry = currentJournalEntry
        //after configuring currentJournalEntry
        // initialize items dependent on profile
        parentsArray = getParentsArray(profile)
        //MARK:  Home Controller Meal State Init
        MealState.setUpMealMenuForProfile(profile)
        self.mealState = MealState.getMealState(NSDate())
        
        
        //MARK: update enums for View Model Initializations
        updateItemChoiceEnums(profile)
        
        var error: NSError?
        if !managedContext.save(&error) {
            println("Could not save: \(error)")
            //return ( nil, error)
        }
        //super.init()

    }
    
    func initializeMealDataItems( journalEntry: OPJournalEntry ){
        self.breakfast = VMBreakfast(fromDataObject: journalEntry.breakfast)
        self.morningSnack = VMSnack(fromDataObject: journalEntry.morningSnack)
        self.lunch = VMLunch(fromDataObject: journalEntry.lunch)
        self.afternoonSnack = VMSnack(fromDataObject: journalEntry.afternoonSnack)
        dinner = VMDinner(fromDataObject: journalEntry.dinner)
        self.eveningSnack = VMSnack(fromDataObject: journalEntry.eveningSnack)
    }
    
    func initializeJournalEntryForCurrentDay ()
    {
        //initialize Patient Record
        self.currentRecord = self.currentRecordAndProfile()
        
        //initialize Profile - use placeholder to initialize
        currentProfile = currentRecord.profile
        let profile = currentProfile
        
//        if let journalEntry = getJournalEntry_Today() {//?? getNewJournalEntry()
//            self.currentJournalEntry = journalEntry
//            
//            //initialize meal items from existing entry
//            //TODO:  Initialize Other Meals to FROM EXISTING ENTRY
//            
//            self.breakfast = VMBreakfast(fromDataObject: currentJournalEntry.breakfast)
//            self.morningSnack = VMSnack(fromDataObject: currentJournalEntry.morningSnack)
//            self.lunch = VMLunch(fromDataObject: currentJournalEntry.lunch)
//            self.afternoonSnack = VMSnack(fromDataObject: currentJournalEntry.afternoonSnack)
//            dinner = VMDinner(fromDataObject: currentJournalEntry.dinner)
//            self.eveningSnack = VMSnack(fromDataObject: currentJournalEntry.eveningSnack)
//            
//        } else {
//            //create blank journal entries
//            self.currentJournalEntry = getJournalEntry_Today()
//            
//            //initialize using Default values in VM Meal Items
//            //TODO:  Initialize Other Meals to VM default values
//            self.breakfast = VMBreakfast()
//            self.morningSnack = VMSnack(fromSnackTime: SnackTime.Morning)
//            self.lunch = VMLunch()
//            self.afternoonSnack = VMSnack(fromSnackTime: SnackTime.Afternoon)
//            self.dinner = VMDinner()
//            self.eveningSnack = VMSnack(fromSnackTime: SnackTime.Evening)
//        }
        
        todayJournalEntry = currentJournalEntry
        //after configuring currentJournalEntry
        // initialize items dependent on profile
        parentsArray = getParentsArray(profile)
        //MARK:  Home Controller Meal State Init
        MealState.setUpMealMenuForProfile(profile)
        self.mealState = MealState.getMealState(NSDate())
        
        
        //MARK: update enums for View Model Initializations
        updateItemChoiceEnums(profile)

    }
    func initializeTodayJournalEntryForCurrentDay()
    {
        //initialize Patient Record
        self.currentRecord = self.currentRecordAndProfile()
        
        //initialize Profile - use placeholder to initialize
        currentProfile = currentRecord.profile
        let profile = currentProfile
        
        //        if let journalEntry = getJournalEntry_Today() {//?? getNewJournalEntry()
        //            self.currentJournalEntry = journalEntry
        //
        //            //initialize meal items from existing entry
        //            //TODO:  Initialize Other Meals to FROM EXISTING ENTRY
        //
        //            self.breakfast = VMBreakfast(fromDataObject: currentJournalEntry.breakfast)
        //            self.morningSnack = VMSnack(fromDataObject: currentJournalEntry.morningSnack)
        //            self.lunch = VMLunch(fromDataObject: currentJournalEntry.lunch)
        //            self.afternoonSnack = VMSnack(fromDataObject: currentJournalEntry.afternoonSnack)
        //            dinner = VMDinner(fromDataObject: currentJournalEntry.dinner)
        //            self.eveningSnack = VMSnack(fromDataObject: currentJournalEntry.eveningSnack)
        //
        //        } else {
        //            //create blank journal entries
        //            self.currentJournalEntry = getJournalEntry_Today()
        //
        //            //initialize using Default values in VM Meal Items
        //            //TODO:  Initialize Other Meals to VM default values
        //            self.breakfast = VMBreakfast()
        //            self.morningSnack = VMSnack(fromSnackTime: SnackTime.Morning)
        //            self.lunch = VMLunch()
        //            self.afternoonSnack = VMSnack(fromSnackTime: SnackTime.Afternoon)
        //            self.dinner = VMDinner()
        //            self.eveningSnack = VMSnack(fromSnackTime: SnackTime.Evening)
        //        }
        
        todayJournalEntry = getJournalEntry_Today()
        currentJournalEntry = todayJournalEntry
        //after configuring currentJournalEntry
        // initialize items dependent on profile
        parentsArray = getParentsArray(profile)
        initializeMealDataItems(todayJournalEntry!)
        
        //MARK:  Home Controller Meal State Init
        MealState.setUpMealMenuForProfile(profile)
        self.mealState = MealState.getMealState(NSDate())
        
        
        //MARK: update enums for View Model Initializations
        updateItemChoiceEnums(profile)
        
    }

    func updateItemChoiceEnums (profile: OPProfile){
        //used to
        
        //update enum used for FoodItem Choice View Controller
        Meals.configureMeals(profile)
        
        PrescribedTimeForAction.configureTimes(profile)

        initializeMealCategoryEnumsAndProfileFields()

    }
    
    func initializeMealCategoryEnumsAndProfileFields (){
        let profile = currentProfile
        //update enums
        //configure MenuChoice also sets medicine/addonRequired fields in journalentry.meal
        BreakfastMenuCategory.configureMenuChoice(profile, journalEntry: &currentJournalEntry!)
        LunchMenuCategory.configureMenuChoice(profile, journalEntry: &self.currentJournalEntry!)
        SnackMenuCategory.configureMenuChoice(profile, journalEntry: &self.currentJournalEntry!)
        DinnerMenuCategory.configureMenuChoice(profile, journalEntry: &self.currentJournalEntry!)


    }
    
    func updateMealCategoryEnumsAndProfileFields (){
        let profile = currentProfile
        //update enums
        //configure MenuChoice also sets medicine/addonRequired fields in journalentry.meal
        BreakfastMenuCategory.configureMenuChoice(profile, journalEntry: &currentJournalEntry!)
        LunchMenuCategory.configureMenuChoice(profile, journalEntry: &self.currentJournalEntry!)
        SnackMenuCategory.configureMenuChoice(profile, journalEntry: &self.currentJournalEntry!)
        DinnerMenuCategory.configureMenuChoice(profile, journalEntry: &self.currentJournalEntry!)
        
        //configure todayJournalEntry
        BreakfastMenuCategory.configureMenuChoice(profile, journalEntry: &self.todayJournalEntry!)
        LunchMenuCategory.configureMenuChoice(profile, journalEntry: &self.self.todayJournalEntry!)
        SnackMenuCategory.configureMenuChoice(profile, journalEntry: &self.self.todayJournalEntry!)
        DinnerMenuCategory.configureMenuChoice(profile, journalEntry: &self.self.todayJournalEntry!)
        
        Meals.configureMeals(profile)
        
        PrescribedTimeForAction.configureTimes(profile)
        
    }
    //MARK: Profile Model
    public func savePatientName (patientName: String) -> (profile: OPProfile?, errorArray: [ParentProfileValidation]) {
        
        let nameInput = patientName.stringByTrimmingCharactersInSet(NSCharacterSet.whitespaceCharacterSet())
        var firstName: String? //= myArray.first
        var lastName: String? //= nil

        if nameInput == "" {
            firstName = nil
            lastName = nil
            
        } else {
            let myArray: [String] = nameInput.componentsSeparatedByString(" ")
            firstName = myArray.first
            lastName = nil

            if myArray.count > 1 {
                var name = myArray[myArray.count - 1]
                lastName = name
            }
        }
        
        let validationResult = validatePatientNameInput(firstName, lastName: lastName)
        
        //return currentRecord.profile
        if validationResult.count == 0  {
            currentProfile.firstAndLastName = patientName
            return (currentProfile, validationResult)
        }
        // return value when errors occur
        return (nil, validationResult)
        
    }

    
    public func setMorningSnackRequired(isRequired: Bool) -> OPProfile {
        currentRecord.profile.morningSnackRequired = isRequired
        var error: NSError?
        if !managedContext.save(&error) {
            println("Could not save: \(error)")
            //return ( nil, error)
        }
        updateMealCategoryEnumsAndProfileFields()

        Meals.configureMeals(currentRecord.profile)
        return currentRecord.profile
    }
    public func setEveningSnackRequired(isRequired: Bool) -> OPProfile {
        currentRecord.profile.eveningSnackRequired = isRequired
        var error: NSError?
        if !managedContext.save(&error) {
            println("Could not save: \(error)")
            //return ( nil, error)
        }
        updateMealCategoryEnumsAndProfileFields()

        Meals.configureMeals(currentRecord.profile)
        
        return currentRecord.profile
    }
    
    
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
    
    public func validateParentInput (firstName: String?, lastName: String?, profile: OPProfile) -> [ParentProfileValidation] {
        var errors = [ParentProfileValidation]()
        
        //check current parents for duplicate name
        let parents = profile.parents
        for parent in parents {
            if parent.firstName == firstName && parent.lastName == lastName {
                errors.append(ParentProfileValidation.DuplicateParentEntry)
                break
            }
        }
        
        
        if firstName == nil {
            errors.append(ParentProfileValidation.FirstNameIsNil)
        }
        if lastName == nil {
            errors.append(ParentProfileValidation.LastNameIsNil)
        }
        //        if atIndex < 0 || atIndex > currentProfile.parents.count  {
        //            errors.append(ParentProfileValidation.IndexOutOfRange)
        //        }
        
        if let fName = firstName  {
            if !validateName(fName, pattern: "^[a-z]{1,15}$") {
                errors.append(ParentProfileValidation.FirstNameInvalidCharacter)
            }
        }
        if let lName = lastName {
            if !validateName(lName, pattern: "^([^-'\\d])([A-Za-z]?['-]?){2,18}([^-'\\d])$" ){// name length limit actually 20 chars, since there is a one char group on each end of string  18 + 1 + 1 //"^([^-'\\d])([A-Za-z]?['-]?){1,21}([^-'\\d])$") {
                errors.append(ParentProfileValidation.LastNameInvalidCharacter)
            }
            
        }
        
        return (errors)
        
    }
    public func validatePatientNameInput (firstName: String?, lastName: String?) -> [ParentProfileValidation] {
        //using parent validation enum here:  refactor for Swift 2.0 to NameValildation enum
        var errors = [ParentProfileValidation]()
        
        if let fName = firstName  {
            if !validateName(fName, pattern: "^[a-z]{1,15}$") {
                errors.append(ParentProfileValidation.FirstNameInvalidCharacter)
            }
        }
        else{
            errors.append(ParentProfileValidation.FirstNameIsNil)
        }

        
        if let lName = lastName {
            if !validateName(lName, pattern: "^([^-'\\d])([A-Za-z]?['-]?){2,18}([^-'\\d])$" ){// name length limit actually 20 chars, since there is a one char group on each end of string  18 + 1 + 1 //"^([^-'\\d])([A-Za-z]?['-]?){1,21}([^-'\\d])$") {
                errors.append(ParentProfileValidation.LastNameInvalidCharacter)
            }
            
        } else {
            errors.append(ParentProfileValidation.LastNameIsNil)
        }
        
        return (errors)
        
    }
    
    public func validateName( name: String , pattern: String ) -> Bool {
        if let regex = NSRegularExpression(pattern: pattern, options: .CaseInsensitive, error: nil) {
            let text = name.stringByTrimmingCharactersInSet(NSCharacterSet.whitespaceAndNewlineCharacterSet())
            let range = NSMakeRange(0, count(text))
            
            let matchRange = regex.rangeOfFirstMatchInString(text, options: .ReportProgress, range: range)
            
            let valid = matchRange.location != NSNotFound
            
            return valid
            //textField.textColor = (valid) ? UIColor.trueColor() : UIColor.falseColor()
        }
        return false
    }
    
    
    public func updateParentInModel( atIndex: Int, firstName: String?, lastName: String?) -> (parent: OPParent?, errorArray: [ParentProfileValidation]){
        
        var validationResult = validateParentInput(firstName, lastName: lastName, profile: currentProfile)
        
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
    public func getMedicines() -> [OPMedicine] {
        let profileMedicines = currentRecord.profile.medicineLIst
        currentMedicines = [OPMedicine]()
        for x in profileMedicines {
            currentMedicines.append( x as! OPMedicine)
        }
        return currentMedicines
    }
    
    public func validateMedicineResult(medicine: Int, prescribedTimeForAction: Int, profileMedicines: [OPMedicine]) -> [MedicineValidation]{
        //TODO: Medicine Validation array:  What should be included?  No out of index range error if input is enum!
        var validationResult = [MedicineValidation]()
        
//        let profileMedicines = getMedicines()
        let result = profileMedicines.filter{
            $0.name.integerValue == medicine && $0.targetTimePeriodToTake.integerValue == prescribedTimeForAction
        }
        if  result.count > 0 {
            validationResult.append(MedicineValidation.DuplicateMedicineEntry)
        }
        
        return validationResult
    }
    
    public func addMedicine (medicine: Int, prescribedTimeForAction: Int) -> (medObject: OPMedicine?, errorArray: [MedicineValidation]) {
        // validate input
        var validationResult = validateMedicineResult(medicine , prescribedTimeForAction: prescribedTimeForAction, profileMedicines: getMedicines())
        
        
        if validationResult.count == 0  {
            //forced unwrap OK because no errors encountered
            let result = addMedicineToModel(medicine, prescribedTimeForAction: prescribedTimeForAction)
            if let medicine = result.0 {
                // return value with no errors
                validationResult.append(MedicineValidation.Success)
                updateItemChoiceEnums(currentRecord.profile)
                return (medicine, validationResult)
            } else {
                validationResult.append(MedicineValidation.CoreDataErrorEncountered)
            }
        }
        // return when errors occur
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
        updateItemChoiceEnums(currentRecord.profile)
        return (medicineToDelete, nil)
    }
    
    func updateMedicine (atIndex: Int, medicine: Int, prescribedTimeForAction: Int) -> ( medObject: OPMedicine?, errorArray: [MedicineValidation])
    {
        // validate input
        var validationResult = validateMedicineResult(medicine , prescribedTimeForAction: prescribedTimeForAction, profileMedicines: getMedicines())
        if validationResult.count == 0  {
            //forced unwrap OK because no errors encountered
            let result = updateMedicineInModel(atIndex, medicine: medicine, prescribedTimeForAction: prescribedTimeForAction)
            if let parent = result.0 {
                // return value with no errors
                validationResult.append(MedicineValidation.Success)
                updateItemChoiceEnums(currentRecord.profile)
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
    public func getAddOns() -> [OPAddOn] {
        let profileAddOns = currentRecord.profile.addOns
        currentAddOns.removeAll(keepCapacity: false)// = [OPAddOn]()
        for x in profileAddOns {
            currentAddOns.append( x as! OPAddOn)
        }
        return currentAddOns
    }
    
    public func validateAddOnResult(addOn: Int, prescribedTimeForAction: Int, profileAddOns: [OPAddOn]) -> [AddOnValidation]{
        
        var validationResult = [AddOnValidation]()
        let a = profileAddOns[0]
        
        let result = profileAddOns.filter{
            $0.addOnItem.integerValue == addOn && $0.targetMealOrSnack.integerValue == prescribedTimeForAction
        }
        if  result.count > 0 {
            validationResult.append(AddOnValidation.DuplicateAddOnEntry)
        }
       
        
        return validationResult
    }
    public func addAddOn (addOn: Int, prescribedTimeForAction: Int) -> (addOnObject: OPAddOn?, errorArray: [AddOnValidation]) {
        // validate input
        var validationResult = validateAddOnResult(addOn , prescribedTimeForAction: prescribedTimeForAction, profileAddOns: getAddOns())
        
        
        if validationResult.count == 0  {
            //forced unwrap OK because no errors encountered
            let result = addAddOnToModel(addOn, prescribedTimeForAction: prescribedTimeForAction)
            if let parent = result.0 {
                // return value with no errors
                validationResult.append(AddOnValidation.Success)
                updateItemChoiceEnums(currentRecord.profile)
                return (parent, validationResult)
            } else {
                validationResult.append(AddOnValidation.CoreDataErrorEncountered)
            }
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
        updateItemChoiceEnums(currentRecord.profile)
        return (addOnToDelete, nil)
    }
    
    func updateAddOn (atIndex: Int, addOn: Int, prescribedTimeForAction: Int) -> ( addOnObject: OPAddOn?, errorArray: [AddOnValidation])
    {
        // validate input
        var validationResult = validateAddOnResult(addOn , prescribedTimeForAction: prescribedTimeForAction, profileAddOns: getAddOns())
        if validationResult.count == 0  {
            //forced unwrap OK because no errors encountered
            let result = updateAddOnInModel(atIndex, addOn: addOn, prescribedTimeForAction: prescribedTimeForAction)
            if let parent = result.0 {
                // return value with no errors
                validationResult.append(AddOnValidation.Success)
                updateItemChoiceEnums(currentRecord.profile)
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
    
    //VMMeal Initialization Helper
    private func initializeMemebers(meal: MedicineAndAddOnMeal)
    {
        
    }
    func initializeMedicineMembers (breakfast: VMBreakfast){
        var matchesMeal = false
        for medicine in currentProfile.medicineLIst {
            //let time = PrescribedTimeForAction(rawValue: medicine.targetTimePeriodToTake.integerValue)
                //if time = PrescribedTimeForAction.BreakfastTime {
                    
                //}
            
        }
    }

    
    
//    func currentRecord() -> OPPatientRecord {
//        // TODO: Implement me!
//        //let managedCon = managedContext
//        let recordEntity = NSEntityDescription.entityForName("OPPatientRecord",
//            inManagedObjectContext: managedContext)
//        let recordFetch = NSFetchRequest(entityName: "OPPatientRecord")
//        
//        var error: NSError?
//        
//        let result = managedContext.executeFetchRequest(recordFetch, error: &error) as! [OPPatientRecord]?
//        
//        if let records = result {
//            
//            if records.count == 0 {
//                
//                self.currentRecord = OPPatientRecord(entity: recordEntity!,
//                    insertIntoManagedObjectContext: managedContext)
//                
//                let profileEntity = NSEntityDescription.entityForName("OPProfile",
//                    inManagedObjectContext: managedContext)
//                
//                currentRecord.profile = OPProfile(entity: profileEntity!,
//                    insertIntoManagedObjectContext: managedContext)
//                
//                return currentRecord
//                
//            } else {
//                currentRecord = records[0] //as OPPatientRecord
//                
//                return currentRecord
//            }
//            
//            
//        } else {
//            println("Could not fetch: \(error)")
//        }
//        
//        return currentRecord
//        //assert(false, "Unimplemented")
//    }
    
    func getNewJournalEntry (dateIdentifier: String) -> OPJournalEntry {
        let profileEntity = NSEntityDescription.entityForName("OPJournalEntry",
            inManagedObjectContext: managedContext)
        
        let journalEntry =  OPJournalEntry(entity: profileEntity!,
            insertIntoManagedObjectContext: managedContext)
        
        journalEntry.patientRecord = currentRecord
        
        journalEntry.date = dateIdentifier
        
        let profileEntityBreakfast = NSEntityDescription.entityForName("OPBreakfast",
            inManagedObjectContext: managedContext)
        
        let breakfastEntry =  OPBreakfast(entity: profileEntityBreakfast!,
            insertIntoManagedObjectContext: managedContext)
        
        breakfastEntry.journalEntry = journalEntry
        
        //lunch
        let profileEntityLunch = NSEntityDescription.entityForName("OPLunch",
            inManagedObjectContext: managedContext)

        let lunchEntry =  OPLunch(entity: profileEntityLunch!,
            insertIntoManagedObjectContext: managedContext)
        
        lunchEntry.journalEntry = journalEntry
        
        //morning snack
        let profileEntitymSnack = NSEntityDescription.entityForName("OPMorningSnack",
            inManagedObjectContext: managedContext)
        
        let mSnackEntry =  OPMorningSnack(entity: profileEntitymSnack!,
            insertIntoManagedObjectContext: managedContext)
        
        mSnackEntry.journalEntry = journalEntry
        
        //afternoon snack
        let profileEntityAfternoonSnack = NSEntityDescription.entityForName("OPAfternoonSnack",
            inManagedObjectContext: managedContext)
        
        let aSnackEntry =  OPAfternoonSnack(entity: profileEntityAfternoonSnack!,
            insertIntoManagedObjectContext: managedContext)
        
        aSnackEntry.journalEntry = journalEntry
        
        //evening snack
        let profileEntityeSnack = NSEntityDescription.entityForName("OPEveningSnack",
            inManagedObjectContext: managedContext)
        
        let eSnackEntry =  OPEveningSnack(entity: profileEntityeSnack!,
            insertIntoManagedObjectContext: managedContext)
        
        eSnackEntry.journalEntry = journalEntry
        
        //dinner
        let profileEntityDinner = NSEntityDescription.entityForName("OPDinner",
            inManagedObjectContext: managedContext)
        
        let dinnerEntry =  OPDinner(entity: profileEntityDinner!,
            insertIntoManagedObjectContext: managedContext)
        
        dinnerEntry.journalEntry = journalEntry
        

       
        return journalEntry
    }
    
    func getJournalEntry_Today ( ) -> OPJournalEntry { // JournalItem{
        
        let journalEntryDate = today
        //  Fetch Request and Predicate:  array of args supports multiple days
        let jEntryFetch = NSFetchRequest(entityName: "OPJournalEntry")
        //jEntryFetch.predicate = NSPredicate(format: "date == %@", journalEntryDate)
        jEntryFetch.predicate = NSPredicate(format: "date == %@", argumentArray: [journalEntryDate])
        //(format: "date IN %@", @[journalEntryDate])
        
        var error: NSError?
        
        let result = managedContext.executeFetchRequest(jEntryFetch, error: &error) as? [OPJournalEntry]
        
         if let entries = result {
            if entries.count > 0 {
                let entry = entries[0] as OPJournalEntry
                println(entry.date)
                return entries[0]
            } else {
                return getNewJournalEntry(today)
            }
            
        } else {
            return getNewJournalEntry(today)
        }
    }
    
    
    func getJournalEntry (dateIdentifier: String) -> JournalEntryResult { // JournalItem{
        
        //  Fetch Request and Predicate:  array of args supports multiple days
        let jEntryFetch = NSFetchRequest(entityName: "OPJournalEntry")
        //jEntryFetch.predicate = NSPredicate(format: "date == %@", journalEntryDate)
        jEntryFetch.predicate = NSPredicate(format: "date == %@", argumentArray: [dateIdentifier])

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
    
    //MARK: Print List of Journal Entries
    func convertStringToDateAndReturnArrayInAscendingOrder(strings: [String]) -> [String] {
        typealias stringDateTuple = (String, NSDate)
        var tupleArray = [stringDateTuple]()
        var dateArray = [NSDate]()
        for s in strings {
            var dateFormatter = NSDateFormatter()
            dateFormatter.dateStyle = NSDateFormatterStyle.FullStyle
            let date = dateFormatter.dateFromString(s)
            tupleArray.append(stringDateTuple(s, date!))
            dateArray.append(date!)
        }
        
        dateArray.sort({$0.compare($1) == NSComparisonResult.OrderedDescending })
        var stringArray = [String]()
        for date in dateArray{
            var dateFormatter = NSDateFormatter()
            dateFormatter.dateStyle = NSDateFormatterStyle.FullStyle
            let dateString = dateFormatter.stringFromDate(date)
            stringArray.append(dateString)
        }
        return stringArray
    }
    
    func getListOfDatePropertyValuesForExisitingJournalEntries() -> [String] {
        var dates: [String] = [String]()
        
        if let entries = getAllJournalEntries() {
            for entry in entries {
                dates.append(entry.date)
            }
            return convertStringToDateAndReturnArrayInAscendingOrder(dates)
        }
        
        return dates
        
    }
    func getAllJournalEntries () -> [OPJournalEntry]? {
        
        //  Fetch Request and Predicate:  array of args supports multiple days
        let jEntryFetch = NSFetchRequest(entityName: "OPJournalEntry")
        var error: NSError?
        
        var result = managedContext.executeFetchRequest(jEntryFetch, error: &error) as? [OPJournalEntry]
        
        if let entries = result {
            //result!.sort({ $0.date.compare($1.date) == NSComparisonResult.OrderedAscending })
            return entries
        } else {
            //ignore error return JournalEntryResult.Error(error)
            return nil
        }
    }

    
    //MARK: Initialization Helper methods
    
    func getParentsArray(profile: OPProfile) -> [String] {
        var parentsArray = [String]()
        for p in profile.parents {
            let parent = p as? OPParent
            let name = parent!.firstName + " " + parent!.lastName
            parentsArray.append(name)
        }
        return  parentsArray

    }
    func defaultParentInitials() -> String?{
        if parentsArray.count == 0 {
            parentsArray = getParentsArray(currentRecord.profile)
        }
        
        if parentsArray.count > 0 {
            
            let fullName = parentsArray[0]
            var fullNameArr = split(fullName) {$0 == " "}
            
            if fullNameArr.count > 1 {
            var firstName: String = fullNameArr[0]
            var lastName: String? = fullNameArr.count > 1 ? fullNameArr[fullNameArr.count-1] : nil
            
            var firstInitial = firstName[firstName.startIndex]
            var lastInitial = lastName?[lastName!.startIndex]
            
            return "\(firstInitial). \(lastInitial!)."
            }
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
            if today != currentJournalEntry.date {
                //condition occurs when Track tab has been active at midnight: create a new journal entry for the new day
                currentJournalEntry = getJournalEntry_Today()
                updateJournalEntryToSelectedDate(currentJournalEntry)
            }
            return today
        } else {
            // handle case where offset was set previous day, but app was inactive and it's now a new day
            if today != currentJournalEntry.date && offsetNumberOfDaysFromCurrentDay == 1 {
                offsetNumberOfDaysFromCurrentDay--
                return selectJournalEntry(0)
            } else {
                //handle operation within the same day
            offsetNumberOfDaysFromCurrentDay--
            return selectJournalEntry(-offsetNumberOfDaysFromCurrentDay)
            }
        }
    }
    
    func selectJournalEntry(offsetFromCurrentDay: Int) -> String {
        //Get the date string for the selected day
        
        let calendar = NSCalendar.currentCalendar()
        let components = NSDateComponents()
        
        
        components.day = offsetFromCurrentDay
        let newDate = calendar.dateByAddingComponents(components, toDate: NSDate(), options: nil)
        let selectedDay = getFullStyleDateString(newDate!)

        println(selectedDay)
        
        // if core data holds journal entry for this day
        // else create new entry for selected day
        let journalEntry = getJournalEntry(selectedDay)
        
        switch journalEntry {
        case let .Success(entry):
            currentJournalEntry = entry
            updateJournalEntryToSelectedDate(entry)
        case .EntryDoesNotExist:
            currentJournalEntry = getNewJournalEntry(selectedDay)
            updateJournalEntryToSelectedDate(currentJournalEntry)
        case .Error:
            println("Core Data error encountered.")
        
        }
        
        return selectedDay
        
    }
    
    public func updateJournalEntryToSelectedDate (journalEntry: OPJournalEntry) {
        self.breakfast = VMBreakfast(fromDataObject: journalEntry.breakfast)
        self.morningSnack = VMSnack(fromDataObject: journalEntry.morningSnack)
        self.lunch = VMLunch(fromDataObject: journalEntry.lunch)
        self.afternoonSnack = VMSnack(fromDataObject: journalEntry.afternoonSnack)
        self.dinner = VMDinner(fromDataObject: journalEntry.dinner)
        self.eveningSnack = VMSnack(fromDataObject: journalEntry.eveningSnack)
    
    }
    public func getFullStyleDateString(date: NSDate) -> String {
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

        //let managedCon = managedContext
        
        let recordFetch = NSFetchRequest(entityName: "OPPatientRecord")
        
        var error: NSError?
        
        let result = managedContext.executeFetchRequest(recordFetch, error: &error) as! [OPPatientRecord]?
        
        if let records = result {
            
            if records.count == 0 {
                // Create mew record and profile
                let recordEntity = NSEntityDescription.entityForName("OPPatientRecord",
                    inManagedObjectContext: managedContext)
                
                self.currentRecord = OPPatientRecord(entity: recordEntity!,
                    insertIntoManagedObjectContext: managedContext)
                
                let profileEntity = NSEntityDescription.entityForName("OPProfile",
                    inManagedObjectContext: managedContext)
                
                currentRecord.profile = OPProfile(entity: profileEntity!,
                    insertIntoManagedObjectContext: managedContext)
                
                currentRecord.profile.firstAndLastName = ""
                
//                //Add Parent Name
//                let profileEntityParent2 = NSEntityDescription.entityForName("OPParent",
//                    inManagedObjectContext: managedContext)
//                
//                let parentEntry2 =  OPParent(entity: profileEntityParent2!,
//                    insertIntoManagedObjectContext: managedContext)
//                
////                parentEntry2.firstName = "Jon"
////                parentEntry2.lastName = "Smith"
//                
//                parentEntry2.profile = currentRecord.profile
                
                
//                //Add Parent Name
//                let profileEntityParent = NSEntityDescription.entityForName("OPParent",
//                    inManagedObjectContext: managedContext)
//                
//                let parentEntry =  OPParent(entity: profileEntityParent!,
//                    insertIntoManagedObjectContext: managedContext)
//                
//                parentEntry.firstName = "Susan"
//                parentEntry.lastName = "Smith"
//                
//                parentEntry.profile = currentRecord.profile
//                
                

                
                return currentRecord
                
            } else {
                currentRecord = records[0] //as OPPatientRecord
                
                return currentRecord
            }
        } else {
            println("Could not fetch: \(error)")
        }
        //assert(false, "Unimplemented")
        return currentRecord
    }
    
    
    
    
    
    
    
    func buildJournalEntry ( profile: PatientProfile ) -> JournalItem{
        return JournalItem(itemTitle: "test jounal entry")// itemTitle: "test journal item")
        
    }
    
    func loadProfile() -> PatientProfile {
        var profile = PatientProfile()
        return profile
    }
    

   
   
    //MARK: Printing Methods
    func getPrintableFoodItemReference(foodItemString: String) -> String {
        //Parse MealItem.FoodChoice -> FoodItem.name + ChildChoiceItem.INDEX
        let myArray: [String] = foodItemString.componentsSeparatedByString(",")
        
        if myArray.count > 1 && myArray[0] != "Milk"{
        let indexString: String? = myArray.last
        let indexValue = indexString?.toInt()
        
        let parentName = myArray.first

        //Get parent food item & cast as FoodItemChoice
        let printableText = getParentTextToPrintAndChildItemNameFromFoodItemWithChoice(parentName!, indexOfChild: indexValue!)
        
        
        //  return concatenate Parent.name + Child.name
        // -> 4 oz Poultry with 1 oz Cheese
        
        return printableText
        } else {
            //return input that doesn't have the comma separator
            var fullString = ""
            for item in foodItems {
                if item.name == foodItemString {
                    if item.menuItemType == "FruitItem" || item.menuItemType == "SnackItem" || item.menuItemType == "StarchDinnerItem" || item.menuItemType == "OilDinnerItem"{
                        return item.itemDescription
                    }
                    if item.menuItemType == "VegetableItem" {
                        
                        return item.serving.servingDescription + " " + item.itemDescription
                    }
                    fullString = item.name + ", " + item.itemDescription
                    
                }
            }

            return fullString
        }
 
    }
    func getParentTextToPrintAndChildItemNameFromFoodItemWithChoice(parentName: String, indexOfChild: Int) -> String {
        
        var childItemName = ""
        var parentTextToPrint = ""
        var fullString = ""
        for item in foodItems {
            if item.name == parentName {
                if let choiceItem = item as? FoodItemWithChoice {
                    let child = choiceItem.choiceItems[indexOfChild]
                    childItemName = child.name
                    let childItemDescription = child.itemDescription
                    
                    if choiceItem.menuItemType == "MeatDinnerItem" {
                        parentTextToPrint = choiceItem.name
                        return parentTextToPrint + childItemName
                    }
                    else {
                        //only other case is lunch item
                        fullString = "A sandwich with " + choiceItem.itemDescription + " and " + childItemDescription
                        return fullString
                    }
                    
                }
            }
            if item.name == parentName {
                
            }
        }
        return fullString
    }
 
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
        
        return VMBreakfast(fromDataObject: getJournalEntry_Today().breakfast )
        //return self.breakfast//initialized in init
    }
    func setOptionalStringProperty( inout stringProperty: String?, valuefromMealVM: String?) -> String? {
        //conditionally sets optional property if value is not nil
        if let value = valuefromMealVM  {
            stringProperty = value
            return value
        }
        return nil
    }
    
    func setBoolProperty( inout property: NSNumber, valuefromMealVM: Bool) -> NSNumber {
            let property = NSNumber(bool: valuefromMealVM)
            return property
    }
    
    func setOptionalBoolProperty( inout property: NSNumber?, valuefromMealVM: Bool?) -> NSNumber? {
        //conditionally sets optional property if value is not nil
        if let value = valuefromMealVM  {
            property = NSNumber(bool: value)
            return property
        }
        return nil
    }
    
    func saveBreakfast(breakfast: VMBreakfast){//, inout modelBreakfast: OPBreakfast){
        //use helper method to set property for optional values
        self.breakfast = breakfast
        let modelBreakfast = currentJournalEntry.breakfast
        
        let mBreakfast =  modelBreakfast
        
        //self.currentJournalEntry.breakfast.foodChoice = breakfast.foodChoice!
        
//        if let value = breakfast.foodChoice  {
//            mBreakfast.foodChoice = value
//        }
        //        if let value = breakfast.fruitChoice  {
        //            mBreakfast.fruitChoice = value
        //        }
        setOptionalStringProperty(&mBreakfast.foodChoice, valuefromMealVM: breakfast.foodChoice)
        setOptionalStringProperty(&mBreakfast.fruitChoice, valuefromMealVM: breakfast.fruitChoice)
        
        mBreakfast.addOnRequired = NSNumber(bool: breakfast.addOnRequired)
        setOptionalStringProperty(&mBreakfast.addOnText, valuefromMealVM: breakfast.addOnText)
        setOptionalBoolProperty(&mBreakfast.addOnConsumed, valuefromMealVM: breakfast.addOnConsumed)
        
        mBreakfast.medicineRequired = NSNumber(bool: breakfast.medicineRequired)
        setOptionalStringProperty(&mBreakfast.medicineText, valuefromMealVM: breakfast.medicineText)
        setOptionalBoolProperty(&mBreakfast.medicineConsumed, valuefromMealVM: breakfast.medicineConsumed)
        
        
        setOptionalStringProperty(&mBreakfast.parentInitials, valuefromMealVM: breakfast.parentInitials)
        setOptionalStringProperty(&mBreakfast.location, valuefromMealVM: breakfast.location)
        setOptionalStringProperty(&mBreakfast.time, valuefromMealVM: breakfast.time)
        setOptionalStringProperty(&mBreakfast.note, valuefromMealVM: breakfast.note)
        var error: NSError?
        if !managedContext.save(&error) {
            println("Could not save: \(error)")
        }
    }

    func getLunch_Today() -> VMLunch {
        
        return self.lunch//initialized in init
    }
    
    func saveLunch(lunch: VMLunch){
        self.lunch = lunch

        setOptionalStringProperty(&currentJournalEntry.lunch.lunchChoice, valuefromMealVM: lunch.lunchChoice)
        setOptionalStringProperty(&currentJournalEntry.lunch.fruitChoice, valuefromMealVM: lunch.fruitChoice)
        
        currentJournalEntry.lunch.addOnRequired = NSNumber(bool: lunch.addOnRequired)
        setOptionalStringProperty(&currentJournalEntry.lunch.addOnText, valuefromMealVM: lunch.addOnText)
        setOptionalBoolProperty(&currentJournalEntry.lunch.addOnConsumed, valuefromMealVM: lunch.addOnConsumed)
        
        currentJournalEntry.lunch.medicineRquired = NSNumber(bool: lunch.medicineRequired)
        setOptionalStringProperty(&currentJournalEntry.lunch.medicineText, valuefromMealVM: lunch.medicineText)
        setOptionalBoolProperty(&currentJournalEntry.lunch.medicineConsumed, valuefromMealVM: lunch.medicineConsumed)
        
        setOptionalStringProperty(&currentJournalEntry.lunch.parentInitials, valuefromMealVM: lunch.parentInitials)
        setOptionalStringProperty(&currentJournalEntry.lunch.location, valuefromMealVM: lunch.location)
        setOptionalStringProperty(&currentJournalEntry.lunch.time, valuefromMealVM: lunch.time)
        setOptionalStringProperty(&currentJournalEntry.lunch.note, valuefromMealVM: lunch.note)
        

                var error: NSError?
        if !managedContext.save(&error) {
            println("Could not save: \(error)")
        }
        
    }
    
    func getSnack_Today(snackTime: SnackTime) -> VMSnack {
        switch snackTime{
        case .Morning:
            return VMSnack(fromDataObject: getJournalEntry_Today().morningSnack)
        case .Afternoon:
            return VMSnack(fromDataObject: getJournalEntry_Today().afternoonSnack)
        case .Evening:
            return VMSnack(fromDataObject: getJournalEntry_Today().eveningSnack)
        }
       // return self.snack!//initialized in init
        
    }
    func saveSnack_Today(snack: VMSnack, snackTime: SnackTime){
    
        
        switch snackTime{
        case .Morning:
            self.morningSnack = snack
            let modelSnack = currentJournalEntry.morningSnack
            setOptionalStringProperty(&modelSnack.snackChoice, valuefromMealVM: snack.snackChoice)
            setOptionalStringProperty(&modelSnack.fruitChoice, valuefromMealVM: snack.fruitChoice)
            
            modelSnack.addOnRequired = NSNumber(bool: snack.addOnRequired)
            setOptionalStringProperty(&modelSnack.addOnText, valuefromMealVM: snack.addOnText)
            setOptionalBoolProperty(&modelSnack.addOnConsumed, valuefromMealVM: snack.addOnConsumed)
            
            modelSnack.medicineRequired = NSNumber(bool: snack.medicineRequired)
            setOptionalStringProperty(&modelSnack.medicineText, valuefromMealVM: snack.medicineText)
            setOptionalBoolProperty(&modelSnack.medicineConsumed, valuefromMealVM: snack.medicineConsumed)
            
            setOptionalStringProperty(&modelSnack.parentInitials, valuefromMealVM: snack.parentInitials)
            setOptionalStringProperty(&modelSnack.location, valuefromMealVM: snack.location)
            setOptionalStringProperty(&modelSnack.time, valuefromMealVM: snack.time)
            setOptionalStringProperty(&modelSnack.note, valuefromMealVM: snack.note)

        case .Afternoon:
            self.afternoonSnack = snack
            let modelSnack = currentJournalEntry.afternoonSnack
            setOptionalStringProperty(&modelSnack.snackChoice, valuefromMealVM: snack.snackChoice)
            setOptionalStringProperty(&modelSnack.fruitChoice, valuefromMealVM: snack.fruitChoice)
            
            modelSnack.addOnRequired = NSNumber(bool: snack.addOnRequired)
            setOptionalStringProperty(&modelSnack.addOnText, valuefromMealVM: snack.addOnText)
            setOptionalBoolProperty(&modelSnack.addOnConsumed, valuefromMealVM: snack.addOnConsumed)
            
            modelSnack.medicineRequired = NSNumber(bool: snack.medicineRequired)
            setOptionalStringProperty(&modelSnack.medicineText, valuefromMealVM: snack.medicineText)
            setOptionalBoolProperty(&modelSnack.medicineConsumed, valuefromMealVM: snack.medicineConsumed)
            
            setOptionalStringProperty(&modelSnack.parentInitials, valuefromMealVM: snack.parentInitials)
            setOptionalStringProperty(&modelSnack.location, valuefromMealVM: snack.location)
            setOptionalStringProperty(&modelSnack.time, valuefromMealVM: snack.time)
            setOptionalStringProperty(&modelSnack.note, valuefromMealVM: snack.note)

        case .Evening:
            self.eveningSnack = snack
            let modelSnack = currentJournalEntry.eveningSnack
            setOptionalStringProperty(&modelSnack.snackChoice, valuefromMealVM: snack.snackChoice)
            setOptionalStringProperty(&modelSnack.fruitChoice, valuefromMealVM: snack.fruitChoice)
            
            modelSnack.addOnRequired = NSNumber(bool: snack.addOnRequired)
            setOptionalStringProperty(&modelSnack.addOnText, valuefromMealVM: snack.addOnText)
            setOptionalBoolProperty(&modelSnack.addOnConsumed, valuefromMealVM: snack.addOnConsumed)
            
            modelSnack.medicineRequired = NSNumber(bool: snack.medicineRequired)
            setOptionalStringProperty(&modelSnack.medicineText, valuefromMealVM: snack.medicineText)
            setOptionalBoolProperty(&modelSnack.medicineConsumed, valuefromMealVM: snack.medicineConsumed)
            
            setOptionalStringProperty(&modelSnack.parentInitials, valuefromMealVM: snack.parentInitials)
            setOptionalStringProperty(&modelSnack.location, valuefromMealVM: snack.location)
            setOptionalStringProperty(&modelSnack.time, valuefromMealVM: snack.time)
            setOptionalStringProperty(&modelSnack.note, valuefromMealVM: snack.note)
        }
        var error: NSError?
        if !managedContext.save(&error) {
            println("Could not save: \(error)")
        }

        
    }
    
    func getDinner_Today() -> VMDinner {
        return self.dinner//initialized in init
    }

    func saveDinner(dinner: VMDinner){
        self.dinner = dinner
        
        let modelDinner = currentJournalEntry.dinner
        modelDinner.meat = dinner.meat
        modelDinner.starch = dinner.starch
        modelDinner.oil = dinner.oil
        modelDinner.vegetable = dinner.vegetable
        modelDinner.requiredItems = dinner.requiredItemsConsumed.boolValue
        
        modelDinner.medicineRequired = dinner.medicineRequired
        modelDinner.medicineConsumed = dinner.medicineConsumed
        modelDinner.medicineText = dinner.medicineText
        
        modelDinner.addOnConsumed = dinner.addOnConsumed
        modelDinner.addOnRequired = dinner.addOnRequired
        modelDinner.addOnText = dinner.addOnText
        
        modelDinner.parentInitials = dinner.parentInitials
        modelDinner.place = dinner.location
        modelDinner.time = dinner.time
        
        modelDinner.note = dinner.note
        var error: NSError?
        if !managedContext.save(&error) {
            println("Could not save: \(error)")
        }

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
    
    lazy var foodItems: [FoodItem] = {
        return self.loadFoodItems()
        }()
    
    
   
    func buildDetailViewArray() -> [AnyObject]{
        
        var profile = self.loadProfile()
        var journalItem = self.buildJournalEntry(profile)
        
        //var logEntryItems = [Any]()
        
        //foodItems Array used by all foodItems
        //self.foodItems = self.loadFoodItems()
        
//        logEntryItems.append(buildBreakfastItems(profile, journalItem: journalItem))
//        logEntryItems.append(self.buildLunchItems(profile, journalItem: journalItem))
//        logEntryItems.append(Snack())
//        logEntryItems.append(self.buildDinnerItems(profile, journalItem: journalItem))
//        logEntryItems.append(Medicine())
//        logEntryItems.append(Activity())
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