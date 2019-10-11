//
//  TopNavigationStackView.swift
//  Tinder-App
//
//  Created by Миронов Влад on 06.10.2019.
//  Copyright © 2019 Миронов Влад. All rights reserved.
//

import UIKit

class TopNavigationStackView: UIStackView {
    let settingButton = UIButton(type: .system)
    let fireButton = UIButton(type: .system)
    let messaggeButton = UIButton(type: .system)

    override init(frame: CGRect) {
        super.init(frame: frame)
        
        settingButton.setImage(#imageLiteral(resourceName: "Profile").withRenderingMode(.alwaysOriginal), for: .normal)
        fireButton.setImage(#imageLiteral(resourceName: "Tinder Single").withRenderingMode(.alwaysOriginal), for: .normal)
        messaggeButton.setImage(#imageLiteral(resourceName: "Chat").withRenderingMode(.alwaysOriginal), for: .normal)
        
        
        
        [settingButton, UIView(), fireButton, UIView(), messaggeButton].forEach { (but) in
            addArrangedSubview(but)
        }
        
        distribution = .equalCentering
        heightAnchor.constraint(equalToConstant: 80).isActive = true
        
        
    }
    
    required init(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
}
