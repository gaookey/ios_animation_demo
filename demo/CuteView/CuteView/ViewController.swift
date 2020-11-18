//
//  ViewController.swift
//  CuteView
//
//  Created by swiftprimer on 2020/11/18.
//

import UIKit

class ViewController: UIViewController {
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        var option = BubbleOptions()
        option.viscosity = 20
        option.bubbleWidth = 80
        option.bubbleColor = .orange
        
        let cuteView = CuteView(point: view.center, superView: view, options: option)
        option.text = "20"
        cuteView.bubbleOptions = option
    }
}

