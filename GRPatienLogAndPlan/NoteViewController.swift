//
//  NoteViewController.swift
//  GRPatienLogAndPlan
//
//  Created by James Klein on 7/6/15.
//  Copyright (c) 2015 ObjectPrism Corp. All rights reserved.
//

import UIKit

class NoteViewController: UIViewController, UITextViewDelegate {

    var vm : MealViewModelDelegate!
    
    var noteDelegate: NoteChangedDelegate!
    
    

    @IBOutlet weak var textView: UITextView!
    
    var kbHeight: CGFloat!
    var keyboardShowing = false

    override func viewDidLoad() {
        super.viewDidLoad()

        self.automaticallyAdjustsScrollViewInsets = false
        
        textView.text = noteDelegate.noteText ?? ""
        
        textView.delegate = self
        
        NSNotificationCenter.defaultCenter().addObserver(self, selector: "keyboardShow:", name: UIKeyboardWillShowNotification, object: nil)
        
        self.navigationController?.navigationBar.barTintColor = UIColor(red: 150.0/255.0, green: 185.0/255.0, blue: 118.0/255.0, alpha: 1.0)
        
//        var sb = UIBarButtonItem(title: "Done", style: UIBarButtonItemStyle.Plain, target: self, action: "doneButtonTapped:")
//        self.navigationItem.rightBarButtonItem = sb
        
        //MARK: back button
        var b = UIBarButtonItem(title: "< Back", style: .Plain, target: self, action:"backButtonPressed:")
        self.navigationItem.leftBarButtonItem = b


    }
    func backButtonPressed (sender: UIBarButtonItem ){
//        if textView.text != nil {
//        noteDelegate.noteHandler(textView.text)
//        }
        self.navigationController?.popViewControllerAnimated(true)
    }

    @IBAction func doneButtonPressed(sender: UIBarButtonItem) {
        if textView.text != nil {
            noteDelegate.noteHandler(textView.text)
        }
        self.navigationController?.popViewControllerAnimated(true)

    }
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    override func viewWillAppear(animated: Bool) {
        textView.becomeFirstResponder()
    }
    func keyboardShow(notification: NSNotification) {
        self.keyboardShowing = true
        
        let dictionary = notification.userInfo!
        var rectForKeyboard = (dictionary[UIKeyboardFrameEndUserInfoKey] as! NSValue).CGRectValue()
        rectForKeyboard = self.textView.convertRect(rectForKeyboard, fromView:nil)
        self.textView.contentInset.bottom = rectForKeyboard.size.height
        self.textView.scrollIndicatorInsets.bottom = rectForKeyboard.size.height
    }
    func textFieldShouldReturn(textField: UITextField) -> Bool {
        textField.resignFirstResponder()
        
        return true
    }
    
    override func viewWillDisappear(animated: Bool) {
        NSNotificationCenter.defaultCenter().removeObserver(self)
    }

    func textViewDidEndEditing(textView: UITextView) {
        noteDelegate.noteHandler(textView.text)
    }
}
