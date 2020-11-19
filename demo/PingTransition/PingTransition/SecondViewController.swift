//
//  SecondViewController.swift
//  PingTransition
//
//  Created by swiftprimer on 2020/11/19.
//

import UIKit

class SecondViewController: UIViewController {
    
    private var percentTransition: UIPercentDrivenInteractiveTransition?
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        self.title = "SecondViewController"
        view.backgroundColor = .cyan
 
        let edgeGes = UIScreenEdgePanGestureRecognizer(target: self, action: #selector(edgePan(_:)))
        edgeGes.edges = .left
        view.addGestureRecognizer(edgeGes)
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        
        navigationController?.delegate = self
    }
    
    @objc private func edgePan(_ recognizer: UIPanGestureRecognizer) {
        
        var per = recognizer.translation(in: view).x / view.bounds.width
        per = min(1, max(0, per))
        
        if recognizer.state == .began {
            percentTransition = UIPercentDrivenInteractiveTransition()
            navigationController?.popViewController(animated: true)
        } else if recognizer.state == .changed {
            percentTransition?.update(per)
        } else if recognizer.state == .cancelled || recognizer.state == .ended {
            if per > 0.3 {
                percentTransition?.finish()
            } else {
                percentTransition?.cancel()
            }
            percentTransition = nil
        }
    }
}

extension SecondViewController: UINavigationControllerDelegate {
    
    func navigationController(_ navigationController: UINavigationController, interactionControllerFor animationController: UIViewControllerAnimatedTransitioning) -> UIViewControllerInteractiveTransitioning? {
        return percentTransition
    }
    
    func navigationController(_ navigationController: UINavigationController, animationControllerFor operation: UINavigationController.Operation, from fromVC: UIViewController, to toVC: UIViewController) -> UIViewControllerAnimatedTransitioning? {
        guard operation == .pop  else { return nil }
        return PingInvertTransition()
    }
}
