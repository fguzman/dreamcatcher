//
//  AlarmViewController.swift
//  dreamcatcher
//
//  Created by Sara Lin on 6/11/15.
//  Copyright (c) 2015 Francisco Guzman. All rights reserved.
//

import UIKit

class AlarmViewController: UIViewController {
    
    enum State {
        case Unset
        case Set
        case Triggered
    }
    
    @IBOutlet weak var editAlarmButton: UIButton!
    @IBOutlet weak var setAlarmButton: UIButton!
    
    @IBOutlet weak var timeLabel: UILabel!
    @IBOutlet weak var repeatLabel: UILabel!
    
    @IBOutlet weak var repeatSwitch: UISwitch!
    @IBOutlet weak var datePicker: UIDatePicker!
    @IBOutlet weak var datePickerContainer: UIView!
    @IBOutlet weak var repeatContainer: UIView!
    
    var currentState: State!
    
    let orangeColor: UIColor = UIColor(red: 255/255, green: 108.0/255, blue: 0.0, alpha: 1)
    let blueColor: UIColor = UIColor(red: 0, green: 153/255, blue: 255/255, alpha: 1)
    let appDelegate = UIApplication.sharedApplication().delegate as! AppDelegate
    let userDefaults: NSUserDefaults = NSUserDefaults.standardUserDefaults()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        editAlarmButton.layer.cornerRadius = editAlarmButton.frame.width/2
        updateAlarmState(State.Unset)
        appDelegate.alarmViewController = self
    }
    
    func setLocalNotification (firedate: NSDate) {
        // set notification
        var notification: UILocalNotification = UILocalNotification()
        notification.fireDate = firedate
        notification.alertBody = "It's a new day!"
        notification.soundName = "alarm_sound_3.mp3"
        notification.applicationIconBadgeNumber = 1
        
        if (repeatSwitch.on) {
            notification.repeatInterval = NSCalendarUnit.CalendarUnitDay
        }
        
        UIApplication.sharedApplication().scheduleLocalNotification(notification)
        
        // add date to user default
        userDefaults.setObject(firedate, forKey: "alarm")
        println(userDefaults.valueForKey("alarm"))
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }

    @IBAction func onPressCloseButton(sender: AnyObject) {
        self.dismissViewControllerAnimated(true, completion: nil)
    }
    
    @IBAction func onPressSetButton(sender: AnyObject) {
        self.dismissViewControllerAnimated(true, completion: nil)
    }
    
    @IBAction func onChangeDatePicker(sender: AnyObject) {
        var dateFormatter = NSDateFormatter()
        dateFormatter.timeStyle = NSDateFormatterStyle.ShortStyle
        var strDate = dateFormatter.stringFromDate(datePicker.date)
        println("user selected date: \(strDate)")
    }
    
    @IBAction func onPressSetAlarm(sender: AnyObject) {
        setLocalNotification(datePicker.date)
        updateAlarmState(State.Set)
    }
    
    func updateAlarmState(state: State) {
        if (state == State.Triggered && currentState != State.Set) {
            println("Error: current state is \(currentState)")
            return
        }
        currentState = state
        
        if currentState == State.Unset {
            editAlarmButton.hidden = true
            repeatContainer.hidden = false
            datePicker.hidden = false
            timeLabel.hidden = true
            repeatLabel.hidden = true
            
            //cancel notification or stop player
            UIApplication.sharedApplication().cancelAllLocalNotifications()
            appDelegate.stopPlayer()
            userDefaults.removeObjectForKey("alarm")
        }
        else if (currentState == State.Set || currentState == State.Triggered) {
            var dateFormatter = NSDateFormatter()
            dateFormatter.timeStyle = NSDateFormatterStyle.ShortStyle
            var strDate = dateFormatter.stringFromDate(datePicker.date)
            timeLabel.text = strDate
            timeLabel.sizeToFit()
            if (repeatSwitch.on) {
                repeatLabel.text = "Everyday"
            } else {
                repeatLabel.text = "Once"
            }
            repeatLabel.sizeToFit()
            
            repeatLabel.center = CGPointMake(UIScreen.mainScreen().bounds.width/2, repeatLabel.center.y)
            repeatLabel.textAlignment = NSTextAlignment.Center
            timeLabel.center = CGPointMake(UIScreen.mainScreen().bounds.width/2, timeLabel.center.y)
            timeLabel.textAlignment = NSTextAlignment.Center
            
            editAlarmButton.layer.backgroundColor = orangeColor.CGColor
            editAlarmButton.setTitleColor(UIColor.whiteColor(), forState: .Normal)
            
            editAlarmButton.hidden = false
            repeatContainer.hidden = true
            datePicker.hidden = true
            timeLabel.hidden = false
            repeatLabel.hidden = false
        }
        
        if (currentState == State.Triggered) {
            editAlarmButton.layer.backgroundColor = blueColor.CGColor
        }
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
