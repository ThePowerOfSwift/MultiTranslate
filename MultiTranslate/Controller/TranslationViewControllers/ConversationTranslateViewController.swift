//
//  ConversationTranslateViewController.swift
//  MultiTranslate
//
//  Created by Keishin CHOU on 2020/01/12.
//  Copyright © 2020 Keishin CHOU. All rights reserved.
//

import UIKit

import LBTATools

class ConversationTranslateViewController: UIViewController {
    
    private var conversations: [Conversation] = [
        Conversation(sourceMessage: "Hello", targetMessage: "こんにちは", sender: .source),
        Conversation(sourceMessage: "Hello", targetMessage: "こんにちは", sender: .target),
        Conversation(sourceMessage: "Hello", targetMessage: "こんにちは", sender: .source),
        Conversation(sourceMessage: "使い方は、まず以下のようにxibを使わないセルはClassRegistrable、xibを使うセルはNibRegistrableに適合させます。プロトコルエクステンションがあるので、メソッドを実装する必要はありません。", targetMessage: "こんにちは", sender: .source),
        Conversation(sourceMessage: "使い方は、まず以下のようにxibを使わないセルはClassRegistrable、xibを使うセルはNibRegistrableに適合させます。プロトコルエクステンションがあるので、メソッドを実装する必要はありません。", targetMessage: "こんにちは", sender: .target),
        Conversation(sourceMessage: "使い方は、まず以下のようにxibを使わないセルはClassRegistrable、xibを使うセルはNibRegistrableに適合させます。プロトコルエクステンションがあるので、メソッドを実装する必要はありません。", targetMessage: "こんにちは", sender: .source)
    ]
    
    private var sourceLanguageIndex = 0
    private var targetLanguageIndex = 0
    
    private let container: UIView = {
        let view = UIView()
        view.translatesAutoresizingMaskIntoConstraints = false
        return view
    }()
    
    private let conversationTableView: UITableView = {
        let tableView = UITableView()
        tableView.translatesAutoresizingMaskIntoConstraints = false
        return tableView
    }()

    private let buttonsContainer: UIView = {
        let view = UIView()
        view.backgroundColor = .gray
        view.layer.cornerRadius = 10
        view.layer.maskedCorners = [.layerMinXMinYCorner, .layerMaxXMinYCorner]
        view.layer.masksToBounds = true
        return view
    }()

    private let languageButtonsView = UIView(backgroundColor: .yellow)
    private let recordButtonsView = UIView(backgroundColor: .black)
    
    private let sourceLanguageView = UIView(backgroundColor: .red)
    private let languageExchangeView = UIView(backgroundColor: .systemBackground)
    private let targetLanguageView = UIView(backgroundColor: .green)

    private let sourceLanguageButton = UIButton(title: languageList[0], titleColor: .label)
    private let languageExchangeButton = UIButton(image: UIImage(named: "exchange")!)
    private let targetLanguageButton = UIButton(title: languageList[2], titleColor: .label)
    
    private let sourceRecorderButtonView = UIView()
    private let recorderButtonPaddingView = UIView()
    private let targetRecorderButtonView = UIView()
    
    private lazy var sourceRecorderButton: UIButton = {
        let button = UIButton()
        button.backgroundColor = .red
        button.heightAnchor.constraint(equalToConstant: 50).isActive = true
        button.widthAnchor.constraint(equalToConstant: 50).isActive = true
        button.layer.cornerRadius = 25
        button.layer.masksToBounds = true
        button.translatesAutoresizingMaskIntoConstraints = false
        
        return button
    }()
    
    private lazy var sourceRecorderButtonBorder: UIView = {
        let view = UIView()
        view.translatesAutoresizingMaskIntoConstraints = false
        view.backgroundColor = .black
        view.layer.borderWidth = 2
        view.layer.borderColor = UIColor.white.cgColor
        view.heightAnchor.constraint(equalToConstant: 60).isActive = true
        view.widthAnchor.constraint(equalToConstant: 60).isActive = true
        view.layer.cornerRadius = 30
        
        return view
    }()
    
    private lazy var targetRecorderButton: UIButton = {
        let button = UIButton()
        button.backgroundColor = .red
        button.heightAnchor.constraint(equalToConstant: 50).isActive = true
        button.widthAnchor.constraint(equalToConstant: 50).isActive = true
        button.layer.cornerRadius = 25
        button.layer.masksToBounds = true
        button.translatesAutoresizingMaskIntoConstraints = false
        
        return button
    }()
    
    private lazy var targetRecorderButtonBorder: UIView = {
        let view = UIView()
        view.translatesAutoresizingMaskIntoConstraints = false
        view.backgroundColor = .black
        view.layer.borderWidth = 2
        view.layer.borderColor = UIColor.white.cgColor
        view.heightAnchor.constraint(equalToConstant: 60).isActive = true
        view.widthAnchor.constraint(equalToConstant: 60).isActive = true
        view.layer.cornerRadius = 30
        
        return view
    }()
    
    override func loadView() {
        super.loadView()
        
        view.addSubview(container)
        container.edgeTo(view, safeArea: .all)

        container.addSubview(buttonsContainer)
        buttonsContainer.setHeight(150)
        buttonsContainer.anchor(top: nil,
                                leading: container.safeAreaLayoutGuide.leadingAnchor,
                                bottom: container.safeAreaLayoutGuide.bottomAnchor,
                                trailing: container.safeAreaLayoutGuide.trailingAnchor)
        
        buttonsContainer.VStack(languageButtonsView,
                                recordButtonsView,
                                alignment: .fill,
                                distribution: .fillEqually)
        
        languageButtonsView.HStack(sourceLanguageView,
                                   languageExchangeView.setWidth(50),
                                   targetLanguageView,
                                   spacing: 10,
                                   alignment: .fill,
                                   distribution: .fill)
        sourceLanguageView.widthAnchor.constraint(equalTo: targetLanguageView.widthAnchor).isActive = true
        
        sourceLanguageView.addSubview(sourceLanguageButton)
        sourceLanguageButton.centerInSuperview()
        sourceLanguageButton.leadingAnchor.constraint(equalTo: sourceLanguageView.leadingAnchor).isActive = true
        sourceLanguageButton.trailingAnchor.constraint(equalTo: sourceLanguageView.trailingAnchor).isActive = true
        sourceLanguageButton.titleLabel?.leadingAnchor.constraint(equalTo: sourceLanguageButton.leadingAnchor).isActive = true
        sourceLanguageButton.titleLabel?.trailingAnchor.constraint(equalTo: sourceLanguageButton.trailingAnchor).isActive = true
        sourceLanguageButton.titleLabel?.textAlignment = .center
        
        languageExchangeView.addSubview(languageExchangeButton)
        languageExchangeButton.setHeight(50)
        languageExchangeButton.setWidth(50)
        languageExchangeButton.centerInSuperview()
        
        targetLanguageView.addSubview(targetLanguageButton)
        targetLanguageButton.centerInSuperview()
        targetLanguageButton.leadingAnchor.constraint(equalTo: targetLanguageView.leadingAnchor).isActive = true
        targetLanguageButton.trailingAnchor.constraint(equalTo: targetLanguageView.trailingAnchor).isActive = true
        targetLanguageButton.titleLabel?.leadingAnchor.constraint(equalTo: targetLanguageButton.leadingAnchor).isActive = true
        targetLanguageButton.titleLabel?.trailingAnchor.constraint(equalTo: targetLanguageButton.trailingAnchor).isActive = true
        targetLanguageButton.titleLabel?.textAlignment = .center
        
        recordButtonsView.HStack(sourceRecorderButtonView,
                                 recorderButtonPaddingView.setWidth(50),
                                 targetRecorderButtonView,
                                 spacing: 10,
                                 alignment: .fill,
                                 distribution: .fill)
        sourceRecorderButtonView.widthAnchor.constraint(equalTo: targetRecorderButtonView.widthAnchor).isActive = true
        
        sourceRecorderButtonView.addSubview(sourceRecorderButtonBorder)
        sourceRecorderButtonBorder.centerInSuperview()

        sourceRecorderButtonView.addSubview(sourceRecorderButton)
        sourceRecorderButton.centerInSuperview()
        
        
        targetRecorderButtonView.addSubview(targetRecorderButtonBorder)
        targetRecorderButtonBorder.centerInSuperview()

        targetRecorderButtonView.addSubview(targetRecorderButton)
        targetRecorderButton.centerInSuperview()
        
        container.addSubview(conversationTableView)
        conversationTableView.topAnchor.constraint(equalTo: container.topAnchor).isActive = true
        conversationTableView.leadingAnchor.constraint(equalTo: container.leadingAnchor).isActive = true
        conversationTableView.trailingAnchor.constraint(equalTo: container.trailingAnchor).isActive = true
        conversationTableView.bottomAnchor.constraint(equalTo: buttonsContainer.topAnchor).isActive = true

    }
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        conversationTableView.delegate = self
        conversationTableView.dataSource = self
        
        conversationTableView.register(ConversationCell.self, forCellReuseIdentifier: Constants.conversationTableViewCellIdentifier)
        conversationTableView.separatorStyle = .none
        
        languageExchangeButton.addTarget(self, action: #selector(exchangeLanguage), for: .touchUpInside)
        sourceLanguageButton.addTarget(self, action: #selector(changeLanguage), for: .touchUpInside)
        targetLanguageButton.addTarget(self, action: #selector(changeLanguage), for: .touchUpInside)
    }
    
    @objc func exchangeLanguage() {
        let exchangeText = targetLanguageButton.titleLabel?.text
        
        UIView.animate(withDuration: 0.25, animations: {
            self.languageExchangeButton.transform = CGAffineTransform(rotationAngle: CGFloat.pi)
            self.languageExchangeButton.transform = self.languageExchangeButton.transform.rotated(by: CGFloat.pi)
            self.targetLanguageButton.titleLabel?.text = self.sourceLanguageButton.titleLabel?.text
            self.sourceLanguageButton.titleLabel?.text = exchangeText
        }, completion: nil)
        
        print("exchange button pressed.")
    }
    
    @objc func changeLanguage() {
        if let sourceLanguage = sourceLanguageButton.titleLabel?.text {
            sourceLanguageIndex = languageList.firstIndex(of: sourceLanguage) ?? 0
            print(sourceLanguageIndex)
            print(sourceLanguage)
        }
        
        if let targetLanguage = targetLanguageButton.titleLabel?.text {
            targetLanguageIndex = languageList.firstIndex(of: targetLanguage) ?? 0
            print(targetLanguageIndex)
            print(targetLanguage)
        }
        
        //present picker view modal
        let viewController = ChangeLanguageViewController()
        viewController.sourceLanguageRow = sourceLanguageIndex
        viewController.targetLanguageRow = targetLanguageIndex
        viewController.delegate = self
        let navController = UINavigationController(rootViewController: viewController)
        
        self.navigationController?.present(navController, animated: true, completion: nil)
    }

}

extension ConversationTranslateViewController: UITableViewDelegate {
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        tableView.deselectRow(at: indexPath, animated: true)
    }
}

extension ConversationTranslateViewController: UITableViewDataSource {
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return conversations.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: Constants.conversationTableViewCellIdentifier, for: indexPath) as! ConversationCell
        cell.conversation = conversations[indexPath.row]
        return cell
    }
}

extension ConversationTranslateViewController: LanguagePickerDelegate {
    func didSelectedLanguagePicker(sourceLanguage: String, targetLanguage: String) {
        sourceLanguageButton.setTitle(sourceLanguage, for: .normal)
        targetLanguageButton.setTitle(targetLanguage, for: .normal)
    }
    
    
}
