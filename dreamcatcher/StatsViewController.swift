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
    
    override func viewDidLoad() {
        super.viewDidLoad()

        scrollView.delegate = self
        
        scrollView.contentSize = CGSize(width: scrollView.frame.size.width * CGFloat(3), height: scrollView.frame.size.height)
        // Do any additional setup after loading the view.
    }

    func scrollViewDidEndDecelerating(scrollView: UIScrollView) {
        dreamVC.didChangeTabToTabNumber(Int(round(scrollView.contentOffset.x / 320)) + 1)
    }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }

}