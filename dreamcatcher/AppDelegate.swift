//
//  AppDelegate.swift
//  dreamcatcher
//
//  Created by Francisco Guzman on 6/7/15.
//  Copyright (c) 2015 Francisco Guzman. All rights reserved.
//

import UIKit
import AVFoundation

@UIApplicationMain
class AppDelegate: UIResponder, UIApplicationDelegate {

    var alarmViewController: AlarmViewController!
    
    var window: UIWindow?
    var player: AVAudioPlayer! = AVAudioPlayer()
    var fader: iiFaderForAvAudioPlayer!
    var backgroundIdentifier: UIBackgroundTaskIdentifier!
    
    var isPlayerPrepared: Bool = false
    
    let userDefaults: NSUserDefaults = NSUserDefaults.standardUserDefaults()
    let alarmSoundDuration: Int = 23

    func application(application: UIApplication, didFinishLaunchingWithOptions launchOptions: [NSObject: AnyObject]?) -> Bool {
        
        Parse.setApplicationId("6lMW6J4FlIcfwtowQuiRFVFSOQbYrjHd53cVAM0l", clientKey: "ENl3CTOUmgRLhJYira0SQYQfMrPc70t0L1WYNi9y")
        
        // Override point for customization after application launch.
        let types: UIUserNotificationType = [.Alert, .Badge, .Sound]
        application.registerUserNotificationSettings(UIUserNotificationSettings(forTypes: types, categories: nil))
        return true
    }
    
    func application(application: UIApplication, didReceiveLocalNotification notification: UILocalNotification) {
        NSLog("Received local notification")

        // App will start playing from here, so cancelling all sound notifications
        UIApplication.sharedApplication().cancelAllLocalNotifications()
        
        prepareAudio()
        
        if (userDefaults.objectForKey(AlarmViewController.AlarmUserSettings.Date.rawValue) != nil) {
            let calendar = NSCalendar.currentCalendar()

            var firedate = userDefaults.objectForKey("alarm.date") as! NSDate
            var nextFiredate = calendar.dateByAddingUnit(.Second, value: alarmSoundDuration, toDate: firedate, options: [])!
            
            if nextFiredate.compare(NSDate()) == .OrderedDescending {
                fadeInAudio(player)
            } else {
                player.play()
            }
        }
        
        if (alarmViewController != nil) {
            alarmViewController.updateAlarmState(AlarmViewController.State.Triggered, isAnimate: true, complete: nil)
        }
    }
    
    // Prepare for audio session settings for background audio
    func prepareAudio() {
        var path = NSBundle.mainBundle().pathForResource("alarm_sound_normal", ofType: "mp3")
        
        do {
            try player = AVAudioPlayer(contentsOfURL: NSURL(fileURLWithPath: path!), fileTypeHint: nil)
            try AVAudioSession.sharedInstance().setCategory(AVAudioSessionCategoryPlayback)
            try AVAudioSession.sharedInstance().setActive(true)
        }
        catch {
            print(error)
        }

        UIApplication.sharedApplication().beginReceivingRemoteControlEvents()
        player.prepareToPlay()
        player.numberOfLoops = -1
        
        isPlayerPrepared = true
    }
    
    // Fade in music
    func fadeInAudio(player: AVAudioPlayer) {
        player.play()
        player.volume = 0
        fader = iiFaderForAvAudioPlayer(player: player)
        fader.fadeIn(22, velocity: 2, onFinished: nil)
    }
    
    func stopPlayer() {
        if (isPlayerPrepared) {
            if (fader != nil) {
                fader.fadeOut(2, velocity: 2, onFinished: { finished in
                    self.player.stop()
                    self.isPlayerPrepared = false
                    UIApplication.sharedApplication().applicationIconBadgeNumber = 0
                })
            } else {
                    self.player.stop()
                    UIApplication.sharedApplication().applicationIconBadgeNumber = 0
            }
        }
    }
    
    func applicationWillResignActive(application: UIApplication) {
        // Sent when the application is about to move from active to inactive state. This can occur for certain types of temporary interruptions (such as an incoming phone call or SMS message) or when the user quits the application and it begins the transition to the background state.
        // Use this method to pause ongoing tasks, disable timers, and throttle down OpenGL ES frame rates. Games should use this method to pause the game.        
        backgroundIdentifier = UIApplication.sharedApplication().beginBackgroundTaskWithExpirationHandler { () -> Void in
            UIApplication.sharedApplication().endBackgroundTask(self.backgroundIdentifier)
        }
    }

    func applicationDidEnterBackground(application: UIApplication) {
        // Use this method to release shared resources, save user data, invalidate timers, and store enough application state information to restore your application to its current state in case it is terminated later.
        // If your application supports background execution, this method is called instead of applicationWillTerminate: when the user quits.
        UIApplication.sharedApplication().beginReceivingRemoteControlEvents()
    }

    func applicationWillEnterForeground(application: UIApplication) {
        // Called as part of the transition from the background to the inactive state; here you can undo many of the changes made on entering the background.
    }

    func applicationDidBecomeActive(application: UIApplication) {
        // Restart any tasks that were paused (or not yet started) while the application was inactive. If the application was previously in the background, optionally refresh the user interface.
    }

    func applicationWillTerminate(application: UIApplication) {
        // Called when the application is about to terminate. Save data if appropriate. See also applicationDidEnterBackground:.
    }


}

