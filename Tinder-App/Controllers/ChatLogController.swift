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
    // Отслеживает получение сообщения
    // MARK: - Public Properties
    var listener: ListenerRegistration?
    var currentUser: User?
    let match: Match
    
    lazy var customNavBar = MessageNavBar(match: self.match)
    lazy var customAccessView: CustomTextView = {
        let civ = CustomTextView(frame: .init(x: 0, y: 0, width: view.frame.width, height: 50))
        civ.sendButton.addTarget(self, action: #selector(handleSend), for: .touchUpInside)
        return civ
    }()
    
    // MARK: - Initializers
    init(match: Match){
        self.match = match
        super.init()
    }
        
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    // MARK: - Lifecycle
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
        fetchCurrentUser()
        setupUI()
        fetchMessages()
    }
    
    deinit {
        Log("ChatLogController was deinited")
    }
    
    
    override func viewWillDisappear(_ animated: Bool) {
        super.viewWillDisappear(animated)
        if isMovingFromParent{
            listener?.remove()
        }
    }
    
    //MARK:- Delegate Methods
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
    
    
    // MARK: - Private Methods
    fileprivate func fetchCurrentUser(){
        guard let uid = Auth.auth().currentUser?.uid else {return}
        Firestore.firestore().collection("users").document(uid).getDocument { (snapshot, err) in
            if let err = err{
                Log(err)
            }
            let data = snapshot?.data() ?? [:]
            self.currentUser = User(dictionary: data)
        }
    }
    
    fileprivate func fetchMessages(){
        guard let uid = Auth.auth().currentUser?.uid else {return}
        let query = Firestore.firestore().collection("matches_messages").document(uid).collection(match.uid).order(by: "timestamp")
        
        listener = query.addSnapshotListener { (snapshot, err) in
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
    
    fileprivate func saveToFromMessages(){
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
        
    fileprivate func saveToFromRecenetMessages(){
        guard let currentUserId = Auth.auth().currentUser?.uid else {return}
        let data: [String: Any] = ["uid":match.uid, "text": customAccessView.textView.text ?? "", "name": match.name, "profileImageUrl": match.profileImageUrl, "timestamp": Timestamp(date: Date())]
        Firestore.firestore().collection("matches_messages").document(currentUserId).collection("recent_messages").document(match.uid).setData(data) { (err) in
            
            if let err = err{
                Log(err)    
            }
        }
        
        guard let currentUser = self.currentUser else {return}
        let toData: [String: Any] = ["uid":currentUserId, "text": customAccessView.textView.text ?? "", "name": currentUser.name ?? "", "profileImageUrl": currentUser.imageUrl1 ?? "", "timestamp": Timestamp(date: Date())]
        Firestore.firestore().collection("matches_messages").document(match.uid).collection("recent_messages").document(currentUserId).setData(toData) { (err) in
             
             if let err = err{
                 Log(err)
             }
         }
    }
    
    //MARK: - Handlers
    @objc fileprivate func handleSend(){
        saveToFromMessages()
        saveToFromRecenetMessages()
    }
    
    @objc fileprivate func handleScrollToBottomItem(){
        self.collectionView.scrollToItem(at: [0, items.count - 1], at: .bottom, animated: true)
    }
    
    @objc fileprivate func handleBack(){
        navigationController?.popViewController(animated: true)
    }
}
