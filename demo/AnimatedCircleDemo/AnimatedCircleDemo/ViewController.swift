//
//  ViewController.swift
//  AnimatedCircleDemo
//
//  Created by swiftprimer on 2020/11/13.
//

import UIKit

class ViewController: UIViewController {
    
    private var circleView: SPCircleView!
    
    @IBOutlet weak var slider: UISlider!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        view.backgroundColor = .white
        
        
        
        circleView = SPCircleView(frame: CGRect(x: (UIScreen.main.bounds.width - 320) * 0.5, y: (UIScreen.main.bounds.height - 320) * 0.5, width: 320, height: 320))
        circleView.backgroundColor = .lightGray
        view.addSubview(circleView)
        
        circleView.circleLayer.progress = 0.5
    }
    
    @IBAction func didchanged(_ sender: UISlider) {
        circleView.circleLayer.progress = CGFloat(slider.value)
    }
    
}

