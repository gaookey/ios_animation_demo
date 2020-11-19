//
//  JumpStarView.swift
//  JumpStarDemo
//
//  Created by swiftprimer on 2020/11/19.
//

import UIKit

enum SelectState {
    case notMarked
    case marked
}

struct JumpStarOptions {
    var markedImage = UIImage()
    var notMarkedImage = UIImage()
    var jumpDuration: TimeInterval = 0
    var downDuration: TimeInterval = 0
}

class JumpStarView: UIView {
    
    var option = JumpStarOptions()
    
    var state = SelectState.notMarked {
        didSet {
            starView.image = state == .marked ? option.markedImage : option.notMarkedImage
        }
    }
    
    private lazy var starView: UIImageView = {
        let view = UIImageView()
        view.contentMode = .scaleToFill
        return view
    }()
    private lazy var shadowView: UIImageView = {
        let view = UIImageView(image: UIImage(named: "shadow_new"))
        view.contentMode = .scaleToFill
        view.alpha = 0.4
        return view
    }()
    
    private var animating = false
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        
        backgroundColor = .clear
        addSubview(starView)
        addSubview(shadowView)
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    override func layoutSubviews() {
        super.layoutSubviews()
        
        starView.frame = CGRect(x: bounds.width * 0.5 - (bounds.width - 6) * 0.5, y: 0, width: bounds.width - 6, height: bounds.height - 6)
        shadowView.frame = CGRect(x: (bounds.width - 10) * 0.5, y: bounds.height - 3, width: 10, height: 3)
    }
}

extension JumpStarView: CAAnimationDelegate {
    
    func animate() {
        guard animating == false else { return }
        
        animating = true
        let transformAnimation = CABasicAnimation(keyPath: "transform.rotation.y")
        transformAnimation.fromValue = 0
        transformAnimation.toValue = Double.pi / 2
        transformAnimation.timingFunction = CAMediaTimingFunction(name: .easeInEaseOut)
        
        let positionAnimation = CABasicAnimation(keyPath: "position.y")
        positionAnimation.fromValue = starView.center.y
        positionAnimation.toValue = starView.center.y - 14
        positionAnimation.timingFunction = CAMediaTimingFunction(name: .easeOut)
        
        let animationGroup = CAAnimationGroup()
        animationGroup.duration = option.jumpDuration
        animationGroup.fillMode = .forwards
        animationGroup.isRemovedOnCompletion = false
        animationGroup.delegate = self
        animationGroup.animations = [transformAnimation, positionAnimation]
        
        starView.layer.add(animationGroup, forKey: "jumpUp")
    }
}

extension JumpStarView {
    
    func animationDidStart(_ anim: CAAnimation) {
        
        if anim == starView.layer.animation(forKey: "jumpUp") {
            UIView.animate(withDuration: option.jumpDuration, delay: 0, options: .curveEaseOut, animations: { [weak self] in
                if let weakSelf = self {
                    weakSelf.shadowView.alpha = 0.2
                    weakSelf.shadowView.bounds = CGRect(x: 0, y: 0, width: weakSelf.shadowView.bounds.width * 1.6, height: weakSelf.shadowView.bounds.height)
                }
            }, completion: nil)
        } else if anim == starView.layer.animation(forKey: "jumpDown") {
            UIView.animate(withDuration: option.jumpDuration, delay: 0, options: .curveEaseOut, animations: { [weak self] in
                if let weakSelf = self {
                    weakSelf.shadowView.bounds = CGRect(x: 0, y: 0, width: weakSelf.shadowView.bounds.width / 1.6, height: weakSelf.shadowView.bounds.height)
                }
            }, completion: nil)
        }
    }
    
    func animationDidStop(_ anim: CAAnimation, finished flag: Bool) {
        
        if anim == starView.layer.animation(forKey: "jumpUp") {
            
            state = state == .marked ? .notMarked : .marked
            
            let transformAnimation = CABasicAnimation(keyPath: "transform.rotation.y")
            transformAnimation.fromValue = Double.pi / 2
            transformAnimation.toValue = Double.pi
            transformAnimation.timingFunction = CAMediaTimingFunction(name: .easeInEaseOut)
            
            let positionAnimation = CABasicAnimation(keyPath: "position.y")
            positionAnimation.fromValue = starView.center.y - 14
            positionAnimation.toValue = starView.center.y
            positionAnimation.timingFunction = CAMediaTimingFunction(name: .easeIn)
            
            let animationGroup = CAAnimationGroup()
            animationGroup.duration = option.downDuration
            animationGroup.fillMode = .forwards
            animationGroup.isRemovedOnCompletion = false
            animationGroup.delegate = self
            animationGroup.animations = [transformAnimation, positionAnimation]
            
            starView.layer.add(animationGroup, forKey: "jumpDown")
        } else if anim == starView.layer.animation(forKey: "jumpDown") {
            starView.layer.removeAllAnimations()
            animating = false
        }
    }
}
