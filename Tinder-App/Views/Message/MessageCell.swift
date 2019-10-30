//
//  MessageCell.swift
//  Tinder-App
//
//  Created by Миронов Влад on 30.10.2019.
//  Copyright © 2019 Миронов Влад. All rights reserved.
//

import LBTATools

class MessageCell: LBTAListCell<Message>{
    
    let textView: UITextView = {
        let textView = UITextView()
        textView.font = .systemFont(ofSize: 20)
        
        textView.isScrollEnabled = false
        textView.isEditable = false
        textView.backgroundColor = .none
        return textView
    }()
    
    let bubbleContainer = UIView(backgroundColor: #colorLiteral(red: 0.4745098054, green: 0.8392156959, blue: 0.9764705896, alpha: 1))

    override var item: Message!{
        didSet{
            textView.text = item.text
            
            if item.isFromCurrentUser {
                bubbleConstraint.trailing?.isActive = true
                bubbleConstraint.leading?.isActive = false
                bubbleContainer.backgroundColor = #colorLiteral(red: 0.1411764771, green: 0.3960784376, blue: 0.5647059083, alpha: 1)
                textView.textColor = .white
                textView.textAlignment = .right

            } else {
                bubbleConstraint.trailing?.isActive = false
                bubbleConstraint.leading?.isActive = true
                bubbleContainer.backgroundColor = #colorLiteral(red: 0.8039215803, green: 0.8039215803, blue: 0.8039215803, alpha: 1)
                textView.textColor = .black
                textView.textAlignment = .left
            }
        }
    }
    
    var bubbleConstraint: AnchoredConstraints!
    
    override func setupViews() {
        super.setupViews()
        backgroundColor = .none
        
        addSubview(bubbleContainer)
        bubbleContainer.layer.cornerRadius = 12
        bubbleConstraint = bubbleContainer.anchor(top: topAnchor, leading: leadingAnchor, bottom: bottomAnchor, trailing: trailingAnchor)
        bubbleConstraint.leading?.constant = 20
        bubbleConstraint.trailing?.constant = -20
        
        bubbleContainer.addSubview(textView)
        bubbleContainer.widthAnchor.constraint(lessThanOrEqualToConstant: self.contentView.frame.width - 100).isActive = true
        textView.fillSuperview(padding: .init(top: 4, left: 12, bottom: 4, right: 12))
    }
}
