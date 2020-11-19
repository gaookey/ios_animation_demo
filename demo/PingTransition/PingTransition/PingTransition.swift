//
//  PingTransition.swift
//  PingTransition
//
//  Created by swiftprimer on 2020/11/19.
//

import UIKit

class PingTransition: NSObject {
    
    private var transitionContext: UIViewControllerContextTransitioning?
}

extension PingTransition: UIViewControllerAnimatedTransitioning, CAAnimationDelegate {
    
    func transitionDuration(using transitionContext: UIViewControllerContextTransitioning?) -> TimeInterval {
        return 0.7
    }
    
    func animateTransition(using transitionContext: UIViewControllerContextTransitioning) {
        self.transitionContext = transitionContext
        
        let fromVC = transitionContext.viewController(forKey: .from) as! ViewController
        let toVC = transitionContext.viewController(forKey: .to) as! SecondViewController
        let contentView = transitionContext.containerView
        
        let button = fromVC.button
        
        let maskStartPath = UIBezierPath(ovalIn: button.frame)
        contentView.addSubview(fromVC.view)
        contentView.addSubview(toVC.view)
        
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
        let maskFinalPath = UIBezierPath(ovalIn: button.frame.insetBy(dx: -radius, dy: -radius))
        
        let maskLayer = CAShapeLayer()
        maskLayer.path = maskFinalPath.cgPath
        toVC.view.layer.mask = maskLayer
        
        let maskLayerAnimation = CABasicAnimation(keyPath: "path")
        maskLayerAnimation.fromValue = maskStartPath.cgPath
        maskLayerAnimation.toValue = maskFinalPath.cgPath
        maskLayerAnimation.duration = transitionDuration(using: transitionContext)
        maskLayerAnimation.timingFunction = CAMediaTimingFunction(name: .easeInEaseOut)
        maskLayerAnimation.delegate = self
        maskLayer.add(maskLayerAnimation, forKey: "path")
    }
    
    func animationDidStop(_ anim: CAAnimation, finished flag: Bool) {
        guard let transitionContext = transitionContext else { return }
        
        transitionContext.completeTransition(!transitionContext.transitionWasCancelled)
        transitionContext.viewController(forKey: .from)?.view.layer.mask = nil
        transitionContext.viewController(forKey: .to)?.view.layer.mask = nil
    }
}
