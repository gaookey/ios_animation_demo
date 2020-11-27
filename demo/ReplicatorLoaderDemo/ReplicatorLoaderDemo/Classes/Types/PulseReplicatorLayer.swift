//
//  PulseReplicatorLayer.swift
//  ReplicatorLoaderDemo
//
//  Created by swiftprimer on 2020/11/27.
//

import UIKit

struct PulseReplicatorLayer: Replicatable {
    
    func configureReplicatorLayer(layer: CALayer, option: Options) {
        
        let pulseLayer = CAShapeLayer()
        
        func setUp() {
            pulseLayer.frame = layer.bounds
            pulseLayer.path  = UIBezierPath(ovalIn: pulseLayer.bounds).cgPath
            pulseLayer.fillColor = option.color.cgColor
            
            let replicatorLayer = CAReplicatorLayer()
            replicatorLayer.frame = layer.bounds
            //重复元素之间的时间间隔，单位为秒
            replicatorLayer.instanceDelay = 0.5
            //显示元素的个数
            replicatorLayer.instanceCount = 8
            replicatorLayer.addSublayer(pulseLayer)
            pulseLayer.opacity = 0
            layer.addSublayer(replicatorLayer)
        }
        setUp()
        
        /**
         动作连贯的必要条件：
         groupAnimation.duration = replicatorLayer.instanceCount * replicatorLayer.instanceDelay
         */
        
        func startToPluse() {
            let groupAnimation = CAAnimationGroup()
            groupAnimation.animations = [alphaAnimation(), scaleAnimation()]
            groupAnimation.duration = 4
            groupAnimation.autoreverses = false
            groupAnimation.repeatCount = HUGE
            pulseLayer.add(groupAnimation, forKey: "groupAnimation")
        }
        startToPluse()
        
        func alphaAnimation() -> CABasicAnimation {
            let alphaAnim = CABasicAnimation(keyPath: "opacity")
            alphaAnim.fromValue = NSNumber(value: option.alpha)
            alphaAnim.toValue = NSNumber(value: 0)
            return alphaAnim
        }
        
        func scaleAnimation() -> CABasicAnimation {
            let scaleAnim = CABasicAnimation(keyPath: "transform")
            scaleAnim.fromValue = NSValue(caTransform3D: CATransform3DScale(CATransform3DIdentity, 0, 0, 0))
            scaleAnim.toValue = NSValue(caTransform3D: CATransform3DScale(CATransform3DIdentity, 1, 1, 0))
            return scaleAnim
        }
    }
}
