//
//  SpringLayerAnimation.swift
//  GooeyMenu
//
//  Created by swiftprimer on 2020/11/25.
//

import UIKit

class SpringLayerAnimation {
    
    static let shared = SpringLayerAnimation()
    
    private init() { }
}

extension SpringLayerAnimation {
    
    func createBasicAnimation(keypath: String, duration: Double, fromValue: Double, toValue: Double) -> CAKeyframeAnimation {
        let animation = CAKeyframeAnimation(keyPath: keypath)
        animation.values = basicAnimationValues(duration: duration, fromValue: fromValue, toValue: toValue)
        animation.duration = duration
        animation.fillMode = .forwards
        animation.isRemovedOnCompletion = false
        return animation
    }
    
    func createSpringAnima(keypath: String, duration: Double, usingSpringWithDamping: Double, initialSpringVelocity: Double, fromValue: Double, toValue: Double) -> CAKeyframeAnimation {
        let dampingFactor: Double  = 10
        let velocityFactor: Double = 10
        let animation = CAKeyframeAnimation(keyPath: keypath)
        animation.values = springAnimationValues(duration: duration, fromValue: fromValue, toValue: toValue, damping: usingSpringWithDamping * dampingFactor, velocity: initialSpringVelocity * velocityFactor)
        animation.duration = duration
        animation.fillMode = .forwards
        animation.isRemovedOnCompletion = false
        return animation
    }
}

extension SpringLayerAnimation {
    
    private func basicAnimationValues(duration: Double, fromValue: Double, toValue: Double) -> [Double] {
        let numberOfFrames: Int = Int(duration * 60)
        var values = [Double](repeating: 0, count: numberOfFrames)
        let diff = toValue - fromValue
        for frame in 0..<numberOfFrames {
            let x = Double(frame) / Double(numberOfFrames)
            let value = fromValue + diff * x
            values[frame] = value
        }
        return values
    }
    
    private func springAnimationValues(duration: Double, fromValue: Double, toValue: Double, damping: Double, velocity: Double) -> [Double] {
        let numberOfFrames: Int = Int(duration * 60)
        var values = [Double](repeating: 0, count: numberOfFrames)
        let diff = toValue - fromValue
        for frame in 0..<numberOfFrames {
            let x = Double(frame) / Double(numberOfFrames)
            let value = toValue - diff * pow(M_E, -damping * x) * cos(velocity * x)
            values[frame] = value
        }
        return values
    }
}
