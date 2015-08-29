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
    var fullTitleLabel = UILabel()
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
        fullTextView.font = UIFont(name: selectedCell.textView.font.fontName, size: 20)
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
        
        fullTitleLabel.text = journalViewController.titleLabel.text
        fullTitleLabel.frame.size = journalViewController.titleLabel.frame.size
        fullTitleLabel.frame.origin = selectedCell.titleLabel.frame.origin
        fullTitleLabel.numberOfLines = 0
        fullTitleLabel.font = UIFont(name: selectedCell.titleLabel.font.fontName, size: 28)
        fullTitleLabel.textColor = UIColor.whiteColor()
        fullTitleLabel.alpha = 0
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
        transitionView.addSubview(fullTitleLabel)
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
            self.titleLabel.frame.origin  = journalViewController.titleLabel.frame.origin
            self.titleLabel.alpha = 0
            self.fullTitleLabel.alpha = 1
            self.fullTitleLabel.frame = journalViewController.titleLabel.frame
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
        transitionView.clipsToBounds = true
        
        fullTextView.attributedText = journalViewController.textView.attributedText
        fullTitleLabel.text = journalViewController.titleLabel.text
        
        titleLabel.text = journalViewController.titleLabel.text
        dateLabel.text = journalViewController.dateLabel.text
        dateLabel.frame = journalViewController.dateLabel.frame
        textView.attributedText = journalViewController.textView.attributedText

        let collectionFlowLayout: UICollectionViewFlowLayout = dreamCollectionViewController.collectionView.collectionViewLayout as! UICollectionViewFlowLayout
        
        var window = UIApplication.sharedApplication().keyWindow
        window?.addSubview(transitionView)
        
        UIView.animateWithDuration(duration, animations: {
            self.transitionView.frame.size = selectedCell.frame.size
            self.transitionView.frame.origin = CGPoint(x: collectionFlowLayout.sectionInset.left, y:cellFrame.origin.y)
            self.backgroundImageView.frame.size = selectedCell.backgroundImageView.frame.size
            self.backgroundImageView.frame.origin = CGPoint(x: selectedCell.backgroundImageView.frame.origin.x-1, y: selectedCell.backgroundImageView.frame.origin.y)
            
            self.fullTitleLabel.alpha = 0
            self.fullTitleLabel.frame.origin = selectedCell.titleLabel.frame.origin
            self.titleLabel.alpha = 1
            self.titleLabel.frame.origin = CGPoint(x: selectedCell.titleLabel.frame.origin.x-1, y: selectedCell.titleLabel.frame.origin.y) //manually moving the x position by 1 pixel to fix the jumpy bug
            
            self.dateLabel.frame.size = selectedCell.dateLabel.frame.size
            self.dateLabel.frame.origin = CGPoint(x: selectedCell.dateLabel.frame.origin.x-1, y: selectedCell.dateLabel.frame.origin.y)//manually moving the x position by 1 pixel to fix the jumpy bug

            self.textView.frame.origin = CGPoint(x: selectedCell.textView.frame.origin.x-1, y: selectedCell.textView.frame.origin.y)
 
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
