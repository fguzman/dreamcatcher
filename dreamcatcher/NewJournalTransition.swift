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
    var fullTitleLabel = UILabel()
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
        
        let dreamComposeViewController = fromViewController as! DreamComposeViewController
        let dreamCollectionViewController = toViewController as! DreamCollectionViewController
        let indexPath = NSIndexPath(forRow: 0, inSection: 0)
        
        dreamCollectionViewController.collectionView.scrollToItemAtIndexPath(indexPath, atScrollPosition: UICollectionViewScrollPosition.CenteredHorizontally, animated: true)
        dreamCollectionViewController.currentRowIndex = NSIndexPath(forRow: 0, inSection: 0)
        
        
        
        if dreamComposeViewController.exitButton == dreamComposeViewController.doneButton {
            if (dreamCollectionViewController.themeActive || dreamCollectionViewController.placeActive || dreamCollectionViewController.emotionActive) {
                dreamCollectionViewController.closeStatsView()
            }
        }
        
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
        transitionView.clipsToBounds = true
        
        backgroundImageView.frame.origin = dreamComposeViewController.styleScrollView.frame.origin
        backgroundImageView.frame.size = CGSize(width: dreamComposeViewController.styleScrollView.frame.size.width+1, height: dreamComposeViewController.styleScrollView.frame.size.height)
        backgroundImageView.image = dreamCollectionViewController.imageArray[0]
        backgroundImageView.contentMode = UIViewContentMode.ScaleAspectFill
        backgroundImageView.clipsToBounds = true
        
        
        fullTextView.attributedText = dreamComposeViewController.composeTextView.attributedText
        fullTextView.frame = dreamComposeViewController.composeTextView.frame
        
        textView.attributedText = dreamComposeViewController.composeTextView.attributedText
        textView.frame.origin = dreamComposeViewController.composeTextView.frame.origin
        textView.alpha = 0
        textView.frame.size = selectedCell.textView.frame.size

    
        fullTitleLabel.text = dreamComposeViewController.titleLabel.text
        fullTitleLabel.frame = dreamComposeViewController.titleLabel.frame
        fullTitleLabel.numberOfLines = 0
        fullTitleLabel.font = UIFont(name: selectedCell.titleLabel.font.fontName, size: 28)
        fullTitleLabel.textColor = UIColor.whiteColor()
        titleLabel.frame = dreamComposeViewController.titleLabel.frame
        titleLabel.text = dreamComposeViewController.titleLabel.text
        titleLabel.numberOfLines = 0
        titleLabel.font = UIFont(name: selectedCell.titleLabel.font.fontName, size: 28)
        titleLabel.textColor = UIColor.whiteColor()
        titleLabel.alpha = 0
        
        dateLabel.text = dreamComposeViewController.dateLabel.text
        dateLabel.frame = dreamComposeViewController.dateLabel.frame
        dateLabel.textColor = UIColor.whiteColor()
        dateLabel.font = UIFont(name: selectedCell.dateLabel.font.fontName, size: 11)
        
        
        transitionView.addSubview(backgroundImageView)
        transitionView.addSubview(titleLabel)
        transitionView.addSubview(dateLabel)
        transitionView.addSubview(fullTitleLabel)
        transitionView.addSubview(textView)
        transitionView.addSubview(fullTextView)
        
        
        dreamCollectionViewController.collectionView.reloadData()
        

        

        if dreamComposeViewController.exitButton == dreamComposeViewController.closeButton{
            print("no entry")
            containerView.backgroundColor = UIColor(white:0, alpha:0)
            fromViewController.view.frame.origin.y = 0
            UIView.animateWithDuration(0.3, animations: { () -> Void in
                fromViewController.view.frame.origin.y = fromViewController.view.frame.size.height
            }, completion: { (Bool) -> Void in
                self.finish()
            })
            
            
        }
            
        else if dreamComposeViewController.exitButton == dreamComposeViewController.doneButton { // if some entry
            print("some entry")

            containerView.backgroundColor = UIColor(white:0, alpha:1)
            fromViewController.view.alpha = 0
            let window = UIApplication.sharedApplication().keyWindow
            window?.addSubview(transitionView)
            
           // containerView.backgroundColor = UIColor(white:0, alpha:0)///tesing only
            
            UIView.animateWithDuration(duration, animations: {
                self.transitionView.frame.size = selectedCell.frame.size
                self.transitionView.frame.origin = CGPoint(x: dreamCollectionViewController.collectionView.contentInset.left, y:cellFrame.origin.y)
                self.backgroundImageView.frame.size = selectedCell.backgroundImageView.frame.size
                self.backgroundImageView.frame.origin = CGPoint(x: selectedCell.backgroundImageView.frame.origin.x-1, y: selectedCell.backgroundImageView.frame.origin.y)
                self.fullTitleLabel.frame.origin = selectedCell.titleLabel.frame.origin
                self.fullTitleLabel.alpha = 0
                self.titleLabel.frame.size = selectedCell.titleLabel.frame.size
                self.titleLabel.frame.origin = CGPoint(x: selectedCell.titleLabel.frame.origin.x-1, y: selectedCell.titleLabel.frame.origin.y) //manually moving the x position by 1 pixel to fix the jumpy bug
                self.titleLabel.alpha = 1

                self.dateLabel.frame.size = selectedCell.dateLabel.frame.size
                self.dateLabel.frame.origin = CGPoint(x: selectedCell.dateLabel.frame.origin.x-1, y: selectedCell.dateLabel.frame.origin.y)
                self.textView.frame.origin = CGPoint(x: selectedCell.textView.frame.origin.x-1, y:selectedCell.textView.frame.origin.y)
                self.textView.alpha = 1
                self.fullTextView.alpha = 0
                self.fullTextView.frame.origin = CGPoint(x: selectedCell.textView.frame.origin.x-1, y:selectedCell.textView.frame.origin.y)
                
                containerView.backgroundColor = UIColor(white:0, alpha:0)
                
                }) { (finished: Bool) -> Void in
//                    println("title label \(self.titleLabel.frame.origin) and after \(selectedCell.titleLabel.frame.origin)")
                    
                    
                    self.transitionView.removeFromSuperview()
                    dreamCollectionViewController.collectionView.reloadData()
                    self.finish()
            }//animation

        }//else
 
        
    }
   
}
