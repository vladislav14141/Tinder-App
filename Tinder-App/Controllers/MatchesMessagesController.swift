//
//  MatchesMessagesController.swift
//  Tinder-App
//
//  Created by Миронов Влад on 26.10.2019.
//  Copyright © 2019 Миронов Влад. All rights reserved.
//

import LBTATools
import Firebase

class MatchesMessagesController: LBTAListHeaderController<RecentMessageCell, RecentMessage, MatchesHeader>, UICollectionViewDelegateFlowLayout {
    let customNavBar = MatchesNavBar()
    var listener: ListenerRegistration?
    var recentMessagesDictionary = [String: RecentMessage]()

    override func viewDidLoad() {
        super.viewDidLoad()
        fetchRecentMessages()
        items = []
        setupUI()
    }
    
    override func viewDidDisappear(_ animated: Bool) {
        super.viewDidDisappear(animated)
        if isMovingFromParent{
            listener?.remove()
        }
    }
    
    deinit {
        Log("Matches controller was deinited")
    }

    override func setupHeader(_ header: MatchesHeader){
        header.horizontalViewController.rootMatchesController = self
    }
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, minimumLineSpacingForSectionAt section: Int) -> CGFloat {
        return 0
    }
    func didSelectMatchFromHeader(match: Match) {
        let chatLogin = ChatLogController(match: match)
        navigationController?.pushViewController(chatLogin, animated: true)
    }
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, referenceSizeForHeaderInSection section: Int) -> CGSize {
        return .init(width: view.frame.width, height: 230)
    }
    
    private func setupUI(){
        collectionView.backgroundView?.backgroundColor = .black
        collectionView.backgroundColor  = .black
        collectionView.contentInset.top = 150
        collectionView.verticalScrollIndicatorInsets.top = 150
        
        customNavBar.backButton.addTarget(self, action: #selector(handleBack), for: .touchUpInside)
        view.addSubview(customNavBar)
        
        customNavBar.anchor(top: view.safeAreaLayoutGuide.topAnchor, leading: view.leadingAnchor, bottom: nil, trailing: view.trailingAnchor,padding: .init(top: 0, left: 0, bottom: 0, right: 0), size: .init(width: 0, height: 150))
        
        let statusBarCover = UIView(backgroundColor: .black)
        view.addSubview(statusBarCover)
        statusBarCover.anchor(top: view.topAnchor, leading: view.leadingAnchor, bottom: view.safeAreaLayoutGuide.topAnchor, trailing: view.trailingAnchor)
    }
    
    private func fetchRecentMessages(){
        guard let currentUserId = Auth.auth().currentUser?.uid else {return}
        let query = Firestore.firestore().collection("matches_messages").document(currentUserId).collection("recent_messages")
        
        listener = query.addSnapshotListener { (snapshot, err) in
            snapshot?.documentChanges.forEach({ (change) in
                if change.type == .added || change.type == .modified{
                    let dictionary = change.document.data()
                    let recentMessages = RecentMessage(dictionary: dictionary)
                    self.recentMessagesDictionary[recentMessages.uid] = recentMessages
                }
            })
            self.resetItems()
        }
    }
    
    private func resetItems(){
        let values = Array(recentMessagesDictionary.values)
        items = values.sorted(by: { (rm1, rm2) -> Bool in
            return rm1.timestamp.compare(rm2.timestamp) == .orderedDescending
        })
        collectionView.reloadData()
    }

    override func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        let recentMessage = self.items[indexPath.item]
        let match = Match(name: recentMessage.name, profileImage: recentMessage.profileImageUrl, uid: recentMessage.uid)
        let chatLogVC = ChatLogController(match: match)
        navigationController?.pushViewController(chatLogVC, animated: true)
    }
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
        return .init(width: view.frame.width, height: 120)
    }
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, insetForSectionAt section: Int) -> UIEdgeInsets {
        return .init(top: 0, left: 0, bottom: 16, right: 0)
    }
    
    @objc fileprivate func handleBack(){
        navigationController?.popViewController(animated: true)
    }
    
}
