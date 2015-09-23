import Foundation
import UIKit
import Foundation
import QuartzCore
import CoreText

public struct HeaderInfo {
    let patientName: String
    let date: String
    var initialYOnPage: Int = 72
    
    init(profile: OPProfile, date: String){
        patientName = profile.firstAndLastName
        self.date = date
    }
    
    
    public func nameAndDateTableDrawItems(currentYOnPage: Int) -> [TextDrawingItem] {
        var drawItems = [TextDrawingItem]()
        
        var currentYOnPage = initialYOnPage
        
        //drawLineAtY(currentYOnPage)
        
        //let patientName = "Jane Sample"
        let patientNameFontSize = 26
        let patientNameYPadding = 10
        let patientNameTotalHeight = patientNameFontSize + patientNameYPadding
        
        let drawTextPatientName = drawableTextFromString(patientName)
        setTextBoldingAndFontSizeFullString(drawTextPatientName, originalString: patientName,  fontSize: patientNameFontSize )
        currentYOnPage += patientNameTotalHeight
        
        let nameFrame = CGRectMake(72, CGFloat(currentYOnPage) , 468, CGFloat(patientNameTotalHeight))
        
        drawItems.append(TextDrawingItem(textToDraw: drawTextPatientName, frameRect: nameFrame))
        
        
        let logEntryDateFontSize = 18
        let logEntryPadding = 8
        let logEntryDateTotalHeight =  logEntryDateFontSize + logEntryPadding
        let logEntryDate = date
        let drawTextJournalEntryDate = drawableTextFromString(logEntryDate)
        setTextBoldingAndFontSizeFullString(drawTextJournalEntryDate, originalString: logEntryDate,  fontSize: logEntryDateFontSize )
        
        currentYOnPage += logEntryDateTotalHeight
        //drawText(drawTextJournalEntryDate, inFrame: CGRectMake(72, CGFloat(currentYOnPage),  468, CGFloat(logEntryDateTotalHeight)))
        let dateFrame = CGRectMake(72, CGFloat(currentYOnPage),  468, CGFloat(logEntryDateTotalHeight))
        
        drawItems.append(TextDrawingItem(textToDraw: drawTextJournalEntryDate, frameRect: dateFrame))
        
        return drawItems
    }
    
    func drawableTextFromString(textToDraw: String) -> CFMutableAttributedStringRef {
        let stringRef = textToDraw as CFStringRef
        
        // Prepare the text using a Core Text Framesetter.
        let currentText: CFAttributedStringRef =  CFAttributedStringCreate(nil , stringRef, nil)
        let mutableAttriburedStringRef: CFMutableAttributedStringRef = CFAttributedStringCreateMutableCopy(nil , 0, currentText)
        
        return mutableAttriburedStringRef
    }
    
    func setTextBoldingAndFontSizeFullString(text:  CFMutableAttributedStringRef, originalString: String, fontSize: Int){
        let size: CGFloat = CGFloat(fontSize)
        
        let stringLength = originalString.characters.count
        let fontBold = CTFontCreateWithName("Helvetica-Bold", size, nil)
        CFAttributedStringSetAttribute(text , CFRangeMake(0, stringLength ), kCTFontAttributeName, fontBold)
    }
    
}
