//
//  UserInfoTests.swift
//  GRPatienLogAndPlan
//
//  Created by James Klein on 8/18/15.
//  Copyright (c) 2015 ObjectPrism Corp. All rights reserved.
//

import UIKit
import CoreData
import XCTest

import GRPatienLogAndPlan

class UserInfoValidationTests: XCTestCase {
    
    var dataStore : DataStore!
    var profile: OPProfile!
    var coreDataStack: CoreDataStack!
    


    
    override func setUp() {
        super.setUp()
        
        coreDataStack = TestCoreDataStack()
        
        dataStore = DataStore(managedContext: coreDataStack.context)

        profile = dataStore.currentProfile
        
        //Parent duplicate test  setup
        //Add Parent Name
        let profileEntityParent2 = NSEntityDescription.entityForName("OPParent",
            inManagedObjectContext: coreDataStack.context)

        let parentEntry2 =  OPParent(entity: profileEntityParent2!,
            insertIntoManagedObjectContext: coreDataStack.context)

        parentEntry2.firstName = "Jon"
        parentEntry2.lastName = "Duplicate"

        parentEntry2.profile = profile//dataStcurrentRecord.profile
        
        //Medicine test setup
        //create new OPMedicine entity in the managed context
        let medicineEntity = NSEntityDescription.entityForName("OPMedicine",
            inManagedObjectContext: coreDataStack.context)
        
        var med: OPMedicine = OPMedicine(entity: medicineEntity!,
            insertIntoManagedObjectContext: coreDataStack.context)
        med.profile = profile
        med.name = 0
        
        med.targetTimePeriodToTake = 0

        //AddOn test setup
        //create new OPAddOn entity in the managed context
        let addOnEntity = NSEntityDescription.entityForName("OPAddOn",
            inManagedObjectContext: coreDataStack.context)
        
        var addOn: OPAddOn = OPAddOn(entity: addOnEntity!,
            insertIntoManagedObjectContext: coreDataStack.context)
        addOn.profile = profile
        addOn.addOnItem = NSNumber(integer: 0)
        
        addOn.targetMealOrSnack = NSNumber(integer: 0)

        
    }
    
    override func tearDown() {
        // Put teardown code here. This method is called after the invocation of each test method in the class.
        super.tearDown()
        dataStore = nil
    }
    
//    func testValidationCode (parentFirstName: String, parentLastName: String) -> [ParentProfileValidation] {
//        let result = dataStore.validateParentInput(parentFirstName, parentLastName: "Doe")
//        return result
//    }
    //MARK: parent name duplicate
    func testParentNameIsUnique () {
        let parentFirstName = "Jon"
        let parentLastName = "Duplicate"
        
        let result = dataStore.validateParentInput(parentFirstName, lastName: parentLastName, profile: profile)
        
        XCTAssert(result.count > 0, "Duplicate name should not pass.")// see parent name added in setup:  Jon Duplicate

    }
    
    //MARK: Test First or Last Name Missing
    func testFirstOrLastNameCanNotBeNil()
    {
        let result = dataStore.validateParentInput("Jon",   lastName: nil, profile: profile)
        
        XCTAssert(result[0] == ParentProfileValidation.LastNameIsNil, "A last name cannot be nil.")
        
        
        let result1 = dataStore.validateParentInput(nil,   lastName: "Doe", profile: profile)
        
        XCTAssert(result1[0] == ParentProfileValidation.FirstNameIsNil, "A first name cannot be nil.")
    }

    
    //MARK: First Name Tests
    func testFirstNameHappyPath(){
        let parentFirstName = "Jon"
        let parentLastName = "Doe"
        
        let result = dataStore.validateParentInput(parentFirstName, lastName: parentLastName, profile: profile)
        
        XCTAssert(result.count == 0, "Happy Path should pass.")
    }
    
    func testFirstNameWithOneCharacter (){
    let parentFirstName = "J"
    let parentLastName = "Doe"
    
    let result = dataStore.validateParentInput(parentFirstName, lastName: parentLastName, profile: profile)
    
    XCTAssert(result.count == 0, "Single character first name should pass.")
    }
    func testFirstNameWithFifteenCharacter (){
        let parentFirstName = "aaaaabbbbbccccc"
        let parentLastName = "Doe"
        
        let result = dataStore.validateParentInput(parentFirstName, lastName: parentLastName, profile: profile)
        
        XCTAssert(result.count == 0, "Fifteen character first name should pass.")
    }
    func testFirstNameWithSixteenCharacters (){
        let parentFirstName = "aaaaabbbbbcccccd"
        let parentLastName = "Doe"
        
        let result = dataStore.validateParentInput(parentFirstName, lastName: parentLastName, profile: profile)
        
        XCTAssert(result.count > 0, "Sixteen character first name should not pass.")
    }
    func testFirstNameCannotContainDigitCharacter () {
        let parentFirstName = "Jo8n"
        let parentLastName = "Doe"
        
        let result = dataStore.validateParentInput(parentFirstName, lastName: parentLastName, profile: profile)
        
        XCTAssert(result[0] == ParentProfileValidation.FirstNameInvalidCharacter, "A first name with a digit should not pass.")
    }
    func testFirstNameCannotContainNonAlphaCharacter () {
        let parentFirstName = "Jo.n"
        let parentLastName = "Doe"
        
        let result = dataStore.validateParentInput(parentFirstName, lastName: parentLastName, profile: profile)
        
        XCTAssert(result[0] == ParentProfileValidation.FirstNameInvalidCharacter, "A first name with a digit should not pass.")
    }
//MARK: Last Name Tests
    
    func testLastNameHappyPath_Simple(){
        let parentFirstName = "Jon"
        let parentLastName = "Doe"
        
        let result = dataStore.validateParentInput(parentFirstName, lastName: parentLastName, profile: profile)
        
        XCTAssert(result.count == 0, "Happy Path should pass.")
    }
  
    func testLastNameHyphenBetweenTwoNames(){
        let parentFirstName = "Jon"
        let parentLastName = "Doe-Smoe"
        
        let result = dataStore.validateParentInput(parentFirstName, lastName: parentLastName, profile: profile)
        
        XCTAssert(result.count == 0, "Two last names separated by a hyphen should pass.")
    }
    func testLastNameIrishName(){
        let parentFirstName = "Jon"
        let parentLastName = "O'Doe"
        
        let result = dataStore.validateParentInput(parentFirstName, lastName: parentLastName, profile: profile)
        
        XCTAssert(result.count == 0, "A last name with an apostrophe should pass.")
    }
    func testLastNameWithOneCharacter (){
        let parentFirstName = "Jon"
        let parentLastName = "D"
        
        let result = dataStore.validateParentInput(parentFirstName, lastName: parentLastName, profile: profile)
        
        XCTAssert(result.count > 0, "Single character last name should not pass.")
    }
    func testLastNameWithTwoCharacter (){
        let parentFirstName = "J"
        let parentLastName = "DD"
        
        let result = dataStore.validateParentInput(parentFirstName, lastName: parentLastName, profile: profile)
        
        XCTAssert(result.count == 0, "Two character last name should pass.")
    }
    
    func testLastNameWithTwentyCharacter (){
        let parentFirstName = "Jon"
        let parentLastName = "aaaaabbbbbcccccddddd"// twenty characters
        
        let result = dataStore.validateParentInput(parentFirstName, lastName: parentLastName, profile: profile)
        
        XCTAssert(result.count == 0, "Twenty character last name should pass.")
    }
    func testLastNameWithTwentyOneCharacters (){
        let parentFirstName = "Jon"
        let parentLastName = "aaaaabbbbbcccccddddde"//21 chars
        
        let result = dataStore.validateParentInput(parentFirstName, lastName: parentLastName, profile: profile)
        
        XCTAssert(result.count > 0, "Sixteen character first name should not pass.")
    }

    func testLastNameCannotContainDigitCharacter () {
        let parentFirstName = "Jon"
        let parentLastName = "O'Doe9"
        
        let result = dataStore.validateParentInput(parentFirstName, lastName: parentLastName, profile: profile)
        
        XCTAssert(result[0] == ParentProfileValidation.LastNameInvalidCharacter, "A first name with a digit should not pass.")
    }

    func testLastNameCanNotStartWithHyphenOrApostrophe ()
    {
        let result = dataStore.validateParentInput("Jon",   lastName: "-Doe", profile: profile)
        
        XCTAssert(result[0] == ParentProfileValidation.LastNameInvalidCharacter, "A last name cannot start with a hyphen.")
        let result1 = dataStore.validateParentInput("Jon",   lastName: "'Doe", profile: profile)
        
        XCTAssert(result1[0] == ParentProfileValidation.LastNameInvalidCharacter, "A last name cannot start with an apostrophe.")
    }
    func testLastNameCanNotEndWithHyphenOrApostrophe ()
    {
        let result = dataStore.validateParentInput("Jon",   lastName: "Doe-", profile: profile)
        
        XCTAssert(result[0] == ParentProfileValidation.LastNameInvalidCharacter, "A last name cannot end with a hyphen.")
        let result1 = dataStore.validateParentInput("Jon",   lastName: "Doe'", profile: profile)
        
        XCTAssert(result1[0] == ParentProfileValidation.LastNameInvalidCharacter, "A last name cannot end with an apostrophe.")
    }
    
    //MARK: Medicine Test
    func testMedicineEntryIsUnique () {
        let result = dataStore.validateMedicineResult(0, prescribedTimeForAction: 0, profileMedicines: dataStore.getMedicines())
        
        XCTAssert(result.count > 0, "Duplicate Medicine should not pass.")
        
    }
    //MARK: AddOn Test
    func testAddOnEntryIsUnique () {
        let result = dataStore.validateAddOnResult(0, prescribedTimeForAction: 0, profileAddOns: dataStore.getAddOns())
        
        XCTAssert(result.count > 0, "Duplicate AddOn should not pass.")
        
    }

    
    func testExample() {
        // This is an example of a functional test case.
        XCTAssert(true, "Pass")
    }

    func testPerformanceExample() {
        // This is an example of a performance test case.
        self.measureBlock() {
            // Put the code you want to measure the time of here.
        }
    }

}
