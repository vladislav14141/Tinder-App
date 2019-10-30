//
//  MatchesHeader.swift
//  Tinder-App
//
//  Created by Миронов Влад on 30.10.2019.
//  Copyright © 2019 Миронов Влад. All rights reserved.
//

import LBTATools

class MatchesHeader: UICollectionReusableView{
    let newMatchesLabel = UILabel(text: "New Matches", font: .boldSystemFont(ofSize: 18), textColor: #colorLiteral(red: 0.8078431487, green: 0.02745098062, blue: 0.3333333433, alpha: 1))
    let messagesLabel = UILabel(text: "Messages", font: .boldSystemFont(ofSize: 18), textColor: #colorLiteral(red: 0.8078431487, green: 0.02745098062, blue: 0.3333333433, alpha: 1))
    
    let horizontalViewController = MatchesHorizontalController()

    override init(frame: CGRect) {
        super.init(frame: frame)
        horizontalViewController.view.backgroundColor = .yellow
        stack(stack(newMatchesLabel).padLeft(20),
              horizontalViewController.view,
              stack(messagesLabel).padLeft(20),
              spacing: 20).withMargins(.init(top: 20, left: 0, bottom: 8, right: 0))
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
}
