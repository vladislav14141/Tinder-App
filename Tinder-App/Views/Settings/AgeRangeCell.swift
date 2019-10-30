//
//  AgeRangeCell.swift
//  Tinder-App
//
//  Created by Миронов Влад on 16.10.2019.
//  Copyright © 2019 Миронов Влад. All rights reserved.
//

import UIKit

class AgeRangeCell: UITableViewCell {

    let minSlider: UISlider = {
        let slider = UISlider()
        slider.minimumValue = 10
        slider.maximumValue = 100
        slider.value = 10
        return slider
    }()
    
    let maxSlider: UISlider = {
        let slider = UISlider()
        slider.minimumValue = 10
        slider.maximumValue = 100
        slider.value = 10
        return slider
    }()
    
    let minLabel: UILabel = {
        let label = UILabel()
        label.text = "Min  "
        label.widthAnchor.constraint(equalToConstant: 70).isActive = true
        return label
    }()
    
    let maxLabel: UILabel = {
        let label = UILabel()
        label.text = "Max  "
        label.widthAnchor.constraint(equalToConstant: 70).isActive = true
        return label
    }()
    
    lazy var minStackView: UIStackView = {
        let stackView = UIStackView(arrangedSubviews: [minLabel, minSlider])
        stackView.axis = .horizontal
        stackView.spacing = 8
        return stackView
    }()
    
    lazy var maxStackView: UIStackView = {
        let stackView = UIStackView(arrangedSubviews: [maxLabel, maxSlider])
        stackView.axis = .horizontal
        stackView.spacing = 8
        return stackView
     }()
    
    lazy var overralStackView: UIStackView = {
        let stackView = UIStackView(arrangedSubviews: [minStackView, maxStackView])
        stackView.axis = .vertical
        stackView.spacing = 16
        return stackView
      }()
    
    
    
    override init(style: UITableViewCell.CellStyle, reuseIdentifier: String?) {
        super.init(style: style, reuseIdentifier: reuseIdentifier)
        addSubview(overralStackView)


        overralStackView.anchor(top: self.topAnchor, leading: self.leadingAnchor, bottom: self.bottomAnchor, trailing: self.trailingAnchor, padding: .init(top: 15, left: 20, bottom: 15, right: 20))

        
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    

    
}
