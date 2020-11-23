//
//  LoadingHUD.swift
//  LoadingHUD
//
//  Created by swiftprimer on 2020/11/23.
//

import UIKit

class LoadingHUD: UIVisualEffectView {
    
    let BALL_RADIUS: CGFloat = 20
    
    private var ball_1 = UIView()
    private var ball_2 = UIView()
    private var ball_3 = UIView()
    private var timer: Timer?
    
    static let sharedHUD = LoadingHUD(effect: UIBlurEffect(style: .dark))
    
    private init(effect: UIVisualEffect) {
        super.init(effect: effect)
        
        frame = UIScreen.main.bounds
        
        ball_2 = UIView(frame: CGRect(x: bounds.width * 0.5 - BALL_RADIUS * 0.5, y: bounds.height * 0.5 - BALL_RADIUS * 0.5, width: BALL_RADIUS, height: BALL_RADIUS))
        ball_2.backgroundColor = .orange
        ball_2.layer.cornerRadius = ball_2.bounds.width * 0.5
        
        ball_1 = UIView(frame: CGRect(x: ball_2.frame.origin.x - BALL_RADIUS, y: ball_2.frame.origin.y, width: BALL_RADIUS, height: BALL_RADIUS))
        ball_1.backgroundColor = .orange
        ball_1.layer.cornerRadius = ball_1.bounds.width * 0.5
        
        ball_3 = UIView(frame: CGRect(x: ball_2.frame.origin.x + BALL_RADIUS, y: ball_2.frame.origin.y, width: BALL_RADIUS, height: BALL_RADIUS))
        ball_3.backgroundColor = .orange
        ball_3.layer.cornerRadius = ball_3.bounds.width * 0.5
        
        contentView.addSubview(ball_1)
        contentView.addSubview(ball_2)
        contentView.addSubview(ball_3)
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    class func showHUD() {
        let hud = LoadingHUD.sharedHUD
        if let window = UIApplication.shared.windows.filter({ $0.isKeyWindow }).first {
            
            hud.alpha = 0.0
            window.addSubview(hud)
            UIView.animate(withDuration: 0.3) {
                hud.alpha = 0.9
            } completion: { (finish) in
                hud.alpha = 0.9
                hud.startLoadingAnimation()
            }
        }
    }
    
    class func dismissHUD() {
        let hud = LoadingHUD.sharedHUD
        hud.stopLoadingAnimation()
        hud.timer?.invalidate()
        hud.timer = nil
        
        UIView.animate(withDuration: 0.3) {
            hud.alpha = 0
        } completion: { (finish) in
            hud.removeFromSuperview()
        }
    }
}

extension LoadingHUD {
    
    private func stopLoadingAnimation() {
        ball_1.layer.removeAllAnimations()
        ball_2.layer.removeAllAnimations()
        ball_3.layer.removeAllAnimations()
    }
    
    private func startLoadingAnimation() {
        //-----1--------
        let circlePath_1 = UIBezierPath()
        circlePath_1.move(to: CGPoint(x: bounds.width * 0.5 - BALL_RADIUS, y: bounds.height * 0.5))
        circlePath_1.addArc(withCenter: CGPoint(x: bounds.width * 0.5, y: bounds.height * 0.5), radius: BALL_RADIUS, startAngle: CGFloat((180 * Double.pi) / 180), endAngle: CGFloat((360 * Double.pi) / 180), clockwise: false)
        
        let circlePath_1_2 = UIBezierPath()
        circlePath_1_2.addArc(withCenter: CGPoint(x: bounds.width * 0.5, y: bounds.height * 0.5), radius: BALL_RADIUS, startAngle: 0.0, endAngle: CGFloat((180 * Double.pi) / 180), clockwise: false)
        circlePath_1.append(circlePath_1_2)
        
        let animation = CAKeyframeAnimation(keyPath: "position")
        animation.path = circlePath_1.cgPath
        animation.isRemovedOnCompletion = true
        animation.duration = 1.4
        animation.repeatCount = MAXFLOAT
        animation.timingFunction = CAMediaTimingFunction(name: .easeInEaseOut)
        ball_1.layer.add(animation, forKey: "ball_1_rotation_animation")
        
        //------2--------
        let circlePath_2 = UIBezierPath()
        circlePath_2.move(to: CGPoint(x: bounds.width * 0.5 + BALL_RADIUS, y: bounds.height * 0.5))
        circlePath_2.addArc(withCenter: CGPoint(x: bounds.width * 0.5, y: bounds.height * 0.5), radius: BALL_RADIUS, startAngle: 0, endAngle: CGFloat((180 * Double.pi) / 180), clockwise: false)
        
        let circlePath_2_2 = UIBezierPath()
        circlePath_2_2.addArc(withCenter: CGPoint(x: bounds.width * 0.5, y: bounds.height * 0.5), radius: BALL_RADIUS, startAngle: CGFloat((180 * Double.pi) / 180), endAngle: CGFloat((360 * Double.pi) / 180), clockwise: false)
        circlePath_2.append(circlePath_2_2)
        
        let animation_2 = CAKeyframeAnimation(keyPath: "position")
        animation_2.path = circlePath_2.cgPath
        animation_2.isRemovedOnCompletion = true
        animation_2.repeatCount = MAXFLOAT
        animation_2.duration = 1.4
        animation_2.timingFunction = CAMediaTimingFunction(name: .easeInEaseOut)
        ball_3.layer.add(animation_2, forKey: "ball_2_rotation_animation")
        
        timer = Timer.scheduledTimer(withTimeInterval: 0.7, repeats: true, block: { (timer) in
            
            UIView.animate(withDuration: 0.3) {
                self.ball_1.transform = CGAffineTransform(translationX: -self.BALL_RADIUS, y: 0)
                self.ball_1.transform = self.ball_1.transform.scaledBy(x: 0.7, y: 0.7)
                
                self.ball_3.transform = CGAffineTransform(translationX: self.BALL_RADIUS, y: 0)
                self.ball_3.transform = self.ball_3.transform.scaledBy(x: 0.7, y: 0.7)
                
                self.ball_2.transform = self.ball_2.transform.scaledBy(x: 0.7, y: 0.7)
                
            } completion: { (finish) in
                UIView.animate(withDuration: 0.3) {
                    self.ball_1.transform = .identity
                    self.ball_3.transform = .identity
                    self.ball_2.transform = .identity
                }
            }
        })
        
        RunLoop.main.add(timer!, forMode: .common)
    }
}



