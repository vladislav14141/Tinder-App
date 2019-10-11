//
//  HomeBottomControlStackView.swift
//  Tinder-App
//
//  Created by Миронов Влад on 06.10.2019.
//  Copyright © 2019 Миронов Влад. All rights reserved.
//

import UIKit

class HomeBottomControlStackView: UIStackView {

    override init(frame: CGRect) {
        super.init(frame:frame)
        distribution = .fillEqually
        heightAnchor.constraint(equalToConstant: 90).isActive = true
        
        let subviews = [ #imageLiteral(resourceName: "Rewind"),#imageLiteral(resourceName: "Nope"),#imageLiteral(resourceName: "Super Like"),#imageLiteral(resourceName: "Like"),#imageLiteral(resourceName: "Boost")].map { (img) -> UIView in
            let button = UIButton(type: .system)
            button.setImage(img.withRenderingMode(.alwaysOriginal), for: .normal)
            return button
        }
        
        subviews.forEach { (but) in
            addArrangedSubview(but)
        }
    }
    
    required init(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
}
