//
//  HomeBottomControlStackView.swift
//  Tinder-App
//
//  Created by Миронов Влад on 06.10.2019.
//  Copyright © 2019 Миронов Влад. All rights reserved.
//

import UIKit

class HomeBottomControlStackView: UIStackView {

    static func createButton(image: UIImage) -> UIButton {
        let button = UIButton(type: .system)
        button.setImage(image.withRenderingMode(.alwaysOriginal), for: .normal)
        button.imageView?.contentMode = .scaleAspectFill
        return button
    }
    
    let refreshButton = createButton(image: #imageLiteral(resourceName: "Rewind"))
    let dislikeButton = createButton(image: #imageLiteral(resourceName: "Nope"))
    let superLikeButton = createButton(image: #imageLiteral(resourceName: "Super Like"))
    let likeButton = createButton(image: #imageLiteral(resourceName: "Like"))
    let specialButton = createButton(image: #imageLiteral(resourceName: "Boost"))

    override init(frame: CGRect) {
        super.init(frame:frame)
        distribution = .fillEqually
        heightAnchor.constraint(equalToConstant: 90).isActive = true
        
        [refreshButton, dislikeButton, superLikeButton, likeButton, specialButton].forEach { (but) in
            self.addArrangedSubview(but)
        }
        
        subviews.forEach { (but) in
            addArrangedSubview(but)
        }
    }
    
    required init(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
}
