//
//  GooeySlideMenu.swift
//  GooeySlideMenuDemo
//
//  Created by swiftprimer on 2020/11/13.
//

import UIKit

struct MenuOptions {
    var titles: [String]
    var buttonHeight: CGFloat
    var menuColor: UIColor
    var blurStyle: UIBlurEffect.Style
    var buttonSpace: CGFloat
    var menuBlankWidth: CGFloat
    var menuClickBlock: ((_ index: Int, _ title: String, _ titleCounts: Int) -> ())?
}

class GooeySlideMenu: UIView {
    
    private var option: MenuOptions
    private var keyWindow: UIWindow?
    private var blurView = UIVisualEffectView()
    private var helperSideView = UIView() // 辅助view
    private var helperCenterView = UIView() // 辅助view
    
    private var diff: CGFloat = 0.0
    private var triggered = false
    private var displayLink: CADisplayLink?
    private var animationCount: Int = 0
    
    init(options: MenuOptions) {
        option = options
        
        if let window = UIApplication.shared.windows.filter({ $0.isKeyWindow }).first {
            keyWindow = window
            super.init(frame: CGRect(x: -window.frame.width * 0.5 - options.menuBlankWidth, y: 0, width: window.frame.width * 0.5 + options.menuBlankWidth, height: window.frame.height))
        } else {
            super.init(frame: .zero)
        }
        
        setUpViews()
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    override func draw(_ rect: CGRect) {
        let path = UIBezierPath()
        path.move(to: CGPoint(x: 0, y: 0))
        path.addLine(to: CGPoint(x: bounds.width - option.menuBlankWidth, y: 0))
        path.addQuadCurve(to: CGPoint(x: bounds.width - option.menuBlankWidth, y: bounds.height), controlPoint: CGPoint(x: bounds.width - option.menuBlankWidth + diff, y: bounds.height * 0.5))
        path.addLine(to: CGPoint(x: 0, y: bounds.height))
        path.close()
        
        let context = UIGraphicsGetCurrentContext()
        context?.addPath(path.cgPath)
        option.menuColor.set()
        context?.fillPath()
    }
    
    func trigger() {
        
        guard !triggered else {
            tapToUntrigger()
            return
        }
        
        guard let window = keyWindow else { return }
        
        window.insertSubview(blurView, belowSubview: self)
        UIView.animate(withDuration: 0.3) { [weak self] in
            if let weakSelf = self {
                weakSelf.blurView.alpha = 1
                weakSelf.frame = CGRect(x: 0, y: 0, width: window.frame.width * 0.5 + weakSelf.option.menuBlankWidth, height: window.frame.height)
            }
        }
        
        beforeAnimation()
        
        UIView.animate(withDuration: 0.7, delay: 0, usingSpringWithDamping: 0.5, initialSpringVelocity: 0.9, options: [.beginFromCurrentState, .allowUserInteraction]) { [weak self] in
            if let weakSelf = self {
                weakSelf.helperSideView.center = CGPoint(x: window.center.x, y: weakSelf.helperSideView.frame.height * 0.5)
            }
        } completion: { [weak self] (finish) in
            self?.finishAnimation()
        }
        
        beforeAnimation()
        
        UIView.animate(withDuration: 0.7, delay: 0, usingSpringWithDamping: 0.8, initialSpringVelocity: 2.0, options: [.beginFromCurrentState, .allowUserInteraction]) { [weak self] in
            self?.helperCenterView.center = window.center
        } completion: { [weak self] (finish) in
            if finish, let weakSelf = self {
                let tap = UITapGestureRecognizer(target: self, action: #selector(weakSelf.tapToUntrigger))
                weakSelf.blurView.addGestureRecognizer(tap)
                weakSelf.finishAnimation()
            }
        }
        
        animateButtons()
        triggered = true
    }
}

extension GooeySlideMenu {
    
    private func setUpViews() {
        guard let keyWindow = keyWindow else { return }
        
        blurView = UIVisualEffectView(effect: UIBlurEffect(style: option.blurStyle))
        blurView.frame = keyWindow.frame
        //blurView.alpha = 0
        
        helperSideView = UIView(frame: CGRect(x: -40, y: 0, width: 40, height: 40))
        helperSideView.backgroundColor = .red
        helperSideView.isHidden = true
        keyWindow.addSubview(helperSideView)
        
        helperCenterView = UIView(frame: CGRect(x: -40, y: keyWindow.bounds.height * 0.5 - 20, width: 40, height: 40))
        helperCenterView.backgroundColor = .purple
        helperCenterView.isHidden = true
        keyWindow.addSubview(helperCenterView)
        
        backgroundColor = .clear
        keyWindow.insertSubview(self, belowSubview: helperSideView)
        
        addButton()
    }
    
    @objc private func tapToUntrigger() {
        
        UIView.animate(withDuration: 0.3) { [weak self] in
            if let weakSelf = self, let keyWindow  = weakSelf.keyWindow {
                weakSelf.frame = CGRect(x: -keyWindow.bounds.width * 0.5 - weakSelf.option.menuBlankWidth, y: 0, width: keyWindow.bounds.width * 0.5 + weakSelf.option.menuBlankWidth, height: keyWindow.bounds.height)
            }
        }
        
        beforeAnimation()
        
        UIView.animate(withDuration: 0.7, delay: 0, usingSpringWithDamping: 0.6, initialSpringVelocity: 0.9, options: [.beginFromCurrentState, .allowUserInteraction]) { [weak self] in
            if let weakSelf = self {
                weakSelf.helperSideView.center = CGPoint(x: -weakSelf.helperSideView.bounds.width * 0.5, y: weakSelf.helperSideView.bounds.height * 0.5)
            }
        } completion: { [weak self] (finish) in
            self?.finishAnimation()
        }
        
        UIView.animate(withDuration: 0.3) { [weak self] in
            self?.blurView.alpha = 0
        }
        
        beforeAnimation()
        
        UIView.animate(withDuration: 0.7, delay: 0, usingSpringWithDamping: 0.7, initialSpringVelocity: 2, options: [.beginFromCurrentState, .allowUserInteraction]) { [weak self] in
            if let weakSelf = self {
                weakSelf.helperCenterView.center = CGPoint(x: -weakSelf.helperCenterView.bounds.width * 0.5, y: weakSelf.bounds.height * 0.5)
            }
        } completion: { [weak self] (finish) in
            self?.finishAnimation()
        }
        
        triggered = false
    }
    
    private func beforeAnimation() {
        if  displayLink == nil {
            displayLink = CADisplayLink(target: self, selector: #selector(handleDisplayLinkAction))
            displayLink?.add(to: .main, forMode: .default)
        }
        
        animationCount += 1
    }
    
    private func finishAnimation() {
        animationCount -= 1
        if animationCount == 0 {
            displayLink?.invalidate()
            displayLink = nil
        }
    }
    
    private func animateButtons() {
        for i in 0..<subviews.count {
            let menuButton = subviews[i]
            menuButton.transform = CGAffineTransform(translationX: -90, y: 0)
            UIView.animate(withDuration: 0.7, delay: Double(i) * 0.3 / Double(subviews.count), usingSpringWithDamping: 0.6, initialSpringVelocity: 0, options: [.beginFromCurrentState, .allowUserInteraction]) {
                menuButton.transform = .identity
            } completion: { _ in }
        }
    }
    
    private func addButton() {
        
        if option.titles.count % 2 == 0 {
            var index_down: CGFloat = CGFloat(option.titles.count) * 0.5
            var index_up: CGFloat = -1
            for i in 0..<option.titles.count {
                let title = option.titles[i]
                
                let buttonOption = MenuButtonOptions(title: title, buttonColor: option.menuColor) { [weak self] in
                    if let weakSelf = self {
                        weakSelf.tapToUntrigger()
                        weakSelf.option.menuClickBlock?(i, title, weakSelf.option.titles.count)
                    }
                }
                
                let home_button = SlideMenuButton(option: buttonOption)
                home_button.bounds = CGRect(x: 0, y: 0, width: bounds.width - option.menuBlankWidth - 20 * 2, height: option.buttonHeight)
                addSubview(home_button)
                
                if CGFloat(i) >= CGFloat(option.titles.count) * 0.5 {
                    index_up += 1
                    let y = (bounds.height * 0.5 + option.buttonHeight * index_up + option.buttonSpace * index_up)
                    home_button.center = CGPoint(x: (bounds.width - option.menuBlankWidth) * 0.5, y: y + option.buttonSpace * 0.5 + option.buttonHeight * 0.5)
                } else {
                    index_down -= 1
                    let y = bounds.height * 0.5 - option.buttonHeight * index_down - option.buttonSpace * index_down
                    home_button.center = CGPoint(x: (bounds.width - option.menuBlankWidth) * 0.5, y: y - option.buttonSpace * 0.5 - option.buttonHeight * 0.5)
                }
            }
        } else {
            var index = (CGFloat(option.titles.count) - 1) * 0.5 + 1
            for i in 0..<option.titles.count {
                let title = option.titles[i]
                index -= 1
                
                let buttonOption = MenuButtonOptions(title: title, buttonColor: option.menuColor) { [weak self] in
                    if let weakSelf = self {
                        weakSelf.tapToUntrigger()
                        weakSelf.option.menuClickBlock?(i, title, weakSelf.option.titles.count)
                    }
                }
                
                let home_button = SlideMenuButton(option: buttonOption)
                home_button.bounds = CGRect(x: 0, y: 0, width: bounds.width - option.menuBlankWidth - 20 * 2, height: option.buttonHeight)
                home_button.center = CGPoint(x: (bounds.width - option.menuBlankWidth) * 0.5, y: bounds.height * 0.5 - option.buttonHeight * index - 20 * index)
                addSubview(home_button)
            }
        }
    }
    
    @objc private func handleDisplayLinkAction() {
        
        guard let sideHelperPresentationLayer = helperSideView.layer.presentation(),
              let centerHelperPresentationLayer = helperCenterView.layer.presentation(),
              let sideRect = (sideHelperPresentationLayer.value(forKeyPath: "frame") as AnyObject).cgRectValue,
              let centerRect = (centerHelperPresentationLayer.value(forKeyPath: "frame") as AnyObject).cgRectValue else { return }
        
        diff = sideRect.origin.x - centerRect.origin.x
        setNeedsDisplay()
    }
}
