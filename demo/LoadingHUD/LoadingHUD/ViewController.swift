//
//  ViewController.swift
//  LoadingHUD
//
//  Created by swiftprimer on 2020/11/23.
//

import UIKit

class ViewController: UIViewController {

    var isDismiss = true
    
    override func viewDidLoad() {
        super.viewDidLoad()

        view.backgroundColor = .white
    }

    override func touchesBegan(_ touches: Set<UITouch>, with event: UIEvent?) {
        LoadingHUD.showHUD()
        
        
        DispatchQueue.main.asyncAfter(deadline: .now() + 5) {
            LoadingHUD.dismissHUD()
        }
    }

}

