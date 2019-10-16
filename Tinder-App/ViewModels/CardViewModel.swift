//
//  CardViewModel.swift
//  Tinder-App
//
//  Created by Миронов Влад on 08.10.2019.
//  Copyright © 2019 Миронов Влад. All rights reserved.
//

import UIKit

protocol ProducesCardViewModel {
    func toCardViewModel() -> CardViewModel
}

class CardViewModel {
    let imageNames: [String]
    let attributedString: NSAttributedString
    let textAlignment: NSTextAlignment
    
    private var imageIndex = 0 {
        didSet {
            let imageUrl = imageNames[imageIndex]
            imageIndexObserver?(imageUrl, imageIndex)
        }
    }
    
    init(imageNames: [String], attributedString: NSAttributedString, textAlignment:  NSTextAlignment) {
        self.imageNames = imageNames
        self.attributedString = attributedString
        self.textAlignment = textAlignment
    }
    
    // Reactive Programming
    var imageIndexObserver: ((String?, Int) -> ())?
    func presentNextPhoto(){
        imageIndex = min(imageIndex + 1, imageNames.count - 1)

    }
    
    func presentPreviusPhoto(){
        imageIndex = max(imageIndex - 1, 0)
    }
}


