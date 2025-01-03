//
//  CustomPushAnimator.swift
//  bebrave
//
//  Created by Anastasia Tyutinova on 3/1/2568 BE.
//


import UIKit

class CustomPushAnimator: NSObject, UIViewControllerAnimatedTransitioning {
    
    func transitionDuration(using transitionContext: UIViewControllerContextTransitioning?) -> TimeInterval {
        return 0.5
    }
    
    func animateTransition(using transitionContext: UIViewControllerContextTransitioning) {
        guard let fromVC = transitionContext.viewController(forKey: .from),
              let toVC = transitionContext.viewController(forKey: .to) else { return }
        
        let containerView = transitionContext.containerView
        let duration = transitionDuration(using: transitionContext)
        
        containerView.addSubview(toVC.view)
        toVC.view.frame = fromVC.view.frame.offsetBy(dx: fromVC.view.frame.width, dy: 0)
        
        UIView.animate(withDuration: duration, animations: {
            fromVC.view.alpha = 0.8
            toVC.view.frame = fromVC.view.frame 
        }, completion: { finished in
            fromVC.view.alpha = 1.0
            transitionContext.completeTransition(finished)
        })
    }
}
