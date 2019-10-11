//
//  RegistrationViewController.swift
//  Tinder-App
//
//  Created by Миронов Влад on 10.10.2019.
//  Copyright © 2019 Миронов Влад. All rights reserved.
//

import UIKit

class RegistrationViewController: UIViewController {
    
    let selectPhotoButton: UIButton = {
        let button = UIButton(type: .system)
        button.setTitle("Select Photo", for: .normal)
        button.titleLabel?.font = UIFont.systemFont(ofSize: 32, weight: .heavy)
        button.backgroundColor = .white
        button.setTitleColor(.black, for: .normal)
        button.heightAnchor.constraint(equalToConstant: 280).isActive = true
        button.layer.cornerRadius = 14
        return button
    }()
    
    let fullNameTextField: UITextField = {
        let tf = CustomTextField(padding: 24, placeholder: "Enter full name")
        return tf
    }()
    
    let emailNameTextField: UITextField = {
        let tf = CustomTextField(padding: 24, placeholder: "Enter email")
        return tf
    }()
    
    let passwordNameTextField: UITextField = {
        let tf = CustomTextField(padding: 24, placeholder: "Enter password")
        return tf
    }()
    
    let registerButton: UIButton = {
        let button = UIButton(type: .system)
        button.setTitle("Register", for: .normal)
        button.titleLabel?.font = UIFont.systemFont(ofSize: 18, weight: .semibold)
        button.backgroundColor = #colorLiteral(red: 0.5725490451, green: 0, blue: 0.2313725501, alpha: 1)
        button.setTitleColor(.white, for: .normal)
        button.heightAnchor.constraint(equalToConstant: 50).isActive = true
        button.layer.cornerRadius = 25
        return button
    }()
    
    let loginButton: UIButton = {
        let button = UIButton(type: .system)
        button.titleLabel?.font = UIFont.systemFont(ofSize: 16, weight: .regular)
        button.setTitleColor(.white, for: .normal)
        button.setTitle("Go to Login", for: .normal)
        button.backgroundColor = #colorLiteral(red: 0.05882352963, green: 0.180392161, blue: 0.2470588237, alpha: 1)
        button.heightAnchor.constraint(equalToConstant: 50).isActive = true
        
        return button
    }()

    
    override func viewDidLoad() {
        super.viewDidLoad()
        setupGradientLayer()
        
        let stackView = UIStackView(arrangedSubviews: [
            selectPhotoButton,
            fullNameTextField,
            emailNameTextField,
            passwordNameTextField,
            registerButton,
            loginButton
            
        ])
        view.addSubview(stackView)
        

        stackView.axis = .vertical
        stackView.spacing = 8
        stackView.anchor(top: nil, leading: view.leadingAnchor, bottom: nil, trailing: view.trailingAnchor, padding: .init(top: 0, left: 50, bottom: 0, right: 50))
        stackView.centerYAnchor.constraint(equalTo: view.centerYAnchor).isActive = true
    }
    
    fileprivate func setupGradientLayer() {
        let gradientLayer = CAGradientLayer()
        gradientLayer.colors = [#colorLiteral(red: 0.9921568627, green: 0.3450980392, blue: 0.3725490196, alpha: 1).cgColor,#colorLiteral(red: 0.8980392157, green: 0, blue: 0.4470588235, alpha: 1).cgColor]
        gradientLayer.locations = [0,1]
        gradientLayer.frame = view.bounds
        view.layer.addSublayer(gradientLayer)
    }
}







