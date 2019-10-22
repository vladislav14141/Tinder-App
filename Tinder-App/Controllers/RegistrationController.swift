//
//  RegistrationViewController.swift
//  Tinder-App
//
//  Created by Миронов Влад on 10.10.2019.
//  Copyright © 2019 Миронов Влад. All rights reserved.
//

import UIKit
import Firebase
import JGProgressHUD
class RegistrationController: UIViewController  {
    let progressHUD = ProgressHUD()
    let registrationViewModel = RegistrationViewModel()
    lazy var verticalStackView: UIStackView = {
       let sv =  UIStackView(arrangedSubviews: [
        self.fullNameTextField,
        self.emailNameTextField,
        self.passwordNameTextField,
        self.registerButton
          ])
        sv.axis = .vertical
        sv.spacing = 8
        sv.distribution = .fillEqually
        return sv
    }()
    
    lazy var overralStackView: UIStackView = {
        let os = UIStackView(arrangedSubviews: [
        selectPhotoButton,
        verticalStackView
    ])
        os.axis = .vertical
        os.spacing = 8
        return os
    }()
    
    let selectPhotoButton: UIButton = {
        let button = UIButton(type: .system)
        button.setTitle("Select Photo", for: .normal)
        button.titleLabel?.font = UIFont.systemFont(ofSize: 32, weight: .heavy)
        button.backgroundColor = .white
        button.setTitleColor(.black, for: .normal)
        button.heightAnchor.constraint(equalToConstant: 280).isActive = true
        button.layer.cornerRadius = 14
        button.imageView?.contentMode = .scaleAspectFill
        button.clipsToBounds = true
        button.addTarget(self, action: #selector(handleSelectPhoto), for: .touchUpInside)
        return button
    }()
    
    let fullNameTextField: UITextField = {
        let tf = CustomTextField(padding: 24, placeholder: "Enter full name")
        tf.addTarget(self, action: #selector(handleTextChange), for: .editingChanged)
        return tf
    }()
    
    let emailNameTextField: UITextField = {
        let tf = CustomTextField(padding: 24, placeholder: "Enter email")
        tf.keyboardType = .emailAddress
        tf.addTarget(self, action: #selector(handleTextChange), for: .editingChanged)
        return tf
    }()
    
    let passwordNameTextField: UITextField = {
        let tf = CustomTextField(padding: 24, placeholder: "Enter password")
        tf.textContentType = .password
        tf.isSecureTextEntry = true
        tf.addTarget(self, action: #selector(handleTextChange), for: .editingChanged)
        return tf
    }()
    
    let registerButton: UIButton = {
        let button = UIButton(type: .system)
        button.setTitle("Register", for: .normal)
        button.titleLabel?.font = UIFont.systemFont(ofSize: 18, weight: .semibold)

        button.backgroundColor = .lightGray
        button.setTitleColor(.darkGray, for: .normal)
        button.isEnabled = false
        button.heightAnchor.constraint(equalToConstant: 50).isActive = true
        button.layer.cornerRadius = 25
        button.addTarget(self, action: #selector(handleRegister), for: .touchUpInside)
        return button
    }()
    
    let loginButton: UIButton = {
        let button = UIButton(type: .system)
        button.titleLabel?.font = UIFont.systemFont(ofSize: 16, weight: .regular)
        button.setTitleColor(.white, for: .normal)
        button.setTitle("Go to Login", for: .normal)
        button.heightAnchor.constraint(equalToConstant: 50).isActive = true
        button.addTarget(self, action: #selector(handleGoToLogin), for: .touchUpInside)
        return button
    }()
    
    let gradientLayer: CAGradientLayer = {
        let gradientLayer = CAGradientLayer()
        gradientLayer.colors = [#colorLiteral(red: 0.9921568627, green: 0.3450980392, blue: 0.3725490196, alpha: 1).cgColor,#colorLiteral(red: 0.8980392157, green: 0, blue: 0.4470588235, alpha: 1).cgColor]
        gradientLayer.locations = [0,1]
        return gradientLayer
    }()
    
    


    override func viewDidLoad() {
        super.viewDidLoad()
        setupNotificationObserver()
        setupTapGesture()
        setupRegistrationViewModelObserver()
        setupLayout()
    }
    

    
    override func viewWillDisappear(_ animated: Bool) {
        super.viewWillDisappear(animated)
        NotificationCenter.default.removeObserver(self)
    }
    
    override func viewWillLayoutSubviews() {
        super.viewWillLayoutSubviews()
        gradientLayer.frame = view.bounds
    }
    
    override func traitCollectionDidChange(_ previousTraitCollection: UITraitCollection?) {
        if self.traitCollection.verticalSizeClass == .compact {
            overralStackView.axis = .horizontal
        } else {
            overralStackView.axis = .vertical
        }
    }
    
    fileprivate func setupLayout() {
        navigationController?.isNavigationBarHidden = true
        view.layer.addSublayer(gradientLayer)
        view.addSubview(overralStackView)
      
        overralStackView.anchor(top: nil, leading: view.leadingAnchor, bottom: nil, trailing: view.trailingAnchor, padding: .init(top: 0, left: 50, bottom: 0, right: 50))
        
        
        overralStackView.centerYAnchor.constraint(equalTo: view.centerYAnchor).isActive = true
        selectPhotoButton.widthAnchor.constraint(lessThanOrEqualToConstant: 274).isActive = true
        
        view.addSubview(loginButton)
        loginButton.anchor(top: nil, leading: view.leadingAnchor, bottom: view.safeAreaLayoutGuide.bottomAnchor, trailing: view.trailingAnchor)
    }
    
    fileprivate func setupRegistrationViewModelObserver() {
        registrationViewModel.binableIsFormValid.bind {  [unowned self] (isFormValid) in
            if isFormValid ?? false {
                self.registerButton.backgroundColor = #colorLiteral(red: 0.5725490451, green: 0, blue: 0.2313725501, alpha: 1)
                self.registerButton.setTitleColor(.white, for: .normal)
                self.registerButton.isEnabled = true
            } else {
                self.registerButton.isEnabled = false
                self.registerButton.backgroundColor = .lightGray
                self.registerButton.setTitleColor(.darkGray, for: .normal)
            }
        }
        registrationViewModel.bindableImage.bind { [unowned self] img in
            self.selectPhotoButton.setImage(img?.withRenderingMode(.alwaysOriginal), for: .normal)
        }
    }
    fileprivate func setupNotificationObserver() {
        NotificationCenter.default.addObserver(self, selector: #selector(handleKeyboardShow), name: UIResponder.keyboardWillShowNotification, object: nil)
        NotificationCenter.default.addObserver(self, selector: #selector(handleKeyboardHide), name: UIResponder.keyboardWillHideNotification, object: nil)
    }
    
    fileprivate func setupTapGesture(){
        let gesture = UITapGestureRecognizer(target: self, action: #selector(handleTapDismiss))
            self.view.addGestureRecognizer(gesture)
    }
    
    
    
    @objc fileprivate func handleRegister() {
        self.handleTapDismiss()
        registrationViewModel.performRegistration { [unowned self] (err) in
            self.progressHUD.showHUDWithMessage(in: self.selectPhotoButton, error: err)
         
            if err == nil {
                self.dismiss(animated: true)
//                let registrationVC = HomeController()
//                let navController = UINavigationController(rootViewController: registrationVC)
//                self.present(navController, animated: true)
            }
        }
        print("Finished registering")
       
    }
    
    @objc fileprivate func handleTextChange(textField: UITextField) {
        switch textField {
        case passwordNameTextField:
            registrationViewModel.password = textField.text
        case emailNameTextField:
            registrationViewModel.email = textField.text
        case fullNameTextField:
            registrationViewModel.fullName = textField.text
        default:
            return
        }
    }
    
    @objc fileprivate func handleKeyboardShow(notification: Notification) {
        guard let value = notification.userInfo?[UIResponder.keyboardFrameEndUserInfoKey] as? NSValue else {return}
        let keyboardFrame = value.cgRectValue
        
        let bottomSpace = view.frame.height - overralStackView.frame.origin.y - overralStackView.frame.height
        let difference = keyboardFrame.height - bottomSpace
        self.view.transform = CGAffineTransform(translationX: 0, y: -difference - 10)
    }
    
    @objc fileprivate func handleKeyboardHide(notification: Notification) {
        self.view.endEditing(true)
        UIView.animate(withDuration: 0.5, delay: 0, usingSpringWithDamping: 1, initialSpringVelocity: 1, options: .curveEaseOut, animations: {
            self.view.transform = .identity
        })
    }
    
    @objc fileprivate func handleTapDismiss() {
        self.view.endEditing(true)
    }
    
    @objc fileprivate func handleGoToLogin() {
        navigationController?.popViewController(animated: true)
        
    }
}

extension RegistrationController: UIImagePickerControllerDelegate, UINavigationControllerDelegate{
    func imagePickerController(_ picker: UIImagePickerController, didFinishPickingMediaWithInfo info: [UIImagePickerController.InfoKey : Any]) {
        let image = info[.originalImage] as? UIImage
        registrationViewModel.bindableImage.value = image
        registrationViewModel.checkFormValidity()
        dismiss(animated: true, completion: nil)
    }
    func imagePickerControllerDidCancel(_ picker: UIImagePickerController) {
        dismiss(animated: true, completion: nil)
    }
    
    
    @objc fileprivate func handleSelectPhoto() {
        let imagePickerController = UIImagePickerController()
        imagePickerController.delegate = self
        present(imagePickerController, animated: true)
    }
}







