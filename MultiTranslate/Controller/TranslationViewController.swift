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
        "pdf",
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
        
        // Add the paging view controller as a child view controller
        // and contrain it to all edges.
        addChild(pagingViewController)
        view.addSubview(pagingViewController.view)
        view.constrainToEdges(pagingViewController.view)
        pagingViewController.didMove(toParent: self)
    }
    
    
    /*
     // MARK: - Navigation
     
     // In a storyboard-based application, you will often want to do a little preparation before navigation
     override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
     // Get the new view controller using segue.destination.
     // Pass the selected object to the new view controller.
     }
     */
    
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
