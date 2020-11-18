//
//  SlideMenuButton.swift
//  GooeySlideMenuDemo
//
//  Created by swiftprimer on 2020/11/13.
//

import UIKit

  struct MenuButtonOptions {
    var title: String
    var buttonColor: UIColor
    var buttonClickHandler: (() -> ())?
}

 class SlideMenuButton: UIView {
    
    private var option: MenuButtonOptions
    
      init(option: MenuButtonOptions) {
        self.option = option
        super.init(frame: .zero)
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    override func draw(_ rect: CGRect) {
        
        let context = UIGraphicsGetCurrentContext()
        context?.addRect(rect)
        option.buttonColor.set()
        context?.fillPath()
        
        let roundedRectanglePath = UIBezierPath(roundedRect: rect.insetBy(dx: 1, dy: 1), cornerRadius: rect.height * 0.5)
        option.buttonColor.setFill()
        roundedRectanglePath.fill()
        UIColor.white.setStroke()
        roundedRectanglePath.lineWidth = 1
        roundedRectanglePath.stroke()
        
        let attr = [NSAttributedString.Key.font : UIFont.systemFont(ofSize: 24), NSAttributedString.Key.foregroundColor : UIColor.white]
        let size = option.title.size(withAttributes: attr)
        let p = CGPoint(x: (rect.width - size.width) * 0.5, y: (rect.height - size.height) * 0.5)
        option.title.draw(at: p, withAttributes: attr)
    }
    
    override func touchesBegan(_ touches: Set<UITouch>, with event: UIEvent?) {
        guard let touch = touches.first else { return }
        let tapCount = touch.tapCount
        
        switch tapCount {
        case 1:
            option.buttonClickHandler?()
        default:
            break
        }
    }
}
