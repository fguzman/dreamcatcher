//
//  HomeViewController.swift
//  dreamcatcher
//
//  Created by Sara Lin on 6/13/15.
//  Copyright (c) 2015 Francisco Guzman. All rights reserved.
//

import UIKit

class HomeViewController: UIViewController {
    
    override func viewDidLoad() {
        super.viewDidLoad()

        // Do any additional setup after loading the view.
        var date = NSDate()
        date = date.dateByAddingTimeInterval(10)
        setLocalNotification(date)
    }
    
    func setLocalNotification (firedate: NSDate) {
        var notification: UILocalNotification = UILocalNotification()
        notification.fireDate = firedate
        notification.alertBody = "It's a new day!"
        notification.soundName = "alarm_sound_3.mp3"
        UIApplication.sharedApplication().scheduleLocalNotification(notification)
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
