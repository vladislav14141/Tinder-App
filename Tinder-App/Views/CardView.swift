//
//  CardView.swift
//  Tinder-App
//
//  Created by Миронов Влад on 07.10.2019.
//  Copyright © 2019 Миронов Влад. All rights reserved.
//

import UIKit

enum SwipeDirection {
    case right
    case left
    case none
}
class CardView: UIView {

    var cardViewModel: CardViewModel! {
        didSet {
            imageView.image = UIImage(named: cardViewModel.imageNames.first ?? "")
            infoLabel.attributedText = cardViewModel.attributedString
            infoLabel.textAlignment = cardViewModel.textAlignment
            
            (0..<cardViewModel.imageNames.count).forEach { (_) in
                 let barView = UIView()
                 barView.backgroundColor = deselectedBarColor
                 barsStackView.addArrangedSubview(barView)
             }
             barsStackView.arrangedSubviews.first?.backgroundColor = .white
            
            setupImageIndexObserver()
        }
    }
    

//   encapsulation
    fileprivate let imageView = UIImageView(image: #imageLiteral(resourceName: "s1200-2"))
    fileprivate let infoLabel = UILabel()
    fileprivate let gradientLayer = CAGradientLayer()
    fileprivate var deselectedBarColor = UIColor(white: 0.2, alpha: 0.4)

    
    override init(frame: CGRect) {
        super.init(frame: frame)
        
        setupLayout()
        
        let panGesture = UIPanGestureRecognizer(target: self, action: #selector(handlePan))
        addGestureRecognizer(panGesture)
        let tapGesture = UITapGestureRecognizer(target: self, action: #selector(handleTap))
        addGestureRecognizer(tapGesture)
        
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    override func layoutSubviews() {
        // in here you know what CardView frame will be
        gradientLayer.frame = self.frame
    }
    

    
    fileprivate func setupLayout() {
        // custom drawing code
        layer.cornerRadius = 10
        clipsToBounds = true
        
        addSubview(imageView)
        imageView.contentMode = .scaleAspectFill
        imageView.fillSuperview()
        
        setupBarsStackView()
        
        // add gradient
        setupGradient()
        
        //  add label
        addSubview(infoLabel)
        infoLabel.anchor(top: nil, leading: self.leadingAnchor, bottom: self.bottomAnchor, trailing: trailingAnchor, padding: .init(top: 0, left: 16, bottom: 16, right: 16))
        infoLabel.textColor = .white
        infoLabel.numberOfLines = 0
    }
    
    fileprivate let barsStackView = UIStackView()
    
    // Bar to present count images
    fileprivate func setupBarsStackView() {
        addSubview(barsStackView)
        barsStackView.anchor(top: self.topAnchor, leading: self.leadingAnchor, bottom: nil, trailing: self.trailingAnchor, padding: .init(top: 8, left: 8, bottom: 0, right: 8), size: .init(width: 0, height: 4))
        barsStackView.spacing = 4
        barsStackView.distribution = .fillEqually
    }
    
    fileprivate func setupGradient() {
        // draw gradient with swift
        gradientLayer.colors = [UIColor.clear.cgColor, UIColor.black.cgColor]
        gradientLayer.locations = [0.55, 1.2]
        layer.addSublayer(gradientLayer)
    }
    //RXSwift
    fileprivate func setupImageIndexObserver() {
        cardViewModel.imageIndexObserver = { [unowned self] (image, i) in
            self.imageView.image = image
            self.barsStackView.arrangedSubviews.forEach { (view) in
                view.backgroundColor = self.deselectedBarColor
            }
            self.barsStackView.arrangedSubviews[i].backgroundColor = .white
        }
    }
    
    @objc fileprivate func handleTap(gesture: UITapGestureRecognizer) {
        let tapLocation = gesture.location(in: nil)
        let shouldAdvance = tapLocation.x > frame.width / 2 ? true : false
        if shouldAdvance{
            cardViewModel.presentNextPhoto()
        } else {
            cardViewModel.presentPreviusPhoto()
        }
    }
    
    @objc fileprivate func handlePan(gesture: UIPanGestureRecognizer) {
        switch gesture.state {
        case .began:
            // removing animation? Maybe i don't needed it
            superview?.subviews.forEach({ (subview) in
                subview.layer.removeAllAnimations()
            })
        case .changed:
            handleChanged(gesture)
        case .ended:
            handleEnded(gesture)
        default:
            ()
        }
    }
    
    fileprivate func handleChanged(_ gesture: UIPanGestureRecognizer) {
        
        let translation = gesture.translation(in: nil)
        
        // Convert radians to degree
        let degrees: CGFloat = translation.x / 20
        let angle = degrees * .pi / 180 
        
        let rotationTransformation = CGAffineTransform(rotationAngle: angle)
        self.transform = rotationTransformation.translatedBy(x: translation.x, y: 0)
    }
    
    fileprivate func handleEnded(_ gesture: UIPanGestureRecognizer) {
        var direction: SwipeDirection = .none
        let velocity = gesture.velocity(in: self).x
        let translation = gesture.translation(in: nil).x

        if velocity > 100 || translation > 100 {
            direction = .right
        } else if velocity < -100 || translation < -100{
            direction = .left
        }
        
        UIView.animate(withDuration: 0.75, delay: 0, usingSpringWithDamping: 0.6, initialSpringVelocity: 0.1, options: .curveEaseOut, animations: {
            
            switch direction {
            case .right:
                self.transform = CGAffineTransform(translationX: self.frame.width * 2, y: 0)
            case .left:
                self.transform = CGAffineTransform(translationX: -self.frame.width * 2, y: 0)
            case .none:
                self.transform = .identity
            }
        }) { (_) in

            switch direction {
            case .right:
                self.removeFromSuperview()
            case .left:
                self.transform = .identity
            case .none:
                self.transform = .identity
            }
            
        }
    }
    
}
