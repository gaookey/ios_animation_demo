//
//  SPCircleView.swift
//  demo
//
//  Created by swiftprimer on 2020/11/13.
//

import UIKit

class SPCircleView: UIView {
    
    var circleLayer = CircleLayer()
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        
        circleLayer.frame = bounds
        circleLayer.contentsScale = UIScreen.main.scale
        layer.addSublayer(circleLayer)
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
}

enum MovingPoint {
    case POINT_D
    case POINT_B
}

let outsideRectSize: CGFloat = 100

class CircleLayer: CALayer {
    
    var progress: CGFloat = 0.0 {
        didSet{
            //外接矩形在左侧，则改变B点；在右边，改变D点
            if progress <= 0.5 {
                movePoint = .POINT_B;
                print("B点动")
            }else{
                movePoint = .POINT_D;
                print("D点动")
            }
            
            lastProgress = progress
            let buff = (progress - 0.5) * (frame.width - outsideRectSize)
            let origin_x = position.x - outsideRectSize / 2 + buff
            let origin_y = position.y - outsideRectSize / 2;
            
            outsideRect = CGRect(x: origin_x, y: origin_y, width: outsideRectSize, height: outsideRectSize)
            setNeedsDisplay()
        }
    }
    
    private var outsideRect = CGRect.zero
    private var lastProgress: CGFloat = 0.5
    private var movePoint = MovingPoint.POINT_B
    
    override init() {
        super.init()
        
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    override func draw(in ctx: CGContext) {
        let offset = outsideRect.width / 3.6
        let movedDistance = (outsideRect.width * 1 / 6) * abs(progress - 0.5) * 2
        let rectCenter = CGPoint(x: outsideRect.origin.x + outsideRect.width / 2 , y: outsideRect.origin.y + outsideRect.height / 2)
        
        let pointA = CGPoint(x: rectCenter.x ,y: outsideRect.origin.y + movedDistance)
        let pointB = CGPoint(x: movePoint == .POINT_D ? rectCenter.x + outsideRect.width / 2 : rectCenter.x + outsideRect.width / 2 + movedDistance * 2 ,y: rectCenter.y)
        let pointC = CGPoint(x: rectCenter.x ,y: rectCenter.y + outsideRect.height / 2 - movedDistance)
        let pointD = CGPoint(x: movePoint == .POINT_D ? outsideRect.origin.x - movedDistance * 2 : outsideRect.origin.x, y: rectCenter.y)
        
        let c1 = CGPoint(x: pointA.x + offset, y: pointA.y)
        let c2 = CGPoint(x: pointB.x, y: movePoint == .POINT_D ? pointB.y - offset : pointB.y - offset + movedDistance)
        
        let c3 = CGPoint(x: pointB.x, y: movePoint == .POINT_D ? pointB.y + offset : pointB.y + offset - movedDistance)
        let c4 = CGPoint(x: pointC.x + offset, y: pointC.y)
        
        let c5 = CGPoint(x: pointC.x - offset, y: pointC.y)
        let c6 = CGPoint(x: pointD.x, y: movePoint == .POINT_D ? pointD.y + offset - movedDistance : pointD.y + offset)
        
        let c7 = CGPoint(x: pointD.x, y: movePoint == .POINT_D ? pointD.y - offset + movedDistance : pointD.y - offset)
        let c8 = CGPoint(x: pointA.x - offset, y: pointA.y)
        
        //外接虚线矩形
        let rectPath = UIBezierPath(rect: outsideRect)
        ctx.addPath(rectPath.cgPath)
        ctx.setStrokeColor(UIColor.purple.cgColor)
        ctx.setLineWidth(1.0)
        ctx.setLineDash(phase: 0, lengths: [5, 5])
        ctx.strokePath()
        
        //圆的边界
        let ovalPath = UIBezierPath()
        ovalPath.move(to: pointA)
        ovalPath.addCurve(to: pointB, controlPoint1: c1, controlPoint2: c2)
        ovalPath.addCurve(to: pointC, controlPoint1: c3, controlPoint2: c4)
        ovalPath.addCurve(to: pointD, controlPoint1: c5, controlPoint2: c6)
        ovalPath.addCurve(to: pointA, controlPoint1: c7, controlPoint2: c8)
        ovalPath.close()
        
        ctx.addPath(ovalPath.cgPath)
        ctx.setStrokeColor(UIColor.cyan.cgColor)
        ctx.setFillColor(UIColor.red.cgColor)
        //同时给线条和线条包围的内部区域填充颜色
        ctx.drawPath(using: .fillStroke)
        
        //标记出每个点并连线，方便观察，给所有关键点染色 -- 白色,辅助线颜色 -- 白色
        ctx.setStrokeColor(UIColor.magenta.cgColor)
        ctx.setFillColor(UIColor.yellow.cgColor)
        
        let points = [NSValue(cgPoint: pointA), NSValue(cgPoint: pointB), NSValue(cgPoint: pointC), NSValue(cgPoint: pointD), NSValue(cgPoint: c1), NSValue(cgPoint: c2), NSValue(cgPoint: c3), NSValue(cgPoint: c4), NSValue(cgPoint: c5), NSValue(cgPoint: c6), NSValue(cgPoint: c7), NSValue(cgPoint: c8)]
        drawPoint(points: points, ctx: ctx)
        
        //连接辅助线
        let helperline = UIBezierPath()
        helperline.move(to: pointA)
        helperline.addLine(to: c1)
        helperline.addLine(to: c2)
        helperline.addLine(to: pointB)
        helperline.addLine(to: c3)
        helperline.addLine(to: c4)
        helperline.addLine(to: pointC)
        helperline.addLine(to: c5)
        helperline.addLine(to: c6)
        helperline.addLine(to: pointD)
        helperline.addLine(to: c7)
        helperline.addLine(to: c8)
        helperline.close()
        
        ctx.addPath(helperline.cgPath)
        ctx.setLineDash(phase: 0, lengths: [2, 2])
        ctx.strokePath()
    }
    
    private func drawPoint(points: [NSValue], ctx: CGContext) {
        for pointValue in points {
            let point = pointValue.cgPointValue
            ctx.fill(CGRect(x: point.x - 2, y: point.y - 2, width: 5, height: 5))
        }
    }
}

