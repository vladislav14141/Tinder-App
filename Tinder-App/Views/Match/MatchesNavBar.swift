//
//  MatchesNavBar.swift
//  Tinder-App
//
//  Created by Миронов Влад on 27.10.2019.
//  Copyright © 2019 Миронов Влад. All rights reserved.
//

import UIKit

class MatchesNavBar: UIView{
    let img = #imageLiteral(resourceName: "app_icon")
    var backButton = UIButton(image: #imageLiteral(resourceName: "app_icon"), tintColor: .gray)
    override init(frame: CGRect) {
        super.init(frame: frame)
        
        backgroundColor = .black
        
        let iconImageView = UIImageView(image: UIImage(named: "top_right_messages")?.withRenderingMode(.alwaysTemplate), contentMode: .scaleAspectFit)
        iconImageView.tintColor = UIColor(red: 0.8549019694, green: 0.250980407, blue: 0.4784313738, alpha: 1)
        let messageLabel = UILabel(text: "Messages", font: UIFont.boldSystemFont(ofSize: 20),
                                   textColor: UIColor(red: 0.8549019694, green: 0.250980407, blue: 0.4784313738, alpha: 1),
                                   textAlignment: .center, numberOfLines: 0)
        
        let feedLabel = UILabel(text: "Feed", font: UIFont.boldSystemFont(ofSize: 20),
                                textColor: .gray, textAlignment: .center, numberOfLines: 0)
        
        stack(iconImageView.withHeight(44),
              hstack(messageLabel,
                     feedLabel,
                     distribution: .fillEqually).padTop(10))
        
        setupShadow(opacity: 0.2, radius: 8, offset: .init(width: 0, height: 10), color: .init(white: 1, alpha: 0.3))
        
        addSubview(backButton)
        backButton.anchor(top: safeAreaLayoutGuide.topAnchor, leading: leadingAnchor, bottom: nil, trailing: nil, padding: .init(top: 12, left: 8, bottom: 0, right: 0), size: .init(width: 34, height: 34))

    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
}
