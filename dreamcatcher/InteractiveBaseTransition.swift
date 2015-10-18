//
//  InteractiveBaseTransition.swift
//  dreamcatcher
//
//  Created by Sara Lin on 6/18/15.
//  Copyright (c) 2015 Francisco Guzman. All rights reserved.
//

import UIKit

class InteractiveBaseTransition: UIPercentDrivenInteractiveTransition, UIViewControllerTransitioningDelegate, UIViewControllerAnimatedTransitioning {
    
    var animationDuration: NSTimeInterval = 0.4
    var isPresenting: Bool = true
    var isInteractive: Bool = false
    var transitionContext: UIViewControllerContextTransitioning!
    
    override init() {
        super.init()
        self.completionSpeed = 0.999;
    }
    
    func animationControllerForPresentedController(presented: UIViewController, presentingController presenting: UIViewController, sourceController source: UIViewController) -> UIViewControllerAnimatedTransitioning? {
        isPresenting = true
        return self
    }
    
    func animationControllerForDismissedController(dismissed: UIViewController) -> UIViewControllerAnimatedTransitioning? {
        isPresenting = false
        return self
    }
    
    func transitionDuration(transitionContext: UIViewControllerContextTransitioning?) -> NSTimeInterval {
        return animationDuration
    }
    
    func interactionControllerForPresentation(animator: UIViewControllerAnimatedTransitioning) -> UIViewControllerInteractiveTransitioning? {
//        println("interactionControllerForPresentation: \(self.isInteractive)")
        return self.isInteractive ? self : nil
    }
    
    func interactionControllerForDismissal(animator: UIViewControllerAnimatedTransitioning) -> UIViewControllerInteractiveTransitioning? {
//        println("interactionControllerForDismissal: \(self.isInteractive)")
        return self.isInteractive ? self : nil
    }
    
    func animateTransition(transitionContext: UIViewControllerContextTransitioning) {
        let containerView = transitionContext.containerView()
        let toViewController = transitionContext.viewControllerForKey(UITransitionContextToViewControllerKey)!
        let fromViewController = transitionContext.viewControllerForKey(UITransitionContextFromViewControllerKey)!
        self.transitionContext = transitionContext
        
        if (isPresenting) {
            containerView!.addSubview(toViewController.view)
            
            presentTransition(containerView!, fromViewController: fromViewController, toViewController: toViewController, completionCallback: {
                if (transitionContext.transitionWasCancelled()) {
                    transitionContext.completeTransition(false)
                } else {
//                    println("-- TRANSITION COMPLETED --")
                    transitionContext.completeTransition(true)
                }
            })
        } else {
            dismissTransition(containerView!, fromViewController: fromViewController, toViewController: toViewController, completionCallback: {
                transitionContext.completeTransition(true)
            })
        }
    }
    
    func presentTransition(containerView: UIView, fromViewController: UIViewController, toViewController: UIViewController, completionCallback: () -> Void) {

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
    
    func dismissTransition(containerView: UIView, fromViewController: UIViewController, toViewController: UIViewController, completionCallback: () -> Void) {
        
//        println("-- DISMISS TRANSITION -- ")
        
        fromViewController.view.alpha = 1
        
        UIView.animateWithDuration(animationDuration, animations: { () -> Void in
            fromViewController.view.alpha = 0
            }, completion: { finished in
                
                completionCallback()
        })
    }
    
    func finish() {
        if isInteractive {
            self.finishInteractiveTransition()
        }
        
        if isPresenting == false {
            let fromViewController = transitionContext?.viewControllerForKey(UITransitionContextFromViewControllerKey)!
            fromViewController?.view.removeFromSuperview()
        }
        
        transitionContext?.completeTransition(true)
    }
    
    func cancel() {
        if isInteractive {
            self.cancelInteractiveTransition()
        }
    }
    
}
