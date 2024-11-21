//
//  HomeViewUIKit.swift
//  Architecture_MVVM
//
//  Created by Isaí Arellano on 21/11/24.
//

import Foundation
import UIKit

class HomeViewUIKit: UIViewController {
    private let messageLabel: UILabel = {
        let label = UILabel()
        label.numberOfLines = 0
        label.text = "Hola desde UIKit"
        return label
    }()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        view.addSubview(messageLabel)
        
        NSLayoutConstraint.activate([
            messageLabel.centerYAnchor.constraint(equalTo: view.centerYAnchor, constant: -60),
            messageLabel.centerXAnchor.constraint(equalTo: view.centerXAnchor),
            messageLabel.leadingAnchor.constraint(equalTo: view.leadingAnchor, constant: 32),
            messageLabel.trailingAnchor.constraint(equalTo: view.trailingAnchor, constant: -32)
        ])
        
        
    }
}
