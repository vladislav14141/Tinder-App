//
//  CustomTextField.swift
//  Tinder-App
//
//  Created by Миронов Влад on 10.10.2019.
//  Copyright © 2019 Миронов Влад. All rights reserved.
//

import UIKit

class CustomTextField: UITextField {
    let padding: CGFloat
    
    
    
    init(padding: CGFloat, placeholder: String) {
        self.padding = padding
        super.init(frame: .zero)
        self.placeholder = placeholder
        backgroundColor = .white
        layer.cornerRadius = 25
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    override func textRect(forBounds bounds: CGRect) -> CGRect {
        return bounds.insetBy(dx: padding, dy: 0)
        
    }
    override func editingRect(forBounds bounds: CGRect) -> CGRect {
        return bounds.insetBy(dx: padding, dy: 0)
    }
    
    override var intrinsicContentSize: CGSize {
        return .init(width: 0, height: 50)
    }
}

