//
//  NewJournalTransition.swift
//  dreamcatcher
//
//  Created by Hsin Yi Huang on 6/22/15.
//  Copyright (c) 2015 Francisco Guzman. All rights reserved.
//

import UIKit

class NewJournalTransition: BaseTransition {
    var transitionView =  UIView()
    var titleLabel = UILabel()
    var dateLabel =  UILabel()
    var textView = UITextView()
    var backgroundImageView = UIImageView()
    var fullTextView = UITextView()
    
    
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
        
        var dreamComposeViewController = fromViewController as! DreamComposeViewController
        var dreamCollectionViewController = toViewController as! DreamCollectionViewController
        
        
        var collectionView = dreamCollectionViewController.collectionView
        var indexPath = NSIndexPath(forRow: 0, inSection: 0)
        
        dreamCollectionViewController.collectionView.scrollToItemAtIndexPath(indexPath, atScrollPosition: UICollectionViewScrollPosition.CenteredHorizontally, animated: true)
        dreamCollectionViewController.currentRowIndex = NSIndexPath(forRow: 0, inSection: 0)
        
        
        if dreamComposeViewController.exitButton == dreamComposeViewController.doneButton {
            if (dreamCollectionViewController.themeActive || dreamCollectionViewController.placeActive || dreamCollectionViewController.emotionActive) {
                dreamCollectionViewController.closeStatsView()
            }
        }
        
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

        

        if dreamComposeViewController.exitButton == dreamComposeViewController.closeButton{
            println("no entry")
            containerView.backgroundColor = UIColor(white:0, alpha:0)
            fromViewController.view.frame.origin.y = 0
            UIView.animateWithDuration(0.3, animations: { () -> Void in
                fromViewController.view.frame.origin.y = fromViewController.view.frame.size.height
            }, completion: { (Bool) -> Void in
                self.finish()
            })
            
            
        }
            
        else if dreamComposeViewController.exitButton == dreamComposeViewController.doneButton { // if some entry
            println("some entry")

            containerView.backgroundColor = UIColor(white:0, alpha:1)
            fromViewController.view.alpha = 0
            var window = UIApplication.sharedApplication().keyWindow
            window?.addSubview(transitionView)
            
           // containerView.backgroundColor = UIColor(white:0, alpha:0)///tesing only
            
            UIView.animateWithDuration(duration, animations: {
                self.transitionView.frame.size = selectedCell.frame.size
                self.transitionView.frame.origin = CGPoint(x: dreamCollectionViewController.collectionView.contentInset.left, y:cellFrame.origin.y)
                self.backgroundImageView.frame = selectedCell.backgroundImageView.frame
                self.titleLabel.frame = selectedCell.titleLabel.frame
                self.dateLabel.frame = selectedCell.dateLabel.frame
                self.textView.frame.origin = selectedCell.textView.frame.origin
                self.textView.alpha = 1
                self.fullTextView.alpha = 0
                self.fullTextView.frame.origin = selectedCell.textView.frame.origin
                
                containerView.backgroundColor = UIColor(white:0, alpha:0)
                
                }) { (finished: Bool) -> Void in
//                    println("title label \(self.titleLabel.frame.origin) and after \(selectedCell.titleLabel.frame.origin)")
                    
                    dreamCollectionViewController.collectionView.reloadData()
                   self.transitionView.removeFromSuperview()
                    
                    self.finish()
            }//animation

        }//else
 
        
    }
   
}
