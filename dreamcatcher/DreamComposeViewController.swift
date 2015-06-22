//
//  DreamComposeViewController.swift
//  dreamcatcher
//
//  Created by Francisco Guzman on 6/14/15.
//  Copyright (c) 2015 Francisco Guzman. All rights reserved.
//

import UIKit

class DreamComposeViewController: UIViewController, UITextViewDelegate {
    
    @IBOutlet weak var pageScroll: UIScrollView!
    @IBOutlet weak var styleScrollView: UIScrollView!
    @IBOutlet weak var composeTextView: UITextView!
    @IBOutlet weak var navLabel: UILabel!
    @IBOutlet weak var nextButton: UIButton!
    @IBOutlet weak var closeButton: UIButton!
    @IBOutlet weak var doneButton: UIButton!
    @IBOutlet weak var backButton: UIButton!
    @IBOutlet weak var dateLabel: UILabel!
    @IBOutlet weak var titleTextView: UITextView!
    
    var panGesture: UIPanGestureRecognizer!
    
    let placeholderText: String = "Jot down your dream"
    let textColor: UIColor = UIColor(red: 45/255, green: 45/255, blue: 64/255, alpha: 1)
    let lightTextColor: UIColor = UIColor(red: 45/255, green: 45/255, blue: 64/255, alpha: 0.3)
    
    override func viewDidLoad() {
        super.viewDidLoad()

        dateLabel.text = "JUNE 17"
        titleTextView.backgroundColor = UIColor.clearColor()
        titleTextView.textColor = UIColor.whiteColor()
        styleScrollView.hidden=true
        
        // Set up text view
        styleScrollView.contentSize = CGSize(width: 1920, height: 568)
        composeTextView.delegate = self
        composeTextView.keyboardDismissMode = .OnDrag
        
        composeTextView.selectedTextRange = composeTextView.textRangeFromPosition(composeTextView.beginningOfDocument, toPosition: composeTextView.beginningOfDocument)
        composeTextView.textColor = lightTextColor
        
        NSNotificationCenter.defaultCenter().addObserver(self, selector: "keyboardWillShowNotification:", name: UIKeyboardWillShowNotification, object: nil)
        NSNotificationCenter.defaultCenter().addObserver(self, selector: "keyboardWillHideNotification:", name: UIKeyboardWillHideNotification, object: nil)
        
        // Add a pan gesture to dismiss keyboard
        panGesture = UIPanGestureRecognizer(target: self, action: "dismissKeyboard")
        view.addGestureRecognizer(panGesture)
    }
    
    func dismissKeyboard() {
        var translation = panGesture.translationInView(view)
        
        if (panGesture.state == UIGestureRecognizerState.Ended) {
            if translation.y > 0 {
                view.endEditing(true)
            }
        }
    }
    
    func keyboardWillShowNotification(notification: NSNotification) {
        var keyboardFrame = (notification.userInfo?[UIKeyboardFrameEndUserInfoKey] as? NSValue)?.CGRectValue()
        var lineHeight = self.composeTextView.font.lineHeight
        
        if (self.composeTextView.frame.origin.y + lineHeight  > keyboardFrame?.origin.y) {
            self.pageScroll.contentSize = CGSizeMake(self.pageScroll.contentSize.width, self.pageScroll.contentSize.height - keyboardFrame!.size.height)
            self.pageScroll.contentOffset = CGPointMake(0, keyboardFrame!.size.height)
        }
    }
    
    func keyboardWillHideNotification(notification: NSNotification) {
        let screenSize: CGRect = UIScreen.mainScreen().bounds
        
        self.pageScroll.contentSize = CGSizeMake(screenSize.width, screenSize.height)
        self.pageScroll.contentOffset = CGPointMake(0, 0)
    }
    
    override func viewDidAppear(animated: Bool) {
        composeTextView.becomeFirstResponder()
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    func textView(textView: UITextView, shouldChangeTextInRange range: NSRange, replacementText text: String) -> Bool {
        
        // Combine the textView text and the replacement text to
        // create the updated text string
        let currentText:NSString = textView.text
        let updatedText = currentText.stringByReplacingCharactersInRange(range, withString:text)
        
        // If updated text view will be empty, add the placeholder
        // and set the cursor to the beginning of the text view
        if count(updatedText) == 0 {
            
            textView.text = placeholderText
            textView.textColor = lightTextColor
            
            textView.selectedTextRange = textView.textRangeFromPosition(textView.beginningOfDocument, toPosition: textView.beginningOfDocument)
            
            return false
        }
            
            // Else if the text view's placeholder is showing and the
            // length of the replacement string is greater than 0, clear
            // the text view and set its color to black to prepare for
            // the user's entry
        else if textView.textColor == lightTextColor && count(text) > 0 {
            textView.text = nil
            textView.textColor = textColor
        }
        
        return true
    }
    
    func textViewDidChangeSelection(textView: UITextView) {
        if self.view.window != nil {
            if textView.textColor == UIColor.lightGrayColor() {
                textView.selectedTextRange = textView.textRangeFromPosition(textView.beginningOfDocument, toPosition: textView.beginningOfDocument)
            }
        }
    }
    
    @IBAction func onNext(sender: AnyObject) {
        titleTextView.text = composeTextView.text
        //println(composeTextView.text)
        styleScrollView.hidden = false
        view.endEditing(true)
        UIView.animateWithDuration(0.3, animations: { () -> Void in
            self.styleScrollView.frame.origin.y += 300
            self.composeTextView.frame.origin.y += 250
        })
        navLabel.textColor = UIColor.whiteColor()
        closeButton.hidden = true
        nextButton.hidden = true
        backButton.hidden = false
        doneButton.hidden = false
        dateLabel.hidden = false
        titleTextView.hidden = false
    }
    
    @IBAction func onBack(sender: AnyObject) {
        UIView.animateWithDuration(0.3, animations: { () -> Void in
            self.styleScrollView.frame.origin.y -= 300
            self.composeTextView.frame.origin.y -= 250
        })
        navLabel.textColor = UIColor.blackColor()
        closeButton.hidden = false
        nextButton.hidden = false
        backButton.hidden = true
        doneButton.hidden = true
        composeTextView.becomeFirstResponder()
        dateLabel.hidden = true
        titleTextView.hidden = true
    }
    
    @IBAction func onClose(sender: AnyObject) {
        view.endEditing(true)
        styleScrollView.hidden = true
        dismissViewControllerAnimated(true, completion: nil)
    }
    
    
    @IBAction func onDone(sender: AnyObject) {
        view.endEditing(true)
        styleScrollView.hidden = true
    }

    override func prepareForSegue(segue: UIStoryboardSegue, sender: AnyObject?) {
        println("====== PREPARE FOR SEGUE ======!")
        
        // Only add new journal if content is not empty
        if composeTextView.textColor == textColor {
            var dreamCollectionViewController = segue.destinationViewController as! DreamCollectionViewController
            
            dreamCollectionViewController.hasNewJournal = true
            dreamCollectionViewController.dateArray.insert(dateLabel.text!, atIndex: 0)
            dreamCollectionViewController.titleArray.insert(titleTextView.text, atIndex: 0)
            dreamCollectionViewController.paragraphArray.insert(composeTextView.text, atIndex: 0)
            dreamCollectionViewController.imageArray.append(UIImage(named: "bg6")!)
            println("Number of journals: \(dreamCollectionViewController.dateArray.count)")
        }
    }
}
