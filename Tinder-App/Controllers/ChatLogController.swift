//
//  ChatLogController.swift
//  Tinder-App
//
//  Created by Миронов Влад on 28.10.2019.
//  Copyright © 2019 Миронов Влад. All rights reserved.
//

import LBTATools
import Firebase

class ChatLogController: LBTAListController<MessageCell,Message>, UICollectionViewDelegateFlowLayout{
    let match: Match
    
    lazy var customNavBar = MessageNavBar(match: self.match)
    lazy var customAccessView: CustomTextView = {
        let civ = CustomTextView(frame: .init(x: 0, y: 0, width: view.frame.width, height: 50))
        civ.sendButton.addTarget(self, action: #selector(handleSend), for: .touchUpInside)
        return civ
    }()
    
    init(match: Match){
        self.match = match
        super.init()
    }
        
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    override var inputAccessoryView: UIView?{
        get{
            return customAccessView
        }
    }
    
    override var canBecomeFirstResponder: Bool{
        return true
    }

    
    override func viewDidLoad() {
        super.viewDidLoad()
        NotificationCenter.default.addObserver(self, selector: #selector(handleScrollToBottomItem), name: UIResponder.keyboardDidShowNotification, object: nil)
        setupUI()
        fetchMessages()
    }
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, insetForSectionAt section: Int) -> UIEdgeInsets {
        return .init(top: 16, left: 0, bottom: 16, right: 0)
    }
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
        let estimatedSizeCell = MessageCell(frame: .init(x: 0, y: 0, width: view.frame.width, height: 1000))
        estimatedSizeCell.item = self.items[indexPath.item]
        estimatedSizeCell.layoutIfNeeded()
        
        let estimatedSize = estimatedSizeCell.systemLayoutSizeFitting(.init(width: view.frame.width, height: 1000))
        return .init(width: view.frame.width, height: estimatedSize.height)
    }
    
    fileprivate func fetchMessages(){
        guard let uid = Auth.auth().currentUser?.uid else {return}
        let query = Firestore.firestore().collection("matches_messages").document(uid).collection(match.uid).order(by: "timestamp")
        
        query.addSnapshotListener { (snapshot, err) in
            
            if let err = err{
                Log(err)
            }
            
            snapshot?.documentChanges.forEach({ (change) in
                if change.type == .added{
                    self.items.append(.init(dictionary: change.document.data()))
                }
            })
            
            self.collectionView.reloadData()
            self.handleScrollToBottomItem()
        }
    }
    
    fileprivate func setupUI() {
        collectionView.alwaysBounceVertical = true
        view.addSubview(customNavBar)
        customNavBar.anchor(top: view.safeAreaLayoutGuide.topAnchor, leading: view.leadingAnchor, bottom: nil, trailing: view.trailingAnchor, size: .init(width: 0, height: 120))
        collectionView.backgroundColor = .black
        collectionView.verticalScrollIndicatorInsets.top = 120
        collectionView.contentInset.top = 120
        collectionView.keyboardDismissMode = .interactive
        customNavBar.backButton.addTarget(self, action: #selector(handleBack), for: .touchUpInside)
        
        let statusBarCover = UIView(backgroundColor: .black)
        view.addSubview(statusBarCover)
        statusBarCover.anchor(top: view.topAnchor, leading: view.leadingAnchor, bottom: view.safeAreaLayoutGuide.topAnchor, trailing: view.trailingAnchor)
    }
    
    @objc fileprivate func handleSend(){
        guard let currentUserId = Auth.auth().currentUser?.uid else {return}
        let CurrentUserCollection = Firestore.firestore().collection("matches_messages").document(currentUserId).collection(match.uid)
        let data: [String: Any] = ["text": customAccessView.textView.text ?? "", "fromId": currentUserId, "toId": match.uid, "timestamp": Timestamp(date: Date())]
        
        CurrentUserCollection.addDocument(data: data) { (err) in
            if let err = err{
                Log(err)
            }
            
            self.customAccessView.textView.text = nil
            self.customAccessView.placeholderLabel.isHidden = false
        }
        
        let matchUserCollection = Firestore.firestore().collection("matches_messages").document(match.uid).collection(currentUserId)
        matchUserCollection.addDocument(data: data) { (err) in
            if let err = err{
                Log(err)
            }
        }
    }
    
    @objc fileprivate func handleScrollToBottomItem(){
        self.collectionView.scrollToItem(at: [0, items.count - 1], at: .bottom, animated: true)
    }
    
    @objc fileprivate func handleBack(){
        navigationController?.popViewController(animated: true)
    }
}
