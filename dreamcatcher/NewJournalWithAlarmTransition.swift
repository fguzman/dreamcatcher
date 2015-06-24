//
//  NewJournalWithAlarmTransition.swift
//  dreamcatcher
//
//  Created by Hsin Yi Huang on 6/23/15.
//  Copyright (c) 2015 Francisco Guzman. All rights reserved.
//

import UIKit

class NewJournalWithAlarmTransition: BaseTransition {
    override func presentTransition(containerView: UIView, fromViewController: UIViewController, toViewController: UIViewController) {
        
        toViewController.view.frame.origin.y = containerView.frame.size.height
        
        UIView.animateWithDuration(0.3, animations: {
            toViewController.view.frame.origin.y = 0
            toViewController.view.alpha = 1
            }) { (finished: Bool) -> Void in
                self.finish()
        }
    }
    
    override func dismissTransition(containerView: UIView, fromViewController: UIViewController, toViewController: UIViewController) {
        
        var alarmNavController = fromViewController as! AlarmNavController
        var dreamCollectionViewController = toViewController as! DreamCollectionViewController
        
        
        if alarmNavController.exitButtonName == "close" || alarmNavController.exitButtonName == "set" {
            
            UIView.animateWithDuration(0.3, animations: {
                fromViewController.view.frame.origin.y = containerView.frame.size.height
                }) { (finished: Bool) -> Void in
                    dreamCollectionViewController.viewDidAppear(true)
                    self.finish()
            }
        }//if
            
            
        else if alarmNavController.exitButtonName == "done"{
            
            var dreamComposeViewController = alarmNavController.topViewController as! DreamComposeViewController
            
            var transitionView =  UIView()
            var titleLabel = UILabel()
            var dateLabel =  UILabel()
            var textView = UITextView()
            var backgroundImageView = UIImageView()
            var fullTextView = UITextView()
            
            var collectionView = dreamCollectionViewController.collectionView
            var indexPath = NSIndexPath(forRow: 0, inSection: 0)
            
            dreamCollectionViewController.collectionView.scrollToItemAtIndexPath(indexPath, atScrollPosition: UICollectionViewScrollPosition.CenteredHorizontally, animated: true)
            dreamCollectionViewController.currentRowIndex = NSIndexPath(forRow: 0, inSection: 0)
            
            
            var selectedCell: CardCollectionViewCell
            
            if dreamCollectionViewController.collectionView.indexPathsForVisibleItems()[0].row != 0{
                selectedCell = dreamCollectionViewController.collectionView.cellForItemAtIndexPath(dreamCollectionViewController.collectionView.indexPathsForVisibleItems()[1] as! NSIndexPath) as! CardCollectionViewCell
            }
            else{
                selectedCell = dreamCollectionViewController.collectionView.cellForItemAtIndexPath(dreamCollectionViewController.currentRowIndex) as! CardCollectionViewCell
            }
            
            
            
            
            var cellFrame = containerView.convertRect(selectedCell.frame, fromView: selectedCell.superview)
            
            transitionView.backgroundColor = UIColor(white:1, alpha:1)
            transitionView.frame = dreamComposeViewController.view.frame
            println(transitionView.frame)
            
            backgroundImageView.frame = dreamComposeViewController.styleScrollView.frame
            backgroundImageView.image = dreamCollectionViewController.imageArray[0]
            backgroundImageView.clipsToBounds = true
            
            
            
            fullTextView.text = dreamComposeViewController.composeTextView.text
            fullTextView.font = UIFont(name: selectedCell.textView.font.fontName, size: 20)
            textView.text = dreamComposeViewController.composeTextView.text
            textView.frame = dreamComposeViewController.composeTextView.frame
            textView.font = UIFont(name: selectedCell.textView.font.fontName, size: 20)
            
            
            titleLabel.text = dreamComposeViewController.titleTextView.text
            titleLabel.frame = dreamComposeViewController.titleTextView.frame
            titleLabel.font = UIFont(name: selectedCell.titleLabel.font.fontName, size: 28)
            titleLabel.textColor = UIColor.whiteColor()
            dateLabel.text = dreamComposeViewController.dateLabel.text
            dateLabel.frame = dreamComposeViewController.dateLabel.frame
            dateLabel.textColor = UIColor.whiteColor()
            dateLabel.font = UIFont(name: selectedCell.dateLabel.font.fontName, size: 11)
            
            transitionView.clipsToBounds = true
            
            transitionView.addSubview(backgroundImageView)
            transitionView.addSubview(titleLabel)
            transitionView.addSubview(dateLabel)
            transitionView.addSubview(textView)
            transitionView.addSubview(fullTextView)

            fromViewController.view.alpha = 0
            (fromViewController as! AlarmNavController).topViewController.view.alpha = 0
            containerView.backgroundColor = UIColor(white:0, alpha:1)
            var window = UIApplication.sharedApplication().keyWindow
            window?.addSubview(transitionView)
            UIView.animateWithDuration(duration, animations: {
                transitionView.frame.size = selectedCell.frame.size
                transitionView.frame.origin = CGPoint(x: dreamCollectionViewController.collectionView.contentInset.left, y:cellFrame.origin.y)
                backgroundImageView.frame = selectedCell.backgroundImageView.frame
                titleLabel.frame = selectedCell.titleLabel.frame
                dateLabel.frame = selectedCell.dateLabel.frame
                textView.frame.origin = selectedCell.textView.frame.origin
                textView.alpha = 1
                fullTextView.alpha = 0
                fullTextView.frame.origin = selectedCell.textView.frame.origin
                containerView.backgroundColor = UIColor(white:0, alpha:0)
                }) { (finished: Bool) -> Void in
                    transitionView.removeFromSuperview()
                    dreamCollectionViewController.collectionView.reloadData()
                    dreamCollectionViewController.viewDidAppear(true)
                    self.finish()
            }

        }//else
        
        
        
    }//dismiss

   
}
