//
//  ViewController.swift
//  GooeySlideMenuDemo
//
//  Created by swiftprimer on 2020/11/13.
//

import UIKit

class ViewController: UIViewController {
    
    private var menu: GooeySlideMenu?
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        let menuOptions = MenuOptions(titles: ["首页","消息","发布","发现","个人","设置"],
                                      buttonHeight: 50,
                                      menuColor: .orange,
                                      blurStyle: .light,
                                      buttonSpace: 30,
                                      menuBlankWidth: 50) { (index, title, titleCount) in
            print("index:\(index) title:\(title) titleCount:\(titleCount)")
        }
        
        menu = GooeySlideMenu(options: menuOptions)
    }
    
    
    override func touchesBegan(_ touches: Set<UITouch>, with event: UIEvent?) {
        menu?.trigger()
    }
}

