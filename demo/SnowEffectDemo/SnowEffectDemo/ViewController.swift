//
//  ViewController.swift
//  SnowEffectDemo
//
//  Created by swiftprimer on 2020/11/27.
//

import UIKit

class ViewController: UIViewController {
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        let snowEmitter = CAEmitterLayer()
        
        snowEmitter.emitterPosition = CGPoint(x: view.bounds.width * 0.5, y: -30)
        snowEmitter.emitterSize = CGSize(width: view.bounds.width * 2, height: 0)
        snowEmitter.emitterShape = .line
        snowEmitter.emitterMode = .outline
        
        let snowflake = CAEmitterCell()
        snowflake.birthRate = 1
        snowflake.lifetime = 120
        snowflake.velocity = -10
        snowflake.velocityRange = 10
        snowflake.yAcceleration = 2
        snowflake.emissionRange = CGFloat(0.5 * .pi)
        snowflake.spinRange = CGFloat(0.25 * .pi)
        snowflake.contents = UIImage(named: "snow")?.cgImage
        snowflake.color = UIColor(red: 0.600, green: 0.658, blue: 0.743, alpha: 1.000).cgColor
        
        snowEmitter.shadowOpacity = 1
        snowEmitter.shadowRadius = 0
        snowEmitter.shadowOffset = CGSize(width: 0, height: 1)
        snowEmitter.shadowColor = UIColor.white.cgColor
        snowEmitter.emitterCells = Array(arrayLiteral: snowflake)
        view.layer.insertSublayer(snowEmitter, at: 0)
    }
}

