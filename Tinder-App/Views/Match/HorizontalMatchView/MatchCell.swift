//
//  MatchCell.swift
//  Tinder-App
//
//  Created by Миронов Влад on 27.10.2019.
//  Copyright © 2019 Миронов Влад. All rights reserved.
//

import LBTATools
import SDWebImage

class MatchCell: LBTAListCell<Match>{
    
    let profileImageView = UIImageView(image: UIImage(named: "mother1"), contentMode: .scaleAspectFill )
    let userNameLabel = UILabel(text: "user name", font: .systemFont(ofSize: 14, weight: .semibold), textColor: .white, textAlignment: .center, numberOfLines: 2)
    
    override var item: Match!{
        didSet{
            userNameLabel.text = item.name
            guard let url = URL(string: item.profileImageUrl ) else {return}
            profileImageView.sd_setImage(with: url, placeholderImage: UIImage(named: "Profile"), options: .continueInBackground) 
        }
    }
    override func setupViews() {
        super.setupViews()
        backgroundColor = .none
        stack(stack(profileImageView, alignment: .center),userNameLabel)
        profileImageView.clipsToBounds = true
        profileImageView.constrainWidth(80)
        profileImageView.constrainHeight(80)
        profileImageView.layer.cornerRadius = 80 / 2
    }
}
