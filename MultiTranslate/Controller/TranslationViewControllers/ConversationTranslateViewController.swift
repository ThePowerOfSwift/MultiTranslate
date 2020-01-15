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
    
    let container: UIView = {
        let view = UIView()
        view.translatesAutoresizingMaskIntoConstraints = false
        return view
    }()
    
    let conversationTableView: UITableView = {
        let tableView = UITableView()
        return tableView
    }()

    let buttonsContainer: UIView = {
        let view = UIView()
        view.backgroundColor = .gray
        view.layer.cornerRadius = 10
        view.layer.maskedCorners = [.layerMinXMinYCorner, .layerMaxXMinYCorner]
        view.layer.masksToBounds = true
        return view
    }()

    let languageButtonsView = UIView(backgroundColor: .yellow)
    let recordButtonsView = UIView(backgroundColor: .black)
    
    let sourceLanguageView = UIView(backgroundColor: .red)
    let languageExchangeView = UIView(backgroundColor: .systemBackground)
    let targetLanguageView = UIView(backgroundColor: .green)

    let sourceLanguageButton = UIButton(title: "English", titleColor: .label)
    let languageExchangeButton = UIButton(image: UIImage(named: "exchange")!)
    let targetLanguageButton = UIButton(title: "Japanese", titleColor: .label)
    
    let sourceRecorderButtonView = UIView()
    let recorderButtonPaddingView = UIView()
    let targetRecorderButtonView = UIView()
    
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
        
        languageExchangeView.addSubview(languageExchangeButton)
        languageExchangeButton.setHeight(50)
        languageExchangeButton.setWidth(50)
        languageExchangeButton.centerInSuperview()
        
        targetLanguageView.addSubview(targetLanguageButton)
        targetLanguageButton.centerInSuperview()
        
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
        
//        container.addSubview(conversationTableView)
//        conversationTableView.topAnchor.constraint(equalTo: container.topAnchor).isActive = true
//        conversationTableView.leadingAnchor.constraint(equalTo: container.leadingAnchor).isActive = true
//        conversationTableView.trailingAnchor.constraint(equalTo: container.trailingAnchor).isActive = true
//        conversationTableView.bottomAnchor.constraint(equalTo: buttonsContainer.topAnchor).isActive = true

    }
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        
    }

}
