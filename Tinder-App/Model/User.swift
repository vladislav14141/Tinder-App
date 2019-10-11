//
//  User.swift
//  Tinder-App
//
//  Created by Миронов Влад on 08.10.2019.
//  Copyright © 2019 Миронов Влад. All rights reserved.
//

import UIKit

struct User: ProducesCardViewModel {
    let name: String
    let age: Int
    let profession: String
    let imageNames: [String]
    
    func toCardViewModel() -> CardViewModel {
        let shadow = NSShadow()
        shadow.shadowColor = UIColor.black
        shadow.shadowOffset = CGSize(width: 0.5, height: -1.5)
        shadow.shadowBlurRadius = 2
        
        
        let attributedText = NSMutableAttributedString(string: name, attributes: [.font: UIFont.systemFont(ofSize: 30, weight: .heavy)])
        attributedText.append(NSAttributedString(string: " \(age)", attributes: [.font: UIFont.systemFont(ofSize: 24, weight: .regular)]))
        attributedText.append(NSAttributedString(string: "\n\(profession)", attributes: [.font: UIFont.systemFont(ofSize: 20, weight: .regular)]))
        return CardViewModel(imageNames: imageNames, attributedString: attributedText, textAlignment: .left)
    }
}


