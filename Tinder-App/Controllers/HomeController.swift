//
//  ViewController.swift
//  Tinder-App
//
//  Created by Миронов Влад on 06.10.2019.
//  Copyright © 2019 Миронов Влад. All rights reserved.
//

import UIKit
import Firebase
class HomeController: UIViewController {

    let topStackView = TopNavigationStackView()
    let cardsDeckView = UIView()
    let bottomControls = HomeBottomControlStackView()
    
    let progressHUD = ProgressHUD()
    var lastFetchedUser: User?
    var cardViewModels = [CardViewModel]()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        topStackView.settingButton.addTarget(self, action: #selector(handleSetting), for: .touchUpInside)
        bottomControls.refreshButton.addTarget(self, action: #selector(handleRefresh), for: .touchUpInside)

        setupLayout()
        fetchUsersFromFirestore()
    }

    private func fetchUsersFromFirestore(){
        let query = Firestore.firestore().collection("users").order(by: "uid").start(after: [lastFetchedUser?.uid ?? ""]).limit(to: 2)
        progressHUD.showProgressHUD(in: self.view, with: "Fetching Users")
        query.getDocuments { (snapshot, err) in
            self.progressHUD.dismiss()
            if let err = err {
                self.progressHUD.showHUDWithMessage(in: self.view, error: err)
                return
            }
            
            snapshot?.documents.forEach({ (documentSnapshot) in
                let userDictionary = documentSnapshot.data()
                let user = User(dictionary: userDictionary)
                self.cardViewModels.append(user.toCardViewModel())
                self.lastFetchedUser = user
                print(userDictionary)
                self.setupCardFromUser(user: user)
            })
        }
    }

    
    // MARK: - Private Methods
    fileprivate func setupCardFromUser(user: User) {
        let cardView = CardView(frame: .zero)
        cardView.cardViewModel = user.toCardViewModel()
        cardsDeckView.addSubview(cardView)
        cardsDeckView.sendSubviewToBack(cardView)
        cardView.fillSuperview()
    }
    

    
    fileprivate func setupLayout() {
        self.view.backgroundColor = .white
        let overallStackView = UIStackView(arrangedSubviews: [topStackView, cardsDeckView, bottomControls])
        overallStackView.axis = .vertical
        view.addSubview(overallStackView)
        overallStackView.anchor(top: view.safeAreaLayoutGuide.topAnchor, leading: view.leadingAnchor, bottom: view.safeAreaLayoutGuide.bottomAnchor, trailing: view.trailingAnchor)
        overallStackView.isLayoutMarginsRelativeArrangement = true
        overallStackView.layoutMargins = .init(top: 0, left: 12, bottom: 0, right: 12)
        
        overallStackView.bringSubviewToFront(cardsDeckView)
    }
    @objc fileprivate func handleRefresh() {
        fetchUsersFromFirestore()
    }
    
    @objc fileprivate func handleSetting() {
        let settingsController = SettingsController()
        let navController = UINavigationController(rootViewController: settingsController)
        present(navController, animated: true)
    }
}

