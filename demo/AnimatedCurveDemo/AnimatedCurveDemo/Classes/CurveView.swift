//
//  CurveView.swift
//  AnimatedCurveDemo
//
//  Created by swiftprimer on 2020/11/24.
//

import UIKit

class CurveView: UIView {
    
    var progress: CGFloat = 0 {
        didSet {
            curveLayer.progress = progress
            curveLayer.setNeedsDisplay()
        }
    }
    
    private var curveLayer = CurveLayer()
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    override func willMove(toSuperview newSuperview: UIView?) {
        super.willMove(toSuperview: newSuperview)
        
        curveLayer = CurveLayer()
        curveLayer.frame = bounds
        curveLayer.contentsScale = UIScreen.main.scale
        curveLayer.progress = 0
        curveLayer.setNeedsDisplay()
        layer.addSublayer(curveLayer)
    }
}
