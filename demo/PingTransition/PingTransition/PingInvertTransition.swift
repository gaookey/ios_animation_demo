//
//  PingInvertTransition.swift
//  PingTransition
//
//  Created by swiftprimer on 2020/11/19.
//

import UIKit

class PingInvertTransition: NSObject {
    
    private var transitionContext: UIViewControllerContextTransitioning?
}

extension PingInvertTransition: UIViewControllerAnimatedTransitioning, CAAnimationDelegate {
    
    func transitionDuration(using transitionContext: UIViewControllerContextTransitioning?) -> TimeInterval {
        return 0.7
    }
    
    func animateTransition(using transitionContext: UIViewControllerContextTransitioning) {
        self.transitionContext = transitionContext
        
        let fromVC = transitionContext.viewController(forKey: .from) as! SecondViewController
        let toVC = transitionContext.viewController(forKey: .to) as! ViewController
        let contentView = transitionContext.containerView
        
        let buttpn = toVC.button
        
        contentView.addSubview(toVC.view)
        contentView.addSubview(fromVC.view)
        
        let finalPath = UIBezierPath(ovalIn: buttpn.frame)
        var finalPoint = CGPoint()
        if buttpn.frame.origin.x > toVC.view.bounds.width * 0.5 {
            if buttpn.frame.origin.y < toVC.view.bounds.height * 0.5 {
                finalPoint = CGPoint(x: buttpn.center.x - 0, y: buttpn.center.y - toVC.view.bounds.height + 30)
            } else {
                finalPoint = CGPoint(x: buttpn.center.x - 0, y: buttpn.center.y - 0)
            }
        } else {
            if buttpn.frame.origin.y < toVC.view.bounds.height * 0.5 {
                finalPoint = CGPoint(x: buttpn.center.x - toVC.view.bounds.width, y: buttpn.center.y - toVC.view.bounds.height + 30)
            } else {
                finalPoint = CGPoint(x: buttpn.center.x - toVC.view.bounds.width, y: buttpn.center.y - 0)
            }
        }
        
        let radius = sqrt((finalPoint.x * finalPoint.x) + (finalPoint.y * finalPoint.y))
        let startPath = UIBezierPath(ovalIn: buttpn.frame.insetBy(dx: -radius, dy: -radius))
        
        let maskLayer = CAShapeLayer()
        maskLayer.path = finalPath.cgPath
        fromVC.view.layer.mask = maskLayer
        
        let pingAnimation = CABasicAnimation(keyPath: "path")
        pingAnimation.fromValue = startPath.cgPath
        pingAnimation.toValue = finalPath.cgPath
        pingAnimation.duration = transitionDuration(using: transitionContext)
        pingAnimation.timingFunction = CAMediaTimingFunction(name: .easeInEaseOut)
        pingAnimation.delegate = self
        maskLayer.add(pingAnimation, forKey: "pingInvert")
    }
    
    func animationDidStop(_ anim: CAAnimation, finished flag: Bool) {
        guard let transitionContext = transitionContext else { return }
        
        transitionContext.completeTransition(!transitionContext.transitionWasCancelled)
        transitionContext.viewController(forKey: .from)?.view.layer.mask = nil
        transitionContext.viewController(forKey: .to)?.view.layer.mask = nil
    }
}
