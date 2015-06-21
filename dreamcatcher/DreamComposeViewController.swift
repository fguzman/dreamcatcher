//
//  DreamComposeViewController.swift
//  dreamcatcher
//
//  Created by Francisco Guzman on 6/14/15.
//  Copyright (c) 2015 Francisco Guzman. All rights reserved.
//

import UIKit

protocol communicationControllerJournal {
    func backFromCompose()
}

class DreamComposeViewController: UIViewController {
    
    var composeDelegate: communicationControllerJournal!
    
    @IBOutlet weak var styleScrollView: UIScrollView!
    @IBOutlet weak var composeTextView: UITextView!
    @IBOutlet weak var navLabel: UILabel!
    @IBOutlet weak var nextButton: UIButton!
    @IBOutlet weak var closeButton: UIButton!
    @IBOutlet weak var doneButton: UIButton!
    @IBOutlet weak var backButton: UIButton!
    @IBOutlet weak var dateLabel: UILabel!
    @IBOutlet weak var titleTextView: UITextView!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        composeTextView.becomeFirstResponder()
                styleScrollView.contentSize = CGSize(width: 960, height: 568)
        dateLabel.text = "June 17"
        titleTextView.backgroundColor = UIColor.clearColor()
        styleScrollView.hidden=true
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
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
        println()
        
        println("====== PREPARE FOR SEGUE ======!")
        
        var dreamCollectionViewController = segue.destinationViewController as! DreamCollectionViewController
        
        dreamCollectionViewController.hasNewJournal = true
        dreamCollectionViewController.dateArray.append(dateLabel.text!)
        dreamCollectionViewController.titleArray.append(titleTextView.text)
        dreamCollectionViewController.paragraphArray.append(composeTextView.text)
        dreamCollectionViewController.imageArray.append(UIImage(named: "bg6")!)
        
        println("Number of journals: \(dreamCollectionViewController.dateArray.count)")
    }

}
