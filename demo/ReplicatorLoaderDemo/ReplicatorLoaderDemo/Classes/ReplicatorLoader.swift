//
//  ReplicatorLoader.swift
//  ReplicatorLoaderDemo
//
//  Created by swiftprimer on 2020/11/27.
//

import UIKit

struct Options {
    var color: UIColor
    var alpha: Float = 1.0
}

enum LoaderType {
    case Pulse(option: Options)
    case DotsFlip(option: Options)
    case GridScale(option: Options)
    
    var replicatorLayer: Replicatable {
        switch self {
        case .Pulse(_):
            return PulseReplicatorLayer()
        case .DotsFlip(_):
            return DotsFlipReplicatorLayer()
        case .GridScale(_):
            return GridReplicatorLayer()
        }
    }
}

protocol Replicatable {
    func configureReplicatorLayer(layer: CALayer, option: Options)
}

class ReplicatorLoader: UIView {
    
    init(frame: CGRect, type: LoaderType) {
        super.init(frame: frame)
        
        setup(type: type)
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    private func setup(type: LoaderType) {
        
        switch type {
        case let .Pulse(option: option):
            type.replicatorLayer.configureReplicatorLayer(layer: layer, option: option)
        case let .DotsFlip(option: option):
            type.replicatorLayer.configureReplicatorLayer(layer: layer, option: option)
        case let .GridScale(option: option):
            type.replicatorLayer.configureReplicatorLayer(layer: layer, option: option)
        }
    }
}
