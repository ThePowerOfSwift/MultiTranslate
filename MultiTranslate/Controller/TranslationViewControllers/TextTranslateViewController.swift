//
//  TextTranslateViewController.swift
//  MultiTranslate
//
//  Created by Keishin CHOU on 2020/01/06.
//  Copyright © 2020 Keishin CHOU. All rights reserved.
//

import AVFoundation
import UIKit

//import PMSuperButton
import Alamofire
import DynamicColor
import SwiftyJSON
import SPAlert
//import RAMAnimatedTabBarController
//import KMPlaceholderTextView
import RealmSwift

class TextTranslateViewController: UIViewController {
    
    //MARK: - Variables and Constants
    var temporarySourceLanguageGCPIndex = UserDefaults.standard.integer(forKey: Constants.textSourceLanguageIndexKey)
    var temporaryTargetLanguageGCPIndex = UserDefaults.standard.integer(forKey: Constants.textTargetLanguageIndexKey)
    var defaultSourceLanguageIndex = UserDefaults.standard.integer(forKey: Constants.textSourceLanguageIndexKey)
    var defaultTargetLanguageIndex = UserDefaults.standard.integer(forKey: Constants.textTargetLanguageIndexKey)
    
    var languagePickerType: LanguagePickerType = .textTranslate
    var isTranslateTypeNeedPro = false
    
    private var isStarButtonTapped: Bool = false
    
    private var translatedCharactersCurrentMonth = 0
    
    private let realm = try! Realm()
    private var savedTranslations: Results<SavedTranslation>!
    
    private var cloudDBTranslatedCharacters = 0
    private var starBadgeNum = 0
    
    //MARK: - UI Parts Declaration
    
    private let container: UIView = {
        let view = UIView()
        view.translatesAutoresizingMaskIntoConstraints = false
        view.backgroundColor = .mtSystemBackground
        return view
    }()
    
    private let languageSelectView: UIView = {
        let view = UIView()
        view.translatesAutoresizingMaskIntoConstraints = false
        return view
    }()
    
    private let sourceLanguageView: UIView = {
        let view = UIView()
        view.translatesAutoresizingMaskIntoConstraints = false
        return view
    }()
    
    private let sourceLanguageButtonContainerView: UIView = {
        let view = UIView()
        view.translatesAutoresizingMaskIntoConstraints = false
        view.backgroundColor = .mtSystemBackground
        view.layer.cornerRadius = 20
        return view
    }()
    
    private let sourceLanguageButtonOutterLightView: UIView = {
        let view = UIView()
        view.translatesAutoresizingMaskIntoConstraints = false
        view.backgroundColor = .mtSystemBackground
        
        view.layer.cornerRadius = 20
        view.layer.masksToBounds = false
        
        view.layer.shadowColor = UIColor.mtSystemBackground.lighter().cgColor
        view.layer.shadowOpacity = 0.35
        view.layer.shadowOffset = CGSize(width: -5, height: -5)
        view.layer.shadowRadius = 5
        
        return view
    }()
    
    private let sourceLanguageButtonOutterDarkView: UIView = {
        let view = UIView()
        view.translatesAutoresizingMaskIntoConstraints = false
        view.backgroundColor = .mtSystemBackground
        
        view.layer.cornerRadius = 20
        view.layer.masksToBounds = false
        
        view.layer.shadowColor = UIColor.mtSystemBackground.darkened().cgColor
        view.layer.shadowOpacity = 0.35
        view.layer.shadowOffset = CGSize(width: 5, height: 5)
        view.layer.shadowRadius = 5
        
        return view
    }()
    
    private let sourceLanguageButtonInnerLightView: SwiftyInnerShadowView = {
        let view = SwiftyInnerShadowView()
        view.translatesAutoresizingMaskIntoConstraints = false

        view.shadowLayer.shadowRadius = 10
        view.shadowLayer.shadowColor = UIColor.mtSystemBackground.lighter().cgColor
        view.shadowLayer.shadowOpacity = 0.5
        view.shadowLayer.shadowOffset = CGSize.zero
        view.cornerRadius = 20
        
        return view
    }()
    
    private let sourceLanguageButtonInnerDarkView: SwiftyInnerShadowView = {
        let view = SwiftyInnerShadowView()
        view.translatesAutoresizingMaskIntoConstraints = false

        view.shadowLayer.shadowRadius = 10
        view.shadowLayer.shadowColor = UIColor.mtSystemBackground.darkened().cgColor
        view.shadowLayer.shadowOpacity = 0.5
        view.shadowLayer.shadowOffset = CGSize.zero
        view.cornerRadius = 20
        
        return view
    }()
    
    private let exchangeButtonView: UIView = {
        let view = UIView()
        view.translatesAutoresizingMaskIntoConstraints = false
        return view
    }()
    
    private let exchangeButtonContainerView: UIView = {
        let view = UIView()
        view.translatesAutoresizingMaskIntoConstraints = false
        view.backgroundColor = .mtSystemBackground
        return view
    }()
    
    private let exchangeButtonOutterLightView: UIView = {
        let view = UIView()
        view.translatesAutoresizingMaskIntoConstraints = false
        view.backgroundColor = .mtSystemBackground
        
        view.layer.masksToBounds = false
        
        view.layer.shadowColor = UIColor.mtSystemBackground.lighter().cgColor
        view.layer.shadowOpacity = 0.35
        view.layer.shadowOffset = CGSize(width: -5, height: -5)
        view.layer.shadowRadius = 5
        
        return view
    }()
    
    private let exchangeButtonOutterDarkView: UIView = {
        let view = UIView()
        view.translatesAutoresizingMaskIntoConstraints = false
        view.backgroundColor = .mtSystemBackground
        
        view.layer.masksToBounds = false
        
        view.layer.shadowColor = UIColor.mtSystemBackground.darkened().cgColor
        view.layer.shadowOpacity = 0.35
        view.layer.shadowOffset = CGSize(width: 5, height: 5)
        view.layer.shadowRadius = 5
        
        return view
    }()
    
    private let exchangeButtonInnerLightView: SwiftyInnerShadowView = {
        let view = SwiftyInnerShadowView()
        view.translatesAutoresizingMaskIntoConstraints = false

        view.shadowLayer.shadowRadius = 10
        view.shadowLayer.shadowColor = UIColor.mtSystemBackground.lighter().cgColor
        view.shadowLayer.shadowOpacity = 0.5
        view.shadowLayer.shadowOffset = CGSize.zero
        return view
    }()
    
    private let exchangeButtonInnerDarkView: SwiftyInnerShadowView = {
        let view = SwiftyInnerShadowView()
        view.translatesAutoresizingMaskIntoConstraints = false

        view.shadowLayer.shadowRadius = 10
        view.shadowLayer.shadowColor = UIColor.mtSystemBackground.darkened().cgColor
        view.shadowLayer.shadowOpacity = 0.5
        view.shadowLayer.shadowOffset = CGSize.zero
        return view
    }()
    
    private let targetLanguageView: UIView = {
        let view = UIView()
        view.translatesAutoresizingMaskIntoConstraints = false
        return view
    }()
    
    private let targetLanguageButtonContainerView: UIView = {
        let view = UIView()
        view.translatesAutoresizingMaskIntoConstraints = false
        view.backgroundColor = .mtSystemBackground
        view.layer.cornerRadius = 20
        return view
    }()
    
    private let targetLanguageButtonOutterLightView: UIView = {
        let view = UIView()
        view.translatesAutoresizingMaskIntoConstraints = false
        view.backgroundColor = .mtSystemBackground
        
        view.layer.cornerRadius = 20
        view.layer.masksToBounds = false
        
        view.layer.shadowColor = UIColor.mtSystemBackground.lighter().cgColor
        view.layer.shadowOpacity = 0.35
        view.layer.shadowOffset = CGSize(width: -5, height: -5)
        view.layer.shadowRadius = 5
        
        return view
    }()
    
    private let targetLanguageButtonOutterDarkView: UIView = {
        let view = UIView()
        view.translatesAutoresizingMaskIntoConstraints = false
        view.backgroundColor = .mtSystemBackground
        
        view.layer.cornerRadius = 20
        view.layer.masksToBounds = false
        
        view.layer.shadowColor = UIColor.mtSystemBackground.darkened().cgColor
        view.layer.shadowOpacity = 0.35
        view.layer.shadowOffset = CGSize(width: 5, height: 5)
        view.layer.shadowRadius = 5
        
        return view
    }()
    
    private let targetLanguageButtonInnerLightView: SwiftyInnerShadowView = {
        let view = SwiftyInnerShadowView()
        view.translatesAutoresizingMaskIntoConstraints = false

        view.shadowLayer.shadowRadius = 10
        view.shadowLayer.shadowColor = UIColor.mtSystemBackground.lighter().cgColor
        view.shadowLayer.shadowOpacity = 0.5
        view.shadowLayer.shadowOffset = CGSize.zero
        view.cornerRadius = 20
        
        return view
    }()
    
    private let targetLanguageButtonInnerDarkView: SwiftyInnerShadowView = {
        let view = SwiftyInnerShadowView()
        view.translatesAutoresizingMaskIntoConstraints = false

        view.shadowLayer.shadowRadius = 10
        view.shadowLayer.shadowColor = UIColor.mtSystemBackground.darkened().cgColor
        view.shadowLayer.shadowOpacity = 0.5
        view.shadowLayer.shadowOffset = CGSize.zero
        view.cornerRadius = 20
        
        return view
    }()

    private let sourceInputView: UIView = {
        let view = UIView()
        view.translatesAutoresizingMaskIntoConstraints = false
        return view
    }()
    
    private let translateButtonView: UIView = {
        let view = UIView()
        view.translatesAutoresizingMaskIntoConstraints = false
        return view
    }()
    
    private let translateButtonContainerView: UIView = {
        let view = UIView()
        view.translatesAutoresizingMaskIntoConstraints = false
        view.backgroundColor = .mtSystemBackground
        return view
    }()
    
    private let translateButtonOutterLightView: UIView = {
        let view = UIView()
        view.translatesAutoresizingMaskIntoConstraints = false
        view.backgroundColor = .mtSystemBackground
        
        view.layer.masksToBounds = false
        
        view.layer.shadowColor = UIColor.mtSystemBackground.lighter().cgColor
        view.layer.shadowOpacity = 0.5
        view.layer.shadowOffset = CGSize(width: -5, height: -5)
        view.layer.shadowRadius = 5
        
        return view
    }()
    
    private let translateButtonOutterDarkView: UIView = {
        let view = UIView()
        view.translatesAutoresizingMaskIntoConstraints = false
        view.backgroundColor = .mtSystemBackground
        
        view.layer.masksToBounds = false
        
        view.layer.shadowColor = UIColor.mtSystemBackground.darkened().cgColor
        view.layer.shadowOpacity = 0.2
        view.layer.shadowOffset = CGSize(width: 5, height: 5)
        view.layer.shadowRadius = 5
        
        return view
    }()
    
    private let translateButtonInnerLightView: SwiftyInnerShadowView = {
        let view = SwiftyInnerShadowView()
        view.translatesAutoresizingMaskIntoConstraints = false

        view.shadowLayer.shadowRadius = 10
        view.shadowLayer.shadowColor = UIColor.mtSystemBackground.lighter().cgColor
        view.shadowLayer.shadowOpacity = 0.5
        view.shadowLayer.shadowOffset = CGSize.zero
        return view
    }()
    
    private let translateButtonInnerDarkView: SwiftyInnerShadowView = {
        let view = SwiftyInnerShadowView()
        view.translatesAutoresizingMaskIntoConstraints = false

        view.shadowLayer.shadowRadius = 5
        view.shadowLayer.shadowColor = UIColor.mtSystemBackground.darkened().cgColor
        view.shadowLayer.shadowOpacity = 0.5
        view.shadowLayer.shadowOffset = CGSize.zero
        return view
    }()
    
    private let targetOutputView: UIView = {
        let view = UIView()
        view.translatesAutoresizingMaskIntoConstraints = false
        return view
    }()
    
    private let exchangeButton: UIButton = {
        let button = UIButton()
        button.setImage(UIImage(named: "exchange"), for: .normal)
        button.translatesAutoresizingMaskIntoConstraints = false
        return button
    }()
    
    private let clearButton: UIButton = {
        let button = UIButton()
        button.setImage(UIImage(systemName: "xmark.circle"), for: .normal)
        button.translatesAutoresizingMaskIntoConstraints = false
        button.setTitleColor(.systemBlue, for: .normal)
        return button
    }()
    
    private let translateButton: UIButton = {
        let button = UIButton()
        button.translatesAutoresizingMaskIntoConstraints = false
        button.setTitle("Translate", for: .normal)
        button.titleLabel?.font = UIFont.systemFont(ofSize: 26, weight: .black)
        button.setTitleColor(.mtButtonLabel, for: .normal)
        button.setTitleColor(.systemBackground, for: .highlighted)
        return button
    }()
    
    private let sourceLanguageButton: UIButton = {
        let button = UIButton()
        button.translatesAutoresizingMaskIntoConstraints = false
        button.titleLabel?.numberOfLines = 0
        button.titleLabel?.lineBreakMode = .byWordWrapping
        button.titleLabel?.textAlignment = .center
        button.titleLabel?.font = UIFont.systemFont(ofSize: 18, weight: .black)
        button.setTitleColor(.mtButtonLabel, for: .normal)
        button.setTitleColor(.systemBackground, for: .highlighted)
        return button
    }()
    
    private let targetLanguageButton: UIButton = {
        let button = UIButton()
        button.translatesAutoresizingMaskIntoConstraints = false
        button.titleLabel?.numberOfLines = 0
        button.titleLabel?.lineBreakMode = .byWordWrapping
        button.titleLabel?.textAlignment = .center
        button.titleLabel?.font = UIFont.systemFont(ofSize: 18, weight: .black)
        button.setTitleColor(.mtButtonLabel, for: .normal)
        button.setTitleColor(.systemBackground, for: .highlighted)
        return button
    }()
    
    let sourceInputText: NoSelectTextView = {
        let textView = NoSelectTextView()
        textView.translatesAutoresizingMaskIntoConstraints = false
        textView.backgroundColor = .mtTextfieldBackground
        textView.font = UIFont.preferredFont(forTextStyle: .body)
        textView.placeholder = "Input source text"
        textView.placeholderFont = UIFont.preferredFont(forTextStyle: .body)
        textView.placeholderColor = .placeholderText
        return textView
    }()
    
    private let clearButtonContainerView: UIView = {
        let view = UIView()
//        view.backgroundColor = #colorLiteral(red: 0.4745098054, green: 0.8392156959, blue: 0.9764705896, alpha: 1)
        return view
    }()
    
    private let sourceInputTextView: UIView = {
        let view = UIView()
//        view.backgroundColor = #colorLiteral(red: 0.05882352963, green: 0.180392161, blue: 0.2470588237, alpha: 1)
        return view
    }()
    
    private let outputActionView: UIView = {
        let view = UIView()
//        view.backgroundColor = #colorLiteral(red: 0.9529411793, green: 0.6862745285, blue: 0.1333333403, alpha: 1)
        return view
    }()
    
    private let outputTextView: UIView = {
        let view = UIView()
//        view.backgroundColor = #colorLiteral(red: 0.1411764771, green: 0.3960784376, blue: 0.5647059083, alpha: 1)
        return view
    }()
    
    private let starButton: UIButton = {
        let button = UIButton()
        button.translatesAutoresizingMaskIntoConstraints = false
        button.setImage(UIImage(systemName: "star"), for: .normal)
        button.tintColor = .systemBlue
        return button
    }()
    
    private let speechButton: UIButton = {
        let button = UIButton()
        button.translatesAutoresizingMaskIntoConstraints = false
        button.setImage(UIImage(systemName: "speaker.2"), for: .normal)
        button.tintColor = .systemBlue
        return button
    }()
    
    private let copyTextButton: UIButton = {
        let button = UIButton()
        button.translatesAutoresizingMaskIntoConstraints = false
        button.setImage(UIImage(systemName: "doc.on.doc"), for: .normal)
        button.tintColor = .systemBlue
        return button
    }()
    
    private let spacerView: UIView = {
        let view = UIView()
        view.translatesAutoresizingMaskIntoConstraints = false
        return view
    }()
    
    private let targetOutputText: UITextView = {
        let textView = UITextView()
        textView.translatesAutoresizingMaskIntoConstraints = false
        textView.font = UIFont.preferredFont(forTextStyle: .title3)
        textView.text = "Hello Blur"
        textView.backgroundColor = .clear
        textView.isEditable = false
        return textView
    }()
    
    
    // MARK: - ViewController Life Cirecle
    override func loadView() {
        super.loadView()
        
        let viewHeight = view.frame.height
        let viewWidth = view.frame.width
        
        view.addSubview(container)
        container.edgeTo(view, safeArea: .top)
        
        container.VStack(languageSelectView.setHeight(viewHeight * 0.12),
                         sourceInputView.setHeight(viewHeight * 0.25),
                         translateButtonView.setHeight(viewHeight * 0.1),
                         targetOutputView,
                         spacing: 5,
                         alignment: .fill,
                         distribution: .fill)
        
        languageSelectView.HStack(sourceLanguageView,
                                  exchangeButtonView.setWidth(viewWidth * 0.12),
                                  targetLanguageView,
                                  spacing: 0,
                                  alignment: .fill,
                                  distribution: .fill)
        exchangeButtonView.centerXAnchor.constraint(equalTo: languageSelectView.centerXAnchor).isActive = true

        sourceLanguageView.addSubview(sourceLanguageButtonContainerView)
        sourceLanguageButtonContainerView.topAnchor.constraint(equalTo: sourceLanguageView.topAnchor, constant: 20).isActive = true
        sourceLanguageButtonContainerView.bottomAnchor.constraint(equalTo: sourceLanguageView.bottomAnchor).isActive = true
        sourceLanguageButtonContainerView.leadingAnchor.constraint(equalTo: sourceLanguageView.leadingAnchor, constant: 25).isActive = true
        sourceLanguageButtonContainerView.trailingAnchor.constraint(equalTo: sourceLanguageView.trailingAnchor, constant: -25).isActive = true
        
        sourceLanguageButtonContainerView.addSubview(sourceLanguageButtonOutterDarkView)
        sourceLanguageButtonOutterDarkView.edgeTo(sourceLanguageButtonContainerView)
        
        sourceLanguageButtonContainerView.addSubview(sourceLanguageButtonOutterLightView)
        sourceLanguageButtonOutterLightView.edgeTo(sourceLanguageButtonContainerView)
        
        sourceLanguageButtonContainerView.addSubview(sourceLanguageButtonInnerDarkView)
        sourceLanguageButtonInnerDarkView.topAnchor.constraint(equalTo: sourceLanguageButtonContainerView.topAnchor).isActive = true
        sourceLanguageButtonInnerDarkView.leadingAnchor.constraint(equalTo: sourceLanguageButtonContainerView.leadingAnchor).isActive = true
        sourceLanguageButtonInnerDarkView.bottomAnchor.constraint(equalTo: sourceLanguageButtonContainerView.bottomAnchor, constant: 20).isActive = true
        sourceLanguageButtonInnerDarkView.trailingAnchor.constraint(equalTo: sourceLanguageButtonContainerView.trailingAnchor, constant: 20).isActive = true
        
        sourceLanguageButtonContainerView.addSubview(sourceLanguageButtonInnerLightView)
        sourceLanguageButtonInnerLightView.bottomAnchor.constraint(equalTo: sourceLanguageButtonContainerView.bottomAnchor).isActive = true
        sourceLanguageButtonInnerLightView.trailingAnchor.constraint(equalTo: sourceLanguageButtonContainerView.trailingAnchor).isActive = true
        sourceLanguageButtonInnerLightView.topAnchor.constraint(equalTo: sourceLanguageButtonContainerView.topAnchor, constant: -20).isActive = true
        sourceLanguageButtonInnerLightView.leadingAnchor.constraint(equalTo: sourceLanguageButtonContainerView.leadingAnchor, constant: -20).isActive = true
        
        sourceLanguageButtonContainerView.addSubview(sourceLanguageButton)
        sourceLanguageButton.edgeTo(sourceLanguageButtonContainerView)
        
        exchangeButtonView.addSubview(exchangeButtonContainerView)
        exchangeButtonContainerView.leadingAnchor.constraint(equalTo: exchangeButtonView.leadingAnchor).isActive = true
        exchangeButtonContainerView.trailingAnchor.constraint(equalTo: exchangeButtonView.trailingAnchor).isActive = true
        exchangeButtonContainerView.centerYAnchor.constraint(equalTo: sourceLanguageButtonContainerView.centerYAnchor).isActive = true
        exchangeButtonContainerView.heightAnchor.constraint(equalTo: exchangeButtonContainerView.widthAnchor).isActive = true
        
        exchangeButtonContainerView.addSubview(exchangeButtonOutterDarkView)
        exchangeButtonOutterDarkView.edgeTo(exchangeButtonContainerView)
        
        exchangeButtonContainerView.addSubview(exchangeButtonOutterLightView)
        exchangeButtonOutterLightView.edgeTo(exchangeButtonContainerView)
        
        exchangeButtonContainerView.addSubview(exchangeButtonInnerDarkView)
        exchangeButtonInnerDarkView.topAnchor.constraint(equalTo: exchangeButtonContainerView.topAnchor).isActive = true
        exchangeButtonInnerDarkView.leadingAnchor.constraint(equalTo: exchangeButtonContainerView.leadingAnchor).isActive = true
        exchangeButtonInnerDarkView.bottomAnchor.constraint(equalTo: exchangeButtonContainerView.bottomAnchor, constant: 30).isActive = true
        exchangeButtonInnerDarkView.trailingAnchor.constraint(equalTo: exchangeButtonContainerView.trailingAnchor, constant: 30).isActive = true
        
        exchangeButtonContainerView.addSubview(exchangeButtonInnerLightView)
        exchangeButtonInnerLightView.bottomAnchor.constraint(equalTo: exchangeButtonContainerView.bottomAnchor).isActive = true
        exchangeButtonInnerLightView.trailingAnchor.constraint(equalTo: exchangeButtonContainerView.trailingAnchor).isActive = true
        exchangeButtonInnerLightView.topAnchor.constraint(equalTo: exchangeButtonContainerView.topAnchor, constant: -30).isActive = true
        exchangeButtonInnerLightView.leadingAnchor.constraint(equalTo: exchangeButtonContainerView.leadingAnchor, constant: -30).isActive = true
        
        exchangeButtonContainerView.addSubview(exchangeButton)
        exchangeButton.topAnchor.constraint(equalTo: exchangeButtonContainerView.topAnchor, constant: viewWidth * 0.02).isActive = true
        exchangeButton.leadingAnchor.constraint(equalTo: exchangeButtonContainerView.leadingAnchor, constant: viewWidth * 0.02).isActive = true
        exchangeButton.trailingAnchor.constraint(equalTo: exchangeButtonContainerView.trailingAnchor, constant: -viewWidth * 0.02).isActive = true
        exchangeButton.bottomAnchor.constraint(equalTo: exchangeButtonContainerView.bottomAnchor, constant: -viewWidth * 0.02).isActive = true
        
        exchangeButtonContainerView.layer.cornerRadius =  viewWidth * 0.12 / 2
        exchangeButtonOutterLightView.layer.cornerRadius = viewWidth * 0.12 / 2
        exchangeButtonOutterDarkView.layer.cornerRadius = viewWidth * 0.12 / 2
        exchangeButtonInnerLightView.cornerRadius = viewWidth * 0.12 / 2
        exchangeButtonInnerDarkView.cornerRadius = viewWidth * 0.12 / 2

        targetLanguageView.addSubview(targetLanguageButtonContainerView)
        targetLanguageButtonContainerView.topAnchor.constraint(equalTo: targetLanguageView.topAnchor, constant: 20).isActive = true
        targetLanguageButtonContainerView.bottomAnchor.constraint(equalTo: targetLanguageView.bottomAnchor).isActive = true
        targetLanguageButtonContainerView.leadingAnchor.constraint(equalTo: targetLanguageView.leadingAnchor, constant: 25).isActive = true
        targetLanguageButtonContainerView.trailingAnchor.constraint(equalTo: targetLanguageView.trailingAnchor, constant: -20).isActive = true
        
        targetLanguageButtonContainerView.addSubview(targetLanguageButtonOutterDarkView)
        targetLanguageButtonOutterDarkView.edgeTo(targetLanguageButtonContainerView)
        
        targetLanguageButtonContainerView.addSubview(targetLanguageButtonOutterLightView)
        targetLanguageButtonOutterLightView.edgeTo(targetLanguageButtonContainerView)
        
        targetLanguageButtonContainerView.addSubview(targetLanguageButtonInnerDarkView)
        targetLanguageButtonInnerDarkView.topAnchor.constraint(equalTo: targetLanguageButtonContainerView.topAnchor).isActive = true
        targetLanguageButtonInnerDarkView.leadingAnchor.constraint(equalTo: targetLanguageButtonContainerView.leadingAnchor).isActive = true
        targetLanguageButtonInnerDarkView.bottomAnchor.constraint(equalTo: targetLanguageButtonContainerView.bottomAnchor, constant: 20).isActive = true
        targetLanguageButtonInnerDarkView.trailingAnchor.constraint(equalTo: targetLanguageButtonContainerView.trailingAnchor, constant: 20).isActive = true
        
        targetLanguageButtonContainerView.addSubview(targetLanguageButtonInnerLightView)
        targetLanguageButtonInnerLightView.bottomAnchor.constraint(equalTo: targetLanguageButtonContainerView.bottomAnchor).isActive = true
        targetLanguageButtonInnerLightView.trailingAnchor.constraint(equalTo: targetLanguageButtonContainerView.trailingAnchor).isActive = true
        targetLanguageButtonInnerLightView.topAnchor.constraint(equalTo: targetLanguageButtonContainerView.topAnchor, constant: -20).isActive = true
        targetLanguageButtonInnerLightView.leadingAnchor.constraint(equalTo: targetLanguageButtonContainerView.leadingAnchor, constant: -20).isActive = true
        
        targetLanguageButtonContainerView.addSubview(targetLanguageButton)
        targetLanguageButton.edgeTo(targetLanguageButtonContainerView)

        if languagePickerType == .targetLanguage {
            sourceLanguageView.isHidden = true
            exchangeButtonView.isHidden = true
        }
        
        sourceInputView.VStack(clearButtonContainerView.setHeight(viewHeight * 0.035),
                               sourceInputTextView,
                               spacing: 0,
                               alignment: .fill,
                               distribution: .fill)
        
        clearButtonContainerView.addSubview(clearButton)
        clearButton.topAnchor.constraint(equalTo: clearButtonContainerView.topAnchor).isActive = true
        clearButton.bottomAnchor.constraint(equalTo: clearButtonContainerView.bottomAnchor).isActive = true
        clearButton.trailingAnchor.constraint(equalTo: clearButtonContainerView.trailingAnchor, constant: -20).isActive = true
        
        sourceInputTextView.addSubview(sourceInputText)
        sourceInputText.leadingAnchor.constraint(equalTo: sourceInputTextView.leadingAnchor, constant: 20).isActive = true
        sourceInputText.trailingAnchor.constraint(equalTo: sourceInputTextView.trailingAnchor, constant: -20).isActive = true
        sourceInputText.topAnchor.constraint(equalTo: sourceInputTextView.topAnchor).isActive = true
        sourceInputText.bottomAnchor.constraint(equalTo: sourceInputTextView.bottomAnchor, constant: -10).isActive = true
        
        translateButtonView.addSubview(translateButtonContainerView)
        translateButtonContainerView.centerInSuperview()
        translateButtonContainerView.heightAnchor.constraint(equalToConstant: viewHeight * 0.075).isActive = true
        translateButtonContainerView.widthAnchor.constraint(equalToConstant: viewWidth * 0.75).isActive = true
        
        translateButtonContainerView.addSubview(translateButtonOutterDarkView)
        translateButtonOutterDarkView.edgeTo(translateButtonContainerView)
        
        translateButtonContainerView.addSubview(translateButtonOutterLightView)
        translateButtonOutterLightView.edgeTo(translateButtonContainerView)
        
        translateButtonContainerView.addSubview(translateButtonInnerDarkView)
        translateButtonInnerDarkView.topAnchor.constraint(equalTo: translateButtonContainerView.topAnchor).isActive = true
        translateButtonInnerDarkView.leadingAnchor.constraint(equalTo: translateButtonContainerView.leadingAnchor).isActive = true
        translateButtonInnerDarkView.bottomAnchor.constraint(equalTo: translateButtonContainerView.bottomAnchor, constant: viewHeight * 0.075 / 2).isActive = true
        translateButtonInnerDarkView.trailingAnchor.constraint(equalTo: translateButtonContainerView.trailingAnchor, constant: viewHeight * 0.075 / 2).isActive = true
        
        translateButtonContainerView.addSubview(translateButtonInnerLightView)
        translateButtonInnerLightView.bottomAnchor.constraint(equalTo: translateButtonContainerView.bottomAnchor).isActive = true
        translateButtonInnerLightView.trailingAnchor.constraint(equalTo: translateButtonContainerView.trailingAnchor).isActive = true
        translateButtonInnerLightView.topAnchor.constraint(equalTo: translateButtonContainerView.topAnchor, constant: -viewHeight * 0.075 / 2).isActive = true
        translateButtonInnerLightView.leadingAnchor.constraint(equalTo: translateButtonContainerView.leadingAnchor, constant: -viewHeight * 0.075 / 2).isActive = true
        
        translateButtonContainerView.addSubview(translateButton)
        translateButton.topAnchor.constraint(equalTo: translateButtonContainerView.topAnchor, constant: viewWidth * 0.02).isActive = true
        translateButton.leadingAnchor.constraint(equalTo: translateButtonContainerView.leadingAnchor, constant: viewWidth * 0.02).isActive = true
        translateButton.trailingAnchor.constraint(equalTo: translateButtonContainerView.trailingAnchor, constant: -viewWidth * 0.02).isActive = true
        translateButton.bottomAnchor.constraint(equalTo: translateButtonContainerView.bottomAnchor, constant: -viewWidth * 0.02).isActive = true
        
        translateButtonContainerView.layer.cornerRadius =  viewHeight * 0.075 / 2
        translateButtonOutterLightView.layer.cornerRadius = viewHeight * 0.075 / 2
        translateButtonOutterDarkView.layer.cornerRadius = viewHeight * 0.075 / 2
        translateButtonInnerLightView.cornerRadius = viewHeight * 0.075 / 2
        translateButtonInnerDarkView.cornerRadius = viewHeight * 0.075 / 2
        
        targetOutputView.VStack(outputActionView.setHeight(viewHeight * 0.035),
                                outputTextView,
                                spacing: 0,
                                alignment: .fill,
                                distribution: .fill)
        
        outputActionView.hstack(spacerView,
                                copyTextButton,
                                speechButton,
                                starButton,
                                spacing: 10,
                                alignment: .fill,
                                distribution: .fill).padRight(20).padLeft(20)

        starButton.widthAnchor.constraint(equalTo: starButton.heightAnchor).isActive = true
        speechButton.widthAnchor.constraint(equalTo: speechButton.heightAnchor).isActive = true
        copyTextButton.widthAnchor.constraint(equalTo: copyTextButton.heightAnchor).isActive = true

        outputTextView.addSubview(targetOutputText)
        targetOutputText.topAnchor.constraint(equalTo: outputTextView.topAnchor).isActive = true
        targetOutputText.leadingAnchor.constraint(equalTo: outputTextView.leadingAnchor, constant: 20).isActive = true
        targetOutputText.trailingAnchor.constraint(equalTo: outputTextView.trailingAnchor, constant: -20).isActive = true
        targetOutputText.bottomAnchor.constraint(equalTo: outputTextView.bottomAnchor, constant: -20).isActive = true
    }

    override func viewDidLoad() {
        super.viewDidLoad()

        setUpCloudKit()
        translatedCharactersCurrentMonth = UserDefaults.standard.integer(forKey: Constants.translatedCharactersCountKey)
        
        savedTranslations = realm.objects(SavedTranslation.self)
        
        setUpViewsAndButtons()
        setUpKeyboardToolBar()
        sourceInputText.delegate = self
        
        navigationItem.rightBarButtonItem = UIBarButtonItem(barButtonSystemItem: .done, target: self, action: #selector(doneButtonTapped))
        
        NotificationCenter.default.addObserver(forName: .savedTranlationsDidShow, object: nil, queue: .main) { (notification) in
            self.starBadgeNum = 0
        }
        
        NotificationCenter.default.addObserver(forName: .firstSavedTranslationDeleted, object: nil, queue: .main) { (notification) in
            self.starButton.setImage(UIImage(systemName: "star"), for: .normal)
            self.starButton.tintColor = .systemBlue
            self.isStarButtonTapped = false
        }
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        
        if defaultSourceLanguageIndex != UserDefaults.standard.integer(forKey: Constants.textSourceLanguageIndexKey) {
            temporarySourceLanguageGCPIndex = UserDefaults.standard.integer(forKey: Constants.textSourceLanguageIndexKey)
            defaultSourceLanguageIndex = temporarySourceLanguageGCPIndex
            
            let sourceLanguage = SupportedLanguages.gcpLanguageList[temporarySourceLanguageGCPIndex]
            sourceLanguageButton.setTitle(sourceLanguage, for: .normal)
            print("defaultSourceLanguageIndex changed")
        }
        
        if defaultTargetLanguageIndex != UserDefaults.standard.integer(forKey: Constants.textTargetLanguageIndexKey) {
            temporaryTargetLanguageGCPIndex = UserDefaults.standard.integer(forKey: Constants.textTargetLanguageIndexKey)
            defaultTargetLanguageIndex = temporaryTargetLanguageGCPIndex

            let targetLanguage = SupportedLanguages.gcpLanguageList[temporaryTargetLanguageGCPIndex]
            targetLanguageButton.setTitle(targetLanguage, for: .normal)
            print("defaultTargetLanguageIndex changed")
        }
        
        let titleInfo = ["title" : "Text"]
        NotificationCenter.default.post(name: .translationViewControllerDidChange, object: nil, userInfo: titleInfo)
    }
    
    func setUpCloudKit() {
        CloudKitManager.isCountRecordEmpty { (isEmpty) in
            if isEmpty {
                CloudKitManager.initializeCloudDatabase()
            } else {
                CloudKitManager.queryCloudDatabaseCountData { (result, error) in
                    if let result = result {
                        self.cloudDBTranslatedCharacters = result
                        print("cloudDBTranslatedCharacters is \(result)")
                    } else {
                        print("queryCloudDatabaseCountData error \(error!.localizedDescription)")
                    }
                }
            }
        }
    }
    
    func setUpViewsAndButtons() {
        let sourceLanguage = SupportedLanguages.gcpLanguageList[temporarySourceLanguageGCPIndex]
        let targetLanguage = SupportedLanguages.gcpLanguageList[temporaryTargetLanguageGCPIndex]
        sourceLanguageButton.setTitle(sourceLanguage, for: .normal)
        sourceLanguageButton.addTarget(self, action: #selector(sourceLanguageButtonTouchDown), for: .touchDown)
        sourceLanguageButton.addTarget(self, action: #selector(sourceLanguageButtonTouchUpInside), for: .touchUpInside)
        targetLanguageButton.setTitle(targetLanguage, for: .normal)
        targetLanguageButton.addTarget(self, action: #selector(targetLanguageButtonTouchDown), for: .touchDown)
        targetLanguageButton.addTarget(self, action: #selector(targetLanguageButtonTouchUpInside), for: .touchUpInside)
        translateButton.addTarget(self, action: #selector(translateButtonTouchDown), for: .touchDown)
        translateButton.addTarget(self, action: #selector(translateButtonTouchUpInside), for: .touchUpInside)
        exchangeButton.addTarget(self, action: #selector(exchangeButtonTouchDown), for: .touchDown)
        exchangeButton.addTarget(self, action: #selector(exchangeButtonTouchUpInside), for: .touchUpInside)
        
        sourceLanguageButtonInnerLightView.isHidden = true
        sourceLanguageButtonInnerDarkView.isHidden = true
        targetLanguageButtonInnerLightView.isHidden = true
        targetLanguageButtonInnerDarkView.isHidden = true
        exchangeButtonInnerLightView.isHidden = true
        exchangeButtonInnerDarkView.isHidden = true
        translateButtonInnerLightView.isHidden = true
        translateButtonInnerDarkView.isHidden = true

        clearButton.addTarget(self, action: #selector(clearText), for: .touchUpInside)
        starButton.addTarget(self, action: #selector(starButtonTapped), for: .touchUpInside)
        speechButton.addTarget(self, action: #selector(speechButtonTapped), for: .touchUpInside)
        copyTextButton.addTarget(self, action: #selector(copyTranslatedText), for: .touchUpInside)
        
        clearButton.isHidden = true
        outputActionView.isHidden = true //outputActionView = clearButton + starButton + copyTextButton
        targetOutputText.isHidden = true
    }
    
    func setUpKeyboardToolBar() {
        let bar = UIToolbar()
        let dismissItem = UIBarButtonItem(title: "Dismiss", style: .plain, target: self, action: #selector(dismissKeyboard))
        let spacer = UIBarButtonItem(barButtonSystemItem: .flexibleSpace, target: nil, action: nil)
        let translateItem = UIBarButtonItem(title: "Translate", style: .plain, target: self, action: #selector(doTranslate))
        bar.items = [dismissItem, spacer, translateItem]
        bar.sizeToFit()
        sourceInputText.inputAccessoryView = bar
    }
    
    
    // MARK: - UIButton Implementation
    @objc func doneButtonTapped() {
        dismiss(animated: true, completion: nil)
    }
    
    @objc func sourceLanguageButtonTouchDown() {
        sourceLanguageButtonOutterDarkView.isHidden = true
        sourceLanguageButtonOutterLightView.isHidden = true
        sourceLanguageButtonInnerDarkView.isHidden = false
        sourceLanguageButtonInnerLightView.isHidden = false
        
        sourceLanguageButtonContainerView.layer.masksToBounds = true
    }
    
    @objc func sourceLanguageButtonTouchUpInside() {
        sourceLanguageButtonOutterDarkView.isHidden = false
        sourceLanguageButtonOutterLightView.isHidden = false
        sourceLanguageButtonInnerDarkView.isHidden = true
        sourceLanguageButtonInnerLightView.isHidden = true
        
        sourceLanguageButtonContainerView.layer.masksToBounds = false
        
        selectLanguage()
    }
    
    @objc func targetLanguageButtonTouchDown() {
        targetLanguageButtonOutterDarkView.isHidden = true
        targetLanguageButtonOutterLightView.isHidden = true
        targetLanguageButtonInnerDarkView.isHidden = false
        targetLanguageButtonInnerLightView.isHidden = false
        
        targetLanguageButtonContainerView.layer.masksToBounds = true
    }
    
    @objc func targetLanguageButtonTouchUpInside() {
        targetLanguageButtonOutterDarkView.isHidden = false
        targetLanguageButtonOutterLightView.isHidden = false
        targetLanguageButtonInnerDarkView.isHidden = true
        targetLanguageButtonInnerLightView.isHidden = true
        
        targetLanguageButtonContainerView.layer.masksToBounds = false

        selectLanguage()
    }
    
    @objc func exchangeButtonTouchDown() {
        exchangeButtonOutterDarkView.isHidden = true
        exchangeButtonOutterLightView.isHidden = true
        exchangeButtonInnerDarkView.isHidden = false
        exchangeButtonInnerLightView.isHidden = false
        
        exchangeButtonContainerView.layer.masksToBounds = true
    }
    
    @objc func exchangeButtonTouchUpInside() {
        exchangeButtonOutterDarkView.isHidden = false
        exchangeButtonOutterLightView.isHidden = false
        exchangeButtonInnerDarkView.isHidden = true
        exchangeButtonInnerLightView.isHidden = true
        
        exchangeButtonContainerView.layer.masksToBounds = false
        
        exchangeLanguage()
    }
    
    @objc func translateButtonTouchDown() {
        translateButtonOutterDarkView.isHidden = true
        translateButtonOutterLightView.isHidden = true
        translateButtonInnerDarkView.isHidden = false
        translateButtonInnerLightView.isHidden = false
        
        translateButtonContainerView.layer.masksToBounds = true
    }
    
    @objc func translateButtonTouchUpInside() {
        translateButtonOutterDarkView.isHidden = false
        translateButtonOutterLightView.isHidden = false
        translateButtonInnerDarkView.isHidden = true
        translateButtonInnerLightView.isHidden = true
        
        translateButtonContainerView.layer.masksToBounds = false
        
        doTranslate()
    }
    
    func selectLanguage() {
        //present picker view modal
        let viewController = LanguagePickerViewController()
        viewController.sourceLanguageRow = temporarySourceLanguageGCPIndex
        viewController.targetLanguageRow = temporaryTargetLanguageGCPIndex
        viewController.languagePickerType = self.languagePickerType
        viewController.delegate = self
        let navController = UINavigationController(rootViewController: viewController)
        
        self.navigationController?.present(navController, animated: true, completion: nil)
    }
    
    func exchangeLanguage() {
        
        guard let exchangeText = targetLanguageButton.titleLabel?.text,
            let sourceLanguage = sourceLanguageButton.titleLabel?.text else { return }
        
        /*
        Animating exchangeButton to rotate 90 degree anti-clockwise
         - rotate exchangeButton for 45 degree anti-clockwise
         - when first animation is done, make another animation rotating exchangeButton for another 45 degree anti-clockwise
         - when all the animations are done(succeed), change the uiview back to .identity(the uiview before animations)
         * rotate a view for 90 degree anti-clockwise at one time is not supportted
         ** reference: https://stackoverflow.com/questions/39045122/rotating-a-uibutton-by-90-degrees-every-time-the-button-is-clicked
             https://developer.apple.com/documentation/coregraphics/cgaffinetransform/1455666-init
             https://developer.apple.com/documentation/coregraphics/cgaffinetransform/1455962-rotated
         
         UIView.animate(withDuration: 0.5, animations: {
             self.exchangeButton.transform = CGAffineTransform(rotationAngle: -CGFloat.pi / 2)
             self.exchangeButton.transform = self.exchangeButton.transform.rotated(by: -CGFloat.pi / 2)
         }) { (succeed) in
             self.exchangeButton.transform = .identity
             self.targetLanguageButton.setTitle(sourceLanguage, for: .normal)
             self.sourceLanguageButton.setTitle(exchangeText, for: .normal)
         }
        */
        
        UIView.animate(withDuration: 0.5, animations: {
            self.exchangeButton.transform = self.exchangeButton.transform.rotated(by: CGFloat.pi)
            //rotate exchangeButton by 90 degrees every time exchangeButton is clicked
            //reference: https://stackoverflow.com/questions/39045122/rotating-a-uibutton-by-90-degrees-every-time-the-button-is-clicked
        }) { (succeed) in
            self.targetLanguageButton.setTitle(sourceLanguage, for: .normal)
            self.sourceLanguageButton.setTitle(exchangeText, for: .normal)
        }
        
        swap(&temporarySourceLanguageGCPIndex, &temporaryTargetLanguageGCPIndex)
        
        print("exchange button pressed.")
    }
    
    @objc func clearText() {
        sourceInputText.text = ""
        
        clearButton.isHidden = true
        outputActionView.isHidden = true
        targetOutputText.isHidden = true
        
        sourceInputText.resignFirstResponder()
    }
    
    @objc func dismissKeyboard() {
        sourceInputText.resignFirstResponder()
    }
    
    @objc func doTranslate() {
        print("do translate")
        sourceInputText.resignFirstResponder()
        
        starButton.setImage(UIImage(systemName: "star"), for: .normal)
        starButton.tintColor = .systemBlue
        isStarButtonTapped = false
        
        guard let raw = UserDefaults.standard.string(forKey: Constants.userTypeKey) else { return }
        let userType = UserType(rawValue: raw)!
        print(userType)
        
        guard let text = sourceInputText.text else { return }
        if text.isEmpty {
            print("text is empty")
            SPAlert.present(message: "Empty text")
        } else {
            
            if userType == .guestUser && isTranslateTypeNeedPro == true {
                let viewController = PurchasePageViewController()
                viewController.modalPresentationStyle = .automatic
                present(viewController, animated: true, completion: nil)
            } else {
                if isTranslatePossible(userType: userType) {
                    performTranslate()
                    translatedCharactersCurrentMonth += text.count
                    cloudDBTranslatedCharacters += text.count
                    
                    let updatedCount = translatedCharactersCurrentMonth >= cloudDBTranslatedCharacters ? translatedCharactersCurrentMonth : cloudDBTranslatedCharacters
                    print("updatedCount is \(updatedCount)")
                    
                    UserDefaults.standard.set(updatedCount, forKey: Constants.translatedCharactersCountKey)
                    
                    CloudKitManager.updateCountData(to: updatedCount)
                    
                } else {
                    print("Here is the limit, pay more money!")
                    let alert = PMAlertController(title: "Translate character has reach the limit", description: "You can change your plan and get more characters", image: UIImage(named: "reading2"), style: .alert)
                    let cancelAction = PMAlertAction(title: "Not now", style: .cancel)
                    let defaultAction = PMAlertAction(title: "See more plans", style: .default) {
                        let viewController = AccountViewController()
                        let navController = UINavigationController(rootViewController: viewController)
                        self.present(navController, animated: true, completion: nil)
                    }
                    alert.addAction(cancelAction)
                    alert.addAction(defaultAction)
                    present(alert, animated: true, completion: nil)
                }
            }
        }
    }
    
    func isTranslatePossible(userType: UserType) -> Bool {
        if userType == .tenKUser && translatedCharactersCurrentMonth <= 10_000 {// the limits should be fetched from Firestore
            print("translate ok")
            return true
        } else if userType == .fiftyKUser && translatedCharactersCurrentMonth <= 50_000 {
            print("translate ok")
            return true
        } else if userType == .noLimitUset {
            print("translate ok")
            return true
        } else if userType == .guestUser && translatedCharactersCurrentMonth <= 10_000 {
            print("translate ok")
            return true
        } else {
            print("here's the limit")
            return false
        }
    }
    
    func performTranslate() {
        guard let textToTranslate = sourceInputText.text,
            let sourceLanguage = sourceLanguageButton.titleLabel?.text,
            let targetLanguage = targetLanguageButton.titleLabel?.text else { return }
        let sourceLanguageCode = SupportedLanguages.gcpLanguageCode[temporarySourceLanguageGCPIndex]
        let targetLanguageCode = SupportedLanguages.gcpLanguageCode[temporaryTargetLanguageGCPIndex]

        if sourceLanguage == targetLanguage {
            let alert = PMAlertController(title: "Error",
                                          description: "You cannot translate \(sourceLanguage) to \(targetLanguage)",
                                          image: UIImage(named: "error"),
                                          style: .alert)
            let defaultAction = PMAlertAction(title: "Change language", style: .default)
            alert.addAction(defaultAction)
            present(alert, animated: true, completion: nil)
        } else {
            if isOfflineTranslateAvailable(from: sourceLanguage, to: targetLanguage) {
                performFBOfflineTranslate(from: sourceLanguage, to: targetLanguage, for: textToTranslate)
            } else {
                performGoogleCloudTranslate(from: sourceLanguageCode, to: targetLanguageCode, for: textToTranslate)
            }            
        }
    }
    
    func isOfflineTranslateAvailable(from sourceLanguage: String, to targetLanguage: String) -> Bool {
        return FBOfflineTranslate.isTranslationPairSupportedByFBOfflineTranslate(from: sourceLanguage, to: targetLanguage) &&
            FBOfflineTranslate.isTranslateLanguageModelDownloaded(for: sourceLanguage) &&
            FBOfflineTranslate.isTranslateLanguageModelDownloaded(for: targetLanguage)
    }
    
    func performFBOfflineTranslate(from sourceLanguage: String, to targetLanguage: String, for textToTranslate: String) {
        guard let fbTranslator = FBOfflineTranslate.generateFBTranslator(from: sourceLanguage, to: targetLanguage) else { return }
        fbTranslator.translate(textToTranslate) { (translatedText, error) in
            if let result = translatedText {
                self.showResult(result: result)
                print("the FB translation is \(result)")
            } else {
                print(error!.localizedDescription)
                SPAlert.present(title: "Error",
                                message: error?.localizedDescription,
                                image: UIImage(systemName: "exclamationmark.triangle")!)
            }
        }
    }
    
    func performGoogleCloudTranslate(from sourceLanguage: String, to targetLanguage: String, for textToTranslate: String) {
        GoogleCloudTranslate.textTranslate(sourceLanguage: sourceLanguage, targetLanguage: targetLanguage, textToTranslate: textToTranslate) { (translatedText, error) in
            if let result = translatedText {
                self.showResult(result: result)
                print("the GCP translation is \(result)")
            } else {
                print(error!.localizedDescription)
                SPAlert.present(title: "Error",
                                message: error?.localizedDescription,
                                image: UIImage(systemName: "exclamationmark.triangle")!)
            }
        }
    }
    
    func showResult(result: String) {
        isStarButtonTapped = false
        
        let targetLanguage = SupportedLanguages.gcpLanguageList[temporaryTargetLanguageGCPIndex]
        if SupportedLanguages.speechRecognizerSupportedLanguage.firstIndex(of: targetLanguage) != nil {
            speechButton.isHidden = false
        } else {
            speechButton.isHidden = true
        }
        outputActionView.isHidden = false
        
        targetOutputText.isHidden = false
        targetOutputText.text = result
    }
    
    @objc func starButtonTapped() {
        isStarButtonTapped = !isStarButtonTapped
        if isStarButtonTapped {
            starButton.setImage(UIImage(systemName: "star.fill"), for: .normal)
            starButton.tintColor = .systemYellow
            
            SPAlert.present(title: "Translation saved",
                            message: nil,
                            image: UIImage(systemName: "star.fill")!)
            
            let savedTranslation = SavedTranslation()
            savedTranslation.sourceLanguage = SupportedLanguages.gcpLanguageList[temporarySourceLanguageGCPIndex]
            savedTranslation.sourceText = sourceInputText.text
            savedTranslation.targetLanguage = SupportedLanguages.gcpLanguageList[temporaryTargetLanguageGCPIndex]
            savedTranslation.targetText = targetOutputText.text
            savedTranslation.dateCreated = Date()
            
            do {
                try realm.write {
                    realm.add(savedTranslation)
                }
            } catch {
                print("Error adding item, \(error)")
                SPAlert.present(title: "Error",
                                message: error.localizedDescription,
                                image: UIImage(systemName: "exclamationmark.triangle")!)
            }
//
//            let vc = SavedTranslationsTableViewController()
//            vc.tableView.reloadData()
            
            if let tabBarItems = tabBarController?.tabBar.items {
                let tabItem = tabBarItems[1]
                starBadgeNum += 1
                tabItem.badgeValue = "\(starBadgeNum)"
                print("badge + 1")
                print(tabBarItems.count)
                print(starBadgeNum)
            }
            
        } else {
            starButton.setImage(UIImage(systemName: "star"), for: .normal)
            starButton.tintColor = .systemBlue
            
            SPAlert.present(title: "Removed",
                            message: nil,
                            image: UIImage(systemName: "star.slash.fill")!)
            
            if let tabBarItems = tabBarController?.tabBar.items {
                let tabItem = tabBarItems[1]
                if starBadgeNum > 1 {
                    starBadgeNum -= 1
                    tabItem.badgeValue = "\(starBadgeNum)"
                    print("badge - 1")
                } else {
                    tabItem.badgeValue = nil
                    if starBadgeNum > 0 {
                        starBadgeNum -= 1                        
                    }
                }
            }
            
            if let savedTranslation = savedTranslations.last {
                do {
                    try realm.write {
                        realm.delete(savedTranslation)
                    }
                } catch {
                    print("Error deleting item, \(error)")
                }
            }
        }
        
        print("star button tapped.")
        
    }
    
    @objc func speechButtonTapped() {
        //Siri speech
        let targetLanguage = SupportedLanguages.gcpLanguageList[temporaryTargetLanguageGCPIndex]
        guard let index = SupportedLanguages.speechRecognizerSupportedLanguage.firstIndex(of: targetLanguage) else { return }

        let utterance = AVSpeechUtterance(string: targetOutputText.text)
        let speechCode = SupportedLanguages.speechRecognizerSupportedLocaleIdentifier[index]
        let synthesizer = AVSpeechSynthesizer()
        utterance.voice = AVSpeechSynthesisVoice(language: speechCode)
        utterance.rate = AVSpeechUtteranceDefaultSpeechRate
        synthesizer.speak(utterance)
        
        print("speechCode is \(speechCode)")
    }
    
    @objc func copyTranslatedText() {
        let pasteboard = UIPasteboard.general
        pasteboard.string = targetOutputText.text
        
        SPAlert.present(title: "Copied to clipboard",
                        message: nil,
                        image: UIImage(systemName: "doc.on.clipboard.fill")!)
    }

}


// MARK: - Extensions
extension TextTranslateViewController: UITextViewDelegate {
    func textViewDidChange(_ textView: UITextView) {
        clearButton.isHidden = false
    }
    
    func textViewDidEndEditing(_ textView: UITextView) {
        if sourceInputText.text == "" {
            clearButton.isHidden = true
        }
    }
}

extension TextTranslateViewController: LanguagePickerDelegate {
    func didSelectedLanguagePicker(temporarySourceLanguageGCPIndex: Int, temporaryTargetLanguageGCPIndex: Int) {
        if temporaryTargetLanguageGCPIndex != self.temporaryTargetLanguageGCPIndex {
            outputActionView.isHidden = true
        }
        
        let sourceLanguage = SupportedLanguages.gcpLanguageList[temporarySourceLanguageGCPIndex]
        let targetLanguage = SupportedLanguages.gcpLanguageList[temporaryTargetLanguageGCPIndex]
        sourceLanguageButton.setTitle(sourceLanguage, for: .normal)
        targetLanguageButton.setTitle(targetLanguage, for: .normal)
        self.temporarySourceLanguageGCPIndex = temporarySourceLanguageGCPIndex
        self.temporaryTargetLanguageGCPIndex = temporaryTargetLanguageGCPIndex
    }
    
    
}

