//
//  RegistrationViewModel.swift
//  Tinder-App
//
//  Created by Миронов Влад on 11.10.2019.
//  Copyright © 2019 Миронов Влад. All rights reserved.
//

import UIKit
import Firebase
class RegistrationViewModel {
    
    let bindableImage = Bindable<UIImage>()
    var fullName: String?{
        didSet{
            checkFormValidity()
        }
    }
    var email: String? {didSet{checkFormValidity()}}
    var password: String? {didSet{checkFormValidity()}}
    
    func performRegistration(completion: @escaping (Error?) -> ()){
        guard let email = email else {return}
        guard let password = password else {return}
        Auth.auth().createUser(withEmail: email, password: password) { (res, err) in
            if let err = err{
                completion(err)
                return
            }
            self.saveImageToFirebase(completion: completion)
            completion(nil)
        }
    }
    
    fileprivate func saveImageToFirebase(completion: @escaping (Error?) -> ()) {
        let filename = UUID().uuidString
        let ref = Storage.storage().reference(withPath: "/images/\(filename)")
        let imageData = self.bindableImage.value?.jpegData(compressionQuality: 0.75) ?? Data()
        
        ref.putData(imageData, metadata: nil) { (_, err) in
            if let err = err {
                completion(err)
                return
            }
            
            ref.downloadURL { (url, err) in
                if let err = err {
                    completion(err)
                    return
                }
                
                self.saveInfoToFirestore(imageURL: url?.absoluteString ?? "", completion: completion)
                
            }
        }
    }
    
    fileprivate func saveInfoToFirestore(imageURL: String, completion: @escaping (Error?) -> ()){
        let uid = Auth.auth().currentUser?.uid ?? ""
        let docData = ["fullName": fullName ?? "", "uid": uid, "imageUrl1": imageURL]
        Firestore.firestore().collection("users").document(uid).setData(docData) { (err) in
            if let err = err {
                completion(err)
                return
            }
            completion(nil)
            
        }
    }
    
    fileprivate func checkFormValidity() {
        let isFormValid = fullName?.isEmpty == false && email?.isEmpty == false && password?.isEmpty == false
        binableIsFormValid.value = isFormValid
    }
    //Reactive programming
    var binableIsFormValid = Bindable<Bool>()    
}
