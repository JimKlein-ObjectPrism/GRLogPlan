//
//  PDFViewController.swift
//  PDFGenRefactor
//
//  Created by James Klein on 7/19/15.
//  Copyright (c) 2015 James Klein. All rights reserved.
//

import UIKit

class PDFViewController: UIViewController {

    var filePath: String!
    
    override func viewDidLoad() {
        super.viewDidLoad()

        view.backgroundColor = .whiteColor()
        
        view.backgroundColor = UIColor.yellowColor()
        
        var webView = UIWebView(frame: CGRectMake(25, 50, view.bounds.width - 50, view.bounds.height - 50))
        webView.backgroundColor = UIColor.orangeColor()
        let writer = PDFWriter()
        //let pdfFileName = writer.getPDFFileName()
//        writer.drawPDF(filePath)
        
        var url = NSURL(fileURLWithPath: filePath)
        
        var request = NSURLRequest(URL: url!)
        
        webView.scalesPageToFit = true
        webView.loadRequest(request)
        view.addSubview(webView)
        
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    

    /*
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepareForSegue(segue: UIStoryboardSegue, sender: AnyObject?) {
        // Get the new view controller using segue.destinationViewController.
        // Pass the selected object to the new view controller.
    }
    */

}
