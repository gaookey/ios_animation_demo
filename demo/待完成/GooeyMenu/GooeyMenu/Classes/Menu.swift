//
//  Menu.swift
//  GooeyMenu
//
//  Created by swiftprimer on 2020/11/25.
//

import UIKit

class Menu: UIView {
    
    var animationQueue = [CAKeyframeAnimation]()
    var menuLayer = MenuLayer()
    
    override init(frame: CGRect) {
        let real_frame = frame.insetBy(dx: -30, dy: -30)
        super.init(frame: real_frame)
        
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    override func willMove(toSuperview newSuperview: UIView?) {
        menuLayer.frame = bounds
        menuLayer.contentsScale = UIScreen.main.scale
        layer.addSublayer(menuLayer)
        menuLayer.setNeedsDisplay()
    }
    
    override func touchesBegan(_ touches: Set<UITouch>, with event: UIEvent?) {
        
        guard let touch = touches.first else { return }
        
        switch touch.tapCount {
        case 1:
            openAnimation()
            break;
        default:
            break;
        }
    }
    
    private func openAnimation() {
        animationQueue.removeAll()
        
        let openAnimation_1 = SpringLayerAnimation.shared.createBasicAnimation(keypath: "xAxisPercent", duration: 0.3, fromValue: 0, toValue: 1)
        let openAnimation_2 = SpringLayerAnimation.shared.createBasicAnimation(keypath: "xAxisPercent", duration: 0.3, fromValue: 0, toValue: 1)
        let openAnimation_3 = SpringLayerAnimation.shared.createSpringAnima(keypath: "xAxisPercent", duration: 1, usingSpringWithDamping: 0.5, initialSpringVelocity: 3, fromValue: 0, toValue: 1)
        
        openAnimation_1.delegate = self
        openAnimation_2.delegate = self
        openAnimation_3.delegate = self
        
        animationQueue.append(openAnimation_1)
        animationQueue.append(openAnimation_2)
        animationQueue.append(openAnimation_3)
        
        menuLayer.add(openAnimation_1, forKey: "openAnimation_1")
        isUserInteractionEnabled = false
        menuLayer.animationState = .state1
    }
}

extension Menu: CAAnimationDelegate {
    
    func animationDidStop(_ anim: CAAnimation, finished flag: Bool) {
        
        guard flag == true else { return }

        if anim == menuLayer.animation(forKey: "openAnimation_1") {
            menuLayer.removeAllAnimations()
            menuLayer.add(animationQueue[1], forKey: "openAnimation_2")
            menuLayer.animationState = .state2
        } else if anim == menuLayer.animation(forKey: "openAnimation_2") {
            menuLayer.removeAllAnimations()
            menuLayer.add(animationQueue[2], forKey: "openAnimation_3")
            menuLayer.animationState = .state3
        } else if anim == menuLayer.animation(forKey: "openAnimation_3") {
            menuLayer.xAxisPercent = 1.0
            menuLayer.removeAllAnimations()
            isUserInteractionEnabled = true
        }
    }
}

