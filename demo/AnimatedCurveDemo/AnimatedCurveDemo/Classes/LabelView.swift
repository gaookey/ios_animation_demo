//
//  LabelView.swift
//  AnimatedCurveDemo
//
//  Created by swiftprimer on 2020/11/24.
//

import UIKit

enum PullingState {
    case up
    case down
}

class LabelView: UIView {
    
    private let labelHeight: CGFloat = 50
    private let pullingDownString  = "下拉即可刷新..."
    private let pullingUpString    = "上拉即可刷新..."
    private let releaseString      = "松开即可刷新..."
    
    private var pullingString = ""
    
    private lazy var titleLabel: UILabel = {
        let view = UILabel(frame: CGRect(x: 0, y: (bounds.height - labelHeight) * 0.5, width: bounds.width, height: labelHeight))
        view.text = pullingString
        view.textColor = .black
        view.adjustsFontSizeToFitWidth = true
        return view
    }()
    
    var loading: Bool = false
    var progress: CGFloat = 0 {
        didSet {
            titleLabel.alpha = progress
            if !loading {
                if progress >= 1 {
                    titleLabel.text = releaseString
                } else {
                    titleLabel.text = pullingString
                }
            } else {
                if progress >= 0.91 {
                    titleLabel.text = releaseString
                } else {
                    titleLabel.text = pullingString
                }
            }
        }
    }
    
    var state: PullingState = .down {
        didSet {
            pullingString = (state == .up ? pullingUpString : pullingDownString)
        }
    }
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        
        state = .down
        addSubview(titleLabel)
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
}
