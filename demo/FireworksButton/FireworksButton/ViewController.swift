//
//  ViewController.swift
//  FireworksButton
//
//  Created by swiftprimer on 2020/11/27.
//

import UIKit

class ViewController: UIViewController {
    
    private lazy var likeButton: FireworksButton = {
        let view = FireworksButton(frame: CGRect(x: 200, y: 300, width: 50, height: 50))
        view.particleImage = UIImage(named: "Sparkle")!
        view.particleScale = 0.05
        view.particleScaleRange = 0.02
        view.setImage(UIImage(named: "Like"), for: .normal)
        view.setImage(UIImage(named: "Like-Blue"), for: .selected)
        view.addTarget(self, action: #selector(likeButtonClick(_:)), for: .touchUpInside)
        return view
    }()
    
    private var selected = false
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        view.addSubview(likeButton)
    }
    
    @objc private func likeButtonClick(_ button: UIButton) {
        button.isSelected = !button.isSelected
        
        if button.isSelected {
            likeButton.popOutside(0.5)
            likeButton.animate()
        } else {
            likeButton.popInside(0.4)
        }
    }
}

