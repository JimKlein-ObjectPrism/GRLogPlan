//
//  ProfileDataStoreDelegate.swift
//  CoreDataTest
//
//  Created by James Klein on 4/21/15.
//  Copyright (c) 2015 James Klein. All rights reserved.
//

import Foundation

//typealias parentReturn =

protocol ProfileDataStoreDelegate {
    //Parents
    func getParents() -> [OPParent]
    func addParent( firstName: String?, lastName: String?) -> (parent: OPParent?, errorArray: [ParentProfileValidation])
    func updateParentInModel( atIndex: Int, firstName: String?, lastName: String?) -> (parent: OPParent?, errorArray: [ParentProfileValidation])
    func deleteParent( atIndex: Int) -> (parent: OPParent?, coreDataError: NSError?)
    
    // Medicines
    //Inputs not optional because picker always has value
    func getMedicines() -> [OPMedicine]
    func addMedicine (medicine: Int, prescribedTimeForAction: Int) -> ( medObject: OPMedicine?, errorArray: [MedicineValidation])
    func updateMedicine (atIndex: Int, medicine: Int, prescribedTimeForAction: Int) -> ( medObject: OPMedicine?, errorArray: [MedicineValidation])
    func deleteMedicine (atIndex: Int) -> (medicine: OPMedicine?, coreDataError: NSError?)
    // AddOns
    //Inputs not optional because picker always has value
    func getAddOns() -> [OPAddOn]
    func addAddOn (addOn: Int, prescribedTimeForAction: Int) -> ( addOnObject: OPAddOn?, errorArray: [AddOnValidation])
    func updateAddOn (atIndex: Int, addOn: Int, prescribedTimeForAction: Int) -> ( addOnObject: OPAddOn?, errorArray: [AddOnValidation])
    func deleteAddOn (atIndex: Int) -> (addOnObject: OPAddOn?, coreDataError: NSError?)

    //Profile
    //func saveProfile(firstName: String, lastName: String) -> (profile: OPProfile?, error: ProfileValidation)
    
}

public enum MedicineValidation: String {
    case Success = "Success",
    DuplicateMedicineEntry = "This entry already exists.",
    CoreDataErrorEncountered = "CoreData Error.  Please Close and Restart the App.",
    IndexOutOfRangeMedicine = "Index Out of Range: Medicine Selection",
    IndexOutOfRangeTimeForAction = "Index Out of Range: TimeForActionSelection"
}

public enum AddOnValidation: String {
    case Success = "Success",
    DuplicateAddOnEntry = "This entry already exists.",
    CoreDataErrorEncountered = "CoreData Error.  Please Close and Restart the App.",
    IndexOutOfRangeMedicine = "Index Out of Range: AddOn Selection",
    IndexOutOfRangeTimeForAction = "Index Out of Range: TimeForActionSelection"
}

public enum ParentProfileValidation: String  {
    case Success = "Success",
    CoreDataErrorEncountered = "CoreData Error.  Please Close and Restart the App.",
    FirstNameIsNil = "A First Name is required.",
    LastNameIsNil = "A Last Name is required.",
    FirstNameInvalidCharacter = "A First Name can contain only letter characters and must be between 1 and 15 letters long.",
    LastNameInvalidCharacter = "A Last Name can contain only alphabet characters and \"'\" and \"-\". It must start and end with an alphabet character.  It must be between 2 and 20 letters long.",
    DuplicateParentEntry = "An entry for this parent already exists.",
    IndexOutOfRange = "Index Out of Range."
}

public enum ProfileValidation: String {
    case Success = "Success.",
    FirstNameIsNil = "A First Name is required.",
    LastNameIsNil = "A Last Name is required.",
    NoParentsPresentInProfile = "At least one parent must be added to the profile."
}


