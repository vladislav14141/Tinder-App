//
//  KeepSwipingButton.swift
//  Tinder-App
//
//  Created by Миронов Влад on 25.10.2019.
//  Copyright © 2019 Миронов Влад. All rights reserved.
//

import UIKit

class KeepSwipingButton: UIButton {
    override func draw(_ rect: CGRect) {
        super.draw(rect)
        let gradientLayer = CAGradientLayer()
        
        gradientLayer.colors = [#colorLiteral(red: 1, green: 0.2433983011, blue: 0.3176470588, alpha: 1).cgColor, #colorLiteral(red: 1, green: 0.3921568627, blue: 0.3176470588, alpha: 1).cgColor]
        gradientLayer.startPoint = CGPoint(x:0, y:0.5)
        gradientLayer.endPoint = CGPoint(x:1, y:0.5)
        
        let cornerRadius = rect.height / 2
        let maskLayer = CAShapeLayer()
        
        let maskPath = CGMutablePath()
        
        maskPath.addPath(UIBezierPath(roundedRect: rect, cornerRadius: cornerRadius).cgPath)
        //Punch out the middle
        maskPath.addPath(UIBezierPath(roundedRect: rect.insetBy(dx: 2, dy: 2), cornerRadius: cornerRadius).cgPath)

        maskLayer.path = maskPath
        maskLayer.fillRule = .evenOdd
        
        gradientLayer.mask = maskLayer
        
        
        self.layer.insertSublayer(gradientLayer, at: 0)
        clipsToBounds = true
        gradientLayer.frame = rect
    }

}
