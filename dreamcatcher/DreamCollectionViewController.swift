//
//  DreamCollectionViewController.swift
//  dreamcatcher
//
//  Created by Hsin Yi Huang on 6/15/15.
//  Copyright (c) 2015 Francisco Guzman. All rights reserved.
//

import UIKit

class DreamCollectionViewController: UIViewController, UICollectionViewDataSource, UICollectionViewDelegate {
    
    var journalTransition : JournalTransition!

    @IBOutlet weak var collectionView: UICollectionView!
    
    // Nav buttons
    @IBOutlet weak var settingButton: UIButton!
    @IBOutlet weak var alarmButton: UIButton!
    @IBOutlet weak var composeButton: UIButton!
    @IBOutlet weak var alarmTimeLabel: UILabel!
    
    var numOfCell = 2
    var dateArray = ["JUNE 17", "JUNE 14"]
    var titleArray = ["Underwater World With Corals", "Fat Cat Getting Stuck in the Wall"]
    var paragraphArray = [
        "My friends and I (probably the same old girls gang, Emily, Jenny, Vivian, also Emily’s bf ",
        "My fat cat is so obese that it resembles an overstuff sausage. There were a few times..."
    ]
    
    let defaultNavAlpha: CGFloat = 0.3
    let userDefaults: NSUserDefaults = NSUserDefaults.standardUserDefaults()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        collectionView.delegate = self
        collectionView.dataSource = self
       
        // Set all nav buttons to 30% alpha by default
        settingButton.alpha = defaultNavAlpha
        alarmButton.alpha = defaultNavAlpha
        composeButton.alpha = defaultNavAlpha
        alarmTimeLabel.alpha = 0
    }
    
    override func viewDidAppear(animated: Bool) {
        if (userDefaults.objectForKey(AlarmViewController.AlarmUserSettings.Date.rawValue) != nil) {
            var dateFormatter = NSDateFormatter()
            dateFormatter.timeStyle = NSDateFormatterStyle.ShortStyle
            var date = userDefaults.objectForKey(AlarmViewController.AlarmUserSettings.Date.rawValue) as! NSDate
            var strDate = dateFormatter.stringFromDate(date)
            alarmTimeLabel.text = strDate
            alarmTimeLabel.sizeToFit()
            alarmTimeLabel.textAlignment = NSTextAlignment.Center
            alarmTimeLabel.center = CGPointMake(UIScreen.mainScreen().bounds.width/2, alarmTimeLabel.center.y)
            
            // Fade in the alarm time label
            UIView.animateWithDuration(0.5, delay: 0.1, options: .CurveEaseInOut, animations: {
                self.alarmButton.alpha = 1
                self.alarmTimeLabel.alpha = 1
            }, completion: nil)
        } else {
            // Fade out the alarm time label
            UIView.animateWithDuration(0.5, delay: 0.1, options: .CurveEaseInOut, animations: {
                self.alarmButton.alpha = self.defaultNavAlpha
                self.alarmTimeLabel.alpha = 0
                }, completion: nil)
        }
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    
    func collectionView(collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int{
        return titleArray.count
        
    }
    
    
    func collectionView(collectionView: UICollectionView, cellForItemAtIndexPath indexPath: NSIndexPath) -> UICollectionViewCell{
       
        var cell = collectionView.dequeueReusableCellWithReuseIdentifier("cardCollectionViewCell", forIndexPath: indexPath) as! CardCollectionViewCell
        
        cell.titleLabel.text = titleArray[indexPath.row]
        cell.dateLabel.text = dateArray[indexPath.row]
        cell.textView.text = paragraphArray[indexPath.row]
        
        return cell
    }
    
    
    @IBAction func onPan(sender: UIPanGestureRecognizer) {
        println("pan")
        
        if sender.state == UIGestureRecognizerState.Began{
            performSegueWithIdentifier("journalDetailSegue", sender: nil)
        }
        else if sender.state == UIGestureRecognizerState.Changed{
        }
        else if sender.state == UIGestureRecognizerState.Ended{
        }
        
    }

    
    
    override func prepareForSegue(segue: UIStoryboardSegue, sender: AnyObject!) {
        
        println(segue.identifier)
        
        if segue.identifier == "journalDetailSegue" {
            var destinationVC = segue.destinationViewController as! JournalViewController
            destinationVC.modalPresentationStyle = UIModalPresentationStyle.Custom
            journalTransition = JournalTransition()
            destinationVC.transitioningDelegate = journalTransition
        }
        
        
    }
    

    

}
