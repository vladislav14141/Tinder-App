//
//  MatchView.swift
//  Tinder-App
//
//  Created by Миронов Влад on 24.10.2019.
//  Copyright © 2019 Миронов Влад. All rights reserved.
//

import UIKit
import Firebase
class MatchView: UIView {
    let visualEffect = UIVisualEffectView(effect: UIBlurEffect(style: .dark))
    
    lazy var views = [
    currentUserImageView,
    cardUserImageView,
    itsMatchImageView,
    decriptionLabel,
    keepSwipingButton,
    sendMessageButton
    ]
    
    var currentUser: User?{
        didSet {
           
        }
    }
    
    var cardUID: String? {
        didSet{
            let query = Firestore.firestore().collection("users")
            query.document(cardUID!).getDocument { (snapshot, err) in
                if let err = err {
                    print("Failed to fetch card user", err)
                    return
                }
                
                guard let dictionary = snapshot?.data() else {return}
                let user = User(dictionary: dictionary)
                if let name = user.name {self.decriptionLabel.text = "You and \(name) have liked\neach other"}
                

                
                guard let url = URL(string: user.imageUrl1 ?? "") else {return}
                self.cardUserImageView.sd_setImage(with: url)
                
                guard let currentImageUrl = URL(string: self.currentUser?.imageUrl1 ?? "") else {return}
                self.currentUserImageView.sd_setImage(with: currentImageUrl) { (_, _, _, _) in
                    self.views.forEach({$0.alpha = 1})
                    self.setupAnimations()
                }
            }
        }
    }
    fileprivate let itsMatchImageView: UIImageView = {
        let iv = UIImageView(image: #imageLiteral(resourceName: "itsamatch"))
        iv.contentMode = .scaleAspectFill
        return iv
    }()
    
    fileprivate let decriptionLabel: UILabel = {
        let label = UILabel()
        label.text = "You and X have liked\neach other"
        label.textAlignment = .center
        label.textColor = .white
        label.font = UIFont.systemFont(ofSize: 21)
        label.numberOfLines = 0
        return label
    }()
    
    fileprivate let currentUserImageView: UIImageView = {
        let iv = UIImageView(image: nil)
        iv.contentMode = .scaleAspectFill
        iv.layer.cornerRadius = 140 / 2
        iv.layer.borderWidth = 2
        iv.layer.borderColor = UIColor.white.cgColor
        iv.clipsToBounds = true
        return iv
    }()
    
    fileprivate let cardUserImageView: UIImageView = {
        let iv = UIImageView(image: nil)
        iv.contentMode = .scaleAspectFill
        iv.layer.cornerRadius = 140 / 2
        iv.layer.borderWidth = 2
        iv.layer.borderColor = UIColor.white.cgColor
        iv.clipsToBounds = true
        iv.alpha = 0
        return iv
    }()
    
    fileprivate let sendMessageButton: UIButton = {
        let but = SendMessageButton(type: .system)
        but.setTitle("SEND MESSAGE", for: .normal)
        but.setTitleColor(.white, for: .normal)
        but.titleLabel?.font = UIFont.systemFont(ofSize: 16, weight: .heavy)
        return but
    }()
    
    fileprivate let keepSwipingButton: UIButton = {
        let but = KeepSwipingButton(type: .system)
        but.setTitle("Keep Swiping", for: .normal)
        but.setTitleColor(.white, for: .normal)
        but.titleLabel?.font = UIFont.systemFont(ofSize: 16, weight: .semibold)
        return but
    }()
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        setupVisualBlurEffect()
        setupLayout()
    }
    
    
    
    
    fileprivate func setupAnimations(){

        
        let angle = 50 * CGFloat.pi / 180
        currentUserImageView.transform = CGAffineTransform(rotationAngle: -angle).concatenating(CGAffineTransform(translationX: 200, y: 0))
        cardUserImageView.transform = CGAffineTransform(rotationAngle: angle).concatenating(CGAffineTransform(translationX: -200, y: 0))

        sendMessageButton.transform = CGAffineTransform(translationX: -500, y: 0)
        keepSwipingButton.transform = CGAffineTransform(translationX: 500, y: 0)

        UIView.animateKeyframes(withDuration: 1.2, delay: 0, options: .calculationModeCubic, animations: {
            
            UIView.addKeyframe(withRelativeStartTime: 0, relativeDuration: 0.45) {
                self.currentUserImageView.transform = CGAffineTransform(rotationAngle: -angle)
                self.cardUserImageView.transform = CGAffineTransform(rotationAngle: angle)

            }
            
            UIView.addKeyframe(withRelativeStartTime: 0.6, relativeDuration: 0.4) {
                self.currentUserImageView.transform = .identity
                self.cardUserImageView.transform = .identity
                self.sendMessageButton.transform = .identity
                self.keepSwipingButton.transform = .identity
            }
            

        }) { (_) in
            
        }
    }
    
    fileprivate func setupLayout(){
        views.forEach { (v) in
            addSubview(v)
            v.alpha = 0
        }
        
        let imageWidth: CGFloat = 140
        
        itsMatchImageView.anchor(top: nil, leading: nil, bottom: decriptionLabel.topAnchor, trailing: nil,
                                 padding: .init(top: 0, left: 0, bottom: 16, right: 0),
                                 size: .init(width: 300, height: 80))
        itsMatchImageView.centerXAnchor.constraint(equalTo: self.centerXAnchor).isActive = true

        decriptionLabel.anchor(top: nil, leading: self.leadingAnchor, bottom: currentUserImageView.topAnchor,
                               trailing:  self.trailingAnchor,
                               padding: .init(top: 0, left: 0, bottom: 30, right: 0),
                               size: .init(width: 0, height: 55))

        currentUserImageView.anchor(top: nil, leading: nil, bottom: nil, trailing: centerXAnchor,
                                    padding: .init(top: 0, left: 0, bottom: 0, right: 16),
                                    size: .init(width: imageWidth, height: imageWidth))
        currentUserImageView.centerYAnchor.constraint(equalTo: self.centerYAnchor).isActive = true

        cardUserImageView.anchor(top: nil, leading: centerXAnchor, bottom: nil, trailing: nil,
                                 padding: .init(top: 0, left: 0, bottom: 0, right: 16),
                                 size: .init(width: imageWidth, height: imageWidth))
        cardUserImageView.centerYAnchor.constraint(equalTo: self.centerYAnchor).isActive = true
        
        sendMessageButton.anchor(top: currentUserImageView.bottomAnchor, leading: leadingAnchor, bottom: nil, trailing: trailingAnchor, padding: .init(top: 25, left: 48, bottom: 0, right: 48), size: .init(width: 0, height: 60))
        
        keepSwipingButton.anchor(top: sendMessageButton.bottomAnchor, leading: leadingAnchor, bottom: nil, trailing: trailingAnchor, padding: .init(top: 16, left: 48, bottom: 0, right: 48), size: .init(width: 0, height: 60))
        
    }
    
    fileprivate func setupVisualBlurEffect(){
        
        self.alpha = 0
        visualEffect.addGestureRecognizer(UITapGestureRecognizer(target: self, action: #selector(handleTapDismiss)))
        addSubview(visualEffect)
        visualEffect.fillSuperview()
        UIView.animate(withDuration: 0.8, delay: 0, usingSpringWithDamping: 1, initialSpringVelocity: 1, options: .curveEaseOut, animations: {
            self.alpha = 1
        }) { (_) in
            
        }
        
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    @objc private func handleTapDismiss(){
        
        UIView.animate(withDuration: 0.8, delay: 0, usingSpringWithDamping: 1, initialSpringVelocity: 1, options: .curveEaseOut, animations: {
            self.alpha = 0
        }) { (_) in
            self.removeFromSuperview()
        }
    }
    
}
