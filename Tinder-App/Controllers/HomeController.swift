//
//  ViewController.swift
//  Tinder-App
//
//  Created by Миронов Влад on 06.10.2019.
//  Copyright © 2019 Миронов Влад. All rights reserved.
//

import UIKit
import Firebase
import JGProgressHUD
class HomeController: UIViewController, SettingsControllerDelegate, CardViewDelegate {

    fileprivate let topStackView = TopNavigationStackView()
    fileprivate let cardsDeckView = UIView()
    fileprivate let bottomControls = HomeBottomControlStackView()
    
    fileprivate let progressHUD = ProgressHUD()
    fileprivate var lastFetchedUser: User?
    fileprivate var cardViewModels = [CardViewModel]()
    fileprivate var loginController = LoginController()
    
    fileprivate var user: User?
    
    override func viewDidLoad() {
        super.viewDidLoad()
        topStackView.settingButton.addTarget(self, action: #selector(handleSetting), for: .touchUpInside)
        bottomControls.refreshButton.addTarget(self, action: #selector(handleRefresh), for: .touchUpInside)
        setupLayout()
    }
    
    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(true)
        fetchCurrentUser()
        loginController.presentLoginVC(in: self)
    }
    

    
    fileprivate func fetchCurrentUser(){
        guard let uid = Auth.auth().currentUser?.uid else {return}
        Firestore.firestore().collection("users").document(uid).getDocument { (snapshot, err) in
            if let err = err {
                self.progressHUD.showHUDWithMessage(in: self.view, error: err)
                return
            }
            
            guard let dictionary = snapshot?.data() else {return}
            let user = User(dictionary: dictionary)
            self.user = user
            self.fetchUsersFromFirestore()
        }
    }

    func didSaveSettings() {
        fetchCurrentUser()
        
    }
    
    fileprivate func fetchUsersFromFirestore(){
        progressHUD.showProgressHUD(in: self.view, with: "Fetching Users")
        guard let minAge = user?.minSeekingAge, let maxAge = user?.maxSeekingAge else {
            progressHUD.textLabel.text = "Can't find users"
            progressHUD.detailTextLabel.text = "Change the search age"
            progressHUD.indicatorView = JGProgressHUDErrorIndicatorView()
            progressHUD.dismiss(afterDelay: 4)
            return
        }
        let query = Firestore.firestore().collection("users").whereField("age", isGreaterThanOrEqualTo: minAge).whereField("age", isLessThanOrEqualTo: maxAge)
        query.getDocuments { (snapshot, err) in
            self.progressHUD.dismiss()
            if let err = err {
                self.progressHUD.showHUDWithMessage(in: self.view, error: err)
                return
            }
            
            snapshot?.documents.forEach({ (documentSnapshot) in
                let userDictionary = documentSnapshot.data()
                let user = User(dictionary: userDictionary)
                if user.uid != Auth.auth().currentUser?.uid {
                    self.setupCardFromUser(user: user)
                }
            })
        }
    }

    
    // MARK: - Private Methods
    fileprivate func setupCardFromUser(user: User) {
        let cardView = CardView(frame: .zero)
        cardView.delegate = self
        cardView.cardViewModel = user.toCardViewModel()
        cardsDeckView.addSubview(cardView)
        cardsDeckView.sendSubviewToBack(cardView)
        cardView.fillSuperview()
    }
    
    func didTapMoreInfo(cardViewModel: CardViewModel) {
        let contr = UserDetailController()
        contr.cardViewModel = cardViewModel
        present(contr, animated: true)
        
    }
    
    fileprivate func setupLayout() {
        let overallStackView = UIStackView(arrangedSubviews: [topStackView, cardsDeckView, bottomControls])
        overallStackView.axis = .vertical
        view.addSubview(overallStackView)
        overallStackView.anchor(top: view.safeAreaLayoutGuide.topAnchor, leading: view.leadingAnchor, bottom: view.safeAreaLayoutGuide.bottomAnchor, trailing: view.trailingAnchor)
        overallStackView.isLayoutMarginsRelativeArrangement = true
        overallStackView.layoutMargins = .init(top: 0, left: 12, bottom: 0, right: 12)
        
        overallStackView.bringSubviewToFront(cardsDeckView)
    }
    @objc fileprivate func handleRefresh() {
        fetchCurrentUser()
        
    }
    
    @objc fileprivate func handleSetting() {
        let settingsController = SettingsController()
        settingsController.delegate = self
        let navController = UINavigationController(rootViewController: settingsController)
        present(navController, animated: true)
    }
}

