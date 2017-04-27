//
//  Animator.swift
//  EasyAnimatedTransition
//
//  Created by Alex Gibson on 3/30/17.
//  Copyright © 2017 AG. All rights reserved.
//

import UIKit

class Animator: NSObject,UIViewControllerTransitioningDelegate, UIViewControllerAnimatedTransitioning {
    
    var duration = 0.5
    fileprivate var isPresenting = true
    var cellImageView : UIView?
    
    func animateTransition(using transitionContext: UIViewControllerContextTransitioning) {
        //heavy work to be done
        guard let toViewController = transitionContext.viewController(forKey: .to) else{return}
        guard let fromViewController = transitionContext.viewController(forKey: .from) else{return}
        let container = transitionContext.containerView
     
        self.cellImageView?.alpha = 1
        let toTargetCopy = cellImageView?.snapshotView()
        let fromTargetCopy = cellImageView?.snapshotView()
        
        if isPresenting{
            toViewController.view.frame = transitionContext.finalFrame(for: toViewController)
            container.addSubview(toViewController.view)
            toViewController.view.alpha = 0
            container.bringSubview(toFront: toViewController.view)
            toViewController.view.layoutIfNeeded()

            //add a copy at the right location in both views
            //set our frame based on the window
            if fromTargetCopy != nil && toTargetCopy != nil && cellImageView != nil && toViewController.view.viewWithTag(100) != nil{
                let keyWindow = UIApplication.shared.keyWindow
                toTargetCopy?.frame = cellImageView!.convert(cellImageView!.bounds, to: keyWindow)
                fromTargetCopy?.frame = cellImageView!.convert(cellImageView!.bounds, to: keyWindow)
                //add from to the from view and the toTarget to the toViewController
                fromViewController.view.addSubview(fromTargetCopy!)
                toViewController.view.addSubview(toTargetCopy!)
                
                // we need to hide the real views
                cellImageView?.alpha = 0
                let toDetailImageView = toViewController.view.viewWithTag(100)!
                toDetailImageView.alpha = 0
                //perform our animation with target frame
                let targetFrame = toViewController.view.viewWithTag(100)!.convert(toDetailImageView.bounds, to: keyWindow)
                
                UIView.animate(withDuration: duration, delay: 0, usingSpringWithDamping: 0.9, initialSpringVelocity: 0.9, options: .curveEaseInOut, animations: {
                    toTargetCopy?.frame = targetFrame
                    fromTargetCopy?.frame = targetFrame
                }, completion: nil)
            }
            
            
            UIView.animate(withDuration: duration, animations: {
                toViewController.view.alpha = 1
                
            }, completion: { (finished) in
                transitionContext.completeTransition(true)
                toTargetCopy?.removeFromSuperview()
                fromTargetCopy?.removeFromSuperview()
                toViewController.view.viewWithTag(100)?.alpha = 1
            })
            
        }else{
            if fromViewController.modalPresentationStyle == UIModalPresentationStyle.none{
                toViewController.view.frame = transitionContext.finalFrame(for: toViewController)
                container.addSubview(toViewController.view)
                container.sendSubview(toBack: toViewController.view)
            }
            
            if fromTargetCopy != nil && toTargetCopy != nil && cellImageView != nil{
            
                let keyWindow = UIApplication.shared.keyWindow
                
                let detailImageView = fromViewController.view.viewWithTag(100)!
                toTargetCopy?.frame = detailImageView.convert(detailImageView.bounds, to: keyWindow)
                fromTargetCopy?.frame = detailImageView.convert(detailImageView.bounds, to: keyWindow)
                
                
                let targetFrame = cellImageView!.convert(cellImageView!.bounds, to: keyWindow)
                
                //add from to the from view and the toTarget to the toViewController
                fromViewController.view.addSubview(fromTargetCopy!)
                toViewController.view.addSubview(toTargetCopy!)
                
                cellImageView?.alpha = 0
                detailImageView.alpha = 0

                
                UIView.animate(withDuration: duration, delay: 0, usingSpringWithDamping: 0.9, initialSpringVelocity: 0.9, options: .curveEaseInOut, animations: { 
                    toTargetCopy?.frame = targetFrame
                    fromTargetCopy?.frame = targetFrame
                }, completion: nil)
            }
            
            UIView.animate(withDuration: duration, animations: {
                fromViewController.view.alpha = 0
                
            }, completion: { (finished) in
                toViewController.view.viewWithTag(100)?.alpha = 1
                self.cellImageView?.alpha = 1
                toTargetCopy?.removeFromSuperview()
                fromTargetCopy?.removeFromSuperview()
                transitionContext.completeTransition(true)
            })
        }
    }
    
    
    func transitionDuration(using transitionContext: UIViewControllerContextTransitioning?) -> TimeInterval {
        return self.duration
    }
    
    func animationController(forDismissed dismissed: UIViewController) -> UIViewControllerAnimatedTransitioning? {
        isPresenting = false
        return self
    }
    
    
    func animationController(forPresented presented: UIViewController, presenting: UIViewController, source: UIViewController) -> UIViewControllerAnimatedTransitioning? {
        isPresenting = true
        return self
    }
    
}





