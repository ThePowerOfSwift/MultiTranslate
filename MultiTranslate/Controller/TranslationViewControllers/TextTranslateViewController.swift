//
//  TextTranslateViewController.swift
//  MultiTranslate
//
//  Created by Keishin CHOU on 2020/01/06.
//  Copyright © 2020 Keishin CHOU. All rights reserved.
//

import UIKit

import RAMAnimatedTabBarController

class TextTranslateViewController: UIViewController {
    
    let exchangeButton: UIButton = {
        let button = UIButton()
        button.setImage(UIImage(named: "exchange"), for: .normal)
        button.translatesAutoresizingMaskIntoConstraints = false
        button.heightAnchor.constraint(equalToConstant: CGFloat(50)).isActive = true
        button.widthAnchor.constraint(equalTo: button.heightAnchor, multiplier: 1).isActive = true
        return button
    }()
    
    override func loadView() {
        super.loadView()
        
        let languageSelectView = UIView()
        languageSelectView.backgroundColor = .red
        
        let sourceInputView = UIView()
        sourceInputView.backgroundColor = .blue
        
        let targetOutputView = UIView()
        targetOutputView.backgroundColor = .cyan
        
        let textTranslateStackView = UIStackView(arrangedSubviews: [languageSelectView, sourceInputView, targetOutputView])
        textTranslateStackView.axis = .vertical
        textTranslateStackView.distribution = .fillProportionally
        
        view.addSubview(textTranslateStackView)
        textTranslateStackView.translatesAutoresizingMaskIntoConstraints = false
        textTranslateStackView.topAnchor.constraint(equalTo: view.topAnchor).isActive = true
        textTranslateStackView.leadingAnchor.constraint(equalTo: view.safeAreaLayoutGuide.leadingAnchor).isActive = true
        textTranslateStackView.trailingAnchor.constraint(equalTo: view.safeAreaLayoutGuide.trailingAnchor).isActive = true
        textTranslateStackView.bottomAnchor.constraint(equalTo: view.bottomAnchor).isActive = true
        
        let sourceLanguageView = UIView()
        sourceLanguageView.backgroundColor = .purple
        
        let exchangeButtonView = UIView()
        exchangeButtonView.backgroundColor = .orange
        
        let targetLanguageView = UIView()
        targetLanguageView.backgroundColor = .gray
        
        let languageSelectStackView = UIStackView(arrangedSubviews: [sourceLanguageView, exchangeButtonView, targetLanguageView])
        languageSelectStackView.axis = .horizontal
        languageSelectStackView.distribution = .fillProportionally
        
        languageSelectView.addSubview(languageSelectStackView)
        languageSelectStackView.translatesAutoresizingMaskIntoConstraints = false
        languageSelectStackView.topAnchor.constraint(equalTo: languageSelectView.topAnchor).isActive = true
        languageSelectStackView.leadingAnchor.constraint(equalTo: languageSelectView.leadingAnchor).isActive = true
        languageSelectStackView.trailingAnchor.constraint(equalTo: languageSelectView.trailingAnchor).isActive = true
        languageSelectStackView.bottomAnchor.constraint(equalTo: languageSelectView.bottomAnchor).isActive = true
        
        exchangeButtonView.addSubview(exchangeButton)
        exchangeButton.centerXAnchor.constraint(equalTo: exchangeButtonView.centerXAnchor).isActive = true
        exchangeButton.centerYAnchor.constraint(equalTo: exchangeButtonView.centerYAnchor).isActive = true
        

    }

    override func viewDidLoad() {
        super.viewDidLoad()

    }

}
