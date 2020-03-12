//
//  TranslationViewController.swift
//  MultiTranslate
//
//  Created by Keishin CHOU on 2020/01/06.
//  Copyright © 2020 Keishin CHOU. All rights reserved.
//

import UIKit

import Parchment
import paper_onboarding


class TranslationViewController: UIViewController {
    
    fileprivate let icons = [
        "text",
        "camera",
        "microphone",
        "conversation",
        "AR",
        "doc",
        "image",
    ]
    
    private let pageViewController: PagingViewController<IconItem> = {
        let controller = PagingViewController<IconItem>()
        controller.menuItemSource = .class(type: IconPagingCell.self)
        controller.menuItemSize = .fixed(width: 70, height: 70)
        controller.textColor = UIColor(red: 0.51, green: 0.54, blue: 0.56, alpha: 1)
        controller.selectedTextColor = UIColor(red: 0.14, green: 0.77, blue: 0.85, alpha: 1)
        controller.indicatorColor = UIColor(red: 0.14, green: 0.77, blue: 0.85, alpha: 1)
        controller.menuBackgroundColor = UIColor.mtSystemBackground
        controller.borderColor = .white
        return controller
    }()
    
    
    
    private lazy var textTranslateViewController = { () -> TextTranslateViewController in
        let viewController = TextTranslateViewController()
        return viewController
    }()
    
    private lazy var cameraTranslateViewController = { () -> CameraTranslateViewController in
        let viewController = CameraTranslateViewController()
        return viewController
    }()
    
    private lazy var voiceTranslateViewController = { () -> VoiceTranslateViewController in
        let viewController = VoiceTranslateViewController()
        return viewController
    }()
    
    
    private lazy var conversationTranslateViewController = { () -> ConversationTranslateViewController in
        let viewController = ConversationTranslateViewController()
        return viewController
    }()
    
    private lazy var arTranslateViewController = { () -> ARTranslateViewController in
        let viewController = ARTranslateViewController()
        return viewController
    }()
    
    private lazy var pdfTranslateViewController = { () -> PDFTranslateViewController in
        let viewController = PDFTranslateViewController()
        return viewController
    }()
    
    private lazy var imageTranslateViewController = { () -> ImageTranslateViewController in
        let viewController = ImageTranslateViewController()
        return viewController
    }()
    
    var translationViewControllers = [UIViewController]()
    
    private let onboardPage: PaperOnboarding = {
        let view = PaperOnboarding()
        view.translatesAutoresizingMaskIntoConstraints = false
        return view
    }()
    
    private let skipButton: UIButton = {
        let button = UIButton()
        button.translatesAutoresizingMaskIntoConstraints = false
        button.setTitle("skip", for: .normal)
        button.titleLabel?.font = UIFont.systemFont(ofSize: 14, weight: .thin)
        button.setTitleColor(UIColor.systemGray.adjustedAlpha(amount: 0.9), for: .normal)
        return button
    }()
    
    private let onboardItems = [
        OnboardingItemInfo(informationImage: UIImage(systemName: "camera")!,
                           title: "title",
                           description: "description",
                           pageIcon: UIImage(systemName: "camera")!,
                           color: UIColor.systemPurple,
                           titleColor: UIColor.label,
                           descriptionColor: UIColor.label,
                           titleFont: UIFont.preferredFont(forTextStyle: .title1),
                           descriptionFont: UIFont.preferredFont(forTextStyle: .body)),

        OnboardingItemInfo(informationImage: UIImage(systemName: "mic")!,
                           title: "title",
                           description: "description",
                           pageIcon: UIImage(systemName: "mic")!,
                           color: UIColor.systemTeal,
                           titleColor: UIColor.label,
                           descriptionColor: UIColor.label,
                           titleFont: UIFont.preferredFont(forTextStyle: .title1),
                           descriptionFont: UIFont.preferredFont(forTextStyle: .body)),

        OnboardingItemInfo(informationImage: UIImage(systemName: "photo")!,
                           title: "title",
                           description: "description",
                           pageIcon: UIImage(systemName: "photo")!,
                           color: UIColor.systemOrange,
                           titleColor: UIColor.label,
                           descriptionColor: UIColor.label,
                           titleFont: UIFont.preferredFont(forTextStyle: .title1),
                           descriptionFont: UIFont.preferredFont(forTextStyle: .body)),
    ]
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        pageViewController.dataSource = self
        pageViewController.select(pagingItem: IconItem(icon: icons[0], index: 0))
        onboardPage.dataSource = self
        
        // Do any additional setup after loading the view.
        translationViewControllers = [
            textTranslateViewController,
            cameraTranslateViewController,
            voiceTranslateViewController,
            conversationTranslateViewController,
            arTranslateViewController,
            pdfTranslateViewController,
            imageTranslateViewController
        ]
        
        NotificationCenter.default.addObserver(forName: .translationViewControllerDidChange,
                                               object: nil,
                                               queue: .main) { [weak self] (notification) in
            if let titleInfo = notification.userInfo as? [String : String] {
                for (_, newTitleName) in titleInfo {
                    self?.title = newTitleName
                }
            }
        }
        
        skipButton.addTarget(self, action: #selector(skipOnboard), for: .touchUpInside)
        navigationItem.rightBarButtonItem = UIBarButtonItem(image: UIImage(systemName: "tray.and.arrow.down"),
                                                            style: .plain,
                                                            target: self,
                                                            action: #selector(showDownloadLanguageModelPage))
        
        let isAppEverLaunched = UserDefaults.standard.bool(forKey: Constants.isAppEverLauchedKey)
        if isAppEverLaunched {
            addChild(pageViewController)
            view.addSubview(pageViewController.view)
            view.constrainToEdges(pageViewController.view)
            view.backgroundColor = .mtSystemBackground
            pageViewController.didMove(toParent: self)
            
        } else {
            UserDefaults.standard.set(true, forKey: Constants.isAppEverLauchedKey)
            view.addSubview(onboardPage)
            onboardPage.edgeTo(view)
            
            view.addSubview(skipButton)
            skipButton.leadingAnchor.constraint(equalTo: view.leadingAnchor, constant: 35).isActive = true
            skipButton.bottomAnchor.constraint(equalTo: view.bottomAnchor, constant: -100).isActive = true
            
            navigationController?.navigationBar.isHidden = true
            tabBarController?.tabBar.isHidden = true
        }
        
    }
    
    @objc func showDownloadLanguageModelPage() {
        let isFBDownloadLanguangePageShown = UserDefaults.standard.bool(forKey: Constants.isFBDownloadLanguangePageShownKey)
        
        if isFBDownloadLanguangePageShown {
            let viewController = FBLanguageTableViewController()
            let navController = UINavigationController(rootViewController: viewController)
            navController.modalPresentationStyle = .pageSheet
            present(navController, animated: true, completion: nil)
        } else {
            print("this is the first time download page shown.")
            let alert = PMAlertController(title: "Download offline language",
                                          description: "Download offline language fast and save your ...",
                                          image: UIImage(named: "download"),
                                          style: .alert)
            let defaultAction = PMAlertAction(title: "Got it", style: .default) { [weak self] in
                let viewController = FBLanguageTableViewController()
                let navController = UINavigationController(rootViewController: viewController)
                navController.modalPresentationStyle = .pageSheet
                self?.present(navController, animated: true, completion: nil)
            }
            alert.addAction(defaultAction)
            present(alert, animated: true) {
                UserDefaults.standard.set(true, forKey: Constants.isFBDownloadLanguangePageShownKey)
            }
        }
    }
    
    @objc func skipOnboard() {
        onboardPage.removeFromSuperview()
        skipButton.removeFromSuperview()
        
        addChild(pageViewController)
        view.addSubview(pageViewController.view)
        view.constrainToEdges(pageViewController.view)
        view.backgroundColor = .mtSystemBackground
        pageViewController.didMove(toParent: self)
        
        navigationController?.navigationBar.isHidden = false
        tabBarController?.tabBar.isHidden = false
    }
}

extension TranslationViewController: PagingViewControllerDataSource {
    func pagingViewController<T>(_ pagingViewController: PagingViewController<T>, viewControllerForIndex index: Int) -> UIViewController {
        return translationViewControllers[index]
    }
    
    func pagingViewController<T>(_ pagingViewController: PagingViewController<T>, pagingItemForIndex index: Int) -> T {
        return IconItem(icon: icons[index], index: index) as! T
    }
    
    func numberOfViewControllers<T>(in: PagingViewController<T>) -> Int {
        return icons.count
    }
}

extension TranslationViewController: PaperOnboardingDataSource {
    func onboardingItem(at index: Int) -> OnboardingItemInfo {
        return onboardItems[index]
    }

    func onboardingItemsCount() -> Int {
        return onboardItems.count
    }
}
