//
//  SPBubbleTransition.swift
//  SPBubbleTransition
//
//  Created by swiftprimer on 2020/11/19.
//

import UIKit

enum BubbleTranisionMode {
    case present
    case dismiss
}

class SPBubbleTransition: NSObject {
    
    var duration: TimeInterval = 0
    var startPoint = CGPoint.zero
    var transitionMode = BubbleTranisionMode.present
    var bubbleColor = UIColor.clear
    
    private var bubble = UIView()
}

extension SPBubbleTransition: UIViewControllerAnimatedTransitioning {
    
    func transitionDuration(using transitionContext: UIViewControllerContextTransitioning?) -> TimeInterval {
        return duration
    }
    
    func animateTransition(using transitionContext: UIViewControllerContextTransitioning) {
        
        let containerView = transitionContext.containerView
        var radius: CGFloat = 0
        
        if startPoint.x > containerView.bounds.width * 0.5 {
            if startPoint.y < containerView.bounds.height * 0.5 {
                radius = sqrt(startPoint.x * startPoint.x + (containerView.bounds.height - startPoint.y) * (containerView.bounds.height - startPoint.y) )
            } else {
                radius = sqrt(startPoint.x * startPoint.x + startPoint.y * startPoint.y )
            }
        } else {
            if startPoint.y < containerView.bounds.height * 0.5 {
                radius = sqrt((containerView.bounds.width - startPoint.x) * (containerView.bounds.width - startPoint.x) + (containerView.bounds.height - startPoint.y) * (containerView.bounds.height - startPoint.y))
            } else {
                radius = sqrt((containerView.bounds.width - startPoint.x) * (containerView.bounds.width - startPoint.x) + startPoint.y * startPoint.y)
            }
        }
        
        let size = CGSize(width: radius * 2, height: radius * 2)
        bubble = UIView(frame: CGRect(x: 0, y: 0, width: size.width, height: size.height))
        bubble.center = startPoint
        bubble.layer.cornerRadius = size.width * 0.5
        bubble.backgroundColor = bubbleColor
        
        if transitionMode == .present {
            
            guard let toView = transitionContext.view(forKey: .to) else { return }
            let originalCenter = toView.center
            
            bubble.transform = CGAffineTransform(scaleX: 0.001, y: 0.001)
            toView.center = startPoint
            toView.transform = CGAffineTransform(scaleX: 0.001, y: 0.001)
            toView.alpha = 0
            bubble.alpha = 1
            
            containerView.addSubview(bubble)
            containerView.addSubview(toView)
            
            UIView.animate(withDuration: duration) { [weak self] in
                self?.bubble.transform = .identity
                toView.transform = .identity
                toView.alpha = 1
                toView.center = originalCenter
            } completion: { [weak self] (finish) in
                self?.bubble.removeFromSuperview()
                transitionContext.completeTransition(true)
            }
        } else {
            
            guard let toView = transitionContext.view(forKey: .to) else { return }
            guard let fromView = transitionContext.view(forKey: .from) else { return }
            
            containerView.addSubview(toView)
            containerView.addSubview(bubble)
            containerView.addSubview(fromView)
            
            UIView.animate(withDuration: duration) { [weak self] in
                if let weakSelf = self {
                    weakSelf.bubble.transform = CGAffineTransform(scaleX: 0.001, y: 0.001)
                    fromView.transform = CGAffineTransform(scaleX: 0.001, y: 0.001)
                    fromView.center = weakSelf.startPoint
                    fromView.alpha = 0
                }
            } completion: { [weak self] (finish) in
                fromView.removeFromSuperview()
                self?.bubble.removeFromSuperview()
                transitionContext.completeTransition(true)
            }
        }
    }
}
