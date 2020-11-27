//
//  DotsFlipReplicatorLayer.swift
//  ReplicatorLoaderDemo
//
//  Created by swiftprimer on 2020/11/27.
//

import UIKit

struct DotsFlipReplicatorLayer: Replicatable {
    
    func configureReplicatorLayer(layer: CALayer, option: Options) {
        
        func setUp() {
            let marginBetweenDot: CGFloat = 5
            let size = layer.bounds.width
            let dotSize = (size - 2 * marginBetweenDot) / 3
            
            let dot = CAShapeLayer()
            dot.frame = CGRect(
                x: 0,
                y: (size - dotSize) / 2,
                width: dotSize,
                height: dotSize)
            
            dot.path = UIBezierPath(rect: CGRect(x: 0, y: 0, width: dotSize, height: dotSize)).cgPath
            dot.fillColor = option.color.cgColor
            
            let replicatorLayer = CAReplicatorLayer()
            replicatorLayer.frame = CGRect(x: 0,y: 0,width: size, height: size)
            
            replicatorLayer.instanceDelay = 0.1
            replicatorLayer.instanceCount = 3
            replicatorLayer.instanceTransform = CATransform3DMakeTranslation(marginBetweenDot + dotSize, 0, 0)
            
            replicatorLayer.addSublayer(dot)
            layer.addSublayer(replicatorLayer)
            dot.add(flipAnimation(), forKey: "scaleAnimation")
        }
        setUp()
        
        func flipAnimation() -> CABasicAnimation {
            let scaleAnim = CABasicAnimation(keyPath: "transform")
            scaleAnim.fromValue = NSValue.init(caTransform3D: CATransform3DRotate(CATransform3DIdentity, 0, 0, 1, 0))
            scaleAnim.toValue = NSValue.init(caTransform3D: CATransform3DRotate(CATransform3DIdentity, CGFloat(Double.pi), 0, 1, 0))
            scaleAnim.repeatCount = HUGE
            scaleAnim.duration = 0.6
            return scaleAnim
        }
    }
}
