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
    let imageUrls: [String]
    let attributedString: NSAttributedString
    let textAlignment: NSTextAlignment
    
    private var imageIndex = 0 {
        didSet {
            let imageUrl = imageUrls[imageIndex]
            imageIndexObserver?(imageUrl, imageIndex)
        }
    }
    
    init(imageNames: [String], attributedString: NSAttributedString, textAlignment:  NSTextAlignment) {
        self.imageUrls = imageNames
        self.attributedString = attributedString
        self.textAlignment = textAlignment
    }
    
    // Reactive Programming
    var imageIndexObserver: ((String?, Int) -> ())?
    func presentNextPhoto(){
        print(imageUrls.count)
        let index = min(imageIndex + 1, imageUrls.count - 1)
        if self.imageIndex == index {return} else { self.imageIndex = index}
    }
    
    func presentPreviusPhoto(){
        let index = max(imageIndex - 1, 0)
        if self.imageIndex == index {return} else {self.imageIndex = index}
    }
}


