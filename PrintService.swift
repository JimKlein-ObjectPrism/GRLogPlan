//
//  swift
//  GRPatienLogAndPlan
//
//  Created by James Klein on 6/4/15.
//  Copyright (c) 2015 ObjectPrism Corp. All rights reserved.
//

import Foundation

public class PrintSevice {
    
    var dataStore: DataStore
    
    init(){
        let appDelegate = UIApplication.sharedApplication().delegate as? AppDelegate
        dataStore = appDelegate!.dataStore
        //let journalEntry = dataStore.getJournalEntry(journalEntryDateString)
    }
    
    func getStringToPrint(journalEntryDateString: String) -> String{
        var result = dataStore.getJournalEntry(journalEntryDateString)

        switch result {
        case let JournalEntryResult.Success(entry):
                let patientRecord = dataStore.currentProfile()
                let profile = patientRecord.profile
            let htmlString = buildLogEntryPrintOut(profile,  breakfastLogEntry: entry.breakfast, morningSnackLogEntry: entry.morningSnack, lunchLogEntry: entry.lunch, afternoonSnackLogEntry: entry.afternoonSnack, dinnerLogEntry: entry.dinner, eveningSnackLogEntry: entry.eveningSnack)
                return htmlString
        case .EntryDoesNotExist:
            println("no journal entry found")
            
        case let .Error(error):
            println("CoreData Error: \(error)")
        }

        return ""
    }
    
    func nilEntryNote () -> String {
        return "None Selected"
    }
    
    public func buildLogEntryPrintOut(profile: OPProfile,
        breakfastLogEntry: OPBreakfast,
        morningSnackLogEntry: OPMorningSnack,
        lunchLogEntry: OPLunch,
        afternoonSnackLogEntry: OPAfternoonSnack,
        dinnerLogEntry: OPDinner,
        eveningSnackLogEntry: OPEveningSnack
        ) -> String{
            
            var morningSnackString = ""
            
            if profile.morningSnackRequired.boolValue {
                morningSnackString =   tableOpeningTags +
                    buildMorningSnackHTML("Morning Snack", date: morningSnackLogEntry.time, snackLogEntry: morningSnackLogEntry) +
                    tableClosingTags +
                    spacerTags
            }
            
            var eveningSnackString = ""
            
            if profile.eveningSnackRequired.boolValue {
                eveningSnackString =   tableOpeningTags +
                    buildEveningSnackHTML("Evening Snack", date: eveningSnackLogEntry.time, snackLogEntry: eveningSnackLogEntry) +
                    tableClosingTags +
                spacerTags
            }
            
            
            var entryPage: String = htmlHeaderString +
                buildFoodJournalHeader(profile, dateString: "June 4") +
                //breakfast
                tableOpeningTags +
                buildBreakfastHTML(breakfastLogEntry.time!, breakfastLogEntry: breakfastLogEntry) +
                tableClosingTags +
                spacerTags +
                
//                //morning snack - optional
//                morningSnackString +
//                
//                //lunch
//                tableOpeningTags +
//                buildLunchHTML(lunchLogEntry.time, lunchLogEntry: lunchLogEntry) +
//                tableClosingTags +
//                spacerTags +
//                
//                //afternoon snack
//                tableOpeningTags +
//                buildAfternoonSnackHTML("Afternoon Snack", date: afternoonSnackLogEntry.time, snackLogEntry: afternoonSnackLogEntry) +
//                tableClosingTags +
//                spacerTags +
//                
//                //dinner
//                tableOpeningTags +
//                buildDinnerHTML(dinnerLogEntry.time, dinnerLogEntry: dinnerLogEntry) +
//                tableClosingTags +
//                spacerTags +
//                
//                //evening snack
//                eveningSnackString +
                
                pageClosingTags
            
            return entryPage
            
    }
    func buildFoodJournalHeader(profile: OPProfile, dateString: String) ->String {
        var patientName: String = ""
        if let firstName = profile.firstName, lastName = profile.lastName {
            patientName = firstName + " " + lastName
        }
        
        var nameDateTableHeader =
        "<body><h2>\(patientName)<br/>\(dateString)</h2>"
        return nameDateTableHeader
    }

    
    public func buildBreakfastHTML(date: NSDate, breakfastLogEntry: OPBreakfast) -> String{
        
        var tableBody: String =
        buildTitleRow("Breakfast") +
            buildMealSummaryRow(breakfastLogEntry) +
            additionalInfoTableRow(date , place: breakfastLogEntry.location, parentInitials: breakfastLogEntry.parentInitials )// +
        //"<p></p>"
        
        return tableBody
    }
    public func buildLunchHTML(date: NSDate, lunchLogEntry: OPLunch) -> String{
        
        var tableBody: String = buildTitleRow("Lunch") + buildMealSummaryRow(lunchLogEntry) + additionalInfoTableRow(date , place: lunchLogEntry.location, parentInitials: lunchLogEntry.parentInitials ) //+
        
        return tableBody
    }
    public func buildMorningSnackHTML(snackName: String, date: NSDate, snackLogEntry: OPMorningSnack) -> String{
        
        var tableBody: String = buildTitleRow(snackName) +
            buildMealSummaryRow(snackLogEntry) +
            additionalInfoTableRow(date , place: snackLogEntry.location, parentInitials: snackLogEntry.parentInitials ) //+
        
        return tableBody
    }
    public func buildAfternoonSnackHTML(snackName: String, date: NSDate, snackLogEntry: OPAfternoonSnack) -> String{
        
        var tableBody: String = buildTitleRow(snackName) +
            buildMealSummaryRow(snackLogEntry) +
            additionalInfoTableRow(date , place: snackLogEntry.location, parentInitials: snackLogEntry.parentInitials ) //+
        
        return tableBody
    }
    public func buildEveningSnackHTML(snackName: String, date: NSDate, snackLogEntry: OPEveningSnack) -> String{
        
        var tableBody: String = buildTitleRow(snackName) +
            buildMealSummaryRow(snackLogEntry) +
            additionalInfoTableRow(date , place: snackLogEntry.location, parentInitials: snackLogEntry.parentInitials ) //+
        
        return tableBody
    }
    public func buildDinnerHTML(date: NSDate, dinnerLogEntry: OPDinner) -> String {
        
        var tableBody: String = buildTitleRow("Dinner") +
            buildMealSummaryRow(dinnerLogEntry) +
            additionalInfoTableRow(date , place: dinnerLogEntry.place, parentInitials: dinnerLogEntry.parentInitials ) //+
        //"<p>-</p>"
        
        return tableBody
    }
    
    public func buildTitleRow(title: String) -> String{
        return "<thead><tr><th colspan=\"3\">\(title)</th></tr></thead>"
    }
    public func buildMealSummaryRow(mealLogEntry: OPBreakfast) -> String {
        var summaryRow = "<tbody><tr><td colspan=\"3\">"
        
        summaryRow = summaryRow + buildListItem("Main Item", listItem: mealLogEntry.foodChoice)
        summaryRow = summaryRow + buildListItem("Fruit", listItem: mealLogEntry.fruitChoice)
        
        if mealLogEntry.addOnRequired.boolValue {
            summaryRow = summaryRow + buildListItem("Add On", listItem: mealLogEntry.addOnText)
        }
        
        if mealLogEntry.medicineRequired.boolValue {
            summaryRow = summaryRow + buildListItem("Medicine", listItem: mealLogEntry.medicineText)
        }
        
        let endingTags = "</td></tr>"
        
        return summaryRow + endingTags
        //"<tbody><tr><td colspan=\"3\"><li>French Toast</li><li>Banana</li><li><b>Add On:</b> Yogurt</li></td></tr>" +
    }
    
    public func buildMealSummaryRow(mealLogEntry: OPLunch) -> String {
        var summaryRow = "<tbody><tr><td colspan=\"3\">"
        
        summaryRow = summaryRow + buildListItem("Main Item", listItem: mealLogEntry.lunchChoice)
        summaryRow = summaryRow + buildListItem("Fruit", listItem: mealLogEntry.fruitChoice)
        
        if mealLogEntry.addOnRequired.boolValue {
            summaryRow = summaryRow + buildListItem("Add On", listItem: mealLogEntry.addOnText)
        }
        
        if mealLogEntry.medicineRquired.boolValue {
            summaryRow = summaryRow + buildListItem("Medicine", listItem: mealLogEntry.medicineText)
        }
        
        let endingTags = "</td></tr>"
        
        return summaryRow + endingTags
        //"<tbody><tr><td colspan=\"3\"><li>French Toast</li><li>Banana</li><li><b>Add On:</b> Yogurt</li></td></tr>" +
    }
    public func buildMealSummaryRow(mealLogEntry: OPMorningSnack) -> String{
        var summaryRow = "<tbody><tr><td colspan=\"3\">"
        
        summaryRow = summaryRow + buildListItem("Main Item", listItem: mealLogEntry.snackChoice)
        summaryRow = summaryRow + buildListItem("Fruit", listItem: mealLogEntry.fruitChoice)
        
        if mealLogEntry.addOnRequired.boolValue {
            summaryRow = summaryRow + buildListItem("Add On", listItem: mealLogEntry.addOnText)
        }
        
        if mealLogEntry.medicineRequired.boolValue {
            summaryRow = summaryRow + buildListItem("Medicine", listItem: mealLogEntry.medicineText)
        }
        
        let endingTags = "</td></tr>"
        
        return summaryRow + endingTags
        //"<tbody><tr><td colspan=\"3\"><li>French Toast</li><li>Banana</li><li><b>Add On:</b> Yogurt</li></td></tr>" +
    }
    public func buildMealSummaryRow(mealLogEntry: OPAfternoonSnack) -> String{
        var summaryRow = "<tbody><tr><td colspan=\"3\">"
        
        summaryRow = summaryRow + buildListItem("Main Item", listItem: mealLogEntry.snackChoice)
        summaryRow = summaryRow + buildListItem("Fruit", listItem: mealLogEntry.fruitChoice)
        
        if mealLogEntry.addOnRequired.boolValue {
            summaryRow = summaryRow + buildListItem("Add On", listItem: mealLogEntry.addOnText)
        }
        
        if mealLogEntry.medicineRequired.boolValue {
            summaryRow = summaryRow + buildListItem("Medicine", listItem: mealLogEntry.medicineText)
        }
        
        let endingTags = "</td></tr>"
        
        return summaryRow + endingTags
        //"<tbody><tr><td colspan=\"3\"><li>French Toast</li><li>Banana</li><li><b>Add On:</b> Yogurt</li></td></tr>" +
    }
    public func buildMealSummaryRow(mealLogEntry: OPEveningSnack) -> String{
        var summaryRow = "<tbody><tr><td colspan=\"3\">"
        
        summaryRow = summaryRow + buildListItem("Main Item", listItem: mealLogEntry.snackChoice)
        summaryRow = summaryRow + buildListItem("Fruit", listItem: mealLogEntry.fruitChoice)
        
        if mealLogEntry.addOnRequired.boolValue {
            summaryRow = summaryRow + buildListItem("Add On", listItem: mealLogEntry.addOnText)
        }
        
        if mealLogEntry.medicineRequired.boolValue {
            summaryRow = summaryRow + buildListItem("Medicine", listItem: mealLogEntry.medicineText)
        }
        
        let endingTags = "</td></tr>"
        
        return summaryRow + endingTags
        //"<tbody><tr><td colspan=\"3\"><li>French Toast</li><li>Banana</li><li><b>Add On:</b> Yogurt</li></td></tr>" +
    }
    public func buildMealSummaryRow(mealLogEntry: OPDinner) -> String{
        var summaryRow = "<tbody><tr><td colspan=\"3\">"
        
        summaryRow = summaryRow +
            buildListItem("First Choice", listItem: mealLogEntry.meat)
            + buildListItem("Second Choice", listItem: mealLogEntry.starch)
            + buildListItem("Third Choice", listItem: mealLogEntry.oil)
            + buildListItem("Vegetable", listItem: mealLogEntry.vegetable)
            //+ buildListItem("Vegetable", mealLogEntry.vegetable)
            + buildListItem("Reqired Items", listItem: "Milk, Salad")
        
        if mealLogEntry.addOnRequired.boolValue {
            summaryRow = summaryRow + buildListItem("Add On", listItem: mealLogEntry.addOnText)
        }
        
        if mealLogEntry.medicineRequired.boolValue {
            summaryRow = summaryRow + buildListItem("Medicine", listItem: mealLogEntry.medicineText)
        }
        
        let endingTags = "</td></tr>"
        
        return summaryRow + endingTags
        //"<tbody><tr><td colspan=\"3\"><li>French Toast</li><li>Banana</li><li><b>Add On:</b> Yogurt</li></td></tr>" +
    }
    
    public func buildListItem(caption: String, listItem: String?) -> String {
        var itemString = listItem ?? nilEntryNote()
        var listItemText = "<b>\(caption):  </b>"
        var foodItem = listItemText  + itemString
        return "<li>\(foodItem)</li>"
    }
    
    
    public func additionalInfoTableRow (date: NSDate, place: String?, parentInitials: String?) -> String{
        var dateFormatter = NSDateFormatter()
        dateFormatter.timeStyle = .ShortStyle
        var time = dateFormatter.stringFromDate(NSDate())
        var p = place ?? nilEntryNote()
        var t = time ?? nilEntryNote()
        var pi = parentInitials ?? nilEntryNote()
        
        return "<tr><th class=\"inline\">Place</th><th class=\"inline\">Time</th><th class=\"inline\">Parent<br/>Initials</th></tr>" +
        "<tr><td class=\"inline\">\(p)</td><td class=\"inline\">\(t)</td><td class=\"inline\">\(pi)</td></tr>"
    }

    //MARK: HTML Strings
    public var htmlHeaderString: String = "<!DOCTYPE html><html><head><title>Food Journal, Jim Klein, Today’s Date</title><style>" +
        //style section
        "#table-example-1 {" +
        "border: solid thin;" +
        "border-collapse: collapse;" +
        "font-family: Helvetica, Geneva, Arial, " +
        "SunSans-Regular, sans-serif;" +
        "width: 90%;" +
        "} " +
        "#table-example-1 caption {padding-bottom: 0.5em;} " +
        "#table-example-1 th, #table-example-1 td {border: solid thin; padding: 0.5rem 1rem; } " +
        "#table-example-1 td { } " +
        "#table-example-1 th {font-weight: bold; font-size: 85%; background: #DFDFDF;} " +
        "#table-example-1 td {border-style: none solid; vertical-align: top; font-size: 85%;} " +
        "#table-example-1 td.inline {border-style: none solid; vertical-align: top; text-align: center; font-size: 85%;} " +
        "#table-example-1 th {padding: 0.2em; vertical-align: middle; text-align: left; } " +
        "#table-example-1 th.inline {padding: 0.2em; vertical-align: middle; text-align: center; font-weight: bold;} " +
        "#table-example-1 tbody td:first-child::after { content: leader(\". \"); } " +
        "body {padding: 0.2rem;} " +
    "</style></head>"
    
    public  var tableOpeningTags = "<table id=\"table-example-1\">"
    
    public  var tableClosingTags = "</tbody></table>"
    
    public  var spacerTags = "<p></p>"
    
    public  var pageClosingTags = "</body></html>"

}