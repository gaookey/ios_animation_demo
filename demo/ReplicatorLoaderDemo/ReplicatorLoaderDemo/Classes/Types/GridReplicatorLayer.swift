//
//  GridReplicatorLayer.swift
//  ReplicatorLoaderDemo
//
//  Created by swiftprimer on 2020/11/27.
//

import UIKit

struct GridReplicatorLayer: Replicatable {
    
    func configureReplicatorLayer(layer: CALayer, option: Options) {
        
        func setUp() {
            let nbColumn = 3
            let marginBetweenDot : CGFloat = 5
            let size = layer.bounds.width
            let dotSize = (size - (marginBetweenDot * (CGFloat(nbColumn)  - 1))) / CGFloat(nbColumn)
            
            let dot = CAShapeLayer()
            dot.frame = CGRect(
                x: 0,
                y: 0,
                width: dotSize,
                height: dotSize)
            
            dot.path = UIBezierPath(ovalIn: CGRect(x: 0, y: 0, width: dotSize, height: dotSize)).cgPath
            dot.fillColor = option.color.cgColor
            
            let replicatorLayerX = CAReplicatorLayer()
            replicatorLayerX.frame = CGRect(x: 0, y: 0, width: size, height: size)
            
            replicatorLayerX.instanceDelay = 0.3
            replicatorLayerX.instanceCount = nbColumn
            
            var transform = CATransform3DIdentity
            transform = CATransform3DTranslate(transform, dotSize+marginBetweenDot, 0, 0)
            replicatorLayerX.instanceTransform = transform
            transform = CATransform3DScale(transform, 1, -1, 0)
            
            let replicatorLayerY = CAReplicatorLayer()
            replicatorLayerY.frame = CGRect(x: 0, y: 0, width: size, height: size)
            replicatorLayerY.instanceDelay = 0.3
            replicatorLayerY.instanceCount = nbColumn
            
            var transformY = CATransform3DIdentity
            transformY = CATransform3DTranslate(transformY, 0, dotSize+marginBetweenDot, 0)
            replicatorLayerY.instanceTransform = transformY
            
            replicatorLayerX.addSublayer(dot)
            replicatorLayerY.addSublayer(replicatorLayerX)
            layer.addSublayer(replicatorLayerY)
            
            let groupAnimation = CAAnimationGroup()
            groupAnimation.animations = [alphaAnimation(), scaleAnimation()]
            groupAnimation.duration = 1
            groupAnimation.autoreverses = true
            groupAnimation.repeatCount = HUGE
            
            dot.add(groupAnimation, forKey: "groupAnimation")
        }
        setUp()
        
        func alphaAnimation() -> CABasicAnimation {
            let alphaAnim = CABasicAnimation(keyPath: "opacity")
            alphaAnim.fromValue = NSNumber(value: option.alpha)
            alphaAnim.toValue = NSNumber(value: 0.3)
            return alphaAnim
        }
        
        func scaleAnimation() -> CABasicAnimation {
            let scaleAnim = CABasicAnimation(keyPath: "transform")
            scaleAnim.fromValue = NSValue(caTransform3D: CATransform3DScale(CATransform3DIdentity, 1, 1, 0))
            scaleAnim.toValue = NSValue(caTransform3D: CATransform3DScale(CATransform3DIdentity, 0.2, 0.2, 0))
            return scaleAnim
        }
    }
}
