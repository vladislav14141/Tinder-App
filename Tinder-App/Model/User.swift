//
//  User.swift
//  Tinder-App
//
//  Created by Миронов Влад on 08.10.2019.
//  Copyright © 2019 Миронов Влад. All rights reserved.
//

import UIKit

struct User: ProducesCardViewModel {
    var name: String?
    var age: Int?
    var profession: String?
//    let imageNames: [String]
    var minSeekingAge: Int?
    var maxSeekingAge: Int?
    var imageUrl1: String?
    var imageUrl2: String?
    var imageUrl3: String?

    var uid: String?
    var bio: String
    
    init(dictionary: [String: Any]) {
        self.name = dictionary["fullName"] as? String ?? ""
        self.age = dictionary["age"] as? Int
        self.maxSeekingAge = dictionary["maxSeekingAge"] as? Int
        self.minSeekingAge = dictionary["minSeekingAge"] as? Int 
        self.profession = dictionary["profession"] as? String
        self.imageUrl1 = dictionary["imageUrl1"] as? String
        self.imageUrl2 = dictionary["imageUrl2"] as? String
        self.imageUrl3 = dictionary["imageUrl3"] as? String 
        self.uid = dictionary["uid"] as? String ?? ""
        self.bio = dictionary["bio"] as? String ?? ""
    }
    
    func toCardViewModel() -> CardViewModel {
        let shadow = NSShadow()
        shadow.shadowColor = UIColor.black
        shadow.shadowOffset = CGSize(width: 0.5, height: -1.5)
        shadow.shadowBlurRadius = 2
        
        let ageString = age != nil ? " \(age!)" : "N/A"
        let professionString = profession != nil ? profession! : "N/A"

        let attributedText = NSMutableAttributedString(string: name ?? "", attributes: [.font: UIFont.systemFont(ofSize: 30, weight: .heavy)])
        attributedText.append(NSAttributedString(string: ageString, attributes: [.font: UIFont.systemFont(ofSize: 24, weight: .regular)]))
        attributedText.append(NSAttributedString(string: "\n\(professionString)", attributes: [.font: UIFont.systemFont(ofSize: 20, weight: .regular)]))
        var imageUrls = [String]()
        if let url = imageUrl1 {imageUrls.append(url)}
        if let url = imageUrl2 {imageUrls.append(url)}
        if let url = imageUrl3 {imageUrls.append(url)}

        return CardViewModel(imageNames: imageUrls, attributedString: attributedText, textAlignment: .left)
    }
}


