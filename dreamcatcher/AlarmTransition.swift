//
//  AlarmTransition.swift
//  dreamcatcher
//
//  Created by Sara Lin on 6/17/15.
//  Copyright (c) 2015 Francisco Guzman. All rights reserved.
//

import UIKit

class AlarmTransition: InteractiveBaseTransition {
    
    override func presentTransition(containerView: UIView, fromViewController: UIViewController, toViewController: UIViewController, completionCallback: () -> Void) {
        
        containerView.backgroundColor = UIColor.whiteColor()
        
        toViewController.view.alpha = 0
        fromViewController.view.alpha = 1
        UIView.animateWithDuration(self.animationDuration, animations: {
            toViewController.view.alpha = 1
            fromViewController.view.alpha = 0
            }) { (finished: Bool) -> Void in
                completionCallback()
        }
    }
    
    override func dismissTransition(containerView: UIView, fromViewController: UIViewController, toViewController: UIViewController, completionCallback: () -> Void) {
        fromViewController.view.alpha = 1
        
        UIView.animateWithDuration(animationDuration, animations: { () -> Void in
            fromViewController.view.alpha = 0
            }, completion: { finished in
                
                completionCallback()
        })
    }
}