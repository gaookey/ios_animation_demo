//
//  TvOSCardView.swift
//  tvOSCardAnimation
//
//  Created by swiftprimer on 2020/11/25.
//

import UIKit

class TvOSCardView: UIView {
    
    private lazy var cardImageView: UIImageView = {
        let view = UIImageView(frame: bounds)
        view.image = UIImage(named: "poster")
        view.layer.masksToBounds = true
        view.layer.cornerRadius = 5
        view.contentMode = .scaleAspectFill
        return view
    }()
    
    private lazy var cardParallaxView: UIImageView = {
        let view = UIImageView(frame: bounds)
        view.image = UIImage(named: "5")
        view.layer.transform = CATransform3DTranslate(view.layer.transform, 0, 0, 200)
        view.contentMode = .scaleAspectFill
        return view
    }()
    
    override func willMove(toSuperview newSuperview: UIView?) {
        super.willMove(toSuperview: newSuperview)
        
        setUpViews()
    }
    
    private func setUpViews() {
        layer.shadowColor = UIColor.black.cgColor
        layer.shadowOffset = CGSize(width: 0, height: 10)
        layer.shadowRadius = 10
        layer.shadowOpacity = 0.3
        
        let panGesture = UIPanGestureRecognizer(target: self, action: #selector(panInCard(panGes:)))
        addGestureRecognizer(panGesture)
        
        addSubview(cardImageView)
        insertSubview(cardParallaxView, aboveSubview: cardImageView)
    }
    
    @objc private func panInCard(panGes: UIPanGestureRecognizer) {
        let touchPoint = panGes.location(in: self)
        
        if panGes.state == .changed {
            let xFactor = min(1, max(-1, (touchPoint.x - bounds.width * 0.5) / bounds.width * 0.5))
            let yFactor = min(1, max(-1, (touchPoint.y - bounds.height * 0.5) / bounds.height * 0.5))
            cardImageView.layer.transform = transformWithM34(m34: -1 / 500, xf: xFactor, yf: yFactor)
            cardParallaxView.layer.transform = transformWithM34(m34: -1 / 250, xf: xFactor, yf: yFactor)
        } else if panGes.state == .ended {
            UIView.animate(withDuration: 0.3) { [weak self] in
                self?.cardImageView.layer.transform = CATransform3DIdentity
                self?.cardParallaxView.layer.transform = CATransform3DIdentity
            }
        }
    }
}

extension TvOSCardView {
    
    private func transformWithM34(m34: CGFloat, xf: CGFloat, yf: CGFloat) -> CATransform3D {
        var t = CATransform3DIdentity
        t.m34 = m34
        t = CATransform3DRotate(t, .pi / 9 * yf, -1, 0, 0)
        t = CATransform3DRotate(t, .pi / 9 * xf, 0, -1, 0)
        return t
    }
}
