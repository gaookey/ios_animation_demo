//
//  FireworksView.swift
//  FireworksButton
//
//  Created by swiftprimer on 2020/11/27.
//

import UIKit

class FireworksView: UIView {
    
    var particleImage = UIImage() {
        didSet {
            emitterCells.forEach({ $0.contents = particleImage.cgImage })
        }
    }
    
    var particleScale: CGFloat = 0
    var particleScaleRange: CGFloat = 0
    
    private var emitterCells = [CAEmitterCell]()
    private var explosionLayer = CAEmitterLayer()
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        
        setup()
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    override func layoutSubviews() {
        super.layoutSubviews()
        
        let center = CGPoint(x: bounds.midX, y: bounds.midY)
        explosionLayer.emitterPosition = center
    }
}

extension FireworksView {
    
    func animate() {
        DispatchQueue.main.asyncAfter(deadline: .now() + 0.2) {
            self.explode()
        }
    }
}

extension FireworksView {
    
    private func setup() {
        
        clipsToBounds = false
        isUserInteractionEnabled = false
        
        let explosionCell = CAEmitterCell()
        explosionCell.name = "explosion"
        explosionCell.alphaRange = 0.2
        explosionCell.alphaSpeed = -1
        
        explosionCell.lifetime = 0.7
        explosionCell.lifetimeRange = 0.3
        explosionCell.birthRate = 0
        explosionCell.velocity = 40
        explosionCell.velocityRange = 10
        explosionCell.emissionRange = .pi / 4
        explosionCell.scale = 0.05
        explosionCell.scaleRange = 0.02
        
        explosionLayer = CAEmitterLayer()
        explosionLayer.name = "emitterLayer"
        explosionLayer.emitterShape = .circle
        explosionLayer.emitterMode = .outline
        explosionLayer.emitterPosition = CGPoint(x: bounds.midX, y: bounds.midY)
        explosionLayer.emitterSize = CGSize(width: 25, height: 0)
        explosionLayer.emitterCells = [explosionCell]
        explosionLayer.renderMode = .oldestFirst
        explosionLayer.masksToBounds = false
        layer.addSublayer(explosionLayer)
        
        emitterCells = [explosionCell]
    }
    
    private func explode() {
        explosionLayer.beginTime = CACurrentMediaTime()
        explosionLayer.setValue(500, forKeyPath: "emitterCells.explosion.birthRate")
        DispatchQueue.main.asyncAfter(deadline: .now() + 0.1) {
            self.stop()
        }
    }
    
    private func stop() {
        explosionLayer.setValue(0, forKeyPath: "emitterCells.explosion.birthRate")
    }
}
