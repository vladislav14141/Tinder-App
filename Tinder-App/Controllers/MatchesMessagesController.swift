//
//  MatchesMessagesController.swift
//  Tinder-App
//
//  Created by Миронов Влад on 26.10.2019.
//  Copyright © 2019 Миронов Влад. All rights reserved.
//

import LBTATools
import Firebase

class MatchesMessagesController: LBTAListHeaderController<RecentMessageCell, UIColor, MatchesHeader>, UICollectionViewDelegateFlowLayout {
    let customNavBar = MatchesNavBar()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        items = [#colorLiteral(red: 1.0, green: 1.0, blue: 1.0, alpha: 1.0), #colorLiteral(red: 1.0, green: 1.0, blue: 1.0, alpha: 1.0), #colorLiteral(red: 1.0, green: 1.0, blue: 1.0, alpha: 1.0)]
        setupUI()
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
        return .init(width: view.frame.width, height: 250)
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
    
    private func fetchMatches(){
        guard let currentUserId = Auth.auth().currentUser?.uid else {return}
        Firestore.firestore().collection("matches_messages").document(currentUserId).collection("matches").getDocuments { (snapshot, err) in
            if let err = err{
                print("Failed to fetch matches", err)
                return
            }
            var matches = [Match]()
            snapshot?.documents.forEach({ (document) in
                matches.append(.init(dictionary: document.data()))
            })
//            self.items = matches
            self.collectionView.reloadData()
        }
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
