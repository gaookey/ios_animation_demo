//
//  SecondViewController.swift
//  SPBubbleTransition
//
//  Created by swiftprimer on 2020/11/19.
//

import UIKit

class SecondViewController: UIViewController, UINavigationControllerDelegate {
    
    private lazy var bubbleTransition: SPBubbleTransition = {
        let view = SPBubbleTransition()
        view.duration = 1
        view.transitionMode = .dismiss
        view.bubbleColor = .purple
        view.startPoint = CGPoint(x: 200, y: 200)
        return view
    }()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        self.title = "SecondViewController"
        view.backgroundColor = .cyan
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        
        navigationController?.delegate = self
    }
    
    override func touchesBegan(_ touches: Set<UITouch>, with event: UIEvent?) {
        navigationController?.popViewController(animated: true)
    }
    
    func navigationController(_ navigationController: UINavigationController, animationControllerFor operation: UINavigationController.Operation, from fromVC: UIViewController, to toVC: UIViewController) -> UIViewControllerAnimatedTransitioning? {
        guard operation == .pop else { return nil }
        return bubbleTransition
    }
}
