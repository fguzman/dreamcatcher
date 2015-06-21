//
//  DreamCollectionViewController.swift
//  dreamcatcher
//
//  Created by Hsin Yi Huang on 6/15/15.
//  Copyright (c) 2015 Francisco Guzman. All rights reserved.
//

import UIKit

class DreamCollectionViewController: UIViewController, UICollectionViewDataSource, UICollectionViewDelegate, UIPageViewControllerDataSource {
    
    var hasNewJournal: Bool = false
    var journalTransition: JournalTransition!
    var currentRowIndex: NSIndexPath!

    @IBOutlet weak var collectionView: UICollectionView!
    
    var pageViewController: UIPageViewController!
    
    // Nav buttons
    @IBOutlet weak var settingButton: UIButton!
    @IBOutlet weak var alarmButton: UIButton!
    @IBOutlet weak var composeButton: UIButton!
    @IBOutlet weak var alarmTimeLabel: UILabel!
    
    var dateArray = ["JUNE 17", "JUNE 14", "MAY 7", "APRIL 20", "APRIL 15", "MARCH 28"]
    var titleArray = ["Underwater world with corals", "Diamond Man in the cellar", "I know or don't know you", "Do you want to inspect your piano", "The invisible murder witness", "Undercover investigator"]
    var paragraphArray = [
        "Lorem ipsum dolor sit er elit lamet, consectetaur cillium adipisicing pecu, sed do eiusmod tempor incididunt ut labore et dolore magna aliqua. Ut enim ad minim veniam, quis nostrud exercitation ullamco laboris nisi ut aliquip ex ea commodo consequat. Duis aute irure dolor in reprehenderit in voluptate velit esse cillum dolore eu fugiat nulla pariatur. Excepteur sint occaecat cupidatat non proident, ",
        "We were lined up at the gate. The guards took everything from us, and checked us before pushing us into the cellar. When it was my turn, they checked all my pockets, making sure I had no valuables on me. Then they pasted a piece of tiny diamond on my thumb. \"If you ever find the Diamond Man. Bring him to us. Your freedom will be granted.\" The underground cellar was like an underground community. There were markets ran by fellow prisoners who allow other people barter for goods. There were merchants, fortune tellers, children, and elders. ",
        "It was at a hike to Alps when I saw this shop at the side of the street of this tiny French village. I walked into the shop, but there was no one there. The entire shop smells of dust and woods, like it has not been visited for a long time. I opened the door again to go back to the street, only to find myself standing at the doorway of a tower at the edge of a cliff. I looked back again, realizing that the shop was no longer there. Instead I saw a spiral stoned staircase. At the bottom of the stairs, I found yet another door. I opened the door an empty theater with rows and rows of wooden seats facing a circular stage. ",
        "Lorem ipsum dolor sit er elit lamet, consectetaur cillium adipisicing pecu, sed do eiusmod tempor incididunt ut labore et dolore magna aliqua. Ut enim ad minim veniam, quis nostrud exercitation ullamco laboris nisi ut aliquip ex ea commodo consequat. Duis aute irure dolor in reprehenderit in voluptate velit esse cillum dolore eu fugiat nulla pariatur. Excepteur sint occaecat cupidatat non proident, ",
        "Lorem ipsum dolor sit er elit lamet, consectetaur cillium adipisicing pecu, sed do eiusmod tempor incididunt ut labore et dolore magna aliqua. Ut enim ad minim veniam, quis nostrud exercitation ullamco laboris nisi ut aliquip ex ea commodo consequat. Duis aute irure dolor in reprehenderit in voluptate velit esse cillum dolore eu fugiat nulla pariatur. Excepteur sint occaecat cupidatat non proident, ",
        "Lorem ipsum dolor sit er elit lamet, consectetaur cillium adipisicing pecu, sed do eiusmod tempor incididunt ut labore et dolore magna aliqua. Ut enim ad minim veniam, quis nostrud exercitation ullamco laboris nisi ut aliquip ex ea commodo consequat. Duis aute irure dolor in reprehenderit in voluptate velit esse cillum dolore eu fugiat nulla pariatur. Excepteur sint occaecat cupidatat non proident, "
    ]
    var imageArray = [UIImage]()
    
    let defaultNavAlpha: CGFloat = 0.7
    let userDefaults: NSUserDefaults = NSUserDefaults.standardUserDefaults()
    let hardcodedJournals: Int = 6
    
    override func viewDidLoad() {
        super.viewDidLoad()
        //setting background images
        for i in 1...dateArray.count {
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
        currentRowIndex = NSIndexPath(forRow: 0, inSection: 0)
        // Do any additional setup after loading the view.
       
        // Set all nav buttons to 70% alpha by default
        settingButton.alpha = defaultNavAlpha
        alarmButton.alpha = defaultNavAlpha
        composeButton.alpha = defaultNavAlpha
        alarmTimeLabel.alpha = 0
        
        pageViewController = UIPageViewController(transitionStyle: UIPageViewControllerTransitionStyle.Scroll, navigationOrientation: UIPageViewControllerNavigationOrientation.Horizontal, options: nil)
        pageViewController.dataSource = self
        pageViewController.view.backgroundColor = UIColor(white: 1, alpha: 0)
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
        
        if hasNewJournal {
            collectionView.reloadData()
            hasNewJournal = false
        }
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    @IBAction func unwindToSegue (segue : UIStoryboardSegue) {
        println("UNWIND TO SEGUE")
    }
    
    func collectionView(collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int{        
        return titleArray.count
    }
    
    func collectionView(collectionView: UICollectionView, didSelectItemAtIndexPath indexPath: NSIndexPath){
        currentRowIndex = indexPath
        NSLog("You selected cell number: \(currentRowIndex.row)!")

        // This acts like pageViewController.reloadData
        pageViewController.dataSource = nil;
        pageViewController.dataSource = self;
        
        pageViewController.setViewControllers([journalViewControllerAtIndex(currentRowIndex.row)], direction: UIPageViewControllerNavigationDirection.Forward, animated: true, completion: nil)

        journalTransition = JournalTransition()
        pageViewController.modalPresentationStyle = UIModalPresentationStyle.Custom
        pageViewController.transitioningDelegate = journalTransition
        presentViewController(pageViewController, animated: true, completion: nil)
    
    }
    
    
    func collectionView(collectionView: UICollectionView, cellForItemAtIndexPath indexPath: NSIndexPath) -> UICollectionViewCell{
       
        var cell = collectionView.dequeueReusableCellWithReuseIdentifier("cardCollectionViewCell", forIndexPath: indexPath) as! CardCollectionViewCell
        
        cell.titleLabel.text = titleArray[indexPath.row]
        cell.dateLabel.text = dateArray[indexPath.row]
        cell.textView.text = paragraphArray[indexPath.row]
        cell.backgroundImageView.image = imageArray[indexPath.row]
        
        return cell
    }
    
    func pageViewController(pageViewController: UIPageViewController, viewControllerBeforeViewController viewController: UIViewController) -> UIViewController? {
        var journalViewController = viewController as! JournalViewController
        if journalViewController.index > 1 {
            return journalViewControllerAtIndex(journalViewController.index - 1)
        }
        
        return nil
    }
    
    func pageViewController(pageViewController: UIPageViewController, viewControllerAfterViewController viewController: UIViewController) -> UIViewController? {
        var journalViewController = viewController as! JournalViewController
        if journalViewController.index < dateArray.count - 1 {
            return journalViewControllerAtIndex(journalViewController.index + 1)
        }

        return nil
    }
    
    func journalViewControllerAtIndex(index: Int) -> JournalViewController {
        var storyboard = UIStoryboard(name: "Main", bundle: nil)
        var journalViewController = storyboard.instantiateViewControllerWithIdentifier("JournalViewController") as! JournalViewController

        journalViewController.paragraph = paragraphArray[index]
        journalViewController.titleText = titleArray[index]
        journalViewController.dateText = dateArray[index]
        journalViewController.image = imageArray[index]
        journalViewController.index = index
        
        
        return journalViewController
    }
    
    @IBAction func onPan(sender: UIPanGestureRecognizer) {
        //var cell = sender.view as! CardCollectionViewCell
        //var indexPath = collectionView.indexPathForCell(cell)!
        
        if sender.state == UIGestureRecognizerState.Began{
            println("pan")
            println(sender.view)
            
        }
        else if sender.state == UIGestureRecognizerState.Changed{
        }
        else if sender.state == UIGestureRecognizerState.Ended{
            
            performSegueWithIdentifier("journalDetailSegue", sender: nil)
        }
        
    }
}
