//
//  Advertiser.swift
//  Tinder-App
//
//  Created by Миронов Влад on 09.10.2019.
//  Copyright © 2019 Миронов Влад. All rights reserved.
//

import UIKit

struct Advertiser: ProducesCardViewModel {
    let title: String
    let brandName: String
    let posterPhotoName: String
    
    func toCardViewModel() -> CardViewModel {
        
        let attributedText = NSMutableAttributedString(string: title, attributes: [.font: UIFont.systemFont(ofSize: 34, weight: .heavy)])
        attributedText.append(NSAttributedString(string: "\n\(brandName)", attributes: [.font: UIFont.systemFont(ofSize: 24, weight: .bold)]))
        return CardViewModel(imageNames: [posterPhotoName], attributedString: attributedText, textAlignment: .center)
    }
}
