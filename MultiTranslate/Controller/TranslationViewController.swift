//
//  TranslationViewController.swift
//  MultiTranslate
//
//  Created by Keishin CHOU on 2020/01/06.
//  Copyright © 2020 Keishin CHOU. All rights reserved.
//

import UIKit

import Parchment


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
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
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
        
        let pagingViewController = PagingViewController<IconItem>()
        pagingViewController.menuItemSource = .class(type: IconPagingCell.self)
        pagingViewController.menuItemSize = .fixed(width: 70, height: 70)
        pagingViewController.textColor = UIColor(red: 0.51, green: 0.54, blue: 0.56, alpha: 1)
        pagingViewController.selectedTextColor = UIColor(red: 0.14, green: 0.77, blue: 0.85, alpha: 1)
        pagingViewController.indicatorColor = UIColor(red: 0.14, green: 0.77, blue: 0.85, alpha: 1)
        pagingViewController.dataSource = self
        pagingViewController.select(pagingItem: IconItem(icon: icons[0], index: 0))
//        pagingViewController.menuBackgroundColor = UIColor(rgb: 0xe1f2fb)
        pagingViewController.menuBackgroundColor = UIColor(rgb: 0xC1D2EB)
        pagingViewController.borderColor = .white
        
        // Add the paging view controller as a child view controller
        // and contrain it to all edges.
        addChild(pagingViewController)
        view.addSubview(pagingViewController.view)
        view.constrainToEdges(pagingViewController.view)
        view.backgroundColor = UIColor(rgb: 0xC1D2EB)
        pagingViewController.didMove(toParent: self)
        
        NotificationCenter.default.addObserver(forName: .translationViewControllerDidChange, object: nil, queue: .main) { (notification) in
            if let titleInfo = notification.userInfo as? [String : String] {
                for (_, newTitleName) in titleInfo {
                    self.title = newTitleName
                }
            }
        }
        
        navigationItem.rightBarButtonItem = UIBarButtonItem(image: UIImage(systemName: "tray.and.arrow.down"), style: .plain, target: self, action: #selector(showDownloadLanguageModelPage))
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
            let alert = PMAlertController(title: "Download offline language", description: "Download offline language fast and save your ...", image: UIImage(named: "download"), style: .alert)
            let defaultAction = PMAlertAction(title: "Got it", style: .default) {
                let viewController = FBLanguageTableViewController()
                let navController = UINavigationController(rootViewController: viewController)
                navController.modalPresentationStyle = .pageSheet
                self.present(navController, animated: true, completion: nil)
            }
            alert.addAction(defaultAction)
            present(alert, animated: true) {
                UserDefaults.standard.set(true, forKey: Constants.isFBDownloadLanguangePageShownKey)
            }
        }
    }
}

extension TranslationViewController: PagingViewControllerDataSource {
    
    func pagingViewController<T>(_ pagingViewController: PagingViewController<T>, viewControllerForIndex index: Int) -> UIViewController {
//        return IconViewController(title: icons[index].capitalized)
        return translationViewControllers[index]
    }
    
    func pagingViewController<T>(_ pagingViewController: PagingViewController<T>, pagingItemForIndex index: Int) -> T {
        return IconItem(icon: icons[index], index: index) as! T
    }
    
    func numberOfViewControllers<T>(in: PagingViewController<T>) -> Int {
        return icons.count
    }
    
}
