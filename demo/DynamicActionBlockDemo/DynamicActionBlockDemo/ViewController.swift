//
//  ViewController.swift
//  DynamicActionBlockDemo
//
//  Created by swiftprimer on 2020/11/26.
//

import UIKit

class ViewController: UIViewController {

    override func viewDidLoad() {
        super.viewDidLoad()

        let dynamicView = DynamicView(frame: view.bounds)
        view.addSubview(dynamicView)
    }
}

