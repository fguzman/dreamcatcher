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
    
    @IBOutlet weak var editAlarmButton: UIButton!
    @IBOutlet weak var setAlarmButton: UIButton!
    
    @IBOutlet weak var timeLabel: UILabel!
    @IBOutlet weak var repeatLabel: UILabel!
    
    @IBOutlet weak var repeatContainer: UIView!
    @IBOutlet weak var repeatFieldLabel: UILabel!
    @IBOutlet weak var repeatSwitch: UISwitch!
    @IBOutlet weak var datePicker: UIDatePicker!
    @IBOutlet weak var datePickerContainer: UIView!
    
    var currentState: State! = State.Unset
    
    let orangeColor: UIColor = UIColor(red: 255/255, green: 108.0/255, blue: 0.0, alpha: 1)
    let blueColor: UIColor = UIColor(red: 0, green: 153/255, blue: 255/255, alpha: 1)
    let appDelegate = UIApplication.sharedApplication().delegate as! AppDelegate
    let userDefaults: NSUserDefaults = NSUserDefaults.standardUserDefaults()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        editAlarmButton.layer.cornerRadius = editAlarmButton.frame.width/2
        appDelegate.alarmViewController = self

        var tempState = State.Unset
        if (userDefaults.objectForKey("alarm.state") != nil) {
            tempState = State(rawValue: userDefaults.objectForKey("alarm.state") as! String)!
        }
        updateAlarmState(tempState)
    }
    
    func setLocalNotification (firedate: NSDate) {
        // set notification
        var notification: UILocalNotification = UILocalNotification()
        notification.fireDate = firedate
        notification.alertBody = "It's a new day!"
        notification.soundName = "alarm_sound_3.mp3"
        notification.applicationIconBadgeNumber = 1
        
        userDefaults.setObject(firedate, forKey: "alarm")
        userDefaults.setObject(Repeat.Once.rawValue, forKey: "alarm.repeat")
        
        if (repeatSwitch.on) {
            notification.repeatInterval = NSCalendarUnit.CalendarUnitDay
            userDefaults.setObject(Repeat.Everyday.rawValue, forKey: "alarm.repeat")
        }
        
        UIApplication.sharedApplication().scheduleLocalNotification(notification)
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }

    @IBAction func onPressCloseButton(sender: AnyObject) {
        self.dismissViewControllerAnimated(true, completion: nil)
    }
    
    @IBAction func onChangeDatePicker(sender: AnyObject) {
        var dateFormatter = NSDateFormatter()
        dateFormatter.timeStyle = NSDateFormatterStyle.ShortStyle
        var strDate = dateFormatter.stringFromDate(datePicker.date)
    }
    
    @IBAction func onPressSetAlarm(sender: AnyObject) {
        setLocalNotification(datePicker.date)
        updateAlarmState(State.Set)
        self.dismissViewControllerAnimated(true, completion: nil)
    }
    
    // Show or hide alarm date picker and repeat switch
    func showHideEditUI(isShow: Bool) {
        var editAlpha: CGFloat = isShow ? 1.0 : 0.0
        var displayAlpha: CGFloat = isShow ? 0.0 : 1.0
        
        let screenSize: CGRect = UIScreen.mainScreen().bounds
        let displayContainerHeight: CGFloat = 300.0
        
        if !isShow {
            UIView.animateKeyframesWithDuration(1, delay: 0, options: nil, animations: {
                UIView.addKeyframeWithRelativeStartTime(0, relativeDuration: 0.5, animations: {
                    self.datePicker.alpha = editAlpha
                    self.repeatContainer.alpha = editAlpha
                    self.setAlarmButton.alpha = editAlpha
                })
                
                UIView.addKeyframeWithRelativeStartTime(0.2, relativeDuration: 0.7, animations: {
                    self.datePickerContainer.frame = CGRectMake(0, 0, screenSize.width, displayContainerHeight)
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
                    self.timeLabel.alpha = displayAlpha
                    self.repeatLabel.alpha = displayAlpha
                })
                
                UIView.addKeyframeWithRelativeStartTime(0.2, relativeDuration: 0.7, animations: {
                    self.datePickerContainer.frame = CGRectMake(0, 0, screenSize.width, screenSize.height)
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
        var date = userDefaults.objectForKey("alarm") as! NSDate
        var strDate = dateFormatter.stringFromDate(date)
        timeLabel.text = strDate
        timeLabel.sizeToFit()
        
        var repeatStr = userDefaults.objectForKey("alarm.repeat") as! String
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
        if (userDefaults.objectForKey("alarm") == nil) {
            currentState = State.Unset
        }
        
        currentState = state
        
        if currentState == State.Unset {
            showHideEditUI(true)
            
            //cancel notification or stop player
            UIApplication.sharedApplication().cancelAllLocalNotifications()
            appDelegate.stopPlayer()
            userDefaults.removeObjectForKey("alarm")
        }
        else if (currentState == State.Set || currentState == State.Triggered) {
            editAlarmButton.layer.backgroundColor = orangeColor.CGColor
            editAlarmButton.setTitleColor(UIColor.whiteColor(), forState: .Normal)
            
            displayAlarmInfo()
            showHideEditUI(false)
        }
        
        if (currentState == State.Triggered) {
            editAlarmButton.layer.backgroundColor = blueColor.CGColor
        }
        
        userDefaults.setObject(currentState.rawValue, forKey: "alarm.state")

    }
    
    @IBAction func onPressCancelAlarm(sender: AnyObject) {
        updateAlarmState(State.Unset)
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
