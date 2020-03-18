//
//  TranslationViewController.swift
//  MultiTranslate
//
//  Created by Keishin CHOU on 2020/01/06.
//  Copyright © 2020 Keishin CHOU. All rights reserved.
//

import UIKit

import DynamicColor
import Parchment
import paper_onboarding
import Localize_Swift


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
        button.setTitle("skip".localized(), for: .normal)
        // use {Localize_Swift} to do localization
        
        button.titleLabel?.font = UIFont.systemFont(ofSize: 16, weight: .thin)
        button.setTitleColor(UIColor.init(white: 1, alpha: 0.95), for: .normal)
        return button
    }()
    
    private let onboardItems = [
        OnboardingItemInfo(informationImage: UIImage(named: "text-onboard")!.withTintColor(.white),
                           title: "Text translate".localized(),
                           description: "Supporting 104 languages. \n Offline translate is also available for FREE.".localized(),
                           pageIcon: UIImage(systemName: "1.circle.fill")!.withRenderingMode(.alwaysOriginal).withTintColor(.init(white: 1, alpha: 0.8)),
                           color: DynamicColor(hexString: "#7BC4E3"),
                           titleColor: .init(white: 1, alpha: 0.9),
                           descriptionColor: .init(white: 1, alpha: 0.9),
                           titleFont: UIFont.preferredFont(forTextStyle: .largeTitle),
                           descriptionFont: UIFont.preferredFont(forTextStyle: .body)),

        OnboardingItemInfo(informationImage: UIImage(named: "camera-onboard")!.withTintColor(.white),
                           title: "Camera translate".localized(),
                           description: "Automatically recognize and translate words in images.".localized(),
                           pageIcon: UIImage(systemName: "2.circle.fill")!.withRenderingMode(.alwaysOriginal).withTintColor(.init(white: 1, alpha: 0.8)),
                           color: DynamicColor(hexString: "#5FB947"),
                           titleColor: .init(white: 1, alpha: 0.9),
                           descriptionColor: .init(white: 1, alpha: 0.9),
                           titleFont: UIFont.preferredFont(forTextStyle: .largeTitle),
                           descriptionFont: UIFont.preferredFont(forTextStyle: .body)),
        
        OnboardingItemInfo(informationImage: UIImage(named: "microphone-onboard")!.withTintColor(.white),
                           title: "Speech translate".localized(),
                           description: "Automatically recognize and translate words in speech.".localized(),
                           pageIcon: UIImage(systemName: "3.circle.fill")!.withRenderingMode(.alwaysOriginal).withTintColor(.init(white: 1, alpha: 0.8)),
                           color: DynamicColor(hexString: "#F2B421"),
                           titleColor: .init(white: 1, alpha: 0.9),
                           descriptionColor: .init(white: 1, alpha: 0.9),
                           titleFont: UIFont.preferredFont(forTextStyle: .largeTitle),
                           descriptionFont: UIFont.preferredFont(forTextStyle: .body)),

        OnboardingItemInfo(informationImage: UIImage(named: "conversation-onboard")!.withTintColor(.white),
                           title: "Conversation translate".localized(),
                           description: "Automatically recognize words in conversations and translate smoothly.".localized(),
                           pageIcon: UIImage(systemName: "4.circle.fill")!.withRenderingMode(.alwaysOriginal).withTintColor(.init(white: 1, alpha: 0.8)),
                           color: DynamicColor(hexString: "#F78019"),
                           titleColor: .init(white: 1, alpha: 0.9),
                           descriptionColor: .init(white: 1, alpha: 0.9),
                           titleFont: UIFont.preferredFont(forTextStyle: .largeTitle),
                           descriptionFont: UIFont.preferredFont(forTextStyle: .body)),
        
        OnboardingItemInfo(informationImage: UIImage(named: "ar-onboard")!.withTintColor(.white),
                           title: "AR object translate".localized(),
                           description: "Automatically recognize objects in camera images. \n Display the names of the objects using AR.".localized(),
                           pageIcon: UIImage(systemName: "5.circle.fill")!.withRenderingMode(.alwaysOriginal).withTintColor(.init(white: 1, alpha: 0.8)),
                           color: DynamicColor(hexString: "#DE3B3C"),
                           titleColor: .init(white: 1, alpha: 0.9),
                           descriptionColor: .init(white: 1, alpha: 0.9),
                           titleFont: UIFont.preferredFont(forTextStyle: .largeTitle),
                           descriptionFont: UIFont.preferredFont(forTextStyle: .body)),

        OnboardingItemInfo(informationImage: UIImage(named: "doc-onboard")!.withTintColor(.white),
                           title: "Document translate".localized(),
                           description: "Automatically scan documents and recognize characters.".localized(),
                           pageIcon: UIImage(systemName: "6.circle.fill")!.withRenderingMode(.alwaysOriginal).withTintColor(.init(white: 1, alpha: 0.8)),
                           color: DynamicColor(hexString: "#933C96"),
                           titleColor: .init(white: 1, alpha: 0.9),
                           descriptionColor: .init(white: 1, alpha: 0.9),
                           titleFont: UIFont.preferredFont(forTextStyle: .largeTitle),
                           descriptionFont: UIFont.preferredFont(forTextStyle: .body)),
        
        OnboardingItemInfo(informationImage: UIImage(named: "image-onboard")!.withTintColor(.white),
                           title: "Image translate".localized(),
                           description: "Automatically recognize and translate words in images.".localized(),
                           pageIcon: UIImage(systemName: "7.circle.fill")!.withRenderingMode(.alwaysOriginal).withTintColor(.init(white: 1, alpha: 0.8)),
                           color: DynamicColor(hexString: "#009DDB"),
                           titleColor: .init(white: 1, alpha: 0.9),
                           descriptionColor: .init(white: 1, alpha: 0.9),
                           titleFont: UIFont.preferredFont(forTextStyle: .largeTitle),
                           descriptionFont: UIFont.preferredFont(forTextStyle: .body)),
    ]
    
    
    override func loadView() {
        super.loadView()

        addChild(pageViewController)
        view.addSubview(pageViewController.view)
        pageViewController.view.edgeTo(view, safeArea: .vertical)
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        view.backgroundColor = .mtSystemBackground
        
        pageViewController.dataSource = self
        pageViewController.select(pagingItem: IconItem(icon: icons[0], index: 0))
        pageViewController.didMove(toParent: self)

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
        
//        let isAppEverLaunched = UserDefaults.standard.bool(forKey: Constants.isAppEverLauchedKey)
        let isAppEverLaunched = false // for test
        if !isAppEverLaunched {
            view.addSubview(onboardPage)
            onboardPage.edgeTo(view)
            
            view.addSubview(skipButton)
            skipButton.topAnchor.constraint(equalTo: view.topAnchor, constant: 100).isActive = true
            skipButton.trailingAnchor.constraint(equalTo: view.trailingAnchor, constant: -35).isActive = true
            
            navigationController?.navigationBar.isHidden = true
            tabBarController?.tabBar.alpha = 0
            
            UserDefaults.standard.set(true, forKey: Constants.isAppEverLauchedKey)
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
            let alert = PMAlertController(title: "Download offline language".localized(),
                                          description: "Offline translate faster with no network access. Offline translate can save your packet communication fee.".localized(),
                                          image: UIImage(named: "download"),
                                          style: .alert)
            let defaultAction = PMAlertAction(title: "Got it".localized(), style: .default) { [weak self] in
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
        navigationController?.navigationBar.isHidden = false
        tabBarController?.tabBar.alpha = 1

        onboardPage.removeFromSuperview()
        skipButton.removeFromSuperview()
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
