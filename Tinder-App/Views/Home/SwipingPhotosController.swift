//
//  SwipingPhotosController.swift
//  Tinder-App
//
//  Created by Миронов Влад on 20.10.2019.
//  Copyright © 2019 Миронов Влад. All rights reserved.
//

import UIKit
import SDWebImage
class SwipingPhotosController: UIPageViewController, UIPageViewControllerDataSource, UIPageViewControllerDelegate {
    fileprivate let barsStackView = UIStackView(arrangedSubviews: [])
    fileprivate var controllers = [UIViewController]()
    fileprivate let deselectedBarColor = UIColor(white: 0, alpha: 0.2)
    var cardViewModel: CardViewModel!{
        didSet {
            controllers = cardViewModel.imageUrls.filter({$0 != ""}).map({ (imageUrl) -> UIViewController in
                let photoController = PhotoController(imageUrl: imageUrl)
                return photoController
            })
            setViewControllers([controllers.first!], direction: .forward, animated: true, completion: nil)
            setupBarViews()
        }
    }
    
    fileprivate var isCardViewModel: Bool
    fileprivate var paddingTop: CGFloat = 8
   

    
    init(isCardViewModel: Bool = false){
        self.isCardViewModel = isCardViewModel
        super.init(transitionStyle: .scroll, navigationOrientation: .horizontal)
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        dataSource = self
        delegate = self
        
        if !isCardViewModel{
            paddingTop += 8
        } else {
            disableSwipingAbility()
        }
        
        view.addGestureRecognizer((UITapGestureRecognizer(target: self, action: #selector(handleTap))))
    }
    
    @objc private func handleTap(gesture: UITapGestureRecognizer){
        let currentViewController = viewControllers!.first!
        if let index = controllers.firstIndex(of: currentViewController){
            barsStackView.arrangedSubviews.forEach({$0.backgroundColor = deselectedBarColor})
            if gesture.location(in: self.view).x > view.frame.width / 2 {
                let nextIndex = min(index + 1, controllers.count - 1)
                let nextController = controllers[nextIndex]
                setViewControllers([nextController], direction: .forward, animated: false)
                
                barsStackView.arrangedSubviews[nextIndex].backgroundColor = .white
            } else {
                let previusIndex = max(index - 1, 0)
                let nextController = controllers[previusIndex]
                setViewControllers([nextController], direction: .reverse, animated: false)
                
                barsStackView.arrangedSubviews[previusIndex].backgroundColor = .white
            }
        }
    }

    func pageViewController(_ pageViewController: UIPageViewController, viewControllerBefore viewController: UIViewController) -> UIViewController? {
        let index = self.controllers.firstIndex(where: {$0 == viewController}) ?? -1
        if index == 0 {return nil}
        return controllers[index - 1]


    }
    
    func pageViewController(_ pageViewController: UIPageViewController, viewControllerAfter viewController: UIViewController) -> UIViewController? {
        let index = self.controllers.firstIndex(where: {$0 == viewController}) ?? -1
        if index == controllers.count - 1 {return nil}
        return controllers[index + 1]
    }
    
    private func disableSwipingAbility(){
        view.subviews.forEach { (v) in
            if let v = v as? UIScrollView {
                v.isScrollEnabled = false
            }
        }
    }
    
    private func setupBarViews(){
        cardViewModel.imageUrls.filter({$0 != ""}).forEach { (_) in
            let barView = UIView()
            barView.backgroundColor = deselectedBarColor
            barView.layer.cornerRadius = 2
            barsStackView.addArrangedSubview(barView)
        }
        barsStackView.arrangedSubviews.first?.backgroundColor = .white
        barsStackView.spacing = 4
        barsStackView.distribution = .fillEqually
        view.addSubview(barsStackView)
//        let paddingTop = UIApplication.shared.statusBarFrame.height + 8
        barsStackView.anchor(top: view.topAnchor, leading: view.leadingAnchor, bottom: nil, trailing: view.trailingAnchor, padding: .init(top: paddingTop, left: 8, bottom: 0, right: 8),size: .init(width: 0, height: 4))
    }
    
    func pageViewController(_ pageViewController: UIPageViewController, didFinishAnimating finished: Bool, previousViewControllers: [UIViewController], transitionCompleted completed: Bool) {
        let currentPhotoController = viewControllers?.first
        if let index = controllers.firstIndex(where: {$0 == currentPhotoController}){
            barsStackView.arrangedSubviews.forEach({$0.backgroundColor = deselectedBarColor})
            barsStackView.arrangedSubviews[index].backgroundColor = .white
        }
        
    }
}

class PhotoController: UIViewController{
    let imageView = UIImageView()
    
    init(imageUrl: String) {
        if let url = URL(string: imageUrl){
            imageView.sd_setImage(with: url, placeholderImage: nil, options: .continueInBackground)
        }
        imageView.contentMode = .scaleAspectFill
        imageView.clipsToBounds = true
        super.init(nibName: nil, bundle: nil)
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        view.addSubview(imageView)
        imageView.fillSuperview()
        
    }
}
