//
//  CurveRefreshHeaderView.swift
//  AnimatedCurveDemo
//
//  Created by swiftprimer on 2020/11/24.
//

import UIKit

class CurveRefreshHeaderView: UIView {
    
    /// 需要滑动多大距离才能松开
    var pullDistance: CGFloat = 0.0
    /// 刷新执行的具体操作
    var refreshingHandler: (() -> ())?
    
    private var progress: CGFloat = 0 {
        didSet {
            if !associatedScrollView.isTracking {
                labelView.loading = true
            }
            
            if !willEnd && !loading {
                curveView.progress = progress
                labelView.progress = progress
            }
            alpha = progress
            
            center = CGPoint(x: center.x, y: -abs(associatedScrollView.contentOffset.y + originOffset) * 0.5)
            
            let diff = abs(associatedScrollView.contentOffset.y + originOffset) - pullDistance + 10
            
            if diff > 0 {
                if !associatedScrollView.isTracking && !notTracking {
                    
                    notTracking = true
                    loading = true
                    
                    curveView.startInfiniteRotation()
                    UIView.animate(withDuration: 0.3) { [weak self] in
                        if let weakSelf = self {
                            weakSelf.associatedScrollView.contentInset = UIEdgeInsets(top: weakSelf.pullDistance + weakSelf.originOffset, left: 0, bottom: 0, right: 0)
                        }
                    } completion: { [weak self] (finish) in
                        self?.refreshingHandler?()
                    }
                }
                
                if !loading {
                    curveView.transform = CGAffineTransform(rotationAngle: .pi * diff * 2 / 180)
                }
            } else {
                labelView.loading = false
                curveView.transform = .identity
            }
        }
    }
    
    private var associatedScrollView = UIScrollView()
    private var labelView = LabelView()
    private var curveView = CurveView()
    private var willEnd = false
    private var notTracking = false
    private var loading = false
    private var originOffset: CGFloat = 0
    
    init(view: UIScrollView, withNavigationBar: Bool) {
        super.init(frame: CGRect(x: (view.bounds.width - 200) * 0.5, y: -100, width: 200, height: 100))
        
        originOffset = withNavigationBar ? 64 : 0
        
        associatedScrollView = view
        setup()
        associatedScrollView.addObserver(self, forKeyPath: "contentOffset", options: [.new, .old], context: nil)
        associatedScrollView.insertSubview(self, at: 0)
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    deinit {
        associatedScrollView.removeObserver(self, forKeyPath: "contentOffset")
    }
}

extension CurveRefreshHeaderView {
    
    func triggerPulling() {
        associatedScrollView.setContentOffset(CGPoint(x: 0, y: -pullDistance - originOffset), animated: true)
    }
    
    func stopRefreshing() {
        willEnd = true
        progress = 1
        UIView.animate(withDuration: 0.1, delay: 0, options: .curveEaseInOut) { [weak self] in
            if let weakSelf = self {
                weakSelf.associatedScrollView.contentInset = UIEdgeInsets(top: weakSelf.originOffset + 0.1, left: 0, bottom: 0, right: 0)
            }
        } completion: { [weak self] (finish) in
            self?.willEnd = false
            self?.notTracking = false
            self?.loading = false
            self?.labelView.loading = false
            self?.curveView.stopInfiniteRotation()
        }
    }
}

extension CurveRefreshHeaderView {
    
    private func setup() {
        pullDistance = 99
        curveView = CurveView(frame: CGRect(x: 20, y: 0, width: 30, height: bounds.height))
        insertSubview(curveView, at: 0)
        
        labelView = LabelView(frame: CGRect(x: curveView.frame.origin.x + curveView.bounds.width + 10, y: curveView.frame.origin.y, width: 150, height: curveView.bounds.height))
        labelView.state = .down
        insertSubview(labelView, aboveSubview: curveView)
    }
}

extension CurveRefreshHeaderView {
    
    override func observeValue(forKeyPath keyPath: String?, of object: Any?, change: [NSKeyValueChangeKey : Any]?, context: UnsafeMutableRawPointer?) {
        
        guard keyPath == "contentOffset",
              let change = change,
              let contentOffset: CGPoint = change[.newKey] as? CGPoint,
              contentOffset.y + originOffset <= 0 else { return }
        
        progress = max(0, min(abs(contentOffset.y + originOffset) / pullDistance, 1))
    }
}

extension UIView {
    
    func startInfiniteRotation() {
        transform = .identity
        let animation = CABasicAnimation(keyPath: "transform.rotation.z")
        animation.toValue = Double.pi * 2
        animation.duration = 0.5
        animation.autoreverses = false
        animation.repeatCount = HUGE
        animation.timingFunction = CAMediaTimingFunction(name: .linear)
        layer.add(animation, forKey: "rotationAnimation")
    }
    
    func stopInfiniteRotation() {
        layer.removeAllAnimations()
    }
}
