//
//  Match.swift
//  Tinder-App
//
//  Created by Миронов Влад on 30.10.2019.
//  Copyright © 2019 Миронов Влад. All rights reserved.
//

import Foundation
struct Match {
    let name: String
    let profileImageUrl: String
    let uid: String
    init(dictionary: [String: Any]){
        self.name = dictionary["name"] as? String ?? ""
        self.profileImageUrl = dictionary["profileImage"] as? String ?? ""
        self.uid = dictionary["uid"] as? String ?? ""
    }
}
