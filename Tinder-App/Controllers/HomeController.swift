//
//  ViewController.swift
//  Tinder-App
//
//  Created by Миронов Влад on 06.10.2019.
//  Copyright © 2019 Миронов Влад. All rights reserved.
//

import UIKit

class HomeController: UIViewController {

    let topStackView = TopNavigationStackView()
    let cardsDeckView = UIView()
    let bottomStackView = HomeBottomControlStackView()
    
    let cardViewModels: [CardViewModel] = {
        let producers = [
            Advertiser(title: "Best game 2019", brandName: "Dota2", posterPhotoName: "dota2"),
            User(name: "Ирина", age: 43, profession: "Бухгалтер", imageNames: ["mother1", "mother2", "mother3"]),
            User(name: "Алексей", age: 42, profession: "Бизнесмен", imageNames: ["father1", "father2"]),
            Advertiser(title: "Best game 2019", brandName: "Dota2", posterPhotoName: "dota2"),
            User(name: "Юлия", age: 20, profession: "Студент", imageNames: ["julia1", "julia2", "julia3", "julia4", "julia5"]),
            User(name: "Владислав", age: 21, profession: "Студент", imageNames: ["vlad1", "vlad2", "vlad3"])
            ] as [ProducesCardViewModel]
        let viewModels = producers.map({return $0.toCardViewModel()})
        return viewModels
    }()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        topStackView.settingButton.addTarget(self, action: #selector(handleSetting), for: .touchUpInside)
        
        setupDummyCards()
        setupLayout()
    }

    @objc func handleSetting() {
        print("Show registration page")
        let registrationController = RegistrationViewController()
        present(registrationController, animated: true)
    }
    
    // MARK: - Private Methods
    fileprivate func setupDummyCards(){
        
        cardViewModels.forEach { (card) in
            let cardView = CardView(frame: .zero)
            
            cardView.cardViewModel = card            
            cardsDeckView.addSubview(cardView)
            cardView.fillSuperview()
        }
    }
    
    fileprivate func setupLayout() {
        let overallStackView = UIStackView(arrangedSubviews: [topStackView, cardsDeckView, bottomStackView])
        overallStackView.axis = .vertical
        view.addSubview(overallStackView)
        overallStackView.anchor(top: view.safeAreaLayoutGuide.topAnchor, leading: view.leadingAnchor, bottom: view.safeAreaLayoutGuide.bottomAnchor, trailing: view.trailingAnchor)
        overallStackView.isLayoutMarginsRelativeArrangement = true
        overallStackView.layoutMargins = .init(top: 0, left: 12, bottom: 0, right: 12)
        
        overallStackView.bringSubviewToFront(cardsDeckView)
    }
    
}

