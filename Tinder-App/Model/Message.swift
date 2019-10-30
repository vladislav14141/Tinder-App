//
//  Message.swift
//  Tinder-App
//
//  Created by Миронов Влад on 30.10.2019.
//  Copyright © 2019 Миронов Влад. All rights reserved.
//

import UIKit
import Firebase
struct Message {
    let text: String
    let fromId: String
    let toId: String
    let timestamp: Timestamp
    let isFromCurrentUser: Bool
    
    init(dictionary: [String: Any]) {
        
        self.text = dictionary["text"] as? String ?? ""
        self.fromId = dictionary["fromId"] as? String ?? ""
        self.toId = dictionary["toId"] as? String ?? ""
        self.timestamp = dictionary["timestamp"] as? Timestamp ?? Timestamp(date: Date())
        
        self.isFromCurrentUser = Auth.auth().currentUser?.uid == self.fromId ? true : false
    }
}
