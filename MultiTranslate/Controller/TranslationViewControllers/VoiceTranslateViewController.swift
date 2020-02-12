//
//  VoiceTranslateViewController.swift
//  MultiTranslate
//
//  Created by Keishin CHOU on 2020/01/06.
//  Copyright © 2020 Keishin CHOU. All rights reserved.
//

import UIKit

import PMSuperButton

class VoiceTranslateViewController: UIViewController {
    
    private var sourceText: String = ""
    private var temporarySourceLanguageIndex = UserDefaults.standard.integer(forKey: Constants.voiceSourceLanguageIndexKey)
    private var temporaryTargetLanguageIndex = UserDefaults.standard.integer(forKey: Constants.voiceTargetLanguageIndexKey)
    private var defaultSourceLanguageIndex = UserDefaults.standard.integer(forKey: Constants.voiceSourceLanguageIndexKey)
    private var defaultTargetLanguageIndex = UserDefaults.standard.integer(forKey: Constants.voiceTargetLanguageIndexKey)

    private let container: UIView = {
        let view = UIView()
        view.translatesAutoresizingMaskIntoConstraints = false
        view.backgroundColor = UIColor(rgb: 0xe1f2fb)
        return view
    }()
    
//    let microphoneImageContainer = UIView(backgroundColor: .cyan)
    private let microphoneImageContainer: PMSuperButton = {
        let button = PMSuperButton()
        button.gradientEnabled = true
        button.gradientStartColor = #colorLiteral(red: 0.9568627477, green: 0.6588235497, blue: 0.5450980663, alpha: 1)
        button.gradientEndColor = #colorLiteral(red: 0.9098039269, green: 0.4784313738, blue: 0.6431372762, alpha: 1)
        button.gradientHorizontal = true
        button.ripple = true
        button.rippleColor = #colorLiteral(red: 0.9880490899, green: 0.7656863332, blue: 0.9337566495, alpha: 0.5442262414)
        
        return button
    }()
    
    private let microphoneImage = UIImageView(image: UIImage(named: "color_microphone"),
                                      contentMode: .scaleAspectFit)
    
    private let microphoneLabel = UILabel(text: "Use microphone",
                                  font: .systemFont(ofSize: 50, weight: .thin),
                                  textAlignment: .center,
                                  numberOfLines: 1)
    
    private let languageSelectView: UIView = {
        let view = UIView()
        view.translatesAutoresizingMaskIntoConstraints = false
        return view
    }()
    
    private let paddingView2: UIView = {
        let view = UIView()
        view.translatesAutoresizingMaskIntoConstraints = false
        return view
    }()
    
    private let buttonView: UIView = {
        let view = UIView()
        view.translatesAutoresizingMaskIntoConstraints = false
        return view
    }()
    
    private let sourceLanguageView: UIView = {
        let view = UIView()
        view.translatesAutoresizingMaskIntoConstraints = false
        return view
    }()
    
    private let targetLanguageView: UIView = {
        let view = UIView()
        view.translatesAutoresizingMaskIntoConstraints = false
        return view
    }()
    
    private let sourceLanguageLabel: UILabel = {
        let label = UILabel()
        label.isUserInteractionEnabled = true
        label.textAlignment = .center
        label.numberOfLines = 0
        label.lineBreakMode = .byWordWrapping
        label.frame = .zero
        label.translatesAutoresizingMaskIntoConstraints = false
        return label
    }()
    
    private let targetLanguageLabel: UILabel = {
        let label = UILabel()
        label.isUserInteractionEnabled = true
        label.textAlignment = .center
        label.numberOfLines = 0
        label.lineBreakMode = .byWordWrapping
        label.frame = .zero
        label.translatesAutoresizingMaskIntoConstraints = false
        return label
    }()
    
    private let arrowImageView: UIImageView = {
        let imageView = UIImageView()
        imageView.translatesAutoresizingMaskIntoConstraints = false
        
        let config = UIImage.SymbolConfiguration(weight: .thin)
        imageView.image = UIImage(systemName: "arrow.right.circle", withConfiguration: config)
        imageView.tintColor = .label
        imageView.contentMode = .scaleAspectFit
        return imageView
    }()
    
    override func loadView() {
        super.loadView()
        
        
        view.addSubview(container)
        container.edgeTo(view, safeArea: .all)
        
        container.VStack(languageSelectView,
                         buttonView.setHeight(300),
                         paddingView2,
                         spacing: 10,
                         alignment: .fill,
                         distribution: .fill)
        
        languageSelectView.heightAnchor.constraint(equalTo: paddingView2.heightAnchor).isActive = true
        
        languageSelectView.HStack(sourceLanguageView,
                            arrowImageView.setWidth(30),
                            targetLanguageView,
                            spacing: 5,
                            alignment: .fill,
                            distribution: .fill)
        arrowImageView.centerXAnchor.constraint(equalTo: languageSelectView.centerXAnchor).isActive = true
        
        sourceLanguageView.addSubview(sourceLanguageLabel)
        sourceLanguageLabel.centerYAnchor.constraint(equalTo: sourceLanguageView.centerYAnchor).isActive = true
        sourceLanguageLabel.widthAnchor.constraint(equalTo: sourceLanguageView.widthAnchor).isActive = true

        targetLanguageView.addSubview(targetLanguageLabel)
        targetLanguageLabel.centerYAnchor.constraint(equalTo: targetLanguageView.centerYAnchor).isActive = true
        targetLanguageLabel.widthAnchor.constraint(equalTo: targetLanguageView.widthAnchor).isActive = true
        
        buttonView.VStack(microphoneImageContainer.setWidth(150).setHeight(150),
                          microphoneLabel,
                          spacing: 8,
                          alignment: .center,
                          distribution: .fillProportionally).padTop(50)
        
        microphoneImageContainer.layer.cornerRadius = 75

        microphoneImageContainer.addSubview(microphoneImage)
        microphoneImage.translatesAutoresizingMaskIntoConstraints = false
        microphoneImage.centerXAnchor.constraint(equalTo: microphoneImageContainer.centerXAnchor).isActive = true
        microphoneImage.centerYAnchor.constraint(equalTo: microphoneImageContainer.centerYAnchor).isActive = true
        microphoneImage.setWidth(100)
        microphoneImage.setHeight(100)
    }

    override func viewDidLoad() {
        super.viewDidLoad()

        microphoneImageContainer.addTarget(self, action: #selector(useMicrophone), for: .touchUpInside)
        
        sourceLanguageLabel.text = SupportedLanguages.speechRecognizerSupportedLocale[temporarySourceLanguageIndex]
        targetLanguageLabel.text = SupportedLanguages.gcpLanguageList[temporaryTargetLanguageIndex]
        
        let sourceLanguageRecognizer = UITapGestureRecognizer(target: self, action: #selector(selectLanguage))
        sourceLanguageLabel.addGestureRecognizer(sourceLanguageRecognizer)
        let targetLanguageRecognizer = UITapGestureRecognizer(target: self, action: #selector(selectLanguage))
        targetLanguageLabel.addGestureRecognizer(targetLanguageRecognizer)
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        
        if defaultSourceLanguageIndex != UserDefaults.standard.integer(forKey: Constants.voiceSourceLanguageIndexKey) {
            temporarySourceLanguageIndex = UserDefaults.standard.integer(forKey: Constants.voiceTargetLanguageIndexKey)
            defaultSourceLanguageIndex = temporarySourceLanguageIndex
            sourceLanguageLabel.text = SupportedLanguages.speechRecognizerSupportedLocale[temporarySourceLanguageIndex]
            print("defaultSourceLanguageIndex changed")
        }
        
        if defaultTargetLanguageIndex != UserDefaults.standard.integer(forKey: Constants.voiceTargetLanguageIndexKey) {
            temporaryTargetLanguageIndex = UserDefaults.standard.integer(forKey: Constants.voiceTargetLanguageIndexKey)
            defaultTargetLanguageIndex = temporaryTargetLanguageIndex
            targetLanguageLabel.text = SupportedLanguages.gcpLanguageList[temporaryTargetLanguageIndex]
            print("defaultTargetLanguageIndex changed")
        }
    }
        
    @objc func useMicrophone() {
        print("Use microphone tapped.")
        let viewController = VoiceRecorderViewController(with: temporarySourceLanguageIndex)
        viewController.modalPresentationStyle = .automatic
        viewController.presentationController?.delegate = self
        viewController.delegate = self
        present(viewController, animated: true, completion: nil)
    }
    
    @objc func selectLanguage() {
        //present picker view modal
        let viewController = LanguagePickerViewController()
        viewController.sourceLanguageRow = temporarySourceLanguageIndex
        viewController.targetLanguageRow = temporaryTargetLanguageIndex
        viewController.languagePickerType = .speechTranslate
        viewController.delegate = self
        let navController = UINavigationController(rootViewController: viewController)
        
        self.navigationController?.present(navController, animated: true, completion: nil)
    }

}

// MARK: - Extensions
extension VoiceTranslateViewController: UIAdaptivePresentationControllerDelegate {
    func presentationControllerDidDismiss(_ presentationController: UIPresentationController) {
        print("PresentationControllerDidDismiss called.")
        if !sourceText.isEmpty {
//            let index: Int
//            if let sourceLanguage = sourceLanguageLabel.text {
//                index = SupportedLanguages.gcpLanguageList.firstIndex(of: sourceLanguage) ?? 0
//            }
            guard let sourceLanguage = sourceLanguageLabel.text,
                let index = SupportedLanguages.gcpLanguageList.firstIndex(of: sourceLanguage) else { return }
            
            let viewController = TextTranslateViewController()
            viewController.temporarySourceLanguageGCPIndex = index
            viewController.temporaryTargetLanguageGCPIndex = temporaryTargetLanguageIndex
            viewController.sourceInputText.text = sourceText
            viewController.languagePickerType = .targetLanguage
            
            let navController = UINavigationController(rootViewController: viewController)
            present(navController, animated: true, completion: nil)
        }
    }
}

extension VoiceTranslateViewController: SourceTextInputDelegate {
    func didSetSourceText(sourceText: String) {
        self.sourceText = sourceText
    }
}

extension VoiceTranslateViewController: LanguagePickerDelegate {
    func didSelectedLanguagePicker(temporarySourceLanguageGCPIndex: Int, temporaryTargetLanguageGCPIndex: Int) {
        sourceLanguageLabel.text = SupportedLanguages.speechRecognizerSupportedLocale[temporarySourceLanguageGCPIndex]
        targetLanguageLabel.text = SupportedLanguages.gcpLanguageList[temporaryTargetLanguageGCPIndex]
        self.temporarySourceLanguageIndex = temporarySourceLanguageGCPIndex
        self.temporaryTargetLanguageIndex = temporaryTargetLanguageGCPIndex
    }
}
