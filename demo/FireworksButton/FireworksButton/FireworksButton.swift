//
//  FireworksButton.swift
//  FireworksButton
//
//  Created by swiftprimer on 2020/11/27.
//

import UIKit

class FireworksButton: UIButton {
    
    var particleImage: UIImage {
        get {
            return fireworksView.particleImage
        }
        set {
            fireworksView.particleImage = newValue
        }
    }
    
    var particleScale: CGFloat {
        get {
            return fireworksView.particleScale
        }
        set {
            fireworksView.particleScale = newValue
        }
    }
    
    var particleScaleRange: CGFloat {
        get {
            return fireworksView.particleScaleRange
        }
        set {
            fireworksView.particleScaleRange = newValue
        }
    }
    
    private var fireworksView = FireworksView()
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        
        setup()
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    override func layoutSubviews() {
        super.layoutSubviews()
        
        fireworksView.frame = bounds
        insertSubview(fireworksView, at: 0)
    }
}

extension FireworksButton {
    
    func animate() {
        fireworksView.animate()
    }
    
    func popOutside(_ duration: TimeInterval) {
        
        transform = .identity
        
        UIView.animateKeyframes(withDuration: duration, delay: 0, options: [], animations: { [weak self] in
            UIView.addKeyframe(withRelativeStartTime: 0, relativeDuration: 1.0 / 3.0) { [weak self] in
                self?.transform = CGAffineTransform(scaleX: 1.5, y: 1.5)
            }
            UIView.addKeyframe(withRelativeStartTime: 1.0 / 3.0, relativeDuration: 1.0 / 3.0) { [weak self] in
                self?.transform = CGAffineTransform(scaleX: 0.8, y: 0.8)
            }
            UIView.addKeyframe(withRelativeStartTime: 2.0 / 3.0, relativeDuration: 1.0 / 3.0) { [weak self] in
                self?.transform = CGAffineTransform(scaleX: 1, y: 1)
            }
        }, completion: nil)
    }
    
    func popInside(_ duration: TimeInterval) {
        
        transform = .identity
        
        UIView.animateKeyframes(withDuration: duration, delay: 0, options: [], animations: { [weak self] in
            UIView.addKeyframe(withRelativeStartTime: 0, relativeDuration: 1.0 / 2.0) { [weak self] in
                self?.transform = CGAffineTransform(scaleX: 0.8, y: 0.8)
            }
            UIView.addKeyframe(withRelativeStartTime: 1.0 / 2.0, relativeDuration: 1.0 / 2.0) { [weak self] in
                self?.transform = CGAffineTransform(scaleX: 1, y: 1)
            }
        }, completion: nil)
    }
}

extension FireworksButton {
    
    private func setup() {
        clipsToBounds = false
        
        fireworksView = FireworksView()
        insertSubview(fireworksView, at: 0)
    }
}
