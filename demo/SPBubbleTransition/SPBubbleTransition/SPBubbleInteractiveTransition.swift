//
//  SPBubbleInteractiveTransition.swift
//  SPBubbleTransition
//
//  Created by swiftprimer on 2020/11/19.
//

import UIKit

class SPBubbleInteractiveTransition: UIPercentDrivenInteractiveTransition {
    
    var interacting = false
    
    private var presentedVC = UIViewController()
    private var percent: CGFloat = 0
    private var panView = UIView()
    
    func addPopGesture(_ controller: UIViewController) {
        
        controller.view.transform = .identity
        presentedVC = controller
        
        let pan = UIPanGestureRecognizer(target: self, action: #selector(edgeGesPan(_:)))
        presentedVC.view.addGestureRecognizer(pan)
    }
    
    @objc private func edgeGesPan(_ pan: UIPanGestureRecognizer) {
        
        let translation = pan.translation(in: presentedVC.view).x
        
        percent = translation / presentedVC.view.bounds.width
        percent = min(0.99, max(0, percent))
        
        if pan.state == .began {
            interacting = true
            presentedVC.navigationController?.popViewController(animated: true)
        } else if pan.state == .changed {
            update(percent)
        } else if pan.state == .ended {
            interacting = false
            if percent > 0.5 {
                finish()
            } else {
                cancel()
            }
        }
    }
}
