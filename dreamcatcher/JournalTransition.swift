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
    var fullTextView = UITextView()
    
    
    override func presentTransition(containerView: UIView, fromViewController: UIViewController, toViewController: UIViewController) {
        
        containerView.backgroundColor = UIColor(white:0, alpha:0)
        
        var pageViewController = toViewController as! UIPageViewController
        var journalViewController = pageViewController.viewControllers[0] as! JournalViewController
        var dreamCollectionViewController = fromViewController as! DreamCollectionViewController
        var selectedCell = dreamCollectionViewController.collectionView.cellForItemAtIndexPath(dreamCollectionViewController.currentRowIndex) as! CardCollectionViewCell
        
        var cellFrame = containerView.convertRect(selectedCell.frame, fromView: selectedCell.superview)
        
        fullTextView.frame.size = journalViewController.textView.frame.size
        fullTextView.frame.origin = selectedCell.textView.frame.origin
        fullTextView.font = UIFont(name: selectedCell.textView.font.fontName, size: 18)
        fullTextView.attributedText = selectedCell.textView.attributedText
        fullTextView.font = selectedCell.textView.font
        fullTextView.alpha = 0
    
        transitionView.clipsToBounds = true
        transitionView.backgroundColor = UIColor(white:1, alpha:1)
        transitionView.frame.size = selectedCell.frame.size
        transitionView.frame.origin = containerView.convertRect(selectedCell.frame, fromView: selectedCell.superview).origin
        
        backgroundImageView.image = selectedCell.backgroundImageView.image
        backgroundImageView.frame = selectedCell.backgroundImageView.frame
        backgroundImageView.contentMode = UIViewContentMode.ScaleAspectFill
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
        textView.frame = selectedCell.textView.frame
        textView.attributedText = selectedCell.textView.attributedText
        textView.font = selectedCell.textView.font
        textView.alpha = 1
        
        transitionView.addSubview(backgroundImageView)
        transitionView.addSubview(titleLabel)
        transitionView.addSubview(dateLabel)
        transitionView.addSubview(textView)
        transitionView.addSubview(fullTextView)
        
        var window = UIApplication.sharedApplication().keyWindow
        window?.addSubview(transitionView)
        
        toViewController.view.alpha = 0
        UIView.animateWithDuration(duration, animations: {
            self.transitionView.frame = toViewController.view.frame
            self.backgroundImageView.frame = journalViewController.backgroundImageView.frame
            self.dateLabel.frame = journalViewController.dateLabel.frame
            self.titleLabel.frame  = journalViewController.titleLabel.frame
            self.textView.frame.origin = journalViewController.textView.frame.origin
            self.textView.alpha = 0
            self.fullTextView.alpha = 1
            self.fullTextView.frame = journalViewController.textView.frame
            containerView.backgroundColor = UIColor(white:0, alpha:1)
            
            }) { (finished: Bool) -> Void in
                toViewController.view.alpha = 1
                containerView.backgroundColor = UIColor(white:0, alpha:0)
                self.transitionView.removeFromSuperview()
                self.finish()
        }
    }
    
    override func dismissTransition(containerView: UIView, fromViewController: UIViewController, toViewController: UIViewController) {
        fromViewController.view.alpha = 0
        
        var pageViewController = fromViewController as! UIPageViewController
        var journalViewController = pageViewController.viewControllers[0] as! JournalViewController
        var dreamCollectionViewController = toViewController as! DreamCollectionViewController
        
        var collectionView = dreamCollectionViewController.collectionView
        
        var indexPath = NSIndexPath(forRow: journalViewController.index, inSection: 0)
        
        dreamCollectionViewController.collectionView.scrollToItemAtIndexPath(indexPath, atScrollPosition: UICollectionViewScrollPosition.CenteredHorizontally, animated: true)
        
        var selectedCell: CardCollectionViewCell
        selectedCell = dreamCollectionViewController.collectionView.cellForItemAtIndexPath(dreamCollectionViewController.currentRowIndex) as! CardCollectionViewCell
        
        var cellFrame = containerView.convertRect(selectedCell.frame, fromView: selectedCell.superview)
        
        containerView.backgroundColor = journalViewController.scrollView.backgroundColor
        transitionView.frame.origin.y = journalViewController.scrollView.contentOffset.y * CGFloat(-1)
        
        backgroundImageView.image = journalViewController.backgroundImageView.image
        backgroundImageView.frame = journalViewController.backgroundImageView.frame
        
        fullTextView.attributedText = journalViewController.textView.attributedText
        fullTextView.font = journalViewController.textView.font
        
        titleLabel.text = journalViewController.titleLabel.text
        titleLabel.frame = journalViewController.titleLabel.frame
        dateLabel.text = journalViewController.dateLabel.text
        dateLabel.frame = journalViewController.dateLabel.frame
        textView.attributedText = journalViewController.textView.attributedText
        textView.font = journalViewController.textView.font
    
        var window = UIApplication.sharedApplication().keyWindow
        window?.addSubview(transitionView)
        
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
                containerView.backgroundColor = UIColor(white:0, alpha:1)
                self.transitionView.removeFromSuperview()
                self.finish()
        }
    }
}
