//
//  LoginController.swift
//  SwipeMatchFirestoreLBTA
//
//  Created by Brian Voong on 11/26/18.
//  Copyright © 2018 Brian Voong. All rights reserved.
//

import UIKit
import Firebase


class LoginController: UIViewController {
    
    // MARK: - Private Properties
    fileprivate let progressHUD = ProgressHUD()
    fileprivate let gradientLayer = CAGradientLayer()
    fileprivate let loginViewModel = LoginViewModel()
    fileprivate let backToRegisterButton: UIButton = {
        let button = UIButton(type: .system)
        button.setTitle("Register", for: .normal)
        button.setTitleColor(.white, for: .normal)
        button.titleLabel?.font = UIFont.boldSystemFont(ofSize: 16)
        button.addTarget(self, action: #selector(handleBack), for: .touchUpInside)
        return button
    }()
    
    // MARK: - Public Properties
    let emailTextField: CustomTextField = {
        let tf = CustomTextField(padding: 24, placeholder: "Enter email")
        tf.keyboardType = .emailAddress
        tf.addTarget(self, action: #selector(handleTextChange), for: .editingChanged)
        return tf
    }()
    
    let passwordTextField: CustomTextField = {
        let tf = CustomTextField(padding: 24, placeholder: "Enter password")
        tf.isSecureTextEntry = true
        tf.addTarget(self, action: #selector(handleTextChange), for: .editingChanged)
        return tf
    }()
    
    lazy var verticalStackView: UIStackView = {
        let sv = UIStackView(arrangedSubviews: [
            emailTextField,
            passwordTextField,
            loginButton
            ])
        sv.axis = .vertical
        sv.spacing = 8
        return sv
    }()
    
    let loginButton: UIButton = {
        let button = UIButton(type: .system)
        button.setTitle("Login", for: .normal)
        button.setTitleColor(.white, for: .normal)
        button.titleLabel?.font = UIFont.systemFont(ofSize: 16, weight: .heavy)
        button.backgroundColor = .lightGray
        button.setTitleColor(.gray, for: .disabled)
        button.isEnabled = false
        button.heightAnchor.constraint(equalToConstant: 44).isActive = true
        button.layer.cornerRadius = 22
        button.addTarget(self, action: #selector(handleLogin), for: .touchUpInside)
        return button
    }()

    // MARK: - Lifecycle
    override func viewWillLayoutSubviews() {
         super.viewWillLayoutSubviews()
         gradientLayer.frame = view.bounds
     }

    override func viewDidLoad() {
        super.viewDidLoad()
        setupTapGesture()
        setupGradientLayer()
        setupLayout()
        
        setupBindables()
    }

    // MARK: - Public Methods
    func presentLoginVC(in view: UIViewController) {
           if Auth.auth().currentUser == nil {
            let registrationVC = LoginController()
               let navController = UINavigationController(rootViewController: registrationVC)
            navController.modalPresentationStyle = .fullScreen
            view.present(navController, animated: true)
           }
       }
    
    // MARK: - Private Methods
    fileprivate func setupBindables() {
        loginViewModel.isFormValid.bind { [unowned self] (isFormValid) in
            guard let isFormValid = isFormValid else { return }
            self.loginButton.isEnabled = isFormValid
            self.loginButton.backgroundColor = isFormValid ? #colorLiteral(red: 0.8235294118, green: 0, blue: 0.3254901961, alpha: 1) : .lightGray
            self.loginButton.setTitleColor(isFormValid ? .white : .gray, for: .normal)
        }
        loginViewModel.isLoggingIn.bind { [unowned self] (isRegistering) in
            if isRegistering == true {
                self.progressHUD.showProgressHUD(in: self.view, with: "Logging...")
            } else {
                self.progressHUD.dismiss()
            }
        }
    }
    
    fileprivate func setupGradientLayer() {
        let topColor = #colorLiteral(red: 0.9921568627, green: 0.3568627451, blue: 0.3725490196, alpha: 1)
        let bottomColor = #colorLiteral(red: 0.8980392157, green: 0, blue: 0.4470588235, alpha: 1)
        // make sure to user cgColor
        gradientLayer.colors = [topColor.cgColor, bottomColor.cgColor]
        gradientLayer.locations = [0, 1]
        view.layer.addSublayer(gradientLayer)
        gradientLayer.frame = view.bounds
    }
    
    fileprivate func setupLayout() {
        navigationController?.isNavigationBarHidden = true
        view.addSubview(verticalStackView)
        verticalStackView.anchor(top: nil, leading: view.leadingAnchor, bottom: nil, trailing: view.trailingAnchor, padding: .init(top: 0, left: 50, bottom: 0, right: 50))
        verticalStackView.centerYAnchor.constraint(equalTo: view.centerYAnchor).isActive = true
        
        view.addSubview(backToRegisterButton)
        backToRegisterButton.anchor(top: nil, leading: view.leadingAnchor, bottom: view.safeAreaLayoutGuide.bottomAnchor, trailing: view.trailingAnchor)
    }
    
    fileprivate func setupTapGesture(){
        let gesture = UITapGestureRecognizer(target: self, action: #selector(handleTapDismiss))
            self.view.addGestureRecognizer(gesture)
    }
    
    //MARK: - Handlers
    @objc fileprivate func handleBack() {
        let registrationController = RegistrationController()
        navigationController?.pushViewController(registrationController, animated: true)
        
    }
    
    @objc fileprivate func handleLogin() {
        loginViewModel.performLogin { (err) in
            self.progressHUD.showHUDWithMessage(in: self.view, error: err)
            
            guard err == nil else {return}
            self.dismiss(animated: true)
        }
    }
    
    @objc fileprivate func handleTextChange(textField: UITextField) {
        if textField == emailTextField {
            loginViewModel.email = textField.text
        } else {
            loginViewModel.password = textField.text
        }
    }
    
    @objc fileprivate func handleTapDismiss() {
        self.view.endEditing(true)
    }
}
