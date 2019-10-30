//
//  CustomTextView.swift
//  Tinder-App
//
//  Created by Миронов Влад on 30.10.2019.
//  Copyright © 2019 Миронов Влад. All rights reserved.
//

import LBTATools
class CustomTextView: UIView{
    let textView = UITextView()
    let sendButton = UIButton(title: "SEND", titleColor: .black, font: .boldSystemFont(ofSize: 14), target: nil, action: nil)
    let placeholderLabel = UILabel(text: "Enter message", textColor: .lightGray)
    override var intrinsicContentSize: CGSize{
        return .zero
    }
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        backgroundColor = .white
        setupShadow(opacity: 0.1, radius: 8, offset: .init(width: 0, height: -8), color: .lightGray)
        autoresizingMask = .flexibleHeight

        textView.isScrollEnabled = false
        textView.font = .systemFont(ofSize: 16)
        NotificationCenter.default.addObserver(self, selector: #selector(handleTextChange), name: UITextView.textDidChangeNotification, object: nil)
        hstack(textView,
                       sendButton.withSize(.init(width: 60, height: 60)),
                       alignment: .center).withMargins(.init(top: 0, left: 16, bottom: 0, right: 16))
        textView.heightAnchor.constraint(lessThanOrEqualToConstant: 250).isActive = true
        addSubview(placeholderLabel)
        placeholderLabel.anchor(top: textView.topAnchor, leading: textView.leadingAnchor, bottom: textView.bottomAnchor, trailing: nil, padding: .init(top: 0, left: 4, bottom: 0, right: 0))
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    deinit {
        NotificationCenter.default.removeObserver(self)
    }
    
    @objc fileprivate func handleTextChange(){
        if textView.text == "" {
            placeholderLabel.isHidden = false
        } else {
            placeholderLabel.isHidden = true
        }
    }
}
