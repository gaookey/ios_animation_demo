//
//  CurveLayer.swift
//  AnimatedCurveDemo
//
//  Created by swiftprimer on 2020/11/24.
//

import UIKit

class CurveLayer: CALayer {
    
    var progress: CGFloat = 0
    
    private let Radius: CGFloat =  10
    private let Space: CGFloat  =  1
    private let LineLength: CGFloat = 30
    private let Degree: CGFloat = CGFloat(Double.pi / 3)
    
    override init() {
        super.init()
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    override func draw(in ctx: CGContext) {
        super.draw(in: ctx)
        
        UIGraphicsPushContext(ctx)
        let context = UIGraphicsGetCurrentContext()
        
        let curvePath1 = UIBezierPath()
        curvePath1.lineCapStyle = .round
        curvePath1.lineJoinStyle = .round
        curvePath1.lineWidth = 2
        
        let arrowPath = UIBezierPath()
        
        if progress <= 0.5 {
            let pointA = CGPoint(x: bounds.width * 0.5 - Radius, y: bounds.height * 0.5 - Space + LineLength + (1 - 2 * progress) * (bounds.height * 0.5 - LineLength))
            let pointB = CGPoint(x: bounds.width * 0.5 - Radius, y: bounds.height * 0.5 - Space + (1 - 2 * progress) * (bounds.height * 0.5 - LineLength))
            curvePath1.move(to: pointA)
            curvePath1.addLine(to: pointB)
            
            arrowPath.move(to: pointB)
            arrowPath.addLine(to: CGPoint(x: pointB.x - 3 * cos(Degree), y: pointB.y + 3 * sin(Degree)))
            curvePath1.append(arrowPath)
        } else {
            let pointA = CGPoint(x: bounds.width * 0.5 - Radius, y: bounds.height * 0.5 - Space + LineLength - LineLength * (progress - 0.5) * 2)
            let pointB = CGPoint(x: bounds.width * 0.5 - Radius, y: bounds.height * 0.5 - Space)
            curvePath1.move(to: pointA)
            curvePath1.addLine(to: pointB)
            curvePath1.addArc(withCenter: CGPoint(x: bounds.width * 0.5, y: bounds.height * 0.5 - Space), radius: Radius, startAngle: .pi, endAngle: .pi + .pi * 9 / 10 * (progress - 0.5) * 2, clockwise: true)
            
            arrowPath.move(to: curvePath1.currentPoint)
            arrowPath.addLine(to: CGPoint(x: curvePath1.currentPoint.x - 3 * cos(Degree - .pi * 9 / 10) * (progress - 0.5) * 2, y: curvePath1.currentPoint.y + 3 * sin(Degree - .pi * 9 / 10) * (progress - 0.5) * 2))
            curvePath1.append(arrowPath)
        }
        
        let curvePath2 = UIBezierPath()
        curvePath2.lineCapStyle = .round
        curvePath2.lineJoinStyle = .round
        curvePath2.lineWidth = 2
        
        if progress <= 0.5 {
            let pointA = CGPoint(x: bounds.width * 0.5 + Radius, y: 2 * progress * (bounds.height * 0.5 + Space - LineLength))
            let pointB = CGPoint(x: bounds.width * 0.5 + Radius, y: LineLength + 2 * progress * (bounds.height * 0.5 + Space - LineLength))
            curvePath2.move(to: pointA)
            curvePath2.addLine(to: pointB)
            
            arrowPath.move(to: pointB)
            arrowPath.addLine(to: CGPoint(x: pointB.x + 3 * cos(Degree), y: pointB.y - 3 * sin(Degree)))
            curvePath2.append(arrowPath)
        }
        
        if progress > 0.5 {
            curvePath2.move(to: CGPoint(x: bounds.width * 0.5 + Radius, y: bounds.height * 0.5 + Space - LineLength + LineLength * (progress - 0.5) * 2))
            curvePath2.addLine(to: CGPoint(x: bounds.width * 0.5 + Radius, y: bounds.height * 0.5 + Space))
            curvePath2.addArc(withCenter: CGPoint(x: bounds.width * 0.5, y: bounds.height * 0.5 + Space), radius: Radius, startAngle: 0, endAngle: .pi * 9 / 10 * (progress - 0.5) * 2, clockwise: true)
            
            arrowPath.move(to: curvePath2.currentPoint)
            arrowPath.addLine(to: CGPoint(x: curvePath2.currentPoint.x + 3 * cos(Degree - .pi * 9 / 10) * (progress - 0.5) * 2, y: curvePath2.currentPoint.y - 3 * sin(Degree - .pi * 9 / 10) * (progress - 0.5) * 2))
            curvePath2.append(arrowPath)
        }
        
        context?.saveGState()
        context?.restoreGState()
        
        UIColor.black.setStroke()
        arrowPath.stroke()
        curvePath1.stroke()
        curvePath2.stroke()
        
        UIGraphicsPopContext()
    }
}
