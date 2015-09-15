
//
//  swift
//  GRPatienLogAndPlan
//
//  Created by James Klein on 6/4/15.
//  Copyright (c) 2015 ObjectPrism Corp. All rights reserved.
//

import Foundation

public typealias LogEntryPrintOutItem = (htmlString: String, mealTableItems: [MealTableInfoItem])

public class PrintSevice {
    
    var dataStore: DataStore
    
    
    
    init(){
        let appDelegate = UIApplication.sharedApplication().delegate as? AppDelegate
        dataStore = appDelegate!.dataStore
        //let journalEntry = dataStore.getJournalEntry(journalEntryDateString)
    }
    func printLogEntryPDF(journalEntryDateString: String) {
        
        getLogEntryToPrint(journalEntryDateString)
    
    }
    
    func emailLogEntryPDF(journalEntryDateString: String) {
        
    }
    
    func getLogEntryToPrint(journalEntryDateString: String) -> LogEntryPrintOutItem {
        var result = dataStore.getJournalEntry(journalEntryDateString)

        switch result {
        case let JournalEntryResult.Success(entry):
                let patientRecord = dataStore.currentRecord
                let profile = patientRecord.profile
            let printOut = buildLogEntryPrintOut(journalEntryDateString, profile: profile,  breakfastLogEntry: entry.breakfast, morningSnackLogEntry: entry.morningSnack, lunchLogEntry: entry.lunch, afternoonSnackLogEntry: entry.afternoonSnack, dinnerLogEntry: entry.dinner, eveningSnackLogEntry: entry.eveningSnack)
                
                let htmlString = printOut.htmlString
                return (htmlString, printOut.mealTableItems)
        case .EntryDoesNotExist:
            println("no journal entry found")
            
        case let .Error(error):
            println("CoreData Error: \(error)")
        }

        return ("", [MealTableInfoItem]())
    }
    
    func nilEntryNote () -> String {
        return "None Selected"
    }
    public func buildLogEntryPrintOut(date: String,
        profile: OPProfile,
        breakfastLogEntry: OPBreakfast,
        morningSnackLogEntry: OPMorningSnack?,
        lunchLogEntry: OPLunch,
        afternoonSnackLogEntry: OPAfternoonSnack,
        dinnerLogEntry: OPDinner,
        eveningSnackLogEntry: OPEveningSnack?
        ) -> LogEntryPrintOutItem {
            
            var morningSnackString = ""
            var mealTableItems = [MealTableInfoItem]()
            var eveningSnackString = ""
            
            var breakfastPrintItems = buildBreakfastHTML(breakfastLogEntry.time, breakfastLogEntry: breakfastLogEntry)
            mealTableItems.append(breakfastPrintItems.pdfInfoItem)
            
            
            if profile.morningSnackRequired.boolValue {
                if let snack = morningSnackLogEntry {
                var morningSnack = buildMorningSnackHTML("Morning Snack", time: snack.time, snackLogEntry: snack)
                morningSnackString =   tableOpeningTags +
                    morningSnack.htmlTableString +
                    tableClosingTags + spacerTags
                mealTableItems.append(morningSnack.pdfInfoItem)
                }
            }
            
            var lunchPrintItems = buildLunchHTML(lunchLogEntry.time, lunchLogEntry: lunchLogEntry)
            mealTableItems.append(lunchPrintItems.pdfInfoItem)
            var afternoonSnackItems = buildAfternoonSnackHTML("Afternoon Snack", time: afternoonSnackLogEntry.time, snackLogEntry: afternoonSnackLogEntry)
            mealTableItems.append(afternoonSnackItems.pdfInfoItem)
            var dinnerPrintItems = buildDinnerHTML(dinnerLogEntry.time, dinnerLogEntry: dinnerLogEntry)
            mealTableItems.append(dinnerPrintItems.pdfInfoItem)
            
            if profile.eveningSnackRequired.boolValue {
                if let snack = eveningSnackLogEntry {
                    var eveningSnack = buildEveningSnackHTML("Evening Snack", time: snack.time, snackLogEntry: snack)
                    eveningSnackString =   tableOpeningTags +
                        eveningSnack.htmlTableString +
                        tableClosingTags + spacerTags
                    mealTableItems.append(eveningSnack.pdfInfoItem)
                }
            }
            
            var entryPage: String = htmlHeaderString +
                buildFoodJournalHeader(profile, dateString: date) +
                tableOpeningTags +
                breakfastPrintItems.htmlTableString + //buildBreakfastHTML(breakfastLogEntry.time, breakfastLogEntry: breakfastLogEntry) +
                tableClosingTags +
                spacerTags +
                
                //morning snack - optional
                morningSnackString +
                
                //lunch
                tableOpeningTags +
                lunchPrintItems.htmlTableString +
                tableClosingTags +
                spacerTags +
                
                //afternoon snack
                tableOpeningTags +
                afternoonSnackItems.htmlTableString +
                tableClosingTags +
                spacerTags +
                
                //dinner
                tableOpeningTags +
                dinnerPrintItems.htmlTableString +
                tableClosingTags +
                spacerTags +
                
                //evening snack
                eveningSnackString +
                
                pageClosingTags
            
            return (entryPage, mealTableItems)
            
    }
    func buildFoodJournalHeader(profile: OPProfile, dateString: String) ->String {
        var patientName: String = ""
        if let firstName = profile.firstAndLastName {
            patientName = firstName
        }
        
        var nameDateTableHeader =
        "<body><h3>\(patientName)<br/>\(dateString)</h3>"
        return nameDateTableHeader
    }

    public typealias MealTableItem = (htmlTableString: String, pdfInfoItem: MealTableInfoItem)
    public func buildBreakfastHTML(time: String?, breakfastLogEntry: OPBreakfast) -> MealTableItem{
        
        var summaryRow = buildMealSummaryRow(breakfastLogEntry)

        var tableBody: String =
        buildTitleRow("Breakfast") +
            summaryRow.htmlString +
            additionalInfoTableRow(time , place: breakfastLogEntry.location, parentInitials: breakfastLogEntry.parentInitials ) +
            buildNoteRows(breakfastLogEntry.note)
        
        let pdfTableInfo = MealTableInfoItem(mealName: "Breakfast", logItems: summaryRow.pdfStrings, place: breakfastLogEntry.location, time: time, parent: breakfastLogEntry.parentInitials, note: breakfastLogEntry.note)
        return (tableBody, pdfTableInfo)
    }
    public func buildLunchHTML(time: String?, lunchLogEntry: OPLunch) -> MealTableItem{
        var summaryRow = buildMealSummaryRow(lunchLogEntry)

        var tableBody: String = buildTitleRow("Lunch") +
            summaryRow.htmlString +
            additionalInfoTableRow(time , place: lunchLogEntry.location, parentInitials: lunchLogEntry.parentInitials ) +
            buildNoteRows(lunchLogEntry.note)
        
        let pdfTableInfo = MealTableInfoItem(mealName: "Lunch", logItems: summaryRow.pdfStrings, place: lunchLogEntry.location, time: time, parent: lunchLogEntry.parentInitials, note: lunchLogEntry.note)
        return (tableBody, pdfTableInfo)
    }
    public func buildMorningSnackHTML(snackName: String, time: String?, snackLogEntry: OPMorningSnack) -> MealTableItem
{
        var summaryRow = buildMealSummaryRow(snackLogEntry)
        
        var tableBody: String = buildTitleRow(snackName) +
            summaryRow.htmlString + //buildMealSummaryRow(snackLogEntry) +
            additionalInfoTableRow(time , place: snackLogEntry.location, parentInitials: snackLogEntry.parentInitials ) +
            buildNoteRows(snackLogEntry.note)
        
        let pdfTableInfo = MealTableInfoItem(mealName: "Morning Snack", logItems: summaryRow.pdfStrings, place: snackLogEntry.location, time: time, parent: snackLogEntry.parentInitials, note: snackLogEntry.note)
        return (tableBody, pdfTableInfo)

    }
    public func buildAfternoonSnackHTML(snackName: String, time: String?, snackLogEntry: OPAfternoonSnack) -> MealTableItem{
        var summaryRow = buildMealSummaryRow(snackLogEntry)

        var tableBody: String = buildTitleRow(snackName) +
            summaryRow.htmlString +  //buildMealSummaryRow(snackLogEntry) +
            additionalInfoTableRow(time , place: snackLogEntry.location, parentInitials: snackLogEntry.parentInitials ) +
            buildNoteRows(snackLogEntry.note)
        let pdfTableInfo = MealTableInfoItem(mealName: "Afternoon Snack", logItems: summaryRow.pdfStrings, place: snackLogEntry.location, time: time, parent: snackLogEntry.parentInitials, note: snackLogEntry.note)
        return (tableBody, pdfTableInfo)
    }
    public func buildEveningSnackHTML(snackName: String, time: String?, snackLogEntry: OPEveningSnack) -> MealTableItem{
        var summaryRow = buildMealSummaryRow(snackLogEntry)
        
        var tableBody: String = buildTitleRow(snackName) +
            summaryRow.htmlString +  //buildMealSummaryRow(snackLogEntry) +
            additionalInfoTableRow(time , place: snackLogEntry.location, parentInitials: snackLogEntry.parentInitials ) +
            buildNoteRows(snackLogEntry.note)
        let pdfTableInfo = MealTableInfoItem(mealName: "Evening Snack", logItems: summaryRow.pdfStrings, place: snackLogEntry.location, time: time, parent: snackLogEntry.parentInitials, note: snackLogEntry.note)
        return (tableBody, pdfTableInfo)

    }
    public func buildDinnerHTML(time: String?, dinnerLogEntry: OPDinner) -> MealTableItem {
        var summaryRow = buildMealSummaryRow(dinnerLogEntry)
    
        var tableBody: String = buildTitleRow("Dinner") +
            summaryRow.htmlString + //buildMealSummaryRow(dinnerLogEntry) +
            additionalInfoTableRow(time , place: dinnerLogEntry.place, parentInitials: dinnerLogEntry.parentInitials ) +
            buildNoteRows(dinnerLogEntry.note)
        
        let pdfTableInfo = MealTableInfoItem(mealName: "Dinner", logItems: summaryRow.pdfStrings, place: dinnerLogEntry.place, time: time, parent: dinnerLogEntry.parentInitials, note: dinnerLogEntry.note)
        return (tableBody, pdfTableInfo)
    }
    
    public func buildTitleRow(title: String) -> String{
        return "<thead><tr><th colspan=\"3\">\(title)</th></tr></thead>"
    }
    public typealias SummaryRowItem = (htmlString: String, pdfStrings: [String])
    public func buildMealSummaryRow(mealLogEntry: OPBreakfast) -> SummaryRowItem  {
        var summaryRow = "<tbody><tr><td colspan=\"3\">"
        
        var pdfText = [String]()
        
        let mainItem = buildListItem_FoodItem("Main Item", listItem: mealLogEntry.foodChoice)
        summaryRow = summaryRow + mainItem.htmlString
        pdfText.append(mainItem.textForPDF)
        
        let fruitItem = buildListItem_FoodItem("Fruit", listItem: mealLogEntry.fruitChoice)
        summaryRow = summaryRow + fruitItem.htmlString
        pdfText.append(fruitItem.textForPDF)
        
        var entries = buildMedicineAndAddOnPrintText(mealLogEntry.medicineRequired.boolValue, medicine: mealLogEntry.medicineText, addOnRequired: mealLogEntry.addOnRequired.boolValue, addOn: mealLogEntry.addOnText)
        
        for htmlString in entries.htmlText {
            summaryRow += htmlString
        }
        
        pdfText += entries.pdfText
        
        let endingTags = "</td></tr>"
        let htmlString = summaryRow + endingTags
        return (htmlString, pdfText)
        //"<tbody><tr><td colspan=\"3\"><li>French Toast</li><li>Banana</li><li><b>Add On:</b> Yogurt</li></td></tr>" +
    }
    public func buildNoteRows(noteText: String?) -> String {
        if let text = noteText {
            return "<tr><th colspan=\"3\" class=\"inline\">Note</th></tr>" +
            "<tr><td colspan=\"3\" class=\"inline\">\(text)</td></tr>"

        }
        return ""

    }

    public func buildMealSummaryRow(mealLogEntry: OPLunch) -> SummaryRowItem {
        var summaryRow = "<tbody><tr><td colspan=\"3\">"
//        var pdfText = [String]()
        
//        summaryRow = summaryRow + buildListItem_FoodItem("Sandwich Item", listItem: mealLogEntry.lunchChoice)
//        summaryRow = summaryRow + buildListItem("Fruit", listItem: mealLogEntry.fruitChoice)
        
        var pdfText = [String]()
        
        let mainItem = buildListItem_FoodItem("Sandwich Item", listItem: mealLogEntry.lunchChoice)
        summaryRow = summaryRow + mainItem.htmlString
        pdfText.append(mainItem.textForPDF)
        
        let fruitItem = buildListItem_FoodItem("Fruit", listItem: mealLogEntry.fruitChoice)
        summaryRow = summaryRow + fruitItem.htmlString
        pdfText.append(fruitItem.textForPDF)
        
        var entries = buildMedicineAndAddOnPrintText(mealLogEntry.medicineRquired.boolValue, medicine: mealLogEntry.medicineText, addOnRequired: mealLogEntry.addOnRequired.boolValue, addOn: mealLogEntry.addOnText)
        
        for htmlString in entries.htmlText {
            summaryRow += htmlString
        }
        
        pdfText += entries.pdfText
        
        let endingTags = "</td></tr>"
        let htmlString = summaryRow + endingTags
        return (htmlString, pdfText)

        
//        
//        if mealLogEntry.addOnRequired.boolValue {
//            summaryRow = summaryRow + buildListItem("Add On", listItem: mealLogEntry.addOnText)
//        }
//        
//        if mealLogEntry.medicineRquired.boolValue {
//            summaryRow = summaryRow + buildListItem("Medicine", listItem: mealLogEntry.medicineText)
//        }
//        
//        let endingTags = "</td></tr>"
//        
//        return summaryRow + endingTags
//        //"<tbody><tr><td colspan=\"3\"><li>French Toast</li><li>Banana</li><li><b>Add On:</b> Yogurt</li></td></tr>" +
    }
    
    func buildMedicineAndAddOnPrintText (medicineRequired: Bool, medicine: String?, addOnRequired: Bool, addOn: String?) -> (htmlText: [String], pdfText: [String] )
    {
        var htmlItems = [String]()
        var pdfItems = [String]()
        
        if medicineRequired {
                let meds = buildListItem("Medicine", listItem: medicine)
                htmlItems.append(meds.htmlString)
                pdfItems.append(meds.textForPDF)
        }
        if addOnRequired {
                let add = buildListItem("Add On", listItem: addOn )
                htmlItems.append(add.htmlString)
                pdfItems.append(add.textForPDF)

        }
        return (htmlItems, pdfItems)
    }
    
    public func buildMealSummaryRow(mealLogEntry: OPMorningSnack) -> SummaryRowItem{
        var summaryRow = "<tbody><tr><td colspan=\"3\">"

        var pdfText = [String]()
        
        let mainItem = buildListItem_FoodItem("Main Item", listItem: mealLogEntry.snackChoice)
        summaryRow = summaryRow + mainItem.htmlString
        pdfText.append(mainItem.textForPDF)
        
        
        var entries = buildMedicineAndAddOnPrintText(mealLogEntry.medicineRequired.boolValue, medicine: mealLogEntry.medicineText, addOnRequired: mealLogEntry.addOnRequired.boolValue, addOn: mealLogEntry.addOnText)
        
        for htmlString in entries.htmlText {
            summaryRow += htmlString
        }
        
        pdfText += entries.pdfText
        
        let endingTags = "</td></tr>"
        let htmlString = summaryRow + endingTags
        return (htmlString, pdfText)

          //"<tbody><tr><td colspan=\"3\"><li>French Toast</li><li>Banana</li><li><b>Add On:</b> Yogurt</li></td></tr>" +
    }
    public func buildMealSummaryRow(mealLogEntry: OPAfternoonSnack) -> SummaryRowItem {
        var summaryRow = "<tbody><tr><td colspan=\"3\">"
        var pdfText = [String]()
        
        let mainItem = buildListItem_FoodItem("Main Item", listItem: mealLogEntry.snackChoice)
        summaryRow = summaryRow + mainItem.htmlString
        pdfText.append(mainItem.textForPDF)
        
        
        var entries = buildMedicineAndAddOnPrintText(mealLogEntry.medicineRequired.boolValue, medicine: mealLogEntry.medicineText, addOnRequired: mealLogEntry.addOnRequired.boolValue, addOn: mealLogEntry.addOnText)
        
        for htmlString in entries.htmlText {
            summaryRow += htmlString
        }
        
        pdfText += entries.pdfText
        
        let endingTags = "</td></tr>"
        let htmlString = summaryRow + endingTags
        return (htmlString, pdfText)
        //"<tbody><tr><td colspan=\"3\"><li>French Toast</li><li>Banana</li><li><b>Add On:</b> Yogurt</li></td></tr>" +
    }
    public func buildMealSummaryRow(mealLogEntry: OPEveningSnack) -> SummaryRowItem{
        var summaryRow = "<tbody><tr><td colspan=\"3\">"
        
        var pdfText = [String]()
        
        let mainItem = buildListItem_FoodItem("Main Item", listItem: mealLogEntry.snackChoice)
        summaryRow = summaryRow + mainItem.htmlString
        pdfText.append(mainItem.textForPDF)
        
        
        var entries = buildMedicineAndAddOnPrintText(mealLogEntry.medicineRequired.boolValue, medicine: mealLogEntry.medicineText, addOnRequired: mealLogEntry.addOnRequired.boolValue, addOn: mealLogEntry.addOnText)
        
        for htmlString in entries.htmlText {
            summaryRow += htmlString
        }
        
        pdfText += entries.pdfText
        
        let endingTags = "</td></tr>"
        let htmlString = summaryRow + endingTags
        return (htmlString, pdfText)
        //"<tbody><tr><td colspan=\"3\"><li>French Toast</li><li>Banana</li><li><b>Add On:</b> Yogurt</li></td></tr>" +
    }
    public func buildMealSummaryRow(mealLogEntry: OPDinner) -> SummaryRowItem{
        var summaryRow = "<tbody><tr><td colspan=\"3\">"
        var pdfText = [String]()
        
        let mainItem = buildListItem_FoodItem("First Choice", listItem: mealLogEntry.meat)
        summaryRow = summaryRow + mainItem.htmlString
        pdfText.append(mainItem.textForPDF)
        
        let fruitItem = buildListItem_FoodItem("Second Choice", listItem: mealLogEntry.starch)
        summaryRow = summaryRow + fruitItem.htmlString
        pdfText.append(fruitItem.textForPDF)
        
        let oilItem = buildListItem_FoodItem("Third Choice", listItem: mealLogEntry.oil)
        summaryRow += oilItem.htmlString
        pdfText.append(oilItem.textForPDF)
        
        let vegItem = buildListItem_FoodItem("Vegetable", listItem: mealLogEntry.vegetable)
        summaryRow += vegItem.htmlString
        pdfText.append(vegItem.textForPDF)

        let requiredItem = buildListItem("Reqired Items", listItem: "1 c Milk, 1 c Salad")
        summaryRow += requiredItem.htmlString
        pdfText.append(requiredItem.textForPDF)
        
        
//        summaryRow = summaryRow +
//            buildListItem_FoodItem("First Choice", listItem: mealLogEntry.meat)
//            + buildListItem_FoodItem("Second Choice", listItem: mealLogEntry.starch)
//            
//            + buildListItem("Third Choice", listItem: mealLogEntry.oil)
//            + buildListItem("Vegetable", listItem: mealLogEntry.vegetable)
//           
//            + buildListItem("Reqired Items", listItem: "Milk, Salad")
        
        
        var entries = buildMedicineAndAddOnPrintText(mealLogEntry.medicineRequired.boolValue, medicine: mealLogEntry.medicineText, addOnRequired: mealLogEntry.addOnRequired.boolValue, addOn: mealLogEntry.addOnText)
        
        for htmlString in entries.htmlText {
            summaryRow += htmlString
        }
        
        pdfText += entries.pdfText
        
        let endingTags = "</td></tr>"
        let htmlString = summaryRow + endingTags
        return (htmlString, pdfText)

        //"<tbody><tr><td colspan=\"3\"><li>French Toast</li><li>Banana</li><li><b>Add On:</b> Yogurt</li></td></tr>" +
    }
    public typealias MealSummaryItem = (htmlString: String, textForPDF: String)
    public func buildListItem_FoodItem(caption: String, listItem: String?) -> MealSummaryItem {
        var foodItem = ""
        var pdfText = caption + ":  "
        let listItemCaption = "<b>\(caption):  </b>"
        if let stringToPrint = listItem {
        var itemString = dataStore.getPrintableFoodItemReference(stringToPrint)
        foodItem = listItemCaption  + itemString
            pdfText +=  itemString
            
        } else {
            foodItem = listItemCaption + nilEntryNote()
            pdfText += nilEntryNote()
        }
        
        
        return ("<li>\(foodItem)</li>" , pdfText)
    }
    public func buildListItem(caption: String, listItem: String?) -> MealSummaryItem {
        var foodItem = ""
        var pdfText = caption + ":  "
        let listItemCaption = "<b>\(caption):  </b>"
        if let stringToPrint = listItem {
            //var itemString = dataStore.getPrintableFoodItemReference(stringToPrint)
            foodItem = listItemCaption  + stringToPrint
            pdfText += stringToPrint
        } else {
            foodItem = listItemCaption + nilEntryNote()
            pdfText += nilEntryNote()
        }
        
        return ("<li>\(foodItem)</li>", pdfText)
    }
    
    public func additionalInfoTableRow (time: String?, place: String?, parentInitials: String?) -> String{
//        var dateFormatter = NSDateFormatter()
//        dateFormatter.timeStyle = .ShortStyle
//        var time = dateFormatter.stringFromDate(NSDate())
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
        "h3 {padding: 0.2rem; font-family: Helvetica, Geneva, Arial, SunSans-Regular, sans-serif;}" +
        "h4 {padding: 0.2rem; font-family: Helvetica, Geneva, Arial, SunSans-Regular, sans-serif;}" +
    "</style></head>"
    
    public  var tableOpeningTags = "<table id=\"table-example-1\">"
    
    public  var tableClosingTags = "</tbody></table>"
    
    public  var spacerTags = "<p></p>"
    
    public  var pageClosingTags = "</body></html>"

}