//
//  AlarmViewController.swift
//  dreamcatcher
//
//  Created by Sara Lin on 6/11/15.
//  Copyright (c) 2015 Francisco Guzman. All rights reserved.
//

import UIKit

class AlarmViewController: UIViewController, UINavigationControllerDelegate {
    
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
    
    @IBOutlet weak var cancelAlarmContainer: UIView!
    @IBOutlet weak var setAlarmButton: UIButton!
    @IBOutlet weak var dismissAlarmContainer: UIView!
    @IBOutlet weak var buttonLabel: UILabel!
    
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
    var initialButtonLabelCenter: CGPoint!
    var initialCancelButtonCenter: CGPoint!
    
    let appDelegate = UIApplication.sharedApplication().delegate as! AppDelegate
    let userDefaults: NSUserDefaults = NSUserDefaults.standardUserDefaults()
    
    let orangeColor: UIColor = UIColor(red: 255/255, green: 108.0/255, blue: 0.0, alpha: 1)
    let blueColor: UIColor = UIColor(red: 0, green: 153/255, blue: 255/255, alpha: 1)

    let screenSize: CGRect = UIScreen.mainScreen().bounds
    let displayContainerHeight: CGFloat = 300.0
    
    // initial cancel and dismiss button, label styles
    let buttonLabelAlpha: CGFloat = 0.3
    let buttonInitOffset: CGFloat = 30.0
    
    // alarm state 
    let alarmSoundDuration: Int = 23
    let alarmNotificationCount: Int = 13
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        appDelegate.alarmViewController = self
        self.navigationController?.delegate = self
        alarmTransition.isInteractive = true

        initialDismissContainerCenter = dismissAlarmContainer.center
        initialButtonLabelCenter = buttonLabel.center
        initialCancelButtonCenter = cancelAlarmContainer.center
        
        initButtonStyle()
        initAlarmState()
    }
    
    func initButtonStyle() {
        // Style edit alarm
        cancelAlarmContainer.layer.cornerRadius = cancelAlarmContainer.frame.width/2
        cancelAlarmContainer.layer.backgroundColor = orangeColor.CGColor
        
        // Style dismiss alarm
        dismissAlarmContainer.layer.cornerRadius = dismissAlarmContainer.frame.width/2
        dismissAlarmContainer.layer.backgroundColor = blueColor.CGColor
        
    }
    
    func initAlarmState() {
        // Set alarm state
        var tempState = State.Unset
        if (userDefaults.objectForKey(AlarmUserSettings.State.rawValue) != nil) {
            tempState = State(rawValue: userDefaults.objectForKey(AlarmUserSettings.State.rawValue) as! String)!
        }
        updateAlarmState(tempState, isAnimate: false, complete: nil)
//        userDefaults.setObject(NSDate(), forKey: AlarmUserSettings.Date.rawValue)
//        updateAlarmState(State.Triggered, isAnimate: false)
        
        // Display last selected alarm date
        if (userDefaults.objectForKey(AlarmUserSettings.LastSelected.rawValue) != nil) {
            var lastSelectedDate: NSDate! = userDefaults.objectForKey(AlarmUserSettings.LastSelected.rawValue) as! NSDate
            datePicker.date = lastSelectedDate
        }
        
        // Bounce the dismiss button
        if (currentState == State.Triggered) {
            println("prepare for trigger animation")
            self.dismissAlarmContainer.frame.offset(dx: 0, dy: buttonInitOffset)
            self.dismissAlarmContainer.alpha = 0
            self.buttonLabel.frame.offset(dx: 0, dy: buttonInitOffset)
            self.buttonLabel.alpha = 0
        } else if (currentState == State.Set) {
            self.cancelAlarmContainer.frame.offset(dx: 0, dy: -buttonInitOffset)
            self.cancelAlarmContainer.alpha = 0
            self.buttonLabel.frame.offset(dx: 0, dy: -buttonInitOffset)
            self.buttonLabel.alpha = 0
        }
    }
    
    
    override func viewDidAppear(animated: Bool) {
        // Bounce the dismiss button
        if (currentState == State.Triggered) {
            UIView.animateWithDuration(1, delay: 0, usingSpringWithDamping: 0.2, initialSpringVelocity: 0.02, options: UIViewAnimationOptions.CurveEaseInOut | UIViewAnimationOptions.AllowUserInteraction, animations: { () -> Void in
                self.dismissAlarmContainer.center = self.initialDismissContainerCenter
                self.dismissAlarmContainer.alpha = 1
                self.buttonLabel.center = self.initialButtonLabelCenter
                self.buttonLabel.alpha = self.buttonLabelAlpha
                }, completion: nil)
        } else if (currentState == State.Set) {
            UIView.animateWithDuration(1, delay: 0, usingSpringWithDamping: 0.2, initialSpringVelocity: 0.02, options: UIViewAnimationOptions.CurveEaseInOut | UIViewAnimationOptions.AllowUserInteraction, animations: { () -> Void in
                self.cancelAlarmContainer.center = self.initialDismissContainerCenter
                self.cancelAlarmContainer.alpha = 1
                self.buttonLabel.center = self.initialButtonLabelCenter
                self.buttonLabel.alpha = self.buttonLabelAlpha
                }, completion: nil)
        }
    }
    
    func navigationController(navigationController: UINavigationController, animationControllerForOperation operation: UINavigationControllerOperation, fromViewController fromVC: UIViewController, toViewController toVC: UIViewController) -> UIViewControllerAnimatedTransitioning? {
        return alarmTransition
    }
    
    func navigationController(navigationController: UINavigationController, interactionControllerForAnimationController animationController: UIViewControllerAnimatedTransitioning) -> UIViewControllerInteractiveTransitioning? {
        println("-- ASKED FOR NAVIGATION INTERACTIVE ANIAMTION CONTROLLER -- ")
        return alarmTransition
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
        updateAlarmState(State.Set, isAnimate: true, complete: nil)
        dismissModal()
    }

    @IBAction func onPressCancelAlarm(sender: AnyObject) {
        unsetLocalNotification()
        updateAlarmState(State.Unset, isAnimate: true, complete: nil)
    }
    
    @IBAction func onPanningCancelButton(sender: UIPanGestureRecognizer) {
        var translation = sender.translationInView(view)
        
        if (sender.state == UIGestureRecognizerState.Began) {
            UIView.animateWithDuration(0.3, delay: 0, options: UIViewAnimationOptions.CurveEaseOut, animations: { () -> Void in
                self.cancelAlarmContainer.transform = CGAffineTransformScale(CGAffineTransformIdentity, 1.1, 1.1)
                }, completion: nil)
        } else if (sender.state == UIGestureRecognizerState.Changed) {
            
            var nextCenterY = initialCancelButtonCenter.y + translation.y
            if (nextCenterY > initialCancelButtonCenter.y) {
                println("translate y: \(translation.y)")
                
                // Hide display UI
                if (translation.y > 0) {
                    var tmpEditUIAlpha = convertValue(translation.y, 0.0, 180.0, 1.0, 0)
                    var tmpButtonLabelAlpha = convertValue(translation.y, 0.0, 180.0, buttonLabelAlpha, 0)
                    
                    self.cancelAlarmContainer.alpha = tmpEditUIAlpha
                    self.timeLabel.alpha = tmpEditUIAlpha
                    self.repeatLabel.alpha = tmpEditUIAlpha
                    self.buttonLabel.alpha = tmpButtonLabelAlpha
                    
                    // Extend date picker container
                    self.datePickerContainer.frame = CGRectMake(0, 0, self.screenSize.width, displayContainerHeight + translation.y)
                    self.cancelAlarmContainer.center = CGPointMake(initialCancelButtonCenter.x, initialCancelButtonCenter.y + translation.y)
                    self.buttonLabel.center = CGPointMake(self.buttonLabel.center.x, initialButtonLabelCenter.y + translation.y)
                }
                
                // Show edit UI
                if (translation.y > 60.0) {
                    var tmpEditUIAlpha = convertValue(translation.y, 0.0, 360.0, 0.0, 1.0)

                    self.datePicker.alpha = tmpEditUIAlpha
                    self.repeatContainer.alpha = tmpEditUIAlpha
                    self.setAlarmButton.alpha = tmpEditUIAlpha
                }
            }
            
        } else if (sender.state == UIGestureRecognizerState.Ended) {
            println("-- GESTURE ENDED -- ")
            
            // passed the threshold to dismiss alarm and start compose journal
            if (translation.y < 60.0) {
                UIView.animateWithDuration(0.3, delay: 0, usingSpringWithDamping: 0.3, initialSpringVelocity: 0.005, options: UIViewAnimationOptions.CurveEaseOut, animations: { () -> Void in
                    self.cancelAlarmContainer.transform = CGAffineTransformIdentity
                    self.cancelAlarmContainer.center = self.initialCancelButtonCenter
                    
                    //reset everything
                    self.cancelAlarmContainer.alpha = 1
                    self.timeLabel.alpha = 1
                    self.repeatLabel.alpha = 1
                    self.buttonLabel.alpha = self.buttonLabelAlpha
                    
                    // Extend date picker container
                    self.datePickerContainer.frame = CGRectMake(0, 0, self.screenSize.width, self.displayContainerHeight)
                    self.cancelAlarmContainer.center = CGPointMake(self.initialCancelButtonCenter.x, self.initialCancelButtonCenter.y)
                    self.buttonLabel.center = CGPointMake(self.buttonLabel.center.x, self.initialButtonLabelCenter.y)
                    
                    self.datePicker.alpha = 0
                    self.repeatContainer.alpha = 0
                    self.setAlarmButton.alpha = 0
                    }, completion: nil)
            } else {
                unsetLocalNotification()
                updateAlarmState(State.Unset, isAnimate: true, complete: nil)
            }
        }
    }
    
    @IBAction func onPanningDismissButton(sender: UIPanGestureRecognizer) {
        var translation = sender.translationInView(view)
        var dismissThreshold: CGFloat = -30.0
        
        if (sender.state == UIGestureRecognizerState.Began) {
            UIView.animateWithDuration(0.3, delay: 0, options: UIViewAnimationOptions.CurveEaseOut, animations: { () -> Void in
                self.dismissAlarmContainer.transform = CGAffineTransformScale(CGAffineTransformIdentity, 1.1, 1.1)
                }, completion: { finished in
                    self.performSegueWithIdentifier("alarmToComposeSegue", sender: self)
            })
        } else if (sender.state == UIGestureRecognizerState.Changed) {
            
            var nextCenterY = initialDismissContainerCenter.y + translation.y
            if (nextCenterY <= initialDismissContainerCenter.y) {
                self.dismissAlarmContainer.center = CGPointMake(initialDismissContainerCenter.x, initialDismissContainerCenter.y + translation.y)
                
                if (translation.y <= dismissThreshold) {
                    var translationDeltaY = translation.y - dismissThreshold
                    var tmpLabelAlpha = convertValue(translationDeltaY, 0.0, -100.0, 1.0, 0)
                    var tmpDisplayContainerHeight = convertValue(translationDeltaY, 0.0, -300.0, displayContainerHeight, 60.0)
                    
                    timeLabel.alpha = tmpLabelAlpha
                    repeatLabel.alpha = tmpLabelAlpha
                    datePickerContainer.frame = CGRectMake(0, 0, screenSize.width, tmpDisplayContainerHeight)
                    
                    var percent = convertValue(translationDeltaY, 0.0, -300.0, 0.0, 1.0)
                    alarmTransition.updateInteractiveTransition(percent)
                }
            }

        } else if (sender.state == UIGestureRecognizerState.Ended) {
            
            // passed the threshold to dismiss alarm and start compose journal
            if (translation.y < -200.0) {
                unsetLocalNotification()
                updateAlarmState(State.Unset, isAnimate: false, complete: nil)
                
                self.alarmTransition.finish()
            } else {
                // cancel dismiss alarm
                self.alarmTransition.cancel()
                
                UIView.animateWithDuration(1, delay: 0, usingSpringWithDamping: 0.2, initialSpringVelocity: 0.005, options: UIViewAnimationOptions.CurveEaseInOut, animations: { () -> Void in
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
            var destinationVC = segue.destinationViewController as! DreamComposeViewController
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
        var originalDate = date
        
        // set notification
        var notification: UILocalNotification!
        let calendar = NSCalendar.currentCalendar()
        for index in 1...alarmNotificationCount {
            notification = UILocalNotification()
            
            if index > 1 {
                date = calendar.dateByAddingUnit(.CalendarUnitSecond, value: alarmSoundDuration, toDate: date, options: nil)!
                notification.soundName = "alarm_sound_normal.mp3"
            }
            
            if index == 1 {
                notification.alertBody = "It's a new day!"
                notification.soundName = "alarm_sound_fadedIn.mp3"
                notification.applicationIconBadgeNumber = 1
            }
            
            notification.fireDate = date
            UIApplication.sharedApplication().scheduleLocalNotification(notification)
        }
        
        userDefaults.setObject(originalDate, forKey: AlarmUserSettings.Date.rawValue)
        userDefaults.setObject(Repeat.Once.rawValue, forKey: AlarmUserSettings.Repeat.rawValue)
        
        if (repeatSwitch.on) {
            notification.repeatInterval = NSCalendarUnit.CalendarUnitDay
            userDefaults.setObject(Repeat.Everyday.rawValue, forKey: AlarmUserSettings.Repeat.rawValue)
        }
    }
    
    // Show or hide alarm date picker and repeat switch
    func showHideEditUI(isShow: Bool, isAnimate: Bool, complete: (() -> Void)?) {
        var editAlpha: CGFloat = isShow ? 1.0 : 0.0
        var displayAlpha: CGFloat = isShow ? 0.0 : 1.0
        
        if !isShow {
            if isAnimate {
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
                        self.cancelAlarmContainer.alpha = displayAlpha
                        self.timeLabel.alpha = displayAlpha
                        self.repeatLabel.alpha = displayAlpha
                        self.buttonLabel.alpha = self.buttonLabelAlpha
                    })
                    }, completion: { finished in
                        complete?()
                })

            } else {
                self.datePicker.alpha = editAlpha
                self.repeatContainer.alpha = editAlpha
                self.setAlarmButton.alpha = editAlpha
                self.datePickerContainer.frame = CGRectMake(0, 0, self.screenSize.width, self.displayContainerHeight)
                self.cancelAlarmContainer.alpha = displayAlpha
                self.timeLabel.alpha = displayAlpha
                self.repeatLabel.alpha = displayAlpha
                self.buttonLabel.alpha = self.buttonLabelAlpha
            }
        } else {
            if isAnimate {
                UIView.animateKeyframesWithDuration(1, delay: 0, options: nil, animations: {
                    UIView.addKeyframeWithRelativeStartTime(0, relativeDuration: 0.5, animations: {
                        self.cancelAlarmContainer.alpha = displayAlpha
                        self.dismissAlarmContainer.alpha = displayAlpha
                        self.timeLabel.alpha = displayAlpha
                        self.repeatLabel.alpha = displayAlpha
                        self.buttonLabel.alpha = displayAlpha
                    })
                    
                    UIView.addKeyframeWithRelativeStartTime(0.2, relativeDuration: 0.7, animations: {
                        self.datePickerContainer.frame = CGRectMake(0, 0, self.screenSize.width, self.screenSize.height)
                    })
                    
                    UIView.addKeyframeWithRelativeStartTime(0.7, relativeDuration: 0.3, animations: {
                        self.datePicker.alpha = editAlpha
                        self.repeatContainer.alpha = editAlpha
                        self.setAlarmButton.alpha = editAlpha
                    })
                    }, completion: { finished in
                        complete?()
                })
            } else {
                self.cancelAlarmContainer.alpha = displayAlpha
                self.dismissAlarmContainer.alpha = displayAlpha
                self.timeLabel.alpha = displayAlpha
                self.repeatLabel.alpha = displayAlpha
                self.buttonLabel.alpha = displayAlpha
                self.datePickerContainer.frame = CGRectMake(0, 0, self.screenSize.width, self.screenSize.height)
                self.datePicker.alpha = editAlpha
                self.repeatContainer.alpha = editAlpha
                self.setAlarmButton.alpha = editAlpha
            }
        }
    }
    
    func centerTextLabel(textLabel: UILabel) {
        textLabel.sizeToFit()
        textLabel.center = CGPointMake(UIScreen.mainScreen().bounds.width/2, textLabel.center.y)
        textLabel.textAlignment = NSTextAlignment.Center
    }
    
    // Display current alarm time and repeat setting
    func displayAlarmInfo() {
        var dateFormatter = NSDateFormatter()
        dateFormatter.timeStyle = NSDateFormatterStyle.ShortStyle
        
        if (userDefaults.objectForKey(AlarmUserSettings.Date.rawValue) != nil) {
            var date = userDefaults.objectForKey(AlarmUserSettings.Date.rawValue) as! NSDate
            var strDate = dateFormatter.stringFromDate(date)
            timeLabel.text = strDate
        }
        
        if (userDefaults.objectForKey(AlarmUserSettings.Repeat.rawValue) != nil) {
            var repeatStr = userDefaults.objectForKey(AlarmUserSettings.Repeat.rawValue) as! String
            repeatLabel.text = repeatStr
        }
        
        centerTextLabel(repeatLabel)
        centerTextLabel(timeLabel)
    }
    
    // Alarm state controller
    func updateAlarmState(state: State, isAnimate: Bool, complete: (() -> Void)?) {
        // If user default doesn't have alarm setting yet, default to Unset
        if (userDefaults.objectForKey(AlarmUserSettings.Date.rawValue) == nil) {
            currentState = State.Unset
        }
        
        currentState = state
        
        if currentState == State.Unset {
            showHideEditUI(true, isAnimate: isAnimate, complete: complete)
        }
        else {
            displayAlarmInfo()
            showHideEditUI(false, isAnimate: isAnimate, complete: complete)
        }
        
        if (currentState == State.Set) {
            dismissAlarmContainer.alpha = 0
            buttonLabel.text = "DRAG TO CANCEL"
            centerTextLabel(buttonLabel)
        }
        
        if (currentState == State.Triggered) {
            dismissAlarmContainer.alpha = 1
            cancelAlarmContainer.alpha = 0
            buttonLabel.text = "DRAG TO DISMISS"
            centerTextLabel(buttonLabel)
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
