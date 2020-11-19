//
//  ViewController.swift
//  JumpStarDemo
//
//  Created by swiftprimer on 2020/11/19.
//

import UIKit

class ViewController: UIViewController {
    
    private lazy var jumpStarView: JumpStarView = {
        let option = JumpStarOptions(markedImage: UIImage(named: "save")!, notMarkedImage: UIImage(named: "saved")!, jumpDuration: 0.125, downDuration: 0.215)
        let view = JumpStarView(frame: CGRect(x: 200, y: 300, width: 50, height: 50))
        view.option = option
        view.state = .marked
        return view
    }()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        view.addSubview(jumpStarView)
    }
    
    override func touchesBegan(_ touches: Set<UITouch>, with event: UIEvent?) {
        jumpStarView.animate()
    }
}

