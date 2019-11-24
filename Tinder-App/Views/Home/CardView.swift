//
//  CardView.swift
//  Tinder-App
//
//  Created by Миронов Влад on 07.10.2019.
//  Copyright © 2019 Миронов Влад. All rights reserved.
//

import UIKit
import SDWebImage
enum SwipeDirection {
    case right
    case left
    case none
}

protocol CardViewDelegate {
    func didTapMoreInfo(cardViewModel: CardViewModel)
    func didRemoveCard(cardView: CardView)
}
class CardView: UIView {
    let progressHUD = ProgressHUD()
    var delegate: CardViewDelegate?
//    var nextCardView: CardView?
    fileprivate let swipingPhotosController = SwipingPhotosController(isCardViewModel: true)
    fileprivate let infoLabel = UILabel()
    fileprivate let gradientLayer = CAGradientLayer()
    fileprivate var deselectedBarColor = UIColor(white: 0.2, alpha: 0.4)
    fileprivate let nopeHeader = UIImageView(image: #imageLiteral(resourceName: "Nope-1"))
    fileprivate let likeHeader = UIImageView(image: #imageLiteral(resourceName: "Like-1"), contentMode: .scaleAspectFit)
    
    
    var cardViewModel: CardViewModel! {
        didSet {
            swipingPhotosController.cardViewModel = self.cardViewModel
            
            infoLabel.attributedText = cardViewModel.attributedString
            infoLabel.textAlignment = cardViewModel.textAlignment
            
            (0..<cardViewModel.imageUrls.count).forEach { (_) in
                 let barView = UIView()
                 barView.backgroundColor = deselectedBarColor
                 barsStackView.addArrangedSubview(barView)
             }
             barsStackView.arrangedSubviews.first?.backgroundColor = .white
            
            setupImageIndexObserver()
        }
    }
    
    fileprivate let infoButton: UIButton = {
        let bt = UIButton(type: .system)
        bt.setImage(UIImage(named: "icons8-info_filled")?.withRenderingMode(.alwaysOriginal), for: .normal)
        bt.addTarget(self, action: #selector(handleMoreInfo), for: .touchUpInside)

        return bt
    }()
    
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
        gradientLayer.frame = self.frame
    }
    

    
    fileprivate func setupLayout() {
        // custom drawing code
        layer.cornerRadius = 10
        clipsToBounds = true
        
        let swipingPhotosView = swipingPhotosController.view!
        addSubview(swipingPhotosView)
        swipingPhotosView.fillSuperview()
                
        // add gradient
        setupGradient()
        
        //  add label
        addSubview(infoLabel)
        infoLabel.anchor(top: nil, leading: self.leadingAnchor, bottom: self.bottomAnchor, trailing: trailingAnchor, padding: .init(top: 0, left: 16, bottom: 16, right: 16))
        infoLabel.textColor = .white
        infoLabel.numberOfLines = 0
        
        addSubview(likeHeader)
        addSubview(nopeHeader)
        likeHeader.alpha = 0
        nopeHeader.alpha = 0
        likeHeader.anchor(top: self.topAnchor, leading: nil, bottom: nil, trailing: self.trailingAnchor, padding: .init(top: 70, left: 0, bottom: 0, right: 20), size: .init(width: 171, height: 112))
        nopeHeader.anchor(top: self.topAnchor, leading: self.leadingAnchor, bottom: nil, trailing: nil, padding: .init(top: 70, left: 20, bottom: 0, right: 0), size: .init(width: 171, height: 112))
        
        addSubview(infoButton)
        infoButton.anchor(top: nil, leading: nil, bottom: self.bottomAnchor, trailing: self.trailingAnchor, padding: .init(top: 0, left: 0, bottom: 16, right: 16), size: .init(width: 44, height: 44))
        
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
        cardViewModel.imageIndexObserver = { [unowned self] (imageUrl, i) in
            self.backgroundColor = .black
            self.barsStackView.arrangedSubviews.forEach { (view) in
                view.backgroundColor = self.deselectedBarColor
            }
            self.barsStackView.arrangedSubviews[i].backgroundColor = .white
        }
    }
    
    @objc fileprivate func handleMoreInfo(){
        delegate?.didTapMoreInfo(cardViewModel: self.cardViewModel)
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
        let alpha = abs(translation.x) / 50
        print(alpha)
        // Convert radians to degree
        let degrees: CGFloat = translation.x / 20
        let angle = degrees * .pi / 180
        if translation.x > 0{
            self.likeHeader.alpha = alpha
            self.nopeHeader.alpha = 0
        } else {
            self.nopeHeader.alpha = alpha
            self.likeHeader.alpha = 0

        }
        
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
        
        guard let homeController = self.delegate as? HomeController else {return}
        switch direction {
        case .right:
            homeController.handleLike()
        case .left:
            homeController.handleDislike(sender: nil)
            print(" ")
        case .none:
            self.transform = .identity
            self.nopeHeader.alpha = 0
            self.likeHeader.alpha = 0
        }
//        UIView.animate(withDuration: 0.75, delay: 0, usingSpringWithDamping: 0.6, initialSpringVelocity: 0.1, options: .curveEaseOut, animations: {
//
//            switch direction {
//            case .right:
//                self.transform = CGAffineTransform(translationX: self.frame.width * 2, y: 0)
//            case .left:
//                self.transform = CGAffineTransform(translationX: -self.frame.width * 2, y: 0)
//            case .none:
//                self.transform = .identity
//            }
//        }) { (_) in
//
//            switch direction {
//            case .right:
//                self.delegate?.didRemoveCard(cardView: self)
//            case .left:
//                self.transform = .identity
//            case .none:
//                self.transform = .identity
//            }
//
//        }
    }
    
}
