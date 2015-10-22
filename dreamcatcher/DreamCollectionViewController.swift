//
//  DreamCollectionViewController.swift
//  dreamcatcher
//
//  Created by Hsin Yi Huang on 6/15/15.
//  Copyright (c) 2015 Francisco Guzman. All rights reserved.
//

import UIKit

class DreamCollectionViewController: UIViewController, UICollectionViewDataSource, UICollectionViewDelegate, UIPageViewControllerDataSource {
    
    var journals: [PFObject]! = []
    
    var hasNewJournal: Bool = false
    var journalTransition: JournalTransition!
    var currentRowIndex: NSIndexPath!
    var newJournalTransition: NewJournalTransition!
    var newJournalWithAlarmTransition: NewJournalWithAlarmTransition!
    
    @IBOutlet weak var statsView: UIView!
    
    @IBOutlet weak var collectionView: UICollectionView!
    
    var pageViewController: UIPageViewController!
    
    // Nav buttons
    @IBOutlet weak var settingButton: UIButton!
    @IBOutlet weak var alarmButton: UIButton!
    @IBOutlet weak var composeButton: UIButton!
    @IBOutlet weak var alarmTimeLabel: UILabel!
    @IBOutlet weak var alarmTimeContainer: UIView!
    @IBOutlet weak var themeButton: UIButton!
    @IBOutlet weak var placesButton: UIButton!
    @IBOutlet weak var emotionsButton: UIButton!
    
    
    //tabs
    @IBOutlet weak var themeCountLabel: UILabel!
    @IBOutlet weak var themeLabel: UILabel!
    
    @IBOutlet weak var placesCountLabel: UILabel!
    @IBOutlet weak var placesLabel: UILabel!
    
    @IBOutlet weak var emotionCountLabel: UILabel!
    @IBOutlet weak var emotionLabel: UILabel!
    
    //colors
    let blueColor = UIColor(red: 0/255, green: 155/255, blue: 255/255, alpha: 1)
    let yellowColor = UIColor(red: 245/255, green: 189/255, blue: 35/255, alpha: 1)
    let orangeColor = UIColor(red: 255/255, green: 108/255, blue: 0/255, alpha: 1)
    
    var themeTabTapCount: Int = 0
    var placeTabTapCount: Int = 0
    var emotionTabTapCount: Int = 0
    
    var themeActive: Bool = false
    var placeActive: Bool = false
    var emotionActive: Bool = false
    
    
    @IBOutlet weak var statsBackButton: UIButton!
    
    var imageArray = [UIImage]()
    
    let defaultNavAlpha: CGFloat = 0.7
    let userDefaults: NSUserDefaults = NSUserDefaults.standardUserDefaults()
    let hardcodedJournals: Int = 6
    
    var statsViewController: StatsViewController!
    
    override func viewDidLoad() {
        
        super.viewDidLoad()
        
        NSNotificationCenter.defaultCenter().addObserver(self, selector: "segueToAlarm", name: UIApplicationWillEnterForegroundNotification, object: nil)
        NSNotificationCenter.defaultCenter().addObserver(self, selector: "launchAnimation", name: UIApplicationDidFinishLaunchingNotification, object: nil)
        
        //setting background images
        for i in 1...3 {
            
            var image: UIImage!
            
            if i <= hardcodedJournals {
                image = UIImage(named: "bg\(i)")
            } else {
                // hardcoding image for now, to be changed later
                image = UIImage(named: "bg6")
            }
            
            imageArray.append(image!)
        }
        
        collectionView.delegate = self
        collectionView.dataSource = self
        
        let timer = NSTimer.scheduledTimerWithTimeInterval(1, target: self, selector: "onTimer", userInfo: nil, repeats: true)
        
        timer.fire()
        
        currentRowIndex = NSIndexPath(forRow: 0, inSection: 0)
        // Do any additional setup after loading the view.
        
        // Set all nav buttons to 70% alpha by default
        settingButton.alpha = defaultNavAlpha
        alarmButton.alpha = defaultNavAlpha
        composeButton.alpha = defaultNavAlpha
        alarmTimeContainer.alpha = 0
        alarmTimeLabel.alpha = 1
        
        pageViewController = UIPageViewController(transitionStyle: UIPageViewControllerTransitionStyle.Scroll, navigationOrientation: UIPageViewControllerNavigationOrientation.Horizontal, options: nil)
        pageViewController.dataSource = self
        //var redSquare = UIView(frame: CGRect(x: 0, y: 0, width: 20, height: 20))
        //redSquare.backgroundColor = UIColor.redColor()
        //pageViewController.view.addSubview(redSquare)
        
        
        let storyboard = UIStoryboard(name: "Main", bundle:nil)
        statsViewController = storyboard.instantiateViewControllerWithIdentifier("StatsViewController") as! StatsViewController
        
        statsViewController.view.frame = statsView.bounds
        addChildViewController(statsViewController)
        statsView.addSubview(statsViewController.view)
        statsView.addSubview(statsBackButton)
        
        statsViewController.dreamVC = self
    }
    
    func onTimer() {
        let query = PFQuery(className: "Journal")
        query.whereKey("user", equalTo: PFUser.currentUser()!)
        query.orderByDescending("createdAt")
        query.findObjectsInBackgroundWithBlock { (results: [AnyObject]?, error: NSError?) -> Void in
            self.journals = results as! [PFObject]
            self.collectionView.reloadData()
        }
    }
    
    override func viewDidAppear(animated: Bool) {
        if (userDefaults.objectForKey(AlarmViewController.AlarmUserSettings.Date.rawValue) != nil) {
            let dateFormatter = NSDateFormatter()
            dateFormatter.timeStyle = NSDateFormatterStyle.ShortStyle
            let date = userDefaults.objectForKey(AlarmViewController.AlarmUserSettings.Date.rawValue) as! NSDate
            let strDate = dateFormatter.stringFromDate(date)
            alarmTimeLabel.text = strDate
            alarmTimeLabel.sizeToFit()
            alarmTimeLabel.textAlignment = NSTextAlignment.Center
            alarmTimeLabel.center = CGPointMake(alarmTimeContainer.bounds.width/2, alarmTimeLabel.center.y)
            
            // Fade in the alarm time label
            UIView.animateWithDuration(0.5, delay: 0.1, options: .CurveEaseInOut, animations: {
                self.alarmButton.alpha = 1
                self.alarmTimeContainer.alpha = 1
                }, completion: nil)
        } else {
            // Fade out the alarm time label
            UIView.animateWithDuration(0.5, delay: 0.1, options: .CurveEaseInOut, animations: {
                self.alarmButton.alpha = self.defaultNavAlpha
                self.alarmTimeContainer.alpha = 0
                }, completion: nil)
        }
        
        if hasNewJournal {
            collectionView.reloadData()
            hasNewJournal = false
        }
    }
    
    func segueToAlarm() {
        if AlarmViewController.getCurrentAlarmState() == AlarmViewController.State.Triggered {
            performSegueWithIdentifier("dreamToAlarmSegue", sender: self)
        }
    }
    
    func launchAnimation() {
        collectionView.alpha = 0
        let initialCollectionCenter = collectionView.center
        collectionView.center = CGPointMake(initialCollectionCenter.x, initialCollectionCenter.y + 20)
        collectionView.transform = CGAffineTransformScale(CGAffineTransformIdentity, 1.05, 1.05)
        
        UIView.animateWithDuration(0.8, delay: 0.3, usingSpringWithDamping: 0.7, initialSpringVelocity: 0.05, options: UIViewAnimationOptions.CurveEaseInOut, animations: { () -> Void in
            self.collectionView.alpha = 1
            self.collectionView.center = initialCollectionCenter
            self.collectionView.transform = CGAffineTransformIdentity
            }, completion: nil)
    }
    
    deinit {
        NSNotificationCenter.defaultCenter().removeObserver(self)
    }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    @IBAction func unwindToSegue (segue : UIStoryboardSegue) {
        //        println("UNWIND TO SEGUE")
    }
    
    @IBAction func onThemeButtonPress(sender: AnyObject) {
        if !themeActive && !placeActive && !emotionActive {
            themeActive=true
            placeActive=false
            emotionActive=false
            
            //special case
            
            
            UIView.animateWithDuration(0.8, delay: 0, usingSpringWithDamping: 0.7, initialSpringVelocity: 0.05, options: UIViewAnimationOptions.CurveEaseInOut, animations: { () -> Void in
                self.themeCountLabel.textColor = self.blueColor
                self.themeLabel.textColor = self.blueColor
                }, completion: nil)
            
            statsViewController.scrollView.contentOffset=CGPoint(x: 0,y: 0)
            
            revealStatsView()
        } else if !themeActive {
            themeActive=true
            placeActive=false
            emotionActive=false
            refreshTabColors()
            didChangeTabToTabNumber(1)
        } else if themeActive {
            refreshTabColors()
            self.closeStatsView()
            themeActive = false
            placeActive=false
            emotionActive=false
        }
    }
    
    
    @IBAction func onPlaceButtonPress(sender: AnyObject) {
        
        if !themeActive && !placeActive && !emotionActive {
            placeActive=true
            themeActive=false
            emotionActive=false
            
            //special case
            placesCountLabel.textColor = yellowColor
            placesLabel.textColor = yellowColor
            statsViewController.scrollView.contentOffset=CGPoint(x: 320,y: 0)
            
            revealStatsView()
        } else if !placeActive {
            placeActive=true
            themeActive=false
            emotionActive=false
            refreshTabColors()
            didChangeTabToTabNumber(2)
        } else if placeActive {
            refreshTabColors()
            self.closeStatsView()
            themeActive = false
            placeActive=false
            emotionActive=false
        }
    }
    
    @IBAction func onEmotionButtonPress(sender: AnyObject) {
        
        if !themeActive && !placeActive && !emotionActive {
            emotionActive=true
            themeActive=false
            placeActive=false
            
            //special case
            //special case
            emotionCountLabel.textColor = orangeColor
            emotionLabel.textColor = orangeColor
            statsViewController.scrollView.contentOffset=CGPoint(x: 640,y: 0)
            
            revealStatsView()
        } else if !emotionActive {
            emotionActive=true
            themeActive=false
            placeActive=false
            refreshTabColors()
            didChangeTabToTabNumber(3)
        } else if emotionActive {
            refreshTabColors()
            self.closeStatsView()
            themeActive = false
            placeActive=false
            emotionActive=false
        }
    }
    
    
    func collectionView(collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int{
        return journals.count
    }
    
    func collectionView(collectionView: UICollectionView, didSelectItemAtIndexPath indexPath: NSIndexPath){
        currentRowIndex = indexPath
        //NSLog("You selected cell number: \(currentRowIndex.row)!")
        
        
        // This acts like pageViewController.reloadData
        pageViewController.dataSource = nil
        pageViewController.dataSource = self
        
        pageViewController.setViewControllers([journalViewControllerAtIndex(currentRowIndex.row)], direction: UIPageViewControllerNavigationDirection.Forward, animated: false, completion: nil)
        
        journalTransition = JournalTransition()
        pageViewController.modalPresentationStyle = UIModalPresentationStyle.Custom
        pageViewController.transitioningDelegate = journalTransition
        presentViewController(pageViewController, animated: true, completion: nil)
        pageViewController.reloadInputViews()
        
    }
    
    
    func collectionView(collectionView: UICollectionView, cellForItemAtIndexPath indexPath: NSIndexPath) -> UICollectionViewCell{
        
        let cell = collectionView.dequeueReusableCellWithReuseIdentifier("cardCollectionViewCell", forIndexPath: indexPath) as! CardCollectionViewCell
        
        let journal = journals[indexPath.row]
        
        cell.titleLabel.text = journal["title"] as? String
        cell.dateLabel.text = journal["date"] as? String
        cell.textView.text = journal["body"] as? String
        //cell.backgroundImageView.image = imageArray[indexPath.row]
        
        let tmpTextView = paragraphStyle(cell.textView.text)
        cell.textView.attributedText = tmpTextView.attributedText
        cell.textView.font = tmpTextView.font
        
        return cell
    }
    
    func collectionView(collectionView: UICollectionView,
        layout collectionViewLayout: UICollectionViewLayout,
        sizeForItemAtIndexPath indexPath: NSIndexPath) -> CGSize {
            let deviceSize = UIScreen.mainScreen().applicationFrame.size
            let collectionSize = collectionView.bounds.size
            let collectionFlowLayout: UICollectionViewFlowLayout = collectionViewLayout as! UICollectionViewFlowLayout
            let cellHeight = collectionSize.height - collectionFlowLayout.sectionInset.top - collectionFlowLayout.sectionInset.bottom
            let cellWidth = deviceSize.width - collectionFlowLayout.sectionInset.left - collectionFlowLayout.sectionInset.right
            return CGSize(width: cellWidth, height: cellHeight)
    }
    
    func pageViewController(pageViewController: UIPageViewController, viewControllerBeforeViewController viewController: UIViewController) -> UIViewController? {
        let journalViewController = viewController as! JournalViewController
        //        println("Fetching for previous page from page: \(journalViewController.index)")
        if journalViewController.index > 0 {
            let previousJournal = journalViewControllerAtIndex(journalViewController.index - 1)
            return previousJournal
        }
        
        return nil
    }
    
    func pageViewController(pageViewController: UIPageViewController, viewControllerAfterViewController viewController: UIViewController) -> UIViewController? {
        let journalViewController = viewController as! JournalViewController
        if journalViewController.index < journals.count - 1 {
            return journalViewControllerAtIndex(journalViewController.index + 1)
        }
        
        return nil
    }
    
    func journalViewControllerAtIndex(index: Int) -> JournalViewController {
        let storyboard = UIStoryboard(name: "Main", bundle: nil)
        let journalViewController = storyboard.instantiateViewControllerWithIdentifier("JournalViewController") as! JournalViewController
        
        let journal = journals[index]
        
        journalViewController.paragraph = journal["body"] as? String
        journalViewController.titleText = journal["title"] as? String
        journalViewController.dateText = journal["date"] as? String
        
        journalViewController.image = imageArray[1]
        journalViewController.index = index
        
        return journalViewController
    }
    
    @IBAction func onPan(sender: UIPanGestureRecognizer) {
        //var cell = sender.view as! CardCollectionViewCell
        //var indexPath = collectionView.indexPathForCell(cell)!
        
        if sender.state == UIGestureRecognizerState.Began{
            print("pan")
            print(sender.view)
            
        }
        else if sender.state == UIGestureRecognizerState.Changed{
        }
        else if sender.state == UIGestureRecognizerState.Ended{
            
            performSegueWithIdentifier("journalDetailSegue", sender: nil)
        }
        
    }
    
    func revealStatsView() {
        UIView.animateWithDuration(0.5, animations: { () -> Void in
            self.statsView.frame.origin.y = 172
            self.collectionView.frame.origin.y = self.view.frame.size.height
            self.collectionView.alpha = 0
        })
    }
    
    
    @IBAction func onStatsBackButtonPressed(sender: AnyObject) {
        refreshTabColors()
        UIView.animateWithDuration(0.5, animations: { () -> Void in
            self.statsView.frame.origin.y = -250
            self.collectionView.frame.origin.y = 172
            self.collectionView.alpha = 1
        })
    }
    
    func closeStatsView() {
        refreshTabColors()
        UIView.animateWithDuration(0.5, animations: { () -> Void in
            self.statsView.frame.origin.y = -250
            self.collectionView.frame.origin.y = 172
            self.collectionView.alpha = 1
        })
    }
    
    func refreshTabColors() {
        themeCountLabel.textColor = UIColor.blackColor()
        themeLabel.textColor = UIColor.blackColor()
        
        placesCountLabel.textColor = UIColor.blackColor()
        placesLabel.textColor = UIColor.blackColor()
        
        emotionCountLabel.textColor = UIColor.blackColor()
        emotionLabel.textColor = UIColor.blackColor()
    }
    
    func didChangeTabToTabNumber(tabNumber: Int) {
        if tabNumber == 1 {
            refreshTabColors()
            themeCountLabel.textColor = blueColor
            themeLabel.textColor = blueColor
            UIView.animateWithDuration(0.5, animations: { () -> Void in
                self.statsViewController.scrollView.contentOffset=CGPoint(x: 0,y: 0)
            })
            
        } else if tabNumber == 2 {
            refreshTabColors()
            placesCountLabel.textColor = yellowColor
            placesLabel.textColor = yellowColor
            UIView.animateWithDuration(0.5, animations: { () -> Void in
                self.statsViewController.scrollView.contentOffset=CGPoint(x: 320,y: 0)
            })
            
        } else if tabNumber == 3 {
            refreshTabColors()
            emotionCountLabel.textColor = orangeColor
            emotionLabel.textColor = orangeColor
            UIView.animateWithDuration(0.5, animations: { () -> Void in
                self.statsViewController.scrollView.contentOffset=CGPoint(x: 640,y: 0)
            })
        } else {
            
        }
    }
    
    override func prepareForSegue(segue: UIStoryboardSegue, sender: AnyObject?) {
        if segue.identifier == "composeSegue"{
            print("compose Segue")
            
            let destinationVC = segue.destinationViewController as! DreamComposeViewController
            destinationVC.modalPresentationStyle = UIModalPresentationStyle.Custom
            newJournalTransition = NewJournalTransition()
            destinationVC.transitioningDelegate = newJournalTransition
            
        }
        else if segue.identifier == "dreamToAlarmSegue"{
            
            let destinationVC = segue.destinationViewController as! AlarmNavController
            destinationVC.modalPresentationStyle = UIModalPresentationStyle.Custom
            newJournalWithAlarmTransition = NewJournalWithAlarmTransition()
            destinationVC.transitioningDelegate = newJournalWithAlarmTransition
        }
    }
    
    
}
