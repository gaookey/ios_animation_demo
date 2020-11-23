//
//  ViewController.swift
//  InteractiveCardDemo
//
//  Created by swiftprimer on 2020/11/23.
//

import UIKit

class ViewController: UIViewController {
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        let interactiveView = InteractiveView(image: UIImage(named: "pic01"), option: InteractiveOptions())
        interactiveView.center = view.center
        interactiveView.bounds = CGRect(x: 0, y: 0, width: 200, height: 150)
        interactiveView.gestureView = view
        
        let blurView = UIVisualEffectView(effect: UIBlurEffect(style: .dark))
        blurView.frame = view.bounds
        view.addSubview(blurView)
        interactiveView.dimmingView = blurView
        
        let backView = UIView(frame: view.bounds)
        view.addSubview(backView)
        backView.addSubview(interactiveView)
    }
}

