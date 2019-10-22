//
//  UserDetailController.swift
//  Tinder-App
//
//  Created by Миронов Влад on 18.10.2019.
//  Copyright © 2019 Миронов Влад. All rights reserved.
//

import UIKit
import SDWebImage
class UserDetailController: UIViewController, UIScrollViewDelegate {
    fileprivate var isFirstOpened = true
    fileprivate let swipingPhotosController = SwipingPhotosController(isCardViewModel: false)
    fileprivate let extraSwipingHeight: CGFloat = 80
    fileprivate let extraPostionY: CGFloat = 0
    
    var cardViewModel: CardViewModel! {
        didSet{
            infoLabel.attributedText = cardViewModel.attributedString
            swipingPhotosController.cardViewModel = cardViewModel
        }
    }
    
    lazy var scrollView: UIScrollView = {
        let sv = UIScrollView()
        sv.alwaysBounceVertical = true
        sv.contentInsetAdjustmentBehavior = .never
        sv.delegate = self
        return sv
    }()
    
    let infoLabel: UILabel = {
        let label = UILabel()
        label.text = "User name 30\n Doctor\nSome Bio text"
        label.numberOfLines = 0
        return label
    }()
    
    let dismissButton: UIButton = {
        let button = UIButton(type: .system)
        button.setImage(#imageLiteral(resourceName: "icons8-circled_up").withRenderingMode(.alwaysOriginal), for: .normal)
        button.addTarget(self, action: #selector(handleTapDismiss), for: .touchUpInside)
        return button
    }()
   
    lazy var dislikeButton = self.createButtons(image: #imageLiteral(resourceName: "Nope"), selector: #selector(handleDislike))
    lazy var superLikeButton = self.createButtons(image: #imageLiteral(resourceName: "Super Like"), selector: #selector(handleDislike))
    lazy var likeButton = self.createButtons(image: #imageLiteral(resourceName: "Like"), selector: #selector(handleDislike))
    
    override func viewDidLoad() {
        super.viewDidLoad()
        setupLayout()
        setupVisualBlurEffect()
        setupBottomControls()
    }
    
    override func viewDidLayoutSubviews() {
        super.viewDidLayoutSubviews()
        if isFirstOpened{
            let swipingPhoto = swipingPhotosController.view!
            swipingPhoto.frame = CGRect(x: 0, y: extraPostionY, width: view.frame.width, height: view.frame.width + extraSwipingHeight)
            isFirstOpened = false
        }
    }
    
    func scrollViewDidScroll(_ scrollView: UIScrollView) {
        let imageView = swipingPhotosController.view!
        let changeY = scrollView.contentOffset.y
        if changeY < 70 && changeY > -1{
            imageView.frame = CGRect(x: -changeY/2, y: -changeY/2 + extraPostionY, width: view.frame.width + changeY, height: view.frame.width + changeY + extraSwipingHeight)
        }
    }
    
    fileprivate func setupBottomControls(){
       let stackView = UIStackView(arrangedSubviews: [dislikeButton, superLikeButton, likeButton])
        stackView.distribution = .fillEqually
        stackView.spacing = 16
        view.addSubview(stackView)
        stackView.anchor(top: nil, leading: nil, bottom: view.safeAreaLayoutGuide.bottomAnchor, trailing: nil, padding: .init(top: 0, left: 0, bottom: 0, right: 0), size: .init(width: 270, height: 80))
        stackView.centerXAnchor.constraint(equalTo: view.centerXAnchor).isActive = true
    }
    
    fileprivate func createButtons(image: UIImage, selector: Selector) -> UIButton{
        let button = UIButton(type: .system)
        button.setImage(image.withRenderingMode(.alwaysOriginal), for: .normal)
        button.addTarget(self, action: selector, for: .touchUpInside)
        button.imageView?.contentMode = .scaleAspectFit
        return button
    }
    
    fileprivate func setupVisualBlurEffect(){
        let blurEffect = UIBlurEffect(style: .regular)
        let visualEffect = UIVisualEffectView(effect: blurEffect)
        view.addSubview(visualEffect)
        visualEffect.anchor(top: view.topAnchor, leading: view.leadingAnchor, bottom: view.safeAreaLayoutGuide.topAnchor, trailing: view.trailingAnchor, padding: .init(top: 0, left: 0, bottom: 0, right: 0))
    }
    
    fileprivate func setupLayout() {
        view.addSubview(scrollView)
        scrollView.fillSuperview()
        
        let swipingView = swipingPhotosController.view!
        scrollView.addSubview(swipingView)
        
        
        scrollView.addSubview(infoLabel)
        infoLabel.anchor(top: swipingView.bottomAnchor, leading: scrollView.leadingAnchor, bottom: nil, trailing: scrollView.trailingAnchor, padding: .init(top: 16, left: 16, bottom: 0, right: 16))
        view.backgroundColor = .white
        
        view.addSubview(dismissButton)
        dismissButton.anchor(top: swipingView.bottomAnchor, leading: nil, bottom: nil, trailing: view.trailingAnchor, padding: .init(top: -25, left: 0, bottom: 0, right: 23), size: .init(width: 50, height: 50))
    }



    
    @objc fileprivate func handleDislike() {
        print("Dislikeee")
    }
    
    @objc func handleTapDismiss(){
        self.dismiss(animated: true)
    }
}
