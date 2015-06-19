//
//  AlarmViewController.swift
//  dreamcatcher
//
//  Created by Sara Lin on 6/11/15.
//  Copyright (c) 2015 Francisco Guzman. All rights reserved.
//

import UIKit

class AlarmViewController: UIViewController {
    
    enum State: String {
        case Unset      = "Unset"
        case Set        = "Set"
        case Triggered  = "Triggered"
    }
    
    enum Repeat: String {
        case Everyday   = "Repeat Everyday"
        case Once       = "Once"
    }
    
    enum AlarmUserSettings: String {
        case Date           = "alarm.date"
        case Repeat         = "alarm.repeat"
        case State          = "alarm.state"
        case LastSelected   = "alarm.lastSelected"
    }
    
    @IBOutlet weak var editAlarmButton: UIButton!
    @IBOutlet weak var setAlarmButton: UIButton!
    @IBOutlet weak var dismissAlarmContainer: UIView!
    @IBOutlet weak var dismissLabel: UILabel!
    
    @IBOutlet weak var timeLabel: UILabel!
    @IBOutlet weak var repeatLabel: UILabel!
    
    @IBOutlet weak var backgroundView: UIView!
    @IBOutlet weak var repeatContainer: UIView!
    @IBOutlet weak var repeatFieldLabel: UILabel!
    @IBOutlet weak var repeatSwitch: UISwitch!
    @IBOutlet weak var datePicker: UIDatePicker!
    @IBOutlet weak var datePickerContainer: UIView!
    
    var alarmTransition = InteractiveBaseTransition()
    
    var currentState: State! = State.Unset
    var initialDismissContainerCenter: CGPoint!
    
    let orangeColor: UIColor = UIColor(red: 255/255, green: 108.0/255, blue: 0.0, alpha: 1)
    let blueColor: UIColor = UIColor(red: 0, green: 153/255, blue: 255/255, alpha: 1)
    let appDelegate = UIApplication.sharedApplication().delegate as! AppDelegate
    let userDefaults: NSUserDefaults = NSUserDefaults.standardUserDefaults()
    let screenSize: CGRect = UIScreen.mainScreen().bounds
    let displayContainerHeight: CGFloat = 300.0
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        appDelegate.alarmViewController = self

        // Style edit alarm
        editAlarmButton.layer.cornerRadius = editAlarmButton.frame.width/2
        editAlarmButton.layer.backgroundColor = orangeColor.CGColor
        editAlarmButton.setTitleColor(UIColor.whiteColor(), forState: .Normal)
        
        // Style dismiss alarm
        dismissAlarmContainer.layer.cornerRadius = dismissAlarmContainer.frame.width/2
        dismissAlarmContainer.layer.backgroundColor = blueColor.CGColor
        
        // Set alarm state
        var tempState = State.Unset
        if (userDefaults.objectForKey(AlarmUserSettings.State.rawValue) != nil) {
            tempState = State(rawValue: userDefaults.objectForKey(AlarmUserSettings.State.rawValue) as! String)!
        }
//        updateAlarmState(tempState)
        userDefaults.setObject(NSDate(), forKey: AlarmUserSettings.Date.rawValue)
        updateAlarmState(State.Triggered)
        
        // Display last selected alarm date
        if (userDefaults.objectForKey(AlarmUserSettings.LastSelected.rawValue) != nil) {
            var lastSelectedDate: NSDate! = userDefaults.objectForKey(AlarmUserSettings.LastSelected.rawValue) as! NSDate
            datePicker.date = lastSelectedDate
        }
        
        initialDismissContainerCenter = dismissAlarmContainer.center
        // Bounce the dismiss button
        if (currentState == State.Triggered) {
            self.dismissAlarmContainer.frame.offset(dx: 0, dy: 30)
            self.dismissAlarmContainer.alpha = 0
            self.dismissLabel.frame.offset(dx: 0, dy: 30)
            self.dismissLabel.alpha = 0
        }
        
        alarmTransition.isInteractive = true
    }
    
    override func viewDidAppear(animated: Bool) {
        // Bounce the dismiss button
        if (currentState == State.Triggered) {
            UIView.animateWithDuration(1, delay: 0, usingSpringWithDamping: 0.2, initialSpringVelocity: 0.02, options: UIViewAnimationOptions.CurveEaseInOut, animations: { () -> Void in
                self.dismissAlarmContainer.frame.offset(dx: 0, dy: -30)
                self.dismissAlarmContainer.alpha = 1
                self.dismissLabel.frame.offset(dx: 0, dy: -30)
                self.dismissLabel.alpha = 0.3
                }, completion: nil)
        }
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }

    @IBAction func onPressCloseButton(sender: AnyObject) {
        dismissModal()
    }
    
    @IBAction func onChangeDatePicker(sender: AnyObject) {
        userDefaults.setObject(datePicker.date, forKey: AlarmUserSettings.LastSelected.rawValue)
    }
    
    @IBAction func onPressSetAlarm(sender: AnyObject) {
        setLocalNotification(datePicker.date)
        updateAlarmState(State.Set)
        dismissModal()
    }

    @IBAction func onPressCancelAlarm(sender: AnyObject) {
        unsetLocalNotification()
        updateAlarmState(State.Unset)
    }
    
    @IBAction func onPanningDismissButton(sender: UIPanGestureRecognizer) {
        var translation = sender.translationInView(view)
        var dismissThreshold: CGFloat = -30.0
        
        if (sender.state == UIGestureRecognizerState.Began) {
            UIView.animateWithDuration(0.3, delay: 0, options: UIViewAnimationOptions.CurveEaseOut, animations: { () -> Void in
                self.dismissAlarmContainer.transform = CGAffineTransformScale(CGAffineTransformIdentity, 1.1, 1.1)
                }, completion: { finished in
                    self.alarmTransition.isInteractive = true
//                    var composeVC = ComposeViewController()
//                    self.navigationController?.pushViewController(composeVC, animated: true)
                    self.performSegueWithIdentifier("alarmToComposeSegue", sender: self)
            })
        } else if (sender.state == UIGestureRecognizerState.Changed) {
            println("in gesture changed state")
            
            var nextCenterY = initialDismissContainerCenter.y + translation.y
            if (nextCenterY <= initialDismissContainerCenter.y) {
                self.dismissAlarmContainer.center = CGPointMake(initialDismissContainerCenter.x, initialDismissContainerCenter.y + translation.y)
                
                if (translation.y < dismissThreshold) {
                    var translationDeltaY = translation.y - dismissThreshold
                    var tmpBackgroundAlpha = convertValue(translationDeltaY, 0.0, -500.0, 1.0, 0)
                    var tmpLabelAlpha = convertValue(translationDeltaY, 0.0, -100.0, 1.0, 0)
                    var tmpDisplayContainerHeight = convertValue(translationDeltaY, 0.0, -300.0, displayContainerHeight, 60.0)
                    
                    timeLabel.alpha = tmpLabelAlpha
                    repeatLabel.alpha = tmpLabelAlpha
                    datePickerContainer.frame = CGRectMake(0, 0, screenSize.width, tmpDisplayContainerHeight)
                    
                    var percent = convertValue(translationDeltaY, 0.0, -300.0, 0.0, 1.0)
                    alarmTransition.updateInteractiveTransition(percent)
                    println("updated interactive transition: \(percent)")
                }
            }

        } else if (sender.state == UIGestureRecognizerState.Ended) {
            println("in gesture ended state")

            // passed the threshold to dismiss alarm and start compose journal
            if (translation.y < -200.0) {
                unsetLocalNotification()
                updateAlarmState(State.Unset)
                
                self.alarmTransition.isInteractive = false
                self.alarmTransition.finishInteractiveTransition()
                println("finished interactive transition")
                
            } else {
                // cancel dismiss alarm
                self.alarmTransition.isInteractive = false
                self.alarmTransition.cancelInteractiveTransition()
                println("cancelled interactive transition")
                
                UIView.animateWithDuration(1, delay: 0, usingSpringWithDamping: 0.2, initialSpringVelocity: 0.01, options: UIViewAnimationOptions.CurveEaseInOut, animations: { () -> Void in
                    
                    println("cancelling interactive transition")
                    
                    self.dismissAlarmContainer.center = self.initialDismissContainerCenter
                    self.dismissAlarmContainer.transform = CGAffineTransformIdentity
                    self.datePickerContainer.frame = CGRectMake(0, 0, self.screenSize.width, self.displayContainerHeight)
                    
                    self.timeLabel.alpha = 1
                    self.repeatLabel.alpha = 1
                    }, completion: nil)
            }
        }
    }
    
    override func prepareForSegue(segue: UIStoryboardSegue, sender: AnyObject!) {
        if segue.identifier == "alarmToComposeSegue" {
            var destinationVC = segue.destinationViewController as! ComposeViewController
            destinationVC.modalPresentationStyle = UIModalPresentationStyle.Custom
            destinationVC.transitioningDelegate = alarmTransition
        }
    }
    
    func dismissModal() {
        self.dismissViewControllerAnimated(true, completion: nil)
    }
    
    func validateDate(wakeUpTime: NSDate) -> NSDate {
        let now = NSDate()
        let calendar = NSCalendar.currentCalendar()
        
        var newWakeUpTime: NSDate = wakeUpTime
        
        while (newWakeUpTime.compare(now) == .OrderedAscending) {
            newWakeUpTime = calendar.dateByAddingUnit(.CalendarUnitDay, value: 1, toDate: newWakeUpTime, options: nil)!
        }
        
        return newWakeUpTime
    }
    
    func unsetLocalNotification() {
        //cancel notification or stop player
        UIApplication.sharedApplication().cancelAllLocalNotifications()
        appDelegate.stopPlayer()
        userDefaults.removeObjectForKey(AlarmUserSettings.Date.rawValue)
    }
    
    func setLocalNotification(firedate: NSDate) {
        var date = validateDate(firedate)
        
        // set notification
        var notification: UILocalNotification = UILocalNotification()
        notification.fireDate = date
        notification.alertBody = "It's a new day!"
        notification.soundName = "alarm_sound_3.mp3"
        notification.applicationIconBadgeNumber = 1
        
        userDefaults.setObject(date, forKey: AlarmUserSettings.Date.rawValue)
        userDefaults.setObject(Repeat.Once.rawValue, forKey: AlarmUserSettings.Repeat.rawValue)
        
        if (repeatSwitch.on) {
            notification.repeatInterval = NSCalendarUnit.CalendarUnitDay
            userDefaults.setObject(Repeat.Everyday.rawValue, forKey: AlarmUserSettings.Repeat.rawValue)
        }
        
        UIApplication.sharedApplication().scheduleLocalNotification(notification)
    }
    
    // Show or hide alarm date picker and repeat switch
    func showHideEditUI(isShow: Bool) {
        var editAlpha: CGFloat = isShow ? 1.0 : 0.0
        var displayAlpha: CGFloat = isShow ? 0.0 : 1.0
        
        if !isShow {
            UIView.animateKeyframesWithDuration(1, delay: 0, options: nil, animations: {
                UIView.addKeyframeWithRelativeStartTime(0, relativeDuration: 0.5, animations: {
                    self.datePicker.alpha = editAlpha
                    self.repeatContainer.alpha = editAlpha
                    self.setAlarmButton.alpha = editAlpha
                })
                
                UIView.addKeyframeWithRelativeStartTime(0.2, relativeDuration: 0.7, animations: {
                    self.datePickerContainer.frame = CGRectMake(0, 0, self.screenSize.width, self.displayContainerHeight)
                })
                
                UIView.addKeyframeWithRelativeStartTime(0.7, relativeDuration: 0.3, animations: {
                    self.editAlarmButton.alpha = displayAlpha
                    self.timeLabel.alpha = displayAlpha
                    self.repeatLabel.alpha = displayAlpha
                })
            }, completion: nil)
        } else {
            UIView.animateKeyframesWithDuration(1, delay: 0, options: nil, animations: {
                UIView.addKeyframeWithRelativeStartTime(0, relativeDuration: 0.5, animations: {
                    self.editAlarmButton.alpha = displayAlpha
                    self.dismissAlarmContainer.alpha = displayAlpha
                    self.timeLabel.alpha = displayAlpha
                    self.repeatLabel.alpha = displayAlpha
                    self.dismissLabel.alpha = displayAlpha
                })
                
                UIView.addKeyframeWithRelativeStartTime(0.2, relativeDuration: 0.7, animations: {
                    self.datePickerContainer.frame = CGRectMake(0, 0, self.screenSize.width, self.screenSize.height)
                })
                
                UIView.addKeyframeWithRelativeStartTime(0.7, relativeDuration: 0.3, animations: {
                    self.datePicker.alpha = editAlpha
                    self.repeatContainer.alpha = editAlpha
                    self.setAlarmButton.alpha = editAlpha
                })
            }, completion: nil)
        }
    }
    
    // Display current alarm time and repeat setting
    func displayAlarmInfo() {
        var dateFormatter = NSDateFormatter()
        dateFormatter.timeStyle = NSDateFormatterStyle.ShortStyle
        var date = userDefaults.objectForKey(AlarmUserSettings.Date.rawValue) as! NSDate
        var strDate = dateFormatter.stringFromDate(date)
        timeLabel.text = strDate
        timeLabel.sizeToFit()
        
        var repeatStr = userDefaults.objectForKey(AlarmUserSettings.Repeat.rawValue) as! String
        repeatLabel.text = repeatStr
        repeatLabel.sizeToFit()
        
        repeatLabel.center = CGPointMake(UIScreen.mainScreen().bounds.width/2, repeatLabel.center.y)
        repeatLabel.textAlignment = NSTextAlignment.Center
        timeLabel.center = CGPointMake(UIScreen.mainScreen().bounds.width/2, timeLabel.center.y)
        timeLabel.textAlignment = NSTextAlignment.Center
    }
    
    // Alarm state controller
    func updateAlarmState(state: State) {
        // If user default doesn't have alarm setting yet, default to Unset
        if (userDefaults.objectForKey(AlarmUserSettings.Date.rawValue) == nil) {
            currentState = State.Unset
        }
        
        currentState = state
        
        if currentState == State.Unset {
            showHideEditUI(true)
        }
        else {
            displayAlarmInfo()
            showHideEditUI(false)
        }
        
        if (currentState == State.Set) {
            dismissAlarmContainer.alpha = 0
            dismissLabel.alpha = 0
        }
        
        if (currentState == State.Triggered) {
            dismissAlarmContainer.alpha = 1
            editAlarmButton.alpha = 0
        }
        
        userDefaults.setObject(currentState.rawValue, forKey: AlarmUserSettings.State.rawValue)

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
