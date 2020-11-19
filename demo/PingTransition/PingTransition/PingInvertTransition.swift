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
        
        let button = toVC.button
        
        transitionContext.containerView.addSubview(toVC.view)
        transitionContext.containerView.addSubview(fromVC.view)
        
        var finalPoint = CGPoint()
        if button.frame.origin.x > toVC.view.bounds.width * 0.5 {
            if button.frame.origin.y < toVC.view.bounds.height * 0.5 {
                finalPoint = CGPoint(x: button.center.x - 0, y: button.center.y - toVC.view.bounds.height + 30)
            } else {
                finalPoint = CGPoint(x: button.center.x - 0, y: button.center.y - 0)
            }
        } else {
            if button.frame.origin.y < toVC.view.bounds.height * 0.5 {
                finalPoint = CGPoint(x: button.center.x - toVC.view.bounds.width, y: button.center.y - toVC.view.bounds.height + 30)
            } else {
                finalPoint = CGPoint(x: button.center.x - toVC.view.bounds.width, y: button.center.y - 0)
            }
        }
        
        let radius = sqrt((finalPoint.x * finalPoint.x) + (finalPoint.y * finalPoint.y))
        let startPath = UIBezierPath(ovalIn: button.frame.insetBy(dx: -radius, dy: -radius))
        let finalPath = UIBezierPath(ovalIn: button.frame)
        
        let maskLayer = CAShapeLayer()
        maskLayer.path = finalPath.cgPath
        fromVC.view.layer.mask = maskLayer
        
        let animation = CABasicAnimation(keyPath: "path")
        animation.fromValue = startPath.cgPath
        animation.toValue = finalPath.cgPath
        animation.duration = transitionDuration(using: transitionContext)
        animation.timingFunction = CAMediaTimingFunction(name: .easeInEaseOut)
        animation.delegate = self
        maskLayer.add(animation, forKey: "pingInvert")
    }
    
    func animationDidStop(_ anim: CAAnimation, finished flag: Bool) {
        guard let transitionContext = transitionContext else { return }
        
        transitionContext.completeTransition(!transitionContext.transitionWasCancelled)
        transitionContext.viewController(forKey: .from)?.view.layer.mask = nil
        transitionContext.viewController(forKey: .to)?.view.layer.mask = nil
    }
}
