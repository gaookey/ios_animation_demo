//
//  ViewController.swift
//  PingTransition
//
//  Created by swiftprimer on 2020/11/19.
//

import UIKit

class ViewController: UIViewController {
    
    lazy var button: UIButton = {
        let view = UIButton(type: .system)
        view.frame = CGRect(x: UIScreen.main.bounds.width - 49, y: 100, width: 44, height: 44)
        view.backgroundColor = .orange
        view.addTarget(self, action: #selector(buttonClick(_:)), for: .touchUpInside)
        return view
    }()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        self.title = "ViewController"
        view.backgroundColor = .lightGray
        view.addSubview(button)
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        
        navigationController?.delegate = self
    }
    
    @objc func buttonClick(_ button: UIButton) {
        navigationController?.pushViewController(SecondViewController(), animated: true)
    }
}

extension ViewController: UINavigationControllerDelegate {
    
    func navigationController(_ navigationController: UINavigationController, animationControllerFor operation: UINavigationController.Operation, from fromVC: UIViewController, to toVC: UIViewController) -> UIViewControllerAnimatedTransitioning? {
        guard operation == .push else { return nil }
        return PingTransition()
    }
}
