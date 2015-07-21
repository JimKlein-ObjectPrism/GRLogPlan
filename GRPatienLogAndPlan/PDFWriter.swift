import UIKit
import Foundation
import QuartzCore
import CoreText


class PDFWriter {
    // fileName : patient Name. Food Journal. dd/mm/yyyy
    func drawPDF (fileName: String, date: String, profile: OPProfile, logEntryPrintItem: LogEntryPrintOutItem) {
        // Create the PDF context using the default page size of 612 x 792.
        UIGraphicsBeginPDFContextToFile(fileName, CGRectZero, nil);
        
        // Mark the beginning of a new page.
        UIGraphicsBeginPDFPageWithInfo(CGRectMake(0, 0, 612, 792), nil)
        
        let header = HeaderInfo(profile: profile, date: date)
        header.nameAndDateTableDrawItems(72)
        
        drawHeader(header)
        var yPosition = 146
        for mTable in logEntryPrintItem.mealTableItems {
        
            let mealTable = MealTable(mealItem: mTable)
            
            if 648 < yPosition + mealTable.getTableHeight() {
                UIGraphicsBeginPDFPageWithInfo(CGRectMake(0, 0, 612, 792), nil)
                yPosition = 72
            }
        
            mealTable.buildMealTable(yPosition)
            drawTableAtY(mealTable, startYCoordinate: yPosition, printableAreaWidth: 468, leftMargin: 72)
            yPosition += mealTable.getTableHeight()
        }
        
        // Close the PDF context and write the contents out.
        UIGraphicsEndPDFContext()
    }
//    func drawPDF (fileName: String) {
//        // Create the PDF context using the default page size of 612 x 792.
//        UIGraphicsBeginPDFContextToFile(fileName, CGRectZero, nil);
//        
//        // Mark the beginning of a new page.
//        UIGraphicsBeginPDFPageWithInfo(CGRectMake(0, 0, 612, 792), nil);
//        
//        let profile = OPProfile()
//        profile.firstAndLastName = "Jane Smithe"
//        let journalEntry = OPJournalEntry()
//        journalEntry.date = "Tuesday, August 9, 2014"
//        
//        let header = HeaderInfo(profile: profile, date: journalEntry.date)
//        //header.nameAndDateTableDrawItems(72)
//        
//        drawHeader(header)
//        
//        let mealTable = MealTable()
//        
//        mealTable.buildMealTable(72)
//        drawTableAtY(mealTable, startYCoordinate: 146, printableAreaWidth: 468, leftMargin: 72)
//        drawTableAtY(mealTable, startYCoordinate: 336, printableAreaWidth: 468, leftMargin: 72)
//        
//        
//        // Close the PDF context and write the contents out.
//        UIGraphicsEndPDFContext()
//    }
    func drawTable(startYCoordinate: Int,
        printableAreaWidth: Int,
        leftMargin: Int ,
        table: MealTable
        ){
            //let table = MealTable()
            let drawItems = table.buildMealTable(startYCoordinate)
            for i in 0..<drawItems.textItems.count {
                drawText(drawItems.textItems[i].textToDraw, inFrame: drawItems.textItems[i].frameRect)
            }
            let tableItems = drawItems.tableLines
            for yValue in tableItems.horizontalLineIndices {
                drawLineAtY(yValue)
            }
            
            // Vertical lines
            let columnWidth = printableAreaWidth/3
            let topIndex = tableItems.horizontalLineIndices[0]
            let bottomIndex = tableItems.horizontalLineIndices[tableItems.horizontalLineIndices.count - 1 ]
            //left margin
            drawVerticalLineAtX(leftMargin, fromY: topIndex, toY: bottomIndex)
            //rightMargin
            drawVerticalLineAtX(leftMargin + printableAreaWidth, fromY: topIndex, toY: bottomIndex)
            // additional Items cell - left
            drawVerticalLineAtX(leftMargin + columnWidth, fromY: tableItems.verticalYStartIndex, toY: tableItems.verticalYEndIndex)
            // additional Items cell - right
            drawVerticalLineAtX(leftMargin + 2 * columnWidth, fromY: tableItems.verticalYStartIndex, toY: tableItems.verticalYEndIndex)
            
    }
    
    
    func drawHeader (header: HeaderInfo) {
        var currentYOnPage = 72
        
        //drawLineAtY(currentYOnPage)
        
        let patientName = header.patientName
        let patientNameFontSize = 26
        let patientNameYPadding = 10
        let patientNameTotalHeight = patientNameFontSize + patientNameYPadding
        
        let drawTextPatientName = drawableTextFromString(patientName)
        setTextBoldingAndFontSizeFullString(drawTextPatientName, originalString: patientName,  fontSize: patientNameFontSize )
        currentYOnPage += patientNameTotalHeight
        
        drawText(drawTextPatientName, inFrame: CGRectMake(72, CGFloat(currentYOnPage) , 500, 36))
        //drawLineAtY(currentYOnPage)
        
        
        let logEntryDateFontSize = 18
        let logEntryPadding = 8
        let logEntryTotalHeight =  logEntryDateFontSize + logEntryPadding
        let logEntryDate = "Food Journal: " + header.date
        let drawTextJournalEntryDate = drawableTextFromString(logEntryDate)
        setTextBoldingAndFontSizeFullString(drawTextJournalEntryDate, originalString: logEntryDate,  fontSize: logEntryDateFontSize )
        
        currentYOnPage += logEntryTotalHeight
        drawText(drawTextJournalEntryDate, inFrame: CGRectMake(72, CGFloat(currentYOnPage),  500, CGFloat(logEntryTotalHeight)))
    }
    
    func drawTableAtY(table: MealTable, startYCoordinate: Int,
        printableAreaWidth: Int,
        leftMargin: Int
        ){
            //let table = MealTable()
            let drawItems = table.buildMealTable(startYCoordinate)
            for i in 0..<drawItems.textItems.count {
                drawText(drawItems.textItems[i].textToDraw, inFrame: drawItems.textItems[i].frameRect)
            }
            let tableItems = drawItems.tableLines
            for yValue in tableItems.horizontalLineIndices {
                drawLineAtY(yValue)
            }
            
            // Vertical lines
            let columnWidth = printableAreaWidth/3
            let topIndex = tableItems.horizontalLineIndices[0]
            let bottomIndex = tableItems.horizontalLineIndices[tableItems.horizontalLineIndices.count - 1 ]
            //left margin
            drawVerticalLineAtX(leftMargin, fromY: topIndex, toY: bottomIndex)
            //rightMargin
            drawVerticalLineAtX(leftMargin + printableAreaWidth, fromY: topIndex,  toY:  bottomIndex)
            // additional Items cell - left
            drawVerticalLineAtX(leftMargin + columnWidth, fromY: tableItems.verticalYStartIndex, toY: tableItems.verticalYEndIndex)
            // additional Items cell - right
            drawVerticalLineAtX(leftMargin + 2 * columnWidth, fromY: tableItems.verticalYStartIndex, toY: tableItems.verticalYEndIndex)
            
    }
    func drawTableLines ( yCoordinateOfUpperLeftCorner: Int, leftMargin: Int, printableAreaWidth: Int, table: MealTable)
    {
        // horizontal lines
        var horizontalLines = [Int]()
        let immutableRowHeight = table.immutableRowHeight
        
        let topLineY = yCoordinateOfUpperLeftCorner
        drawLineAtY(topLineY)
        
        let bottomLineTableTitleCell = topLineY + immutableRowHeight
        drawLineAtY(bottomLineTableTitleCell)
        print(table.logEntriesHeight)
        let bottomLineLogEntryCell = bottomLineTableTitleCell + 14 + table.logEntriesHeight
        drawLineAtY(bottomLineLogEntryCell)
        
        let bottomLineAdditionalInfoTitleCells = bottomLineLogEntryCell + immutableRowHeight
        drawLineAtY(bottomLineAdditionalInfoTitleCells)
        
        let bottomLineAdditionalInfoDataCells = bottomLineAdditionalInfoTitleCells + immutableRowHeight
        drawLineAtY(bottomLineAdditionalInfoDataCells)
        
        if table.note != nil {
            let bottomLineNoteTitleCell = bottomLineAdditionalInfoDataCells + immutableRowHeight
            drawHorizonalLineAtY(bottomLineNoteTitleCell, leftMargin: leftMargin, printableAreaWidth: printableAreaWidth)
            
            let bottomLineOfNoteDataCell = bottomLineNoteTitleCell + immutableRowHeight
            drawHorizonalLineAtY(bottomLineOfNoteDataCell, leftMargin: leftMargin, printableAreaWidth: printableAreaWidth)
        }
        
    }
    func drawText(textToDraw: CFMutableAttributedStringRef, inFrame frameRect: CGRect) {
        
        
        let frameSetter = CTFramesetterCreateWithAttributedString(textToDraw)
        
        //let frameRect = CGRectMake(0, 0, 300, 50)
        let framePath = CGPathCreateMutable()
        
        CGPathAddRect(framePath, nil, frameRect)
        
        
        // Get the frame that will do the rendering.
        let currentRange = CFRangeMake(0, 0);
        let frameRef = CTFramesetterCreateFrame(frameSetter, currentRange, framePath, nil);
        
        // Get the graphics context.
        let currentContext = UIGraphicsGetCurrentContext()
        
        // Put the text matrix into a known state. This ensures
        // that no old scaling factors are left in place.
        CGContextSetTextMatrix(currentContext, CGAffineTransformIdentity);
        
        
        
        // Core Text draws from the bottom-left corner up, so flip
        // the current transform prior to drawing.
        CGContextTranslateCTM(currentContext, 0, frameRect.origin.y*2)
        CGContextScaleCTM(currentContext, 1.0, -1.0)
        
        //    CGContextSetFillColorWithColor(currentContext, UIColor.yellowColor().CGColor)
        
        // Draw the frame.
        CTFrameDraw(frameRef, currentContext)
        
        // these two lines to reverse the earlier transformation.
        CGContextScaleCTM(currentContext, 1.0, -1.0);
        CGContextTranslateCTM(currentContext, 0, (-1)*frameRect.origin.y*2);
        //        UIGraphicsEndPDFContext()
        
        
        
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
        
        let stringLength = count(originalString)
        let fontBold = CTFontCreateWithName("Helvetica-Bold", size, nil)
        CFAttributedStringSetAttribute(text , CFRangeMake(0, stringLength ), kCTFontAttributeName, fontBold)
    }
    
    func drawLineFromPoint(from: CGPoint, to: CGPoint) {
        let context = UIGraphicsGetCurrentContext()
        
        CGContextSetLineWidth(context, 2.0)
        
        let color = UIColor.blackColor().CGColor//CGColorCreate(colorspace, components)
        
        CGContextSetStrokeColorWithColor(context, color)
        
        CGContextMoveToPoint(context, from.x, from.y);
        CGContextAddLineToPoint(context, to.x, to.y);
        
        CGContextStrokePath(context);
        
    }
    
    func drawLineAtY (ycoord: Int) {
        let from = CGPointMake(72, CGFloat(ycoord))
        let to = CGPointMake(540, CGFloat(ycoord))
        drawLineFromPoint(from, to: to)
    }
    func drawVerticalLineAtX ( xCoordinate: Int, fromY: Int, toY: Int) {
        let from = CGPointMake(CGFloat(xCoordinate), CGFloat(fromY))
        let to = CGPointMake(CGFloat(xCoordinate), CGFloat(toY))
        drawLineFromPoint(from, to: to)
    }
    func drawHorizonalLineAtY( yCoordinate: Int, leftMargin: Int, printableAreaWidth: Int){
        let from = CGPointMake(CGFloat(leftMargin), CGFloat(yCoordinate))
        let to = CGPointMake(CGFloat(leftMargin + printableAreaWidth), CGFloat(yCoordinate))
        drawLineFromPoint(from, to: to)
    }
    
    func getPDFFileName() -> String {
        var fileName = "Invoice.pdf"
        if let arrayPaths: [String] = NSSearchPathForDirectoriesInDomains(NSSearchPathDirectory.DocumentDirectory, NSSearchPathDomainMask.UserDomainMask, true) as? [String] {
            
            let path = arrayPaths[0]
            
            let pdfFileName: String = path.stringByAppendingPathComponent(fileName)
            
            fileName = pdfFileName
            
        }
        
        return fileName
    }

}
