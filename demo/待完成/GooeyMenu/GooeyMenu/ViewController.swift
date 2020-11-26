//
//  ViewController.swift
//  GooeyMenu
//
//  Created by swiftprimer on 2020/11/25.
//

import UIKit

class ViewController: UIViewController {
    
    private var isShow = false
    
    private lazy var menu: Menu = {
        let view = Menu(frame: CGRect(x: UIScreen.main.bounds.width * 0.5 - 50, y: UIScreen.main.bounds.height * 0.5 - 50, width: 100, height: 100))
        return view
    }()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        view.addSubview(menu)
    }
    
    override func touchesBegan(_ touches: Set<UITouch>, with event: UIEvent?) {

//        isShow = !isShow
//        menu.menuLayer.showDebug = isShow
//        menu.menuLayer.setNeedsDisplay()
    }
}

