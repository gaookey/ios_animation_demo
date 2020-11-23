//
//  InteractiveView.swift
//  InteractiveCardDemo
//
//  Created by swiftprimer on 2020/11/23.
//

import UIKit

struct InteractiveOptions {
    var duration: TimeInterval = 0.3
    var damping: CGFloat = 0.6
    var scrollDistance: CGFloat = 100
}

class InteractiveView: UIImageView {
    
    var option: InteractiveOptions
    var initialPoint = CGPoint.zero
    var dimmingView: UIView?
    var gestureView: UIView? {
        didSet{
            let panGesture = UIPanGestureRecognizer(target: self, action: #selector(panGestureRecognized(pan:)))
            gestureView?.addGestureRecognizer(panGesture)
        }
    }
    
    init(image: UIImage?, option: InteractiveOptions) {
        self.option = option
        super.init(image: image)
        contentMode = .scaleAspectFill
        layer.cornerRadius = 8
        layer.masksToBounds = true
    }
    
    override func willMove(toSuperview newSuperview: UIView?) {
        super.willMove(toSuperview: newSuperview)
        
        initialPoint = center
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    @objc private func panGestureRecognized(pan: UIPanGestureRecognizer) {
        
        var factorOfAngle: CGFloat = 0
        var factorOfScale: CGFloat = 0
        let transition = pan.translation(in: superview)
        
        if pan.state == .began {
            
        } else if pan.state == .changed {
            center = CGPoint(x: initialPoint.x, y: initialPoint.y + transition.y)
            let Y = min(CGFloat(option.scrollDistance), max(0, abs(transition.y)))
            //一个开口向下,顶点(SCROLLDISTANCE/2,1),过(0,0),(SCROLLDISTANCE,0)的二次函数
            factorOfAngle = max(0.0,-4.0/(CGFloat(option.scrollDistance)*CGFloat(option.scrollDistance))*Y*(Y-CGFloat(option.scrollDistance)));
            //一个开口向下,顶点(SCROLLDISTANCE,1),过(0,0),(2*SCROLLDISTANCE,0)的二次函数
            factorOfScale = max(0,-1/(CGFloat(option.scrollDistance)*CGFloat(option.scrollDistance))*Y*(Y-2*CGFloat(option.scrollDistance)));
            var t = CATransform3DIdentity
            t.m34 = -1.0 / 1000
            
            t = CATransform3DRotate(t,factorOfAngle*(CGFloat(Double.pi / 5)), transition.y > 0 ? -1 : 1, 0, 0)
            t = CATransform3DScale(t, 1 - factorOfScale * 0.2, 1 - factorOfScale * 0.2, 0)
            layer.transform = t
            dimmingView?.alpha = 1.0 - Y / option.scrollDistance
            
        } else if pan.state == .ended || pan.state == .cancelled {
            UIView.animate(withDuration: option.duration, delay: 0, usingSpringWithDamping: option.damping, initialSpringVelocity: 0, options: .curveEaseInOut, animations: {
                self.layer.transform = CATransform3DIdentity
                self.center = self.initialPoint
                self.dimmingView?.alpha = 1
            }, completion: nil)
        }
    }
}
