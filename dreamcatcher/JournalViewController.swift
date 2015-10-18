//
//  JournalViewController.swift
//  dreamcatcher
//
//  Created by Sara Lin on 6/12/15.
//  Copyright (c) 2015 Francisco Guzman. All rights reserved.
//

import UIKit

class JournalViewController: UIViewController, UIScrollViewDelegate{
    
    @IBOutlet weak var backButton: UIButton!
    @IBOutlet weak var backgroundImageView: UIImageView!
    @IBOutlet weak var backgroundView: UIView!
    @IBOutlet weak var scrollView: UIScrollView!
    @IBOutlet weak var dateLabel: UILabel!
    @IBOutlet weak var titleLabel: UILabel!
    @IBOutlet weak var textView: UITextView!
    var paragraph: String!
    var titleText: String!
    var dateText: String!
    var image: UIImage!
    
    var index: Int = 0
    
    override func viewDidLoad() {
        super.viewDidLoad()
//        println("\(titleText): \(index)")
        
        UIApplication.sharedApplication().setStatusBarHidden(true, withAnimation: UIStatusBarAnimation.None)
        
        var tmpTextView = paragraphStyle(paragraph)
        textView.attributedText = tmpTextView.attributedText
        textView.font = tmpTextView.font
        
        titleLabel.text = titleText
        dateLabel.text = dateText
        backgroundImageView.image = image
        let size: CGSize = textView.sizeThatFits(CGSizeMake(textView.frame.size.width, CGFloat.max))
        textView.frame.size.height = size.height
        textView.scrollEnabled = false
        let inset: CGFloat = 20
        
        scrollView.contentSize.height = textView.frame.origin.y + textView.frame.size.height + inset
        
        if scrollView.contentSize.height < self.view.frame.size.height{
            scrollView.contentSize.height = self.view.frame.size.height + 1
        }
        backgroundView.frame.size.height = scrollView.contentSize.height
        
        scrollView.delegate = self
        
//        println("=== I'm showing \(index), \(titleText)")
    }
    
    override func viewDidDisappear(animated: Bool) {
        UIApplication.sharedApplication().setStatusBarHidden(false, withAnimation: UIStatusBarAnimation.None)
    }
    
    func scrollViewDidScroll(scrollView: UIScrollView){
        var backgroundAlpha = progressValue(scrollView.contentOffset.y, refValueMin: 0, refValueMax: -300, convertValueMin: 1, convertValueMax: 0)
       
        backButton.alpha = progressValue(scrollView.contentOffset.y, refValueMin: 0, refValueMax: -150, convertValueMin: 1, convertValueMax: 0)
        scrollView.backgroundColor = UIColor(white:0, alpha: backgroundAlpha)
    }
    
    func scrollViewDidEndDragging(scrollView: UIScrollView, willDecelerate decelerate: Bool){
        print("end")
        
        if scrollView.contentOffset.y <= -80{
            self.dismissViewControllerAnimated(true, completion: nil)
        }
        
    }
    

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    
    @IBAction func onPressBackButton(sender: AnyObject) {
        self.dismissViewControllerAnimated(true, completion: nil)
    }

    
    func progressValue(value: CGFloat, refValueMin: CGFloat, refValueMax: CGFloat, convertValueMin: CGFloat, convertValueMax: CGFloat) -> CGFloat {
        
        
        
        var ratio = (value - refValueMin)/(refValueMax - refValueMin)
        
        var currentValue = (convertValueMax - convertValueMin)*ratio + convertValueMin
        
        return currentValue
        
    }

}
