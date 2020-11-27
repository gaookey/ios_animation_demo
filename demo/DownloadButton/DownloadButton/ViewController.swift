//
//  ViewController.swift
//  DownloadButton
//
//  Created by swiftprimer on 2020/11/27.
//

import UIKit

class ViewController: UIViewController {

    private lazy var downloadButton: DownloadButton = {
        let view = DownloadButton(frame: CGRect(x: 100, y: 300, width: 100, height: 100))
        view.progressBarWidth = 100
        view.progressBarHeight = 30
        view.backgroundColor = .lightGray
        return view
    }()
    
    override func viewDidLoad() {
        super.viewDidLoad()

        view.addSubview(downloadButton)
    }
}

