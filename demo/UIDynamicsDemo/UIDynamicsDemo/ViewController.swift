//
//  ViewController.swift
//  UIDynamicsDemo
//
//  Created by swiftprimer on 2020/11/26.
//

import UIKit

class ViewController: UIViewController {
    
    private lazy var restoreButton: UIButton = {
        let view = UIButton(type: .system)
        view.frame = CGRect(x: 200, y: 300, width: 100, height: 50)
        view.setTitle("恢复", for: .normal)
        view.backgroundColor = .orange
        view.addTarget(self, action: #selector(restoreButtonClick(_:)), for: .touchUpInside)
        return view
    }()
    
    private lazy var lockScreenView: UIImageView = {
        let view = UIImageView(image: UIImage(named: "lockScreen"))
        view.contentMode = .scaleToFill
        view.isUserInteractionEnabled = true
        return view
    }()
    
    private var animator: UIDynamicAnimator!
    private var gravityBehaviour: UIGravityBehavior!//重力行为
    private var pushBehavior: UIPushBehavior!//推动行为
    private var attachmentBehaviour: UIAttachmentBehavior! //吸附行为
    private var itemBehaviour: UIDynamicItemBehavior!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        lockScreenView.frame = CGRect(x: 0, y: 0, width: UIScreen.main.bounds.width, height: UIScreen.main.bounds.height)
        view.addSubview(restoreButton)
        view.addSubview(lockScreenView)
        
        let tapGesture = UITapGestureRecognizer(target: self, action: #selector(tapOnIt(tap:)))
        lockScreenView.addGestureRecognizer(tapGesture)
        
        let panGesture = UIPanGestureRecognizer(target: self, action: #selector(panOnIt(pan:)))
        lockScreenView.addGestureRecognizer(panGesture)
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        
        animator = UIDynamicAnimator(referenceView: view)
        //碰撞行为
        let collisionBehaviour = UICollisionBehavior(items: [lockScreenView])
        collisionBehaviour.setTranslatesReferenceBoundsIntoBoundary(with: UIEdgeInsets(top: -lockScreenView.bounds.height, left: 0, bottom: 0, right: 0))
        animator.addBehavior(collisionBehaviour)
        
        gravityBehaviour = UIGravityBehavior(items: [lockScreenView])
        gravityBehaviour.gravityDirection = CGVector(dx: 0, dy: 1)
        gravityBehaviour.magnitude = 2.6
        animator.addBehavior(gravityBehaviour)
        
        pushBehavior = UIPushBehavior(items: [lockScreenView], mode: .instantaneous)
        pushBehavior.magnitude = 2
        pushBehavior.angle = .pi
        animator.addBehavior(pushBehavior)
        
        itemBehaviour = UIDynamicItemBehavior(items: [lockScreenView])
        itemBehaviour.elasticity = 0.35
        animator.addBehavior(itemBehaviour)
    }
}

extension ViewController {
    
    @objc private func restoreButtonClick(_ button: UIButton) {
        
        animator.removeBehavior(gravityBehaviour)
        animator.removeBehavior(itemBehaviour)
        gravityBehaviour = nil
        itemBehaviour = nil
        
        gravityBehaviour = UIGravityBehavior(items: [lockScreenView])
        gravityBehaviour.gravityDirection = CGVector(dx: 0, dy: 1)
        gravityBehaviour.magnitude = 2.6
        
        itemBehaviour = UIDynamicItemBehavior(items: [lockScreenView])
        itemBehaviour.elasticity = 0.35
        
        animator.addBehavior(itemBehaviour)
        animator.addBehavior(gravityBehaviour)
    }
    
    @objc private func tapOnIt(tap: UITapGestureRecognizer) {
        pushBehavior.pushDirection = CGVector(dx: 0, dy: -150)
        pushBehavior.active = true
    }
    
    @objc private func panOnIt(pan: UIPanGestureRecognizer) {
        
        let location = CGPoint(x: lockScreenView.frame.midX, y: pan.location(in: view).y)
        
        if pan.state == .began {
            animator.removeBehavior(gravityBehaviour)
            attachmentBehaviour = UIAttachmentBehavior(item: lockScreenView, attachedToAnchor: location)
            animator.addBehavior(attachmentBehaviour)
        } else if pan.state == .changed {
            attachmentBehaviour.anchorPoint = location
        } else if pan.state == .ended {
            let velocity = pan.velocity(in: lockScreenView)
            animator.removeBehavior(attachmentBehaviour)
            attachmentBehaviour = nil
            
            if velocity.y < -1300 {
                animator.removeBehavior(gravityBehaviour)
                animator.removeBehavior(itemBehaviour)
                gravityBehaviour = nil
                itemBehaviour = nil
                
                gravityBehaviour = UIGravityBehavior(items: [lockScreenView])
                gravityBehaviour.gravityDirection = CGVector(dx: 0.0, dy: -1.0)
                gravityBehaviour.magnitude = 2.6
                animator.addBehavior(gravityBehaviour)
                
                itemBehaviour = UIDynamicItemBehavior(items: [lockScreenView])
                itemBehaviour.elasticity = 0.0
                animator.addBehavior(itemBehaviour)
                
                pushBehavior.pushDirection = CGVector(dx: 0.0, dy: -200.0)
                pushBehavior.active = true
            } else {
                restoreButtonClick(restoreButton)
            }
        }
    }
}
