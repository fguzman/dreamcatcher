//
//  JournalTransition.swift
//  dreamcatcher
//
//  Created by Hsin Yi Huang on 6/16/15.
//  Copyright (c) 2015 Francisco Guzman. All rights reserved.
//

import UIKit

class JournalTransition: BaseTransition {
    
    var transitionView =  UIView()
    var titleLabel = UILabel()
    var dateLabel =  UILabel()
    var textView = UITextView()
    var backgroundImageView = UIImageView()
    
    
    override func presentTransition(containerView: UIView, fromViewController: UIViewController, toViewController: UIViewController) {
        
        
        
        var journalViewController = toViewController as! JournalViewController
        
        var dreamCollectionViewController = fromViewController as! DreamCollectionViewController
        var selectedCell = dreamCollectionViewController.collectionView.cellForItemAtIndexPath(dreamCollectionViewController.currentRowIndex) as! CardCollectionViewCell
        
        var frame = containerView.convertRect(selectedCell.frame, fromView: selectedCell.superview)
        
        
        transitionView = UIView()
        transitionView.backgroundColor = UIColor(white:1, alpha:1)
        transitionView.frame.size = selectedCell.frame.size
        transitionView.frame.origin = CGPoint(x: selectedCell.frame.origin.x, y: dreamCollectionViewController.collectionView.frame.origin.y + selectedCell.frame.origin.y) // need to find a way to convert absolute value
        println(selectedCell.frame.size)
        
        backgroundImageView.image = selectedCell.backgroundImageView.image
        backgroundImageView.frame = selectedCell.backgroundImageView.frame
        backgroundImageView.contentMode = UIViewContentMode.Center
        backgroundImageView.clipsToBounds = true
        titleLabel.text = selectedCell.titleLabel.text
        titleLabel.frame = selectedCell.titleLabel.frame
        titleLabel.numberOfLines = 0
        titleLabel.font = UIFont(name: selectedCell.titleLabel.font.fontName, size: 28)
        titleLabel.textColor = UIColor.whiteColor()
        dateLabel.text = selectedCell.dateLabel.text
        dateLabel.frame = selectedCell.dateLabel.frame
        dateLabel.textColor = UIColor.whiteColor()
        dateLabel.font = UIFont(name: selectedCell.dateLabel.font.fontName, size: 11)
        textView.text = selectedCell.textView.text
        textView.frame = selectedCell.textView.frame
        textView.font = UIFont(name: selectedCell.textView.font.fontName, size: 18)
        
        transitionView.addSubview(backgroundImageView)
        transitionView.addSubview(titleLabel)
        transitionView.addSubview(dateLabel)
        transitionView.addSubview(textView)
        

        var window = UIApplication.sharedApplication().keyWindow
        
        window?.addSubview(transitionView)
        
        
        
        toViewController.view.alpha = 0
        UIView.animateWithDuration(2, animations: {
            self.transitionView.frame = toViewController.view.frame
            self.backgroundImageView.frame = journalViewController.backgroundImageView.frame
            self.dateLabel.frame = journalViewController.dateLabel.frame
            self.titleLabel.frame  = journalViewController.titleLabel.frame
            self.textView.frame = journalViewController.textView.frame
            
            
            }) { (finished: Bool) -> Void in
                toViewController.view.alpha = 1
                self.transitionView.removeFromSuperview()
                self.finish()
        }
    }
    
    override func dismissTransition(containerView: UIView, fromViewController: UIViewController, toViewController: UIViewController) {
        
        fromViewController.view.alpha = 1
        UIView.animateWithDuration(duration, animations: {
            fromViewController.view.alpha = 0
            }) { (finished: Bool) -> Void in
                self.finish()
        }
    }

}
