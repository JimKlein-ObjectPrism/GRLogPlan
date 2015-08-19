//
//  UserInfoTests.swift
//  GRPatienLogAndPlan
//
//  Created by James Klein on 8/18/15.
//  Copyright (c) 2015 ObjectPrism Corp. All rights reserved.
//

import UIKit
import XCTest
import GRPatienLogAndPlan

class UserInfoTests: XCTestCase {
    
    var dataStore : DataStore!
    
    override func setUp() {
        super.setUp()
        
        dataStore = DataStore()
        
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
    //MARK: First Name Tests
    func testFirstNameHappyPath(){
        let parentFirstName = "Jon"
        let parentLastName = "Doe"
        
        let result = dataStore.validateParentInput(parentFirstName, lastName: parentLastName)
        
        XCTAssert(result.count == 0, "Happy Path should pass.")
    }
    
    func testFirstNameWithOneCharacter (){
    let parentFirstName = "J"
    let parentLastName = "Doe"
    
    let result = dataStore.validateParentInput(parentFirstName, lastName: parentLastName)
    
    XCTAssert(result.count == 0, "Single character first name should pass.")
    }
    func testFirstNameWithFifteenCharacter (){
        let parentFirstName = "aaaaabbbbbccccc"
        let parentLastName = "Doe"
        
        let result = dataStore.validateParentInput(parentFirstName, lastName: parentLastName)
        
        XCTAssert(result.count == 0, "Fifteen character first name should pass.")
    }
    func testFirstNameWithSixteenCharacters (){
        let parentFirstName = "aaaaabbbbbcccccd"
        let parentLastName = "Doe"
        
        let result = dataStore.validateParentInput(parentFirstName, lastName: parentLastName)
        
        XCTAssert(result.count > 0, "Sixteen character first name should not pass.")
    }
    func testFirstNameCannotContainDigitCharacter () {
        let parentFirstName = "Jo8n"
        let parentLastName = "Doe"
        
        let result = dataStore.validateParentInput(parentFirstName, lastName: parentLastName)
        
        XCTAssert(result[0] == ParentProfileValidation.FirstNameInvalidCharacter, "A first name with a digit should not pass.")
    }
    func testFirstNameCannotContainNonAlphaCharacter () {
        let parentFirstName = "Jo.n"
        let parentLastName = "Doe"
        
        let result = dataStore.validateParentInput(parentFirstName, lastName: parentLastName)
        
        XCTAssert(result[0] == ParentProfileValidation.FirstNameInvalidCharacter, "A first name with a digit should not pass.")
    }
//MARK: Last Name Tests
    
    func testLastNameHappyPath_Simple(){
        let parentFirstName = "Jon"
        let parentLastName = "Doe"
        
        let result = dataStore.validateParentInput(parentFirstName, lastName: parentLastName)
        
        XCTAssert(result.count == 0, "Happy Path should pass.")
    }
  
    func testLastNameHyphenBetweenTwoNames(){
        let parentFirstName = "Jon"
        let parentLastName = "Doe-Smoe"
        
        let result = dataStore.validateParentInput(parentFirstName, lastName: parentLastName)
        
        XCTAssert(result.count == 0, "Two last names separated by a hyphen should pass.")
    }
    func testLastNameIrishName(){
        let parentFirstName = "Jon"
        let parentLastName = "O'Doe"
        
        let result = dataStore.validateParentInput(parentFirstName, lastName: parentLastName)
        
        XCTAssert(result.count == 0, "A last name with an apostrophe should pass.")
    }
    func testLastNameWithOneCharacter (){
        let parentFirstName = "J"
        let parentLastName = "Doe"
        
        let result = dataStore.validateParentInput(parentFirstName, lastName: parentLastName)
        
        XCTAssert(result.count > 0, "Single character last name should not pass.")
    }
    func testLastNameWithTwoCharacter (){
        let parentFirstName = "J"
        let parentLastName = "Doe"
        
        let result = dataStore.validateParentInput(parentFirstName, lastName: parentLastName)
        
        XCTAssert(result.count == 0, "Two character last name should pass.")
    }
    
    func testLastNameWithTwentyCharacter (){
        let parentFirstName = "Jon"
        let parentLastName = "aaaaabbbbbcccccddddd"
        
        let result = dataStore.validateParentInput(parentFirstName, lastName: parentLastName)
        
        XCTAssert(result.count == 0, "Twenty character last name should pass.")
    }
    func testLastNameWithTwentyOneCharacters (){
        let parentFirstName = "Jon"
        let parentLastName = "aaaaabbbbbcccccdddddee"
        
        let result = dataStore.validateParentInput(parentFirstName, lastName: parentLastName)
        
        XCTAssert(result.count > 0, "Sixteen character first name should not pass.")
    }

    func testLastNameCannotContainDigitCharacter () {
        let parentFirstName = "Jon"
        let parentLastName = "O'Doe9"
        
        let result = dataStore.validateParentInput(parentFirstName, lastName: parentLastName)
        
        XCTAssert(result[0] == ParentProfileValidation.LastNameInvalidCharacter, "A first name with a digit should not pass.")
    }

    func testLastNameCanNotStartWithHyphenOrApostrophe ()
    {
        let result = dataStore.validateParentInput("Jon",   lastName: "-Doe")
        
        XCTAssert(result[0] == ParentProfileValidation.LastNameInvalidCharacter, "A last name cannot start with a hyphen.")
        let result1 = dataStore.validateParentInput("Jon",   lastName: "'Doe")
        
        XCTAssert(result1[0] == ParentProfileValidation.LastNameInvalidCharacter, "A last name cannot start with an apostrophe.")
    }
    func testLastNameCanNotEndWithHyphenOrApostrophe ()
    {
        let result = dataStore.validateParentInput("Jon",   lastName: "Doe-")
        
        XCTAssert(result[0] == ParentProfileValidation.LastNameInvalidCharacter, "A last name cannot end with a hyphen.")
        let result1 = dataStore.validateParentInput("Jon",   lastName: "Doe'")
        
        XCTAssert(result1[0] == ParentProfileValidation.LastNameInvalidCharacter, "A last name cannot end with an apostrophe.")
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
