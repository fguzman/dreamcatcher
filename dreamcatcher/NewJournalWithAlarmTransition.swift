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
        
        let alarmNavController = fromViewController as! AlarmNavController
        let dreamCollectionViewController = toViewController as! DreamCollectionViewController
        
        
        if alarmNavController.exitButtonName == "close" || alarmNavController.exitButtonName == "set" {
            
            UIView.animateWithDuration(0.3, animations: {
                fromViewController.view.frame.origin.y = containerView.frame.size.height
                }) { (finished: Bool) -> Void in
                    dreamCollectionViewController.viewDidAppear(true)
                    self.finish()
            }
        }//if
            
            
        else if alarmNavController.exitButtonName == "done"{
            
            fromViewController.view.alpha = 0
            (fromViewController as! AlarmNavController).topViewController!.view.alpha = 0
            containerView.backgroundColor = UIColor(white:0, alpha:1)
            
            let dreamComposeViewController = alarmNavController.topViewController as! DreamComposeViewController
            
            let transitionView =  UIView()
            let titleLabel = UILabel()
            let fullTitleLabel = UILabel()
            let dateLabel =  UILabel()
            let textView = UITextView()
            let backgroundImageView = UIImageView()
            let fullTextView = UITextView()
            
            let indexPath = NSIndexPath(forRow: 0, inSection: 0)
            
            dreamCollectionViewController.collectionView.scrollToItemAtIndexPath(indexPath, atScrollPosition: UICollectionViewScrollPosition.CenteredHorizontally, animated: true)
            dreamCollectionViewController.currentRowIndex = NSIndexPath(forRow: 0, inSection: 0)
            
            
            var selectedCell: CardCollectionViewCell
            
            if dreamCollectionViewController.collectionView.indexPathsForVisibleItems()[0].row != 0{
                selectedCell = dreamCollectionViewController.collectionView.cellForItemAtIndexPath(dreamCollectionViewController.collectionView.indexPathsForVisibleItems()[1] ) as! CardCollectionViewCell
            }
            else{
                selectedCell = dreamCollectionViewController.collectionView.cellForItemAtIndexPath(dreamCollectionViewController.currentRowIndex) as! CardCollectionViewCell
            }
            
            let cellFrame = containerView.convertRect(selectedCell.frame, fromView: selectedCell.superview)
            
            transitionView.backgroundColor = UIColor(white:1, alpha:1)
            transitionView.frame = dreamComposeViewController.view.frame
            print(transitionView.frame)
            
            backgroundImageView.frame.origin = dreamComposeViewController.styleScrollView.frame.origin
            backgroundImageView.frame.size = CGSize(width: dreamComposeViewController.styleScrollView.frame.size.width+1, height: dreamComposeViewController.styleScrollView.frame.size.height)
            backgroundImageView.image = dreamCollectionViewController.imageArray[0]
            backgroundImageView.contentMode = UIViewContentMode.ScaleAspectFill
            backgroundImageView.clipsToBounds = true
            
            
            
            fullTextView.attributedText = dreamComposeViewController.composeTextView.attributedText
            fullTextView.frame = dreamComposeViewController.composeTextView.frame
            textView.attributedText = dreamComposeViewController.composeTextView.attributedText
            textView.frame.size = selectedCell.textView.frame.size
            textView.frame.origin = dreamComposeViewController.composeTextView.frame.origin
            textView.alpha = 0
            
            titleLabel.numberOfLines = 0
            titleLabel.text = dreamComposeViewController.titleLabel.text
            
            titleLabel.frame = dreamComposeViewController.titleLabel.frame
            titleLabel.font = UIFont(name: selectedCell.titleLabel.font.fontName, size: 28)
            titleLabel.textColor = UIColor.whiteColor()
            titleLabel.alpha = 0
            fullTitleLabel.numberOfLines = 0
            fullTitleLabel.text = dreamComposeViewController.titleLabel.text
            fullTitleLabel.frame = dreamComposeViewController.titleLabel.frame
            fullTitleLabel.font = UIFont(name: selectedCell.titleLabel.font.fontName, size: 28)
            fullTitleLabel.textColor = UIColor.whiteColor()
            
            
            dateLabel.text = dreamComposeViewController.dateLabel.text
            dateLabel.frame = dreamComposeViewController.dateLabel.frame
            dateLabel.textColor = UIColor.whiteColor()
            dateLabel.font = UIFont(name: selectedCell.dateLabel.font.fontName, size: 11)
            
            transitionView.clipsToBounds = true
            
            transitionView.addSubview(backgroundImageView)
            transitionView.addSubview(titleLabel)
            transitionView.addSubview(fullTitleLabel)
            transitionView.addSubview(dateLabel)
            transitionView.addSubview(textView)
            transitionView.addSubview(fullTextView)
            
            dreamCollectionViewController.collectionView.reloadData()

           
            let window = UIApplication.sharedApplication().keyWindow
            window?.addSubview(transitionView)
            
            UIView.animateWithDuration(duration, animations: {
                transitionView.frame.size = selectedCell.frame.size
                transitionView.frame.origin = CGPoint(x: dreamCollectionViewController.collectionView.contentInset.left, y:cellFrame.origin.y)
                
                backgroundImageView.frame.origin = CGPoint(x: selectedCell.backgroundImageView.frame.origin.x-1, y: selectedCell.backgroundImageView.frame.origin.y)
                backgroundImageView.frame.size = selectedCell.backgroundImageView.frame.size
                
                
                
                titleLabel.alpha = 1
                titleLabel.frame.size = selectedCell.titleLabel.frame.size
                titleLabel.frame.origin = CGPoint(x: selectedCell.titleLabel.frame.origin.x-1, y: selectedCell.titleLabel.frame.origin.y)
                fullTitleLabel.alpha = 0
                fullTitleLabel.frame.origin = CGPoint(x: selectedCell.titleLabel.frame.origin.x-1, y: selectedCell.titleLabel.frame.origin.y)
                dateLabel.frame.size = selectedCell.dateLabel.frame.size
                dateLabel.frame.origin = CGPoint(x: selectedCell.dateLabel.frame.origin.x-1, y: selectedCell.dateLabel.frame.origin.y)

                textView.frame.origin = CGPoint(x: selectedCell.textView.frame.origin.x-1, y: selectedCell.textView.frame.origin.y)

                textView.alpha = 1
                fullTextView.alpha = 0
                fullTextView.frame.origin = CGPoint(x: selectedCell.textView.frame.origin.x-1, y: selectedCell.textView.frame.origin.y)
                containerView.backgroundColor = UIColor(white:0, alpha:0)
                }) { (finished: Bool) -> Void in
                    transitionView.removeFromSuperview()
                    
                    dreamCollectionViewController.viewDidAppear(true)
                    self.finish()
            }

        }//else
        
        
        
    }//dismiss

   
}
