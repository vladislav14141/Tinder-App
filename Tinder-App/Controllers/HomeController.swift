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
//    fileprivate var topCardView: CardView?
    fileprivate let topStackView = TopNavigationStackView()
    fileprivate let cardsDeckView = UIView()
    fileprivate let bottomControls = HomeBottomControlStackView()
    fileprivate var isFireButtonPressed = false
    fileprivate let progressHUD = ProgressHUD()

    fileprivate var cardViewModels = [CardViewModel]()
    fileprivate var loginController = LoginController()
    
    fileprivate var visibledUserCards = [CardView]()
    fileprivate var user: User?
    fileprivate var swipesUsers = [String: Int]()
    fileprivate var users = [String: User]()

    
    override func viewDidLoad() {
        super.viewDidLoad()
        topStackView.settingButton.addTarget(self, action: #selector(handleSetting), for: .touchUpInside)
        topStackView.fireButton.addTarget(self, action: #selector(handleFireButton), for: .touchUpInside)
        topStackView.messaggeButton.addTarget(self, action: #selector(handleMessage), for: .touchUpInside)
        bottomControls.refreshButton.addTarget(self, action: #selector(handleRefresh), for: .touchUpInside)
        bottomControls.likeButton.addTarget(self, action: #selector(handleLike), for: .touchUpInside)
        bottomControls.dislikeButton.addTarget(self, action: #selector(handleDislike), for: .touchUpInside)
        let longGesture = UILongPressGestureRecognizer(target: self, action: #selector(handleDislike))
        longGesture.minimumPressDuration = 0.5
        bottomControls.dislikeButton.addGestureRecognizer(longGesture)
        navigationController?.navigationBar.isHidden = true
        setupLayout()
        
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        fetchCurrentUser()
    }
    
    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(true)
        loginController.presentLoginVC(in: self)
    }
    
    
    deinit {
        Log("HomeController was deinited")
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
    
    func didRemoveCard(cardView: CardView) {
        self.visibledUserCards.first?.removeFromSuperview()
    }
    
    func didTapMoreInfo(cardViewModel: CardViewModel) {
        let contr = UserDetailController()
        contr.cardViewModel = cardViewModel
        present(contr, animated: true)
        
    }
    
    // MARK: - Private Methods
    fileprivate func setupLayout() {
        let overallStackView = UIStackView(arrangedSubviews: [topStackView, cardsDeckView, bottomControls])
        overallStackView.axis = .vertical
        view.addSubview(overallStackView)
        overallStackView.anchor(top: view.safeAreaLayoutGuide.topAnchor, leading: view.leadingAnchor, bottom: view.safeAreaLayoutGuide.bottomAnchor, trailing: view.trailingAnchor)
        overallStackView.isLayoutMarginsRelativeArrangement = true
        overallStackView.layoutMargins = .init(top: 0, left: 12, bottom: 0, right: 12)
        
        overallStackView.bringSubviewToFront(cardsDeckView)
    }
    
    fileprivate func fetchUsersFromFirestore(){
        guard let minAge = user?.minSeekingAge, let maxAge = user?.maxSeekingAge else {
            progressHUD.textLabel.text = "Can't find users"
            progressHUD.detailTextLabel.text = "Change the search age"
            progressHUD.indicatorView = JGProgressHUDErrorIndicatorView()
            progressHUD.dismiss(afterDelay: 4)
            return
        }
        
        cardsDeckView.subviews.forEach({ $0.removeFromSuperview() })
        visibledUserCards.removeAll()
        
        progressHUD.showProgressHUD(in: self.view, with: "Получение пользователей")
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
                self.users[user.uid ?? ""] = user
                let hasNotSwipedBefore = self.swipesUsers[user.uid!] == nil
                let isNotCurrentUser = user.uid != Auth.auth().currentUser?.uid
                if  isNotCurrentUser && hasNotSwipedBefore{
                    let cardView = self.setupCardFromUser(user: user)
                    self.visibledUserCards.append(cardView)
                }
            })
        }
    }
    
    fileprivate func setupCardFromUser(user: User) -> CardView{
        let cardView = CardView(frame: .zero)
        cardView.delegate = self
        cardView.cardViewModel = user.toCardViewModel()
        cardsDeckView.addSubview(cardView)
        cardsDeckView.sendSubviewToBack(cardView)
        cardView.fillSuperview()
        return cardView
    }
    
    
    fileprivate func safeSwipeToFirestore(didLike: Int){
        guard let uid = Auth.auth().currentUser?.uid else {return}
        guard let firstCard = visibledUserCards.first else {return}
        
        let cardUID = firstCard.cardViewModel.UID

        let documentData = [cardUID: didLike]
        
        Firestore.firestore().collection("swipes").document(uid).getDocument { (snapshot, err) in
            if let err = err{
                self.progressHUD.showHUDWithMessage(in: self.view, error: err)
                return
            }
            
            if snapshot?.exists == true {
                Firestore.firestore().collection("swipes").document(uid).updateData(documentData) { (err) in
                    if let err = err{
                        self.progressHUD.showHUDWithMessage(in: self.view, error: err)
                        return
                    }
                    if didLike == 1 {self.checkIfMatchExists(cardUID: cardUID)}
                }
            } else {
                Firestore.firestore().collection("swipes").document(uid).setData(documentData) { (err) in
                    if let err = err{
                        self.progressHUD.showHUDWithMessage(in: self.view, error: err)
                        return
                    }
                    if didLike == 1 {self.checkIfMatchExists(cardUID: cardUID)}
                }
            }
            
        }
        
    }
    
    fileprivate func checkIfMatchExists(cardUID: String){
        Firestore.firestore().collection("swipes").document(cardUID).getDocument { (snapshot, err) in
            if let err = err{
                self.progressHUD.showHUDWithMessage(in: self.view, error: err)
                return
            }
            guard let data = snapshot?.data() else {return}
            guard let uid = Auth.auth().currentUser?.uid else {return}
            
            let hasMatched = data[uid] as? Int == 1
            guard hasMatched else {return}
            guard let users = self.users[cardUID] else {return}
            
            self.presentMatchView(cardUID: cardUID)
            let currentUserData: [String: Any] = ["name": users.name ?? "", "profileImage": users.imageUrl1 ?? "", "uid": cardUID, "timestamp": Timestamp(date: Date())]
            Firestore.firestore().collection("matches_messages").document(uid).collection("matches").document(cardUID).setData(currentUserData) { (err) in
                if let err = err{
                    Log("Failed to save match info \(err.localizedDescription)")
                }
            }
            
            guard let currentUser = self.user else {return}
            let matchData: [String: Any] = ["name": currentUser.name ?? "", "profileImage": currentUser.imageUrl1 ?? "", "uid": uid, "timestamp": Timestamp(date: Date())]
            Firestore.firestore().collection("matches_messages").document(cardUID).collection("matches").document(uid).setData(matchData) { (err) in
                if let err = err{
                    Log("Failed to save match info \(err.localizedDescription)")
                }
            }
        }
    }
    
    fileprivate func presentMatchView(cardUID: String){
        let matchView = MatchView()
        matchView.currentUser = user
        matchView.cardUID = cardUID
        view.addSubview(matchView)
        matchView.fillSuperview()
    }
    
    fileprivate func fetchSwipes(completion: @escaping ()->()){
        guard let uid = Auth.auth().currentUser?.uid else {return}
        Firestore.firestore().collection("swipes").document(uid).getDocument { (snapshot, err) in
            if let err = err{
                self.progressHUD.showHUDWithMessage(in: self.view, error: err)
                return
            }
            guard let data = snapshot?.data() as? [String: Int] else {return}
            self.swipesUsers = data
            print(self.swipesUsers)
        }
    }
    
    fileprivate func likeOrDislikeAnimation(isLikeAnimation: Bool = true) {
        guard let cardView = self.visibledUserCards.first else {return}

        let translationAnimation = CABasicAnimation(keyPath: "position.x")
        let positionX = isLikeAnimation ? self.view.frame.width : -self.view.frame.width
        translationAnimation.toValue = 1.5*positionX + self.view.frame.width / 2
        translationAnimation.duration = 0.5
        translationAnimation.fillMode = .forwards
        translationAnimation.isRemovedOnCompletion = false
        translationAnimation.timingFunction = CAMediaTimingFunction(name: .easeOut)
        
        let rotationAnimation = CABasicAnimation(keyPath: "transform.rotation.z")
        let angle = CGFloat.random(in: 10...30) * CGFloat.pi / 180
        rotationAnimation.toValue = isLikeAnimation ? angle : -angle
        rotationAnimation.duration = 0.3
        
        CATransaction.setCompletionBlock {
            cardView.removeFromSuperview()
        }
        
        cardView.layer.add(translationAnimation, forKey: "translation")
        cardView.layer.add(rotationAnimation, forKey: "rotation")
        CATransaction.commit()
        self.visibledUserCards.removeFirst()
    }
    
    private var timer: Timer?
    
    @objc func handleDislike(sender: UIGestureRecognizer?){
            if (sender != nil) && sender is UILongPressGestureRecognizer{
                switch sender?.state{
                case .began:
                    timer = Timer.scheduledTimer(withTimeInterval: 0.03, repeats: true, block: { (_) in
                        self.safeSwipeToFirestore(didLike: 0)
                        self.likeOrDislikeAnimation(isLikeAnimation: false)
                    })
                case .changed:
                    ()
                default:
                    timer?.invalidate()
                }
            } else {
                safeSwipeToFirestore(didLike: 0)
                likeOrDislikeAnimation(isLikeAnimation: false)
            }
        
    }
    @objc fileprivate func handleFireButton(sender: UIButton){
        isFireButtonPressed.toggle()
        if isFireButtonPressed{
            cardsDeckView.subviews.forEach({ $0.removeFromSuperview() })
            visibledUserCards.removeAll()
            fetchSwipes(completion: {
                self.fetchUsersFromFirestore()
            })
            sender.setImage(UIImage(named: "Tinder Single gray")?.withRenderingMode(.alwaysOriginal), for: .normal)
            
        } else {
            swipesUsers.removeAll()
            fetchUsersFromFirestore()
            sender.setImage(UIImage(named: "Tinder Single")?.withRenderingMode(.alwaysOriginal), for: .normal)
        }
    }
    
    @objc fileprivate func handleMessage(){
        let vc = MatchesMessagesController()
        navigationController?.pushViewController(vc, animated: true)
    }
    
    @objc func handleLike(){
        self.safeSwipeToFirestore(didLike: 1)
        self.likeOrDislikeAnimation()
    }
    
    @objc fileprivate func handleRefresh() {
            fetchUsersFromFirestore()
    }
    
    @objc fileprivate func handleSetting() {
        let settingsController = SettingsController()
        settingsController.delegate = self
        let navController = UINavigationController(rootViewController: settingsController)
        present(navController, animated: true)
    }
}

