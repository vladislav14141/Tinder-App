//
//  MessagesNavBar.swift
//  Tinder-App
//
//  Created by Миронов Влад on 28.10.2019.
//  Copyright © 2019 Миронов Влад. All rights reserved.
//

import LBTATools
class MessageNavBar: UIView {
    var backButton = UIButton(image: #imageLiteral(resourceName: "back"), tintColor: #colorLiteral(red: 0.8078431487, green: 0.02745098062, blue: 0.3333333433, alpha: 1))
    var flagButton = UIButton(image: #imageLiteral(resourceName: "flag"), tintColor: #colorLiteral(red: 0.8078431487, green: 0.02745098062, blue: 0.3333333433, alpha: 1))
    var userImageView = CircularImageView(width: 54)
    var userName = UILabel(text: "UserName", font: .systemFont(ofSize: 16), textColor: .white , textAlignment: .center, numberOfLines: 2)
    var match: Match
    
    init(match: Match){
        self.match = match
        super.init(frame: .zero)
        backgroundColor = .black
        userName.text = match.name
        if let match = URL(string: match.profileImageUrl){
            userImageView.sd_setImage(with: match)
        }

        
        let imageStack = stack(userImageView, userName, spacing: 8, alignment: .center)
        let barStack = hstack(backButton,imageStack,flagButton, alignment: .center).withMargins(.init(top: 0, left: 16, bottom: 0, right: 16))
        setupShadow(opacity: 0.2, radius: 8, offset: .init(width: 0, height: 10), color: .init(white: 1, alpha: 0.3))
        
        addSubview(barStack)
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
}
