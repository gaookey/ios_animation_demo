//
//  MenuLayer.swift
//  GooeyMenu
//
//  Created by swiftprimer on 2020/11/25.
//

import UIKit

enum State {
    case state1
    case state2
    case state3
}

class MenuLayer: CALayer {
    
    var showDebug = false {
        didSet {
            setNeedsDisplay()
        }
    }
    
    var animationState = State.state1
    var xAxisPercent: CGFloat = 0
    
    private let OFF: CGFloat = 30
    
    override init() {
        super.init()
        
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    override init(layer: Any) {
        super.init(layer: layer)
        
        guard let lastLayer = layer as? MenuLayer else { return }
        
        showDebug = lastLayer.showDebug
        xAxisPercent = lastLayer.xAxisPercent
        animationState = lastLayer.animationState
    }
    
    override class func needsDisplay(forKey key: String) -> Bool {
        guard key == "xAxisPercent" else { return super.needsDisplay(forKey: key) }
        return true
    }
    
    override func draw(in ctx: CGContext) {
        
        let real_rect = frame.insetBy(dx: OFF, dy: OFF)
        let offset = real_rect.width / 3.6
        let center = CGPoint(x: self.frame.midX, y: self.frame.midY)
        
        var moveDistance_1: CGFloat = 0
        var moveDistance_2: CGFloat = 0
        var top_left = CGPoint.zero
        var top_center = CGPoint.zero
        var top_right = CGPoint.zero
        
        switch animationState {
        case .state1:
            moveDistance_1 = xAxisPercent * (real_rect.width * 0.5 - offset) * 0.5
            top_left = CGPoint(x: center.x - offset - moveDistance_1 * 2, y: OFF)
            top_center = CGPoint(x: center.x - moveDistance_1, y: OFF)
            top_right = CGPoint(x: center.x + offset, y: OFF)
        case .state2:
//            var hightFactor: CGFloat = 0
//            if xAxisPercent >= 0.2 {
//                hightFactor = 1 - xAxisPercent
//            } else {
//                hightFactor = xAxisPercent
//            }
            moveDistance_1 = (real_rect.width * 0.5 - offset) * 0.5
            moveDistance_2 = xAxisPercent * real_rect.width / 3
            top_left = CGPoint(x: center.x - offset - moveDistance_1 * 2 + moveDistance_2, y: OFF)
            top_center = CGPoint(x: center.x - moveDistance_1 + moveDistance_2, y: OFF)
            top_right = CGPoint(x: center.x + offset + moveDistance_2, y: OFF)
        case .state3:
            moveDistance_1 = (real_rect.width * 0.5 - offset) * 0.5
            moveDistance_2 = real_rect.width / 3
            
            let gooeyDis_1 = xAxisPercent * (center.x - offset - moveDistance_1 * 2 + moveDistance_2 - (center.x - offset))
            let gooeyDis_2 = xAxisPercent * (center.x - moveDistance_1 + moveDistance_2 - center.x)
            let gooeyDis_3 = xAxisPercent * (center.x + offset + moveDistance_2 - (center.x + offset))
            
            top_left = CGPoint(x: center.x - offset - moveDistance_1 * 2 + moveDistance_2 - gooeyDis_1, y: OFF)
            top_center = CGPoint(x: center.x - moveDistance_1 + moveDistance_2 - gooeyDis_2, y: OFF)
            top_right = CGPoint(x: center.x + offset + moveDistance_2 - gooeyDis_3, y: OFF)
        }
        
        let right_top    =  CGPoint(x: real_rect.maxX, y: center.y - offset)
        let right_center =  CGPoint(x: real_rect.maxX, y: center.y)
        let right_bottom =  CGPoint(x: real_rect.maxX, y: center.y + offset)
        
        let bottom_left   =  CGPoint(x: center.x - offset, y: real_rect.maxY)
        let bottom_center =  CGPoint(x: center.x, y: real_rect.maxY)
        let bottom_right  =  CGPoint(x: center.x + offset, y: real_rect.maxY)
        
        let left_top    =  CGPoint(x: OFF, y: center.y - offset)
        let left_center =  CGPoint(x: OFF, y: center.y)
        let left_bottom =  CGPoint(x: OFF, y: center.y + offset)
        
        let circlePath = UIBezierPath()
        circlePath.move(to: top_center)
        circlePath.addCurve(to: right_center, controlPoint1: top_right, controlPoint2: right_top)
        circlePath.addCurve(to: bottom_center, controlPoint1: right_bottom, controlPoint2: bottom_right)
        circlePath.addCurve(to: left_center, controlPoint1: bottom_left, controlPoint2: left_bottom)
        circlePath.addCurve(to: top_center, controlPoint1: left_top, controlPoint2: top_left)
        circlePath.close()
        
        ctx.addPath(circlePath.cgPath)
        ctx.setFillColor(UIColor(red: 29.0/255.0, green: 163.0/255.0, blue: 1.0, alpha: 1.0).cgColor)
        ctx.fillPath()
        
        guard showDebug == true else { return }
        
        ctx.setFillColor(UIColor.blue.cgColor)
        
        showPoint(point: top_left, context: ctx)
        showPoint(point: top_center, context: ctx)
        showPoint(point: top_right, context: ctx)
        
        showPoint(point: right_top, context: ctx)
        showPoint(point: right_center, context: ctx)
        showPoint(point: right_bottom, context: ctx)
        
        showPoint(point: bottom_left, context: ctx)
        showPoint(point: bottom_center, context: ctx)
        showPoint(point: bottom_right, context: ctx)
        
        showPoint(point: left_top, context: ctx)
        showPoint(point: left_center, context: ctx)
        showPoint(point: left_bottom, context: ctx)
    }
    
    private func showPoint(point: CGPoint, context: CGContext) {
        let rect = CGRect(x: point.x - 1, y: point.y - 1, width: 2, height: 2)
        context.fill(rect)
    }
}
