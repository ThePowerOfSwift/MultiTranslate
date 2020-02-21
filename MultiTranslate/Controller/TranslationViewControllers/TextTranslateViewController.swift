//
//  TextTranslateViewController.swift
//  MultiTranslate
//
//  Created by Keishin CHOU on 2020/01/06.
//  Copyright © 2020 Keishin CHOU. All rights reserved.
//

import AVFoundation
import UIKit

import PMSuperButton
import Alamofire
import SwiftyJSON
//import RAMAnimatedTabBarController
import KMPlaceholderTextView
import RealmSwift

class TextTranslateViewController: UIViewController {
    
    //MARK: - Variables and Constants
    var temporarySourceLanguageGCPIndex = UserDefaults.standard.integer(forKey: Constants.textSourceLanguageIndexKey)
    var temporaryTargetLanguageGCPIndex = UserDefaults.standard.integer(forKey: Constants.textTargetLanguageIndexKey)
    var defaultSourceLanguageIndex = UserDefaults.standard.integer(forKey: Constants.textSourceLanguageIndexKey)
    var defaultTargetLanguageIndex = UserDefaults.standard.integer(forKey: Constants.textTargetLanguageIndexKey)
    
    var languagePickerType: LanguagePickerType = .textTranslate
    
    private var isStarButtonTapped: Bool = false
    
    private var translatedCharactersCurrentMonth = 0
    
    private let realm = try! Realm()
    private var savedTranslations: Results<SavedTranslation>!
    
    private var cloudDBTranslatedCharacters = 0
    
    
    //MARK: - UI Parts Declaration
    
    private let container: UIView = {
        let view = UIView()
        view.translatesAutoresizingMaskIntoConstraints = false
        view.backgroundColor = UIColor(rgb: 0xC1D2EB)
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
        view.backgroundColor = UIColor(rgb: 0xC1D2EB)
        view.layer.cornerRadius = 20
        return view
    }()
    
    private let sourceLanguageButtonOutterLightView: UIView = {
        let view = UIView()
        view.translatesAutoresizingMaskIntoConstraints = false
        view.backgroundColor = UIColor(rgb: 0xC1D2EB)
        
        view.layer.cornerRadius = 20
        view.layer.masksToBounds = false
        
        view.layer.shadowColor = UIColor.white.cgColor
        view.layer.shadowOpacity = 0.5
        view.layer.shadowOffset = CGSize(width: -5, height: -5)
        view.layer.shadowRadius = 5
        
        return view
    }()
    
    private let sourceLanguageButtonOutterDarkView: UIView = {
        let view = UIView()
        view.translatesAutoresizingMaskIntoConstraints = false
        view.backgroundColor = UIColor(rgb: 0xC1D2EB)
        
        view.layer.cornerRadius = 20
        view.layer.masksToBounds = false
        
        view.layer.shadowColor = UIColor.black.cgColor
        view.layer.shadowOpacity = 0.2
        view.layer.shadowOffset = CGSize(width: 5, height: 5)
        view.layer.shadowRadius = 5
        
        return view
    }()
    
    private let sourceLanguageButtonInnerLightView: SwiftyInnerShadowView = {
        let view = SwiftyInnerShadowView()
        view.translatesAutoresizingMaskIntoConstraints = false

        view.shadowLayer.shadowRadius = 10
        view.shadowLayer.shadowColor = UIColor.white.cgColor
        view.shadowLayer.shadowOpacity = 1
        view.shadowLayer.shadowOffset = CGSize.zero
        view.cornerRadius = 20
        
        return view
    }()
    
    private let sourceLanguageButtonInnerDarkView: SwiftyInnerShadowView = {
        let view = SwiftyInnerShadowView()
        view.translatesAutoresizingMaskIntoConstraints = false

        view.shadowLayer.shadowRadius = 5
        view.shadowLayer.shadowColor = UIColor.black.cgColor
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
        view.backgroundColor = UIColor(rgb: 0xC1D2EB)
        view.layer.cornerRadius = 20
        return view
    }()
    
    private let exchangeButtonOutterLightView: UIView = {
        let view = UIView()
        view.translatesAutoresizingMaskIntoConstraints = false
        view.backgroundColor = UIColor(rgb: 0xC1D2EB)
        
        view.layer.cornerRadius = 20
        view.layer.masksToBounds = false
        
        view.layer.shadowColor = UIColor.white.cgColor
        view.layer.shadowOpacity = 0.5
        view.layer.shadowOffset = CGSize(width: -5, height: -5)
        view.layer.shadowRadius = 5
        
        return view
    }()
    
    private let exchangeButtonOutterDarkView: UIView = {
        let view = UIView()
        view.translatesAutoresizingMaskIntoConstraints = false
        view.backgroundColor = UIColor(rgb: 0xC1D2EB)
        
        view.layer.cornerRadius = 20
        view.layer.masksToBounds = false
        
        view.layer.shadowColor = UIColor.black.cgColor
        view.layer.shadowOpacity = 0.2
        view.layer.shadowOffset = CGSize(width: 5, height: 5)
        view.layer.shadowRadius = 5
        
        return view
    }()
    
    private let exchangeButtonInnerLightView: SwiftyInnerShadowView = {
        let view = SwiftyInnerShadowView()
        view.translatesAutoresizingMaskIntoConstraints = false

        view.shadowLayer.shadowRadius = 10
        view.shadowLayer.shadowColor = UIColor.white.cgColor
        view.shadowLayer.shadowOpacity = 1
        view.shadowLayer.shadowOffset = CGSize.zero
        view.cornerRadius = 20
        
        return view
    }()
    
    private let exchangeButtonInnerDarkView: SwiftyInnerShadowView = {
        let view = SwiftyInnerShadowView()
        view.translatesAutoresizingMaskIntoConstraints = false

        view.shadowLayer.shadowRadius = 5
        view.shadowLayer.shadowColor = UIColor.black.cgColor
        view.shadowLayer.shadowOpacity = 0.5
        view.shadowLayer.shadowOffset = CGSize.zero
        view.cornerRadius = 20
        
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
        view.backgroundColor = UIColor(rgb: 0xC1D2EB)
        view.layer.cornerRadius = 20
        return view
    }()
    
    private let targetLanguageButtonOutterLightView: UIView = {
        let view = UIView()
        view.translatesAutoresizingMaskIntoConstraints = false
        view.backgroundColor = UIColor(rgb: 0xC1D2EB)
        
        view.layer.cornerRadius = 20
        view.layer.masksToBounds = false
        
        view.layer.shadowColor = UIColor.white.cgColor
        view.layer.shadowOpacity = 0.5
        view.layer.shadowOffset = CGSize(width: -5, height: -5)
        view.layer.shadowRadius = 5
        
        return view
    }()
    
    private let targetLanguageButtonOutterDarkView: UIView = {
        let view = UIView()
        view.translatesAutoresizingMaskIntoConstraints = false
        view.backgroundColor = UIColor(rgb: 0xC1D2EB)
        
        view.layer.cornerRadius = 20
        view.layer.masksToBounds = false
        
        view.layer.shadowColor = UIColor.black.cgColor
        view.layer.shadowOpacity = 0.2
        view.layer.shadowOffset = CGSize(width: 5, height: 5)
        view.layer.shadowRadius = 5
        
        return view
    }()
    
    private let targetLanguageButtonInnerLightView: SwiftyInnerShadowView = {
        let view = SwiftyInnerShadowView()
        view.translatesAutoresizingMaskIntoConstraints = false

        view.shadowLayer.shadowRadius = 10
        view.shadowLayer.shadowColor = UIColor.white.cgColor
        view.shadowLayer.shadowOpacity = 1
        view.shadowLayer.shadowOffset = CGSize.zero
        view.cornerRadius = 20
        
        return view
    }()
    
    private let targetLanguageButtonInnerDarkView: SwiftyInnerShadowView = {
        let view = SwiftyInnerShadowView()
        view.translatesAutoresizingMaskIntoConstraints = false

        view.shadowLayer.shadowRadius = 5
        view.shadowLayer.shadowColor = UIColor.black.cgColor
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
    
    private let targetOutputView: UIView = {
        let view = UIView()
        view.translatesAutoresizingMaskIntoConstraints = false
        return view
    }()
    
    private let exchangeButton: UIButton = {
        let button = UIButton()
        button.setImage(UIImage(named: "exchange"), for: .normal)
        button.translatesAutoresizingMaskIntoConstraints = false
        button.heightAnchor.constraint(equalToConstant: CGFloat(30)).isActive = true
        button.widthAnchor.constraint(equalTo: button.heightAnchor, multiplier: 1).isActive = true
        return button
    }()
    
    private let clearButton: UIButton = {
        let button = UIButton()
        button.setTitle("Clear", for: .normal)
        button.translatesAutoresizingMaskIntoConstraints = false
        button.setTitleColor(.systemBlue, for: .normal)
        button.setTitleColor(.darkGray, for: .highlighted)
        return button
    }()
    
    private let translateButton: PMSuperButton = {
        let button = PMSuperButton()
        button.borderColor = .white
        button.borderWidth = 2
        button.cornerRadius = 25
//        button.shadowColor = #colorLiteral(red: 0.1764705926, green: 0.4980392158, blue: 0.7568627596, alpha: 1)
        button.shadowOpacity = 1
        button.shadowOffset.width = 1
        button.shadowOffset.height = 1
        button.shadowRadius = 5
        
        button.gradientEnabled = true
        button.gradientStartColor = #colorLiteral(red: 0.9568627477, green: 0.6588235497, blue: 0.5450980663, alpha: 1)
        button.gradientEndColor = #colorLiteral(red: 0.7450980544, green: 0.1568627506, blue: 0.07450980693, alpha: 1)
        button.gradientHorizontal = true
        button.ripple = true
        button.rippleColor = #colorLiteral(red: 0.9880490899, green: 0.7656863332, blue: 0.9337566495, alpha: 0.5442262414)
        
        button.setTitle("Translate", for: .normal)
        button.setTitleColor(.white, for: .normal)
        button.setTitleColor(.gray, for: .highlighted)
        
        button.translatesAutoresizingMaskIntoConstraints = false
        
        return button
    }()
    
    private let sourceLanguageButton: UIButton = {
        let button = UIButton()
        button.translatesAutoresizingMaskIntoConstraints = false
        button.titleLabel?.numberOfLines = 0
        button.titleLabel?.lineBreakMode = .byWordWrapping
        button.titleLabel?.textAlignment = .center
        return button
    }()
    
    private let targetLanguageButton: UIButton = {
        let button = UIButton()
        button.translatesAutoresizingMaskIntoConstraints = false
        button.titleLabel?.numberOfLines = 0
        button.titleLabel?.lineBreakMode = .byWordWrapping
        button.titleLabel?.textAlignment = .center
        return button
    }()
    
    let sourceInputText: KMPlaceholderTextView = {
        let textView = KMPlaceholderTextView()
        textView.backgroundColor = .systemBackground
        textView.placeholder = "Enter text here"
        textView.layer.style = .none
        textView.layer.cornerRadius = 10
        textView.layer.borderColor = UIColor.lightGray.cgColor
        textView.layer.borderWidth = 1
        textView.layer.masksToBounds = true
        textView.translatesAutoresizingMaskIntoConstraints = false
        
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
        button.setImage(UIImage(systemName: "star")?.withTintColor(.systemGray), for: .normal)
//        button.backgroundColor = .white
        return button
    }()
    
    private let speechButton: UIButton = {
        let button = UIButton()
        button.translatesAutoresizingMaskIntoConstraints = false
        button.setImage(UIImage(named: "speech")?.withTintColor(.systemBlue), for: .normal)
//        button.backgroundColor = .white
        
        return button
    }()
    
    private let targetOutputText: UITextView = {
        let textView = UITextView()
        textView.translatesAutoresizingMaskIntoConstraints = false
        textView.font = UIFont.preferredFont(forTextStyle: .title3)
        textView.text = "Hello Blur"
        textView.backgroundColor = .clear
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
                         translateButtonView.setHeight(viewHeight * 0.05),
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
        sourceLanguageButtonContainerView.topAnchor.constraint(equalTo: sourceLanguageView.topAnchor, constant: 25).isActive = true
        sourceLanguageButtonContainerView.bottomAnchor.constraint(equalTo: sourceLanguageView.bottomAnchor).isActive = true
        sourceLanguageButtonContainerView.leadingAnchor.constraint(equalTo: sourceLanguageView.leadingAnchor, constant: 25).isActive = true
        sourceLanguageButtonContainerView.trailingAnchor.constraint(equalTo: sourceLanguageView.trailingAnchor, constant: -20).isActive = true
        
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
        exchangeButtonInnerDarkView.bottomAnchor.constraint(equalTo: exchangeButtonContainerView.bottomAnchor, constant: 20).isActive = true
        exchangeButtonInnerDarkView.trailingAnchor.constraint(equalTo: exchangeButtonContainerView.trailingAnchor, constant: 20).isActive = true
        
        exchangeButtonContainerView.addSubview(exchangeButtonInnerLightView)
        exchangeButtonInnerLightView.bottomAnchor.constraint(equalTo: exchangeButtonContainerView.bottomAnchor).isActive = true
        exchangeButtonInnerLightView.trailingAnchor.constraint(equalTo: exchangeButtonContainerView.trailingAnchor).isActive = true
        exchangeButtonInnerLightView.topAnchor.constraint(equalTo: exchangeButtonContainerView.topAnchor, constant: -20).isActive = true
        exchangeButtonInnerLightView.leadingAnchor.constraint(equalTo: exchangeButtonContainerView.leadingAnchor, constant: -20).isActive = true
        
        exchangeButtonContainerView.addSubview(exchangeButton)
        exchangeButton.topAnchor.constraint(equalTo: exchangeButtonContainerView.topAnchor, constant: 8).isActive = true
        exchangeButton.leadingAnchor.constraint(equalTo: exchangeButtonContainerView.leadingAnchor, constant: 8).isActive = true
        exchangeButton.trailingAnchor.constraint(equalTo: exchangeButtonContainerView.trailingAnchor, constant: -8).isActive = true
        exchangeButton.bottomAnchor.constraint(equalTo: exchangeButtonContainerView.bottomAnchor, constant: -8).isActive = true

        targetLanguageView.addSubview(targetLanguageButtonContainerView)
        targetLanguageButtonContainerView.topAnchor.constraint(equalTo: targetLanguageView.topAnchor, constant: 25).isActive = true
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
        
        sourceInputView.VStack(clearButtonContainerView,
                               sourceInputTextView,
                               spacing: 0,
                               alignment: .fill,
                               distribution: .fill)
        
        clearButtonContainerView.addSubview(clearButton)
        clearButton.topAnchor.constraint(equalTo: clearButtonContainerView.topAnchor).isActive = true
        clearButton.bottomAnchor.constraint(equalTo: clearButtonContainerView.bottomAnchor).isActive = true
        clearButton.trailingAnchor.constraint(equalTo: clearButtonContainerView.trailingAnchor, constant: -10).isActive = true
        
        sourceInputTextView.addSubview(sourceInputText)
        sourceInputText.leadingAnchor.constraint(equalTo: sourceInputTextView.leadingAnchor, constant: 10).isActive = true
        sourceInputText.trailingAnchor.constraint(equalTo: sourceInputTextView.trailingAnchor, constant: -10).isActive = true
        sourceInputText.topAnchor.constraint(equalTo: sourceInputTextView.topAnchor).isActive = true
        sourceInputText.bottomAnchor.constraint(equalTo: sourceInputTextView.bottomAnchor, constant: -10).isActive = true
        
        translateButtonView.addSubview(translateButton)
        translateButton.topAnchor.constraint(equalTo: translateButtonView.topAnchor).isActive = true
        translateButton.leadingAnchor.constraint(equalTo: translateButtonView.leadingAnchor, constant: 50).isActive = true
        translateButton.trailingAnchor.constraint(equalTo: translateButtonView.trailingAnchor, constant: -50).isActive = true
        translateButton.bottomAnchor.constraint(equalTo: translateButtonView.bottomAnchor).isActive = true
        
        targetOutputView.VStack(outputActionView.setHeight(30),
                                outputTextView,
                                spacing: 5,
                                alignment: .fill,
                                distribution: .fill)
        
        outputActionView.addSubview(starButton)
        starButton.topAnchor.constraint(equalTo: outputActionView.topAnchor).isActive = true
        starButton.bottomAnchor.constraint(equalTo: outputActionView.bottomAnchor).isActive = true
        starButton.trailingAnchor.constraint(equalTo: outputActionView.trailingAnchor, constant: -5).isActive = true
        starButton.widthAnchor.constraint(equalToConstant: 30).isActive = true
        
        outputActionView.addSubview(speechButton)
        speechButton.topAnchor.constraint(equalTo: starButton.topAnchor).isActive = true
        speechButton.bottomAnchor.constraint(equalTo: starButton.bottomAnchor).isActive = true
        speechButton.trailingAnchor.constraint(equalTo: starButton.leadingAnchor, constant: -10).isActive = true
        speechButton.widthAnchor.constraint(equalTo: starButton.widthAnchor).isActive = true

        outputTextView.addSubview(targetOutputText)
        targetOutputText.topAnchor.constraint(equalTo: outputTextView.topAnchor).isActive = true
        targetOutputText.leadingAnchor.constraint(equalTo: outputTextView.leadingAnchor, constant: 16).isActive = true
        targetOutputText.trailingAnchor.constraint(equalTo: outputTextView.trailingAnchor, constant: -16).isActive = true
        targetOutputText.bottomAnchor.constraint(equalTo: outputTextView.bottomAnchor, constant: -16).isActive = true
    }

    override func viewDidLoad() {
        super.viewDidLoad()
        
        savedTranslations = realm.objects(SavedTranslation.self)
        
        let sourceLanguage = SupportedLanguages.gcpLanguageList[temporarySourceLanguageGCPIndex]
        let targetLanguage = SupportedLanguages.gcpLanguageList[temporaryTargetLanguageGCPIndex]
        sourceLanguageButton.setTitle(sourceLanguage, for: .normal)
        sourceLanguageButton.addTarget(self, action: #selector(sourceLanguageButtonTouchDown), for: .touchDown)
        sourceLanguageButton.addTarget(self, action: #selector(sourceLanguageButtonTouchUpInside), for: .touchUpInside)
        targetLanguageButton.setTitle(targetLanguage, for: .normal)
        targetLanguageButton.addTarget(self, action: #selector(targetLanguageButtonTouchDown), for: .touchDown)
        targetLanguageButton.addTarget(self, action: #selector(targetLanguageButtonTouchUpInside), for: .touchUpInside)
        
        clearButton.isHidden = true
        sourceLanguageButtonInnerLightView.isHidden = true
        sourceLanguageButtonInnerDarkView.isHidden = true
        targetLanguageButtonInnerLightView.isHidden = true
        targetLanguageButtonInnerDarkView.isHidden = true
        exchangeButtonInnerLightView.isHidden = true
        exchangeButtonInnerDarkView.isHidden = true
        
        exchangeButton.addTarget(self, action: #selector(exchangeButtonTouchDown), for: .touchDown)
        exchangeButton.addTarget(self, action: #selector(exchangeButtonTouchUpInside), for: .touchUpInside)
        clearButton.addTarget(self, action: #selector(clearText), for: .touchUpInside)
        translateButton.addTarget(self, action: #selector(doTranslate), for: .touchUpInside)
        
        starButton.addTarget(self, action: #selector(starButtonTapped), for: .touchUpInside)
        speechButton.addTarget(self, action: #selector(speechButtonTapped), for: .touchUpInside)
        
        starButton.isHidden = true
        speechButton.isHidden = true
        targetOutputText.isHidden = true
        
        sourceInputText.delegate = self
        
        translatedCharactersCurrentMonth = UserDefaults.standard.integer(forKey: Constants.translatedCharactersCountKey)
        
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
        
        navigationItem.rightBarButtonItem = UIBarButtonItem(barButtonSystemItem: .done, target: self, action: #selector(doneButtonTapped))
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
    
    @objc func selectLanguage() {
        //present picker view modal
        let viewController = LanguagePickerViewController()
        viewController.sourceLanguageRow = temporarySourceLanguageGCPIndex
        viewController.targetLanguageRow = temporaryTargetLanguageGCPIndex
        viewController.languagePickerType = self.languagePickerType
        viewController.delegate = self
        let navController = UINavigationController(rootViewController: viewController)
        
        self.navigationController?.present(navController, animated: true, completion: nil)
    }
    
    @objc func exchangeLanguage() {
        
        guard let exchangeText = targetLanguageButton.titleLabel?.text,
            let sourceLanguage = sourceLanguageButton.titleLabel?.text else { return }
        
        UIView.animate(withDuration: 0.25, animations: {
            self.exchangeButton.transform = CGAffineTransform(rotationAngle: CGFloat.pi)
            self.exchangeButton.transform = self.exchangeButton.transform.rotated(by: CGFloat.pi)
            self.targetLanguageButton.setTitle(sourceLanguage, for: .normal)
            self.sourceLanguageButton.setTitle(exchangeText, for: .normal)
        }, completion: nil)
        
        swap(&temporarySourceLanguageGCPIndex, &temporaryTargetLanguageGCPIndex)
        
        print("exchange button pressed.")
    }
    
    @objc func clearText() {
        sourceInputText.text = ""
        
        clearButton.isHidden = true
        starButton.isHidden = true
        speechButton.isHidden = true
        targetOutputText.isHidden = true
    }
    
    @objc func doTranslate() {
        print("do translate")
        
        guard let raw = UserDefaults.standard.string(forKey: Constants.userTypeKey) else { return }
        let userType = UserType(rawValue: raw)!
        print(userType)
        
        guard let text = sourceInputText.text else { return }
        if text.isEmpty {
            print("text is empty")
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

        if isOfflineTranslateAvailable(from: sourceLanguage, to: targetLanguage) {
            performFBOfflineTranslate(from: sourceLanguage, to: targetLanguage, for: textToTranslate)
        } else {
            performGoogleCloudTranslate(from: sourceLanguageCode, to: targetLanguageCode, for: textToTranslate)
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
            }
        }
    }
    
    func showResult(result: String) {
        starButton.isHidden = false
        isStarButtonTapped = false
        starButton.setImage(UIImage(systemName: "star"), for: .normal)
        starButton.tintColor = .gray
        
        speechButton.isHidden = false
        
        targetOutputText.isHidden = false
        targetOutputText.text = result
    }
    
    @objc func starButtonTapped() {
        isStarButtonTapped = !isStarButtonTapped
        if isStarButtonTapped {
            starButton.setImage(UIImage(systemName: "star.fill"), for: .normal)
            starButton.tintColor = .systemYellow
            
            let savedTranslation = SavedTranslation()
            savedTranslation.sourceLanguage = "English"
            savedTranslation.sourceText = sourceInputText.text
            savedTranslation.targetLanguage = "Japanese"
            savedTranslation.targetText = targetOutputText.text
            savedTranslation.dateCreated = Date()
            
            do {
                try realm.write {
                    realm.add(savedTranslation)
                }
            } catch {
                print("Error adding item, \(error)")
            }
            
            let vc = SavedTranslationsTableViewController()
            vc.tableView.reloadData()
            
        } else {
            starButton.setImage(UIImage(systemName: "star"), for: .normal)
            starButton.tintColor = .gray
            
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
        let utterance = AVSpeechUtterance(string: targetOutputText.text)
        utterance.voice = AVSpeechSynthesisVoice(language: "ja")
        utterance.rate = AVSpeechUtteranceDefaultSpeechRate

        let synthesizer = AVSpeechSynthesizer()
        synthesizer.speak(utterance)
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
        let sourceLanguage = SupportedLanguages.gcpLanguageList[temporarySourceLanguageGCPIndex]
        let targetLanguage = SupportedLanguages.gcpLanguageList[temporaryTargetLanguageGCPIndex]
        sourceLanguageButton.setTitle(sourceLanguage, for: .normal)
        targetLanguageButton.setTitle(targetLanguage, for: .normal)
        self.temporarySourceLanguageGCPIndex = temporarySourceLanguageGCPIndex
        self.temporaryTargetLanguageGCPIndex = temporaryTargetLanguageGCPIndex
    }
    
    
}

