//
//  SendMessageButton.swift
//  Tinder-App
//
//  Created by Миронов Влад on 25.10.2019.
//  Copyright © 2019 Миронов Влад. All rights reserved.
//

import UIKit

class SendMessageButton: UIButton {

    override func draw(_ rect: CGRect) {
        super.draw(rect)
        
        let gradientLayer = CAGradientLayer()
        
        gradientLayer.colors = [#colorLiteral(red: 1, green: 0.2433983011, blue: 0.3176470588, alpha: 1).cgColor, #colorLiteral(red: 1, green: 0.3921568627, blue: 0.3176470588, alpha: 1).cgColor]
        gradientLayer.startPoint = CGPoint(x:0, y:0.5)
        gradientLayer.endPoint = CGPoint(x:1, y:0.5)
        
        self.layer.insertSublayer(gradientLayer, at: 0)
        layer.cornerRadius = rect.height / 2
        clipsToBounds = true
        gradientLayer.frame = rect
    }
}
