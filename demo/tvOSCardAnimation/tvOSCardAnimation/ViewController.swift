//
//  ViewController.swift
//  tvOSCardAnimation
//
//  Created by swiftprimer on 2020/11/25.
//

import UIKit

class ViewController: UIViewController {
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        let cardView = TvOSCardView()
        cardView.center = view.center
        cardView.bounds = CGRect(x: 0, y: 0, width: 250, height: 300)
        view.addSubview(cardView)
    }
}

