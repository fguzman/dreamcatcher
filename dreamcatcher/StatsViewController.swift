//
//  StatsViewController.swift
//  dreamcatcher
//
//  Created by Sara Lin on 6/11/15.
//  Copyright (c) 2015 Francisco Guzman. All rights reserved.
//

import UIKit

class StatsViewController: UIViewController, UIScrollViewDelegate{
    
    @IBOutlet weak var scrollView: UIScrollView!
    
    weak var dreamVC: DreamCollectionViewController!
    var tab: Int!
    
    override func viewDidLoad() {
        super.viewDidLoad()

        scrollView.delegate = self
        
        scrollView.contentSize = CGSize(width: scrollView.frame.size.width * CGFloat(3), height: scrollView.frame.size.height)
        // Do any additional setup after loading the view.
    }

    func scrollViewDidEndDecelerating(scrollView: UIScrollView) {
        tab = Int(round(scrollView.contentOffset.x / 320)) + 1
        
        if tab==1 {
            
            dreamVC.themeActive=true
            dreamVC.placeActive=false
            dreamVC.emotionActive=false
            
            dreamVC.didChangeTabToTabNumber(tab)
        } else if tab==2 {
            
            dreamVC.themeActive=false
            dreamVC.placeActive=true
            dreamVC.emotionActive=false
            
            dreamVC.didChangeTabToTabNumber(tab)
        } else if tab==3 {
            
            dreamVC.themeActive=false
            dreamVC.placeActive=false
            dreamVC.emotionActive=true
            dreamVC.didChangeTabToTabNumber(tab)
        }
        
    }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }

}