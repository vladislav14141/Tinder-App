//
//  MatchesHorizontalController.swift
//  Tinder-App
//
//  Created by Миронов Влад on 30.10.2019.
//  Copyright © 2019 Миронов Влад. All rights reserved.
//

import LBTATools
import Firebase
class MatchesHorizontalController: LBTAListController<MatchCell, Match>,UICollectionViewDelegateFlowLayout{
    var rootMatchesController: MatchesMessagesController?
    
    override func viewDidLoad() {
        super.viewDidLoad()
        collectionView.backgroundColor = .black
        if let layout = collectionViewLayout as? UICollectionViewFlowLayout{
            layout.scrollDirection = .horizontal
        }
        fetchMatches()
        
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
            self.items = matches
            self.collectionView.reloadData()
        }
    }
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, insetForSectionAt section: Int) -> UIEdgeInsets {
        return .init(top: 0, left: 4, bottom: 0, right: 4)
    }
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
        return .init(width: 100, height: view.frame.height)
    }
    
    override func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        let match = items[indexPath.item]
        rootMatchesController?.didSelectMatchFromHeader(match: match)
    }
}
