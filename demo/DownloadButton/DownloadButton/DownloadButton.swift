//
//  DownloadButton.swift
//  DownloadButton
//
//  Created by swiftprimer on 2020/11/27.
//

import UIKit

let kRadiusShrinkAnim = "cornerRadiusShrinkAnim"
let kRadiusExpandAnim = "radiusExpandAnimation"
let kProgressBarAnimation = "progressBarAnimation"
let kCheckAnimation = "checkAnimation"

class DownloadButton: UIView {
    
    var progressBarHeight: CGFloat = 0
    var progressBarWidth: CGFloat = 0
    
    private var originframe = CGRect.zero
    private var animating: Bool = false
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        
        setUpViews()
    }
    
    required init?(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)
        
        setUpViews()
    }
    
    private func setUpViews(){
        let tapGes = UITapGestureRecognizer(target: self, action: #selector(handleButtonDidTapped(gesture:)))
        addGestureRecognizer(tapGes)
    }
    
    @objc private func handleButtonDidTapped(gesture: UITapGestureRecognizer){
        guard !animating else { return }
        
        animating = true
        originframe = frame
        layer.sublayers?.forEach({ $0.removeFromSuperlayer() })
        
        backgroundColor = UIColor(red: 0, green: 122 / 255.0, blue: 255 / 255.0, alpha: 1)
        layer.cornerRadius = progressBarHeight * 0.5
        
        let radiusShrinkAnimation = CABasicAnimation(keyPath: "cornerRadius")
        radiusShrinkAnimation.duration = 0.2
        radiusShrinkAnimation.timingFunction = CAMediaTimingFunction(name: .easeOut)
        radiusShrinkAnimation.fromValue = originframe.height * 0.5
        radiusShrinkAnimation.delegate = self
        layer.add(radiusShrinkAnimation, forKey: kRadiusShrinkAnim)
    }
    
    private func progressBarAnimation() {
        
        let progressLayer = CAShapeLayer()
        let path = UIBezierPath()
        path.move(to: CGPoint(x: progressBarHeight * 0.5, y: frame.height * 0.5))
        path.addLine(to: CGPoint(x: bounds.width - progressBarHeight * 0.5, y: bounds.height * 0.5))
        
        progressLayer.path = path.cgPath
        progressLayer.strokeColor = UIColor.white.cgColor
        progressLayer.lineWidth = progressBarHeight - 6
        progressLayer.lineCap = .round
        layer.addSublayer(progressLayer)
        
        let pathAnimation = CABasicAnimation(keyPath: "strokeEnd")
        pathAnimation.duration = 2
        pathAnimation.fromValue = 0
        pathAnimation.toValue = 1
        pathAnimation.delegate = self
        pathAnimation.setValue(kProgressBarAnimation, forKey: "animationName")
        progressLayer.add(pathAnimation, forKey: nil)
    }
    
    private func checkAnimation() {
        let checkLayer = CAShapeLayer()
        let path = UIBezierPath()
        let rectInCircle = bounds.insetBy(dx: bounds.width * (1 - 1 / sqrt(2.0)) / 2, dy: bounds.width * (1 - 1 / sqrt(2.0)) / 2)
        path.move(to: CGPoint(x: rectInCircle.origin.x + rectInCircle.width / 9, y: rectInCircle.origin.y + rectInCircle.height * 2 / 3))
        path.addLine(to: CGPoint(x: rectInCircle.origin.x + rectInCircle.width / 3,y: rectInCircle.origin.y + rectInCircle.height * 9 / 10))
        path.addLine(to: CGPoint(x: rectInCircle.origin.x + rectInCircle.width * 8 / 10, y: rectInCircle.origin.y + rectInCircle.height * 2 / 10))
        
        checkLayer.path = path.cgPath
        checkLayer.fillColor = UIColor.clear.cgColor
        checkLayer.strokeColor = UIColor.white.cgColor
        checkLayer.lineWidth = 10
        checkLayer.lineCap = .round
        checkLayer.lineJoin = .round
        layer.addSublayer(checkLayer)
        
        let checkAnimation = CABasicAnimation(keyPath: "strokeEnd")
        checkAnimation.duration = 0.3
        checkAnimation.fromValue = 0
        checkAnimation.toValue = 1
        checkAnimation.delegate = self
        checkAnimation.setValue(kCheckAnimation, forKey:"animationName")
        checkLayer.add(checkAnimation,forKey:nil)
    }
}

extension DownloadButton: CAAnimationDelegate {
    
    func animationDidStart(_ anim: CAAnimation) {
        
        if anim.isEqual(layer.animation(forKey: kRadiusShrinkAnim)) {
            UIView.animate(withDuration: 0.6, delay: 0, usingSpringWithDamping: 0.6, initialSpringVelocity: 0, options: .curveEaseOut) { [weak self] in
                guard let weakSelf = self else { return }
                weakSelf.bounds = CGRect(x: 0, y: 0, width: weakSelf.progressBarWidth, height: weakSelf.progressBarHeight)
            } completion: { [weak self] (finish) in
                self?.layer.removeAllAnimations()
                self?.progressBarAnimation()
            }
        } else if anim.isEqual(layer.animation(forKey: kRadiusExpandAnim)){
            
            UIView.animate(withDuration: 0.6, delay: 0, usingSpringWithDamping: 0.6, initialSpringVelocity: 0, options: .curveEaseOut) { [weak self] in
                guard let weakSelf = self else { return }
                weakSelf.bounds = CGRect(x: 0, y: 0, width: weakSelf.originframe.width, height: weakSelf.originframe.height)
                weakSelf.backgroundColor = UIColor(red: 0.1803921568627451, green: 0.8, blue: 0.44313725490196076, alpha: 1.0)
            } completion: { [weak self] (finish) in
                self?.layer.removeAllAnimations()
                self?.checkAnimation()
                self?.animating = false
            }
        }
    }
    
    func animationDidStop(_ anim: CAAnimation, finished flag: Bool) {
        
        guard let animationName: String = anim.value(forKey: "animationName") as? String,
              animationName == kProgressBarAnimation
        else { return }
        
        UIView.animate(withDuration: 0.3) { [weak self] in
            guard let sublayers = self?.layer.sublayers else { return }
            sublayers.forEach({ $0.opacity = 0 })
        } completion: { [weak self] (finish) in
            
            guard let weakSelf = self else { return }
            weakSelf.layer.sublayers?.forEach({ $0.removeFromSuperlayer() })
            weakSelf.layer.cornerRadius = weakSelf.originframe.height * 0.5
            
            let radiusExpandAnimation = CABasicAnimation(keyPath: "cornerRadius")
            radiusExpandAnimation.duration = 0.2
            radiusExpandAnimation.timingFunction = CAMediaTimingFunction(name: .easeOut)
            radiusExpandAnimation.fromValue = weakSelf.progressBarHeight * 0.5
            radiusExpandAnimation.delegate = self
            weakSelf.layer.add(radiusExpandAnimation, forKey: kRadiusExpandAnim)
        }
    }
}
