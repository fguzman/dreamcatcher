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
    var currentRowIndex: NSIndexPath!

    @IBOutlet weak var collectionView: UICollectionView!
    
    var numOfCell = 2
    var dateArray = ["JUNE 17", "JUNE 14"]
    var titleArray = ["Underwater world with corals", "Fat Cat Getting Stuck in the Wall"]
    var paragraphArray = [
        "Lorem ipsum dolor sit er elit lamet, consectetaur cillium adipisicing pecu, sed do eiusmod tempor incididunt ut labore et dolore magna aliqua. Ut enim ad minim veniam, quis nostrud exercitation ullamco laboris nisi ut aliquip ex ea commodo consequat. Duis aute irure dolor in reprehenderit in voluptate velit esse cillum dolore eu fugiat nulla pariatur. Excepteur sint occaecat cupidatat non proident, ",
        "My fat cat is so obese that it resembles an overstuff sausage. There were a few times..."
    ]
    
    
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        collectionView.delegate = self
        collectionView.dataSource = self
        currentRowIndex = NSIndexPath(forRow: 0, inSection: 0)
        // Do any additional setup after loading the view.
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    
    func collectionView(collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int{
        return titleArray.count
        
    }
 
    
    
    func collectionView(collectionView: UICollectionView, didSelectItemAtIndexPath indexPath: NSIndexPath){
        currentRowIndex = indexPath
        NSLog("You selected cell number: \(currentRowIndex.row)!")
        performSegueWithIdentifier("journalDetailSegue", sender: nil)
    }
    
    
    func collectionView(collectionView: UICollectionView, cellForItemAtIndexPath indexPath: NSIndexPath) -> UICollectionViewCell{
       
        var cell = collectionView.dequeueReusableCellWithReuseIdentifier("cardCollectionViewCell", forIndexPath: indexPath) as! CardCollectionViewCell
        
        cell.titleLabel.text = titleArray[indexPath.row]
        cell.dateLabel.text = dateArray[indexPath.row]
        cell.textView.text = paragraphArray[indexPath.row]
        
        return cell
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
