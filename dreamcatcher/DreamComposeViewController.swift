//
//  DreamComposeViewController.swift
//  dreamcatcher
//
//  Created by Francisco Guzman on 6/14/15.
//  Copyright (c) 2015 Francisco Guzman. All rights reserved.
//

import UIKit

class DreamComposeViewController: UIViewController, UITextViewDelegate{

    @IBOutlet weak var pageScroll: UIScrollView!
    @IBOutlet weak var styleScrollView: UIScrollView!
    @IBOutlet weak var composeTextView: UITextView!
    @IBOutlet weak var navLabel: UILabel!
    @IBOutlet weak var nextButton: UIButton!
    @IBOutlet weak var closeButton: UIButton!
    @IBOutlet weak var doneButton: UIButton!
    @IBOutlet weak var backButton: UIButton!
    @IBOutlet weak var dateLabel: UILabel!
    @IBOutlet weak var titleLabel: UILabel!
    @IBOutlet weak var contentView: UIView!
    
    
    //constraints
    @IBOutlet weak var composeTextViewVerticalConstraint: NSLayoutConstraint!
    @IBOutlet weak var styleScrollViewVerticalConstraint: NSLayoutConstraint!
    
//    @IBOutlet weak var closeButtonVerticalConstraint: NSLayoutConstraint!
    
    
    
    var exitButton: UIButton!
    var panGesture: UIPanGestureRecognizer!
    
    let placeholderText: String = "Jot down your dream"
    let textColor: UIColor = UIColor(red: 45/255, green: 45/255, blue: 64/255, alpha: 1)
    let lightTextColor: UIColor = UIColor(red: 45/255, green: 45/255, blue: 64/255, alpha: 0.3)
    let titleMaxLength: Int = 30
    let titleMaxWords: Int = 10

    var todaysDate: NSDate = NSDate()
    var dateFormatter: NSDateFormatter = NSDateFormatter()
    var dateString: String!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        dateFormatter.dateFormat = "MMMM dd"
        dateString = dateFormatter.stringFromDate(todaysDate)
        
        dateLabel.text = dateString.uppercaseString

        styleScrollView.hidden=true
        
        // If come from alarm, hide nav bar
        if (self.navigationController != nil) {
            self.navigationController?.setNavigationBarHidden(true, animated: false)
            self.automaticallyAdjustsScrollViewInsets = false
        }
        
        // Set up text view
        styleScrollView.contentSize = CGSize(width: 1920, height: styleScrollView.frame.size.height)
        composeTextView.delegate = self
        composeTextView.keyboardDismissMode = .OnDrag
        
        let tmpTextView = paragraphStyle(placeholderText)
        composeTextView.attributedText = tmpTextView.attributedText
        composeTextView.font = tmpTextView.font
        composeTextView.textColor = lightTextColor

        composeTextView.selectedTextRange = composeTextView.textRangeFromPosition(composeTextView.beginningOfDocument, toPosition: composeTextView.beginningOfDocument)

        NSNotificationCenter.defaultCenter().addObserver(self, selector: "keyboardWillShowNotification:", name: UIKeyboardWillShowNotification, object: nil)
        NSNotificationCenter.defaultCenter().addObserver(self, selector: "keyboardWillHideNotification:", name: UIKeyboardWillHideNotification, object: nil)
        
        // Add a pan gesture to dismiss keyboard
        panGesture = UIPanGestureRecognizer(target: self, action: "dismissKeyboard")
        view.addGestureRecognizer(panGesture)
        nextButton.enabled = false
        
        // Set the scroll views frame to current device view
        let deviceSize = UIScreen.mainScreen().applicationFrame.size
        contentView.frame = CGRectMake(0, 0, deviceSize.width, deviceSize.height)
        pageScroll.frame = contentView.frame
    }
    
    func didChangeTabToTabNumber(tabNumber: Int) {
    
    }
    
    func dismissKeyboard() {
        let translation = panGesture.translationInView(view)
        
        if (panGesture.state == UIGestureRecognizerState.Ended) {
            if translation.y > 0 {
                view.endEditing(true)
            }
        }
    }
    
    func keyboardWillShowNotification(notification: NSNotification) {
        if composeTextView.isFirstResponder() {
            let keyboardFrame = (notification.userInfo?[UIKeyboardFrameEndUserInfoKey] as? NSValue)?.CGRectValue()
            let lineHeight = self.composeTextView.font!.lineHeight
            
            if (self.composeTextView.frame.origin.y + lineHeight  > keyboardFrame?.origin.y) {
                var contentInset: UIEdgeInsets = pageScroll.contentInset;
                contentInset.bottom = keyboardFrame!.size.height;
                pageScroll.contentInset = contentInset;
            }
        }
    }
    
    func keyboardWillHideNotification(notification: NSNotification) {
        if composeTextView.isFirstResponder() {
            var contentInset: UIEdgeInsets = pageScroll.contentInset;
            contentInset.bottom = 0;
            pageScroll.contentInset = contentInset;
//            let screenSize: CGRect = UIScreen.mainScreen().bounds
//            
//            self.pageScroll.contentSize = CGSizeMake(screenSize.width, screenSize.height)
//            self.pageScroll.contentOffset = CGPointMake(0, 0)
        }
    }
    
    override func viewDidAppear(animated: Bool) {
        composeTextView.becomeFirstResponder()
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    func textView(textView: UITextView, shouldChangeTextInRange range: NSRange, replacementText text: String) -> Bool {
        
        if textView == self.composeTextView {
            // Combine the textView text and the replacement text to
            // create the updated text string
            let currentText:NSString = textView.text
            let updatedText = currentText.stringByReplacingCharactersInRange(range, withString:text)
            
            // If updated text view will be empty, add the placeholder
            // and set the cursor to the beginning of the text view
            if updatedText.characters.count == 0 {
                
                textView.text = placeholderText
                textView.textColor = lightTextColor
                
                textView.selectedTextRange = textView.textRangeFromPosition(textView.beginningOfDocument, toPosition: textView.beginningOfDocument)
                nextButton.enabled = false
                doneButton.enabled = false
                doneButton.alpha = 0.5
                return false
            }
                
                // Else if the text view's placeholder is showing and the
                // length of the replacement string is greater than 0, clear
                // the text view and set its color to black to prepare for
                // the user's entry
            else if textView.textColor == lightTextColor && text.characters.count > 0 {
                textView.text = nil
                textView.textColor = textColor
                nextButton.enabled = true
                doneButton.enabled = true
                doneButton.alpha = 1
                return true
            }
            
            return true
        } else {
            return true
        }
    }
    
    func textViewDidChangeSelection(textView: UITextView) {
        if textView == self.composeTextView {
            if self.view.window != nil {
                if textView.textColor == UIColor.lightGrayColor() {
                    textView.selectedTextRange = textView.textRangeFromPosition(textView.beginningOfDocument, toPosition: textView.beginningOfDocument)
                }
            }
        }
    }
    
    @IBAction func onNext(sender: AnyObject) {
        // Use the first 10 words from the compose field as title
        var words = composeTextView.text.componentsSeparatedByString(" ")
        print("words: \(words.count)")
        let index = words.count > titleMaxWords ? titleMaxWords - 1 : words.count - 1
        let firstWords = Array(words[0...index])
        titleLabel.text = firstWords.joinWithSeparator(" ")
        
        //println(composeTextView.text)
        styleScrollView.hidden = false
        view.endEditing(true)
        
        self.styleScrollViewVerticalConstraint.constant = 0
        self.composeTextViewVerticalConstraint.constant = 265
        UIView.animateWithDuration(0.3, animations: { () -> Void in
            self.view.layoutIfNeeded()
        })
        navLabel.textColor = UIColor.whiteColor()
        closeButton.hidden = true
        nextButton.hidden = true
        backButton.hidden = false
        doneButton.hidden = false
        dateLabel.hidden = false
        titleLabel.hidden = false
    }
    
    @IBAction func onBack(sender: AnyObject) {
        self.styleScrollViewVerticalConstraint.constant = -319
        self.composeTextViewVerticalConstraint.constant = 10
        
        UIView.animateWithDuration(0.3, animations: { () -> Void in
            self.view.layoutIfNeeded()
        })
        navLabel.textColor = UIColor.blackColor()
        closeButton.hidden = false
        nextButton.hidden = false
        backButton.hidden = true
        doneButton.hidden = true
        composeTextView.becomeFirstResponder()
        dateLabel.hidden = true
        titleLabel.hidden = true
    }
    
    @IBAction func onClose(sender: AnyObject) {
        view.endEditing(true)
        styleScrollView.hidden = true
        if self.parentViewController != nil{ //if embded in AlarmNavController
            let alarmNavController = self.parentViewController as! AlarmNavController
            alarmNavController.exitButtonName = "close"
            
        }

        exitButton = closeButton
        dismissViewControllerAnimated(true, completion: nil)
    }
    
    
    @IBAction func onDone(sender: AnyObject) {

        let journal = PFObject(className: "Journal")
        
        journal["date"] = dateLabel.text
        journal["title"] = titleLabel.text
        journal["body"] = composeTextView.text
        journal["user"] = PFUser.currentUser()
        
        journal.saveInBackgroundWithBlock { (success: Bool, error: NSError?) -> Void in
            print("Saved the entry!")
        }
        
        if self.parentViewController != nil{ //if embded in AlarmNavController
            let alarmNavController = self.parentViewController as! AlarmNavController
            alarmNavController.exitButtonName = "done"
        }
        
        view.endEditing(true)
        exitButton = doneButton
        styleScrollView.hidden = true
    }
}
