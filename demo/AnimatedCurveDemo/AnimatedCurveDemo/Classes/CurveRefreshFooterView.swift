//
//  CurveRefreshFooterView.swift
//  AnimatedCurveDemo
//
//  Created by swiftprimer on 2020/11/24.
//

import UIKit

class CurveRefreshFooterView: UIView {
    
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
            
            let diff = associatedScrollView.contentOffset.y - (associatedScrollView.contentSize.height - associatedScrollView.bounds.height) - pullDistance + 10
            
            if diff > 0 {
                if !associatedScrollView.isTracking && !isHidden && !notTracking{
                    notTracking = true
                    loading = true
                    
                    curveView.startInfiniteRotation()
                    UIView.animate(withDuration: 0.3) { [weak self] in
                        if let weakSelf = self {
                            weakSelf.associatedScrollView.contentInset = UIEdgeInsets(top: weakSelf.originOffset, left: 0, bottom: weakSelf.pullDistance, right: 0)
                        }
                    } completion: { (finish) in
                        self.refreshingHandler?()
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
    private var contentSize = CGSize.zero
    private var originOffset: CGFloat = 0
    private var willEnd = false
    private var notTracking = false
    private var loading = false
    
    init(view: UIScrollView, withNavigationBar: Bool) {
        super.init(frame: CGRect(x: (view.bounds.width - 200) * 0.5, y: view.bounds.height, width: 200, height: 100))
        
        originOffset = withNavigationBar ? 64 : 0
        
        associatedScrollView = view
        setup()
        associatedScrollView.addObserver(self, forKeyPath: "contentOffset", options: [.new, .old], context: nil)
        associatedScrollView.addObserver(self, forKeyPath: "contentSize", options: [.new, .old], context: nil)
        isHidden = true
        associatedScrollView.insertSubview(self, at: 0)
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    deinit {
        associatedScrollView.removeObserver(self, forKeyPath: "contentOffset")
        associatedScrollView.removeObserver(self, forKeyPath: "contentSize")
    }
}

extension CurveRefreshFooterView {
    
    private func setup() {
        pullDistance = 99
        curveView = CurveView(frame: CGRect(x: 20, y: 0, width: 30, height: bounds.height))
        insertSubview(curveView, at: 0)
        
        labelView = LabelView(frame: CGRect(x: curveView.frame.origin.x + curveView.bounds.width + 10, y: curveView.frame.origin.y, width: 150, height: curveView.bounds.height))
        labelView.state = .up
        insertSubview(labelView, aboveSubview: curveView)
    }
}

extension CurveRefreshFooterView {
    
    func stopRefreshing() {
        willEnd = true
        progress = 1
        UIView.animate(withDuration: 0.1, delay: 0, options: .curveEaseInOut) { [weak self] in
            if let weakSelf = self {
                weakSelf.associatedScrollView.contentInset = UIEdgeInsets(top: weakSelf.originOffset, left: 0, bottom: 0, right: 0)
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

extension CurveRefreshFooterView {
    
    override func observeValue(forKeyPath keyPath: String?, of object: Any?, change: [NSKeyValueChangeKey : Any]?, context: UnsafeMutableRawPointer?) {
        
        if keyPath == "contentSize" {
            guard let change = change,
                  let contentSize = change[.newKey] as? CGSize else { return }
            self.contentSize = contentSize
            if contentSize.height > 0 {
                isHidden = false
            }
            frame = CGRect(x: (associatedScrollView.bounds.width - 200) * 0.5, y: contentSize.height, width: 200, height: 100)
        }
        
        if keyPath == "contentOffset" {
            guard let change = change,
                  let contentOffset = change[.newKey] as? CGPoint,
                  contentOffset.y >= (contentSize.height - associatedScrollView.bounds.height) else { return }
            
            center = CGPoint(x: center.x, y: contentSize.height + (contentOffset.y - (contentSize.height - associatedScrollView.bounds.height)) * 0.5)
            progress = max(0, min((contentOffset.y - (contentSize.height - associatedScrollView.bounds.height)) / pullDistance, 1))
        }
    }
}
