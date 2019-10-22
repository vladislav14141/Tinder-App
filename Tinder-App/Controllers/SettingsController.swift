//
//  SettingsController.swift
//  Tinder-App
//
//  Created by Миронов Влад on 15.10.2019.
//  Copyright © 2019 Миронов Влад. All rights reserved.
//

import UIKit
import Firebase
import SDWebImage

protocol SettingsControllerDelegate {
    func didSaveSettings()
}
class SettingsController: UITableViewController {
    class HeaderLabel: UILabel {
        override func drawText(in rect: CGRect) {
            super.drawText(in: rect.insetBy(dx: 16, dy: 0))
            font = UIFont.systemFont(ofSize: 16, weight: .bold)
        }
    }
    
    class CustomImagePickerController: UIImagePickerController{
        var imageButton: UIButton?
    }
    var delegate: SettingsControllerDelegate?
    
    let loginController = LoginController()
    lazy var image1Button = createButton(selector: #selector(handleSelectPhoto))
    lazy var image2Button = createButton(selector: #selector(handleSelectPhoto))
    lazy var image3Button = createButton(selector: #selector(handleSelectPhoto))
    lazy var header: UIView = {
        let header = UIView()
        header.addSubview(image1Button)
        let padding: CGFloat = 16
        image1Button.anchor(top: header.topAnchor, leading: header.leadingAnchor, bottom: header.bottomAnchor, trailing: nil, padding: .init(top: padding, left: padding, bottom: padding, right: padding))
        image1Button.widthAnchor.constraint(equalTo: header.widthAnchor, multiplier: 0.45).isActive = true
        let stackView = UIStackView(arrangedSubviews: [image2Button, image3Button])
        stackView.spacing = padding
        stackView.axis = .vertical
        stackView.distribution = .fillEqually
        header.addSubview(stackView)
        stackView.anchor(top: header.topAnchor, leading: image1Button.trailingAnchor, bottom: header.bottomAnchor, trailing: header.trailingAnchor, padding: .init(top: padding, left: padding, bottom: padding, right: padding))
        
        return header
    }()
    
    var progressHUD = ProgressHUD()
    var user: User?
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        setupTapGesture()
        setupNavigationItems()
        tableView.backgroundColor = UIColor(white: 0.95, alpha: 1)
        tableView.tableFooterView = UIView()
        tableView.keyboardDismissMode = .interactive
        
        fetchCurrentUser()
    }
    
    override func tableView(_ tableView: UITableView, viewForHeaderInSection section: Int) -> UIView? {
        let label = HeaderLabel()
        
        switch section {
        case 0:
            return header
        case 1:
            label.text = "Name"
        case 2:
            label.text = "Profession"
        case 3:
            label.text = "Age"
        case 4:
            label.text = "Bio"
        default:
            label.text = "Range"
        }
        
        return label
    }
    
    override func tableView(_ tableView: UITableView, heightForHeaderInSection section: Int) -> CGFloat {
        if section == 0 {
            return 300
        }
        return 40
        
    }
    
    override func numberOfSections(in tableView: UITableView) -> Int {
        return 6
    }
    
    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return section == 0 ? 0 : 1
    }
    
    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = SettingCell(style: .default, reuseIdentifier: nil)
        
        if indexPath.section == 5 {
             let ageRangeCell = AgeRangeCell(style: .default, reuseIdentifier: nil)
            ageRangeCell.maxSlider.addTarget(self, action: #selector(handleMaxSliderChange), for: .valueChanged)
            ageRangeCell.minSlider.addTarget(self, action: #selector(handleMinSliderChange), for: .valueChanged)
            
            ageRangeCell.maxLabel.text = "Max \(user?.maxSeekingAge ?? 20)"
            ageRangeCell.minLabel.text = "Min \(user?.minSeekingAge ?? 20)"
            ageRangeCell.maxSlider.value = Float(user?.maxSeekingAge ?? 20)
            ageRangeCell.minSlider.value = Float(user?.minSeekingAge ?? 20)

            return ageRangeCell
        }
        
        switch indexPath.section {
        case 1:
            cell.textField.placeholder = "Enter name"
            cell.textField.text = user?.name
            cell.textField.addTarget(self, action: #selector(handleNameChange), for: .editingChanged)
        case 2:
            cell.textField.placeholder = "Enter profession"
            cell.textField.text = user?.profession
            cell.textField.addTarget(self, action: #selector(handleProfessionChange), for: .editingChanged)
        case 3:
            cell.textField.placeholder = "Enter age"
            let ageString = user == nil ?  "" : String(describing: user?.age ?? 0)
            cell.textField.text = ageString
            cell.textField.keyboardType = .numberPad
            cell.textField.addTarget(self, action: #selector(handleAgeChange), for: .editingChanged)
        case 4:
            cell.textField.placeholder = "Enter bio"
            cell.textField.text = user?.bio
            cell.textField.addTarget(self, action: #selector(handleBioChange), for: .editingChanged)
        default:
            break
        }
        return cell
    }
    
 
    
    fileprivate func fetchCurrentUser() {
        guard let uid = Auth.auth().currentUser?.uid else {return}
        Firestore.firestore().collection("users").document(uid).getDocument { (snapshot, err) in
            if let err = err {
                self.progressHUD.showHUDWithMessage(in: self.view, error: err)
                return
            }
            guard let dictionary = snapshot?.data() else {return}
            let user = User(dictionary: dictionary)
            self.user = user
            self.loadUsersPhoto()
            self.tableView.reloadData()
        }
    }
    
    fileprivate func loadUsersPhoto(){
        if let imageUrl = user?.imageUrl1, let url = URL(string: imageUrl) {
        SDWebImageManager.shared().loadImage(with: url, options: .continueInBackground, progress: nil) { (img, _, _, _, _, _) in
            self.image1Button.setImage(img?.withRenderingMode(.alwaysOriginal), for: .normal)
            }
        }
        
        if let imageUrl = user?.imageUrl2, let url = URL(string: imageUrl) {
        SDWebImageManager.shared().loadImage(with: url, options: .continueInBackground, progress: nil) { (img, _, _, _, _, _) in
            self.image2Button.setImage(img?.withRenderingMode(.alwaysOriginal), for: .normal)
            }
        }
        
        if let imageUrl = user?.imageUrl3, let url = URL(string: imageUrl) {
        SDWebImageManager.shared().loadImage(with: url, options: .continueInBackground, progress: nil) { (img, _, _, _, _, _) in
            self.image3Button.setImage(img?.withRenderingMode(.alwaysOriginal), for: .normal)
            }
        }
    }
    
    fileprivate func createButton(selector: Selector) -> UIButton {
        let button = UIButton(type: .system)
        button.addTarget(self, action: selector, for: .touchUpInside)
        button.backgroundColor = .white
        button.setTitle("Select Photo", for: .normal)
        button.imageView?.contentMode = .scaleAspectFill
        button.layer.cornerRadius = 8
        button.clipsToBounds = true
        button.titleLabel?.font = UIFont.systemFont(ofSize: 14, weight: .heavy)
        button.setTitleColor(.black, for: .normal)
        return button
    }
    
    fileprivate func setupNavigationItems() {
        navigationItem.title = "Settings"
        navigationController?.navigationBar.prefersLargeTitles = true
        navigationItem.leftBarButtonItem = UIBarButtonItem(title: "Cancel", style: .plain, target: self, action: #selector(handleCancel))
        navigationItem.rightBarButtonItems = [
            UIBarButtonItem(title: "Save", style: .plain, target: self, action: #selector(handleSave)),
            UIBarButtonItem(title: "Logout", style: .plain, target: self, action: #selector(handleLogout))
        ]
    }
    
    fileprivate func setupTapGesture(){
        let gesture = UITapGestureRecognizer(target: self, action: #selector(handleTapDismiss))
        self.view.addGestureRecognizer(gesture)
    }
    
    @objc fileprivate func handleNameChange(textField: UITextField){
        guard textField.text?.count ?? 0 > 1 else {return}
        self.user?.name = textField.text ?? ""
    }
    
    @objc fileprivate func handleAgeChange(textField: UITextField){
        guard let text = textField.text, let age = Int(text) else {return}
        guard age > 16 else {return}

        self.user?.age = Int(textField.text ?? "0")
    }
    
    @objc fileprivate func handleProfessionChange(textField: UITextField){
        self.user?.profession = textField.text ?? ""
    }
    
    @objc fileprivate func handleBioChange(textField: UITextField){
        self.user?.bio = textField.text ?? ""
    }
    
    @objc private func handleSave(){
        guard let uid = Auth.auth().currentUser?.uid else {return}
        progressHUD.showProgressHUD(in: self.view, with: "Updating🐙")
        let docData: [String: Any] = [
            "uid": uid,
            "fullName": user?.name ?? "",
            "age": user?.age ?? -1,
            "profession": user?.profession ?? "",
            "imageUrl1": user?.imageUrl1 ?? "",
            "imageUrl2": user?.imageUrl2 ?? "",
            "imageUrl3": user?.imageUrl3 ?? "",
            "bio": user?.bio ?? "",
            "maxSeekingAge": user?.maxSeekingAge ?? -1,
            "minSeekingAge": user?.minSeekingAge ?? -1
            ]

        Firestore.firestore().collection("users").document(uid).setData(docData) { (err) in
            if let err = err {
                self.progressHUD.showHUDWithMessage(in: self.view, error: err)
                return
            }
            self.progressHUD.dismiss()
            self.dismiss(animated: true) {
                self.delegate?.didSaveSettings()
            }
        }
    }
    
    @objc private func handleSelectPhoto(button: UIButton) {
        let imagePicker = CustomImagePickerController()
        imagePicker.delegate = self
        imagePicker.imageButton = button
        present(imagePicker, animated: true)
    }
    
    @objc private func handleCancel(){
        dismiss(animated: true)
    }
    
    @objc fileprivate func handleLogout() {
        try? Auth.auth().signOut()
        dismiss(animated: true)
        loginController.presentLoginVC(in: delegate as! HomeController)
    }
    
    @objc fileprivate func handleTapDismiss() {
        self.view.endEditing(true)
    }
    
    @objc private func handleMaxSliderChange(slider: UISlider){
        let indexPath = IndexPath(row: 0, section: 5)
        guard let ageRangeCell = tableView.cellForRow(at: indexPath) as? AgeRangeCell else {return}
        
        let intMaxAge = Int(ageRangeCell.maxSlider.value)
        let intMinAge = Int(ageRangeCell.minSlider.value)
        self.user?.minSeekingAge = intMinAge
        self.user?.maxSeekingAge = intMaxAge
        
        ageRangeCell.maxLabel.text = "Max \(Int(slider.value))"
        if slider.value < ageRangeCell.minSlider.value {
            ageRangeCell.minSlider.value = slider.value
            ageRangeCell.minLabel.text = "Min \(Int(ageRangeCell.minSlider.value))"
        }
    }
    
    @objc private func handleMinSliderChange(slider: UISlider){
        let indexPath = IndexPath(row: 0, section: 5)
        guard let ageRangeCell = tableView.cellForRow(at: indexPath) as? AgeRangeCell else {return}
        
        let intMinAge = Int(ageRangeCell.minSlider.value)
        let intMaxAge = Int(ageRangeCell.maxSlider.value)
        self.user?.minSeekingAge = intMinAge
        self.user?.maxSeekingAge = intMaxAge

        ageRangeCell.minLabel.text = "Min \(intMinAge)"
        if ageRangeCell.maxSlider.value < slider.value {
            ageRangeCell.maxSlider.value = slider.value
            ageRangeCell.maxLabel.text = "Max \(intMaxAge)"
        }

     }
}

extension SettingsController: UIImagePickerControllerDelegate, UINavigationControllerDelegate {
    func imagePickerController(_ picker: UIImagePickerController, didFinishPickingMediaWithInfo info: [UIImagePickerController.InfoKey : Any]) {
        let selectedImage = info[.originalImage] as? UIImage
        let imageButton = (picker as? CustomImagePickerController)?.imageButton
        imageButton?.setImage(selectedImage?.withRenderingMode(.alwaysOriginal), for: .normal)
        dismiss(animated: true)
        
        let filename = UUID().uuidString
        let ref = Storage.storage().reference(withPath: "/images/\(filename)")
        guard let uploadData = selectedImage?.jpegData(compressionQuality: 0.75) else {return}
        progressHUD.showUploadingProgressHUD(in: self.view, progress: 1000.74, with: "Uploading image...")
        ref.putData(uploadData, metadata: nil) { (data, err) in
            
            
            if let err = err{
                self.progressHUD.showHUDWithMessage(in: self.view, error: err)
                return
            }
            
            ref.downloadURL { (url, err) in
                self.progressHUD.dismiss()
                if let err = err{
                    self.progressHUD.showHUDWithMessage(in: self.view, error: err)
                    return
                }
                
                
                
                switch imageButton {
                case self.image1Button: self.user?.imageUrl1 = url?.absoluteString
                case self.image2Button: self.user?.imageUrl2 = url?.absoluteString
                case self.image3Button: self.user?.imageUrl3 = url?.absoluteString
                default: print("*****************************SetController")
                }
            }
            
        }
    }
}
