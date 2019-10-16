//
//  Bindable.swift
//  Tinder-App
//
//  Created by Миронов Влад on 13.10.2019.
//  Copyright © 2019 Миронов Влад. All rights reserved.
//

import Foundation

class Bindable<T> {
    var value: T?{
        didSet{
            observer?(value)
        }
    }
    var observer: ((T?)->())?
    
    func bind(observer: @escaping (T?)->()) {
        self.observer = observer
    }
    
}
