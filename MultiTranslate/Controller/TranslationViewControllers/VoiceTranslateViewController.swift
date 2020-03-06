//
//  VoiceTranslateViewController.swift
//  MultiTranslate
//
//  Created by Keishin CHOU on 2020/01/06.
//  Copyright © 2020 Keishin CHOU. All rights reserved.
//

import AVFoundation
import UIKit
import Speech

import PMSuperButton

class VoiceTranslateViewController: UIViewController {
    
    //MARK: - Variables and Constants
    private var detectedResultString: String = ""
    private var temporarySourceLanguageIndex = UserDefaults.standard.integer(forKey: Constants.voiceSourceLanguageIndexKey)
    private var temporaryTargetLanguageIndex = UserDefaults.standard.integer(forKey: Constants.voiceTargetLanguageIndexKey)
    private var defaultSourceLanguageIndex = UserDefaults.standard.integer(forKey: Constants.voiceSourceLanguageIndexKey)
    private var defaultTargetLanguageIndex = UserDefaults.standard.integer(forKey: Constants.voiceTargetLanguageIndexKey)

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
    
    private let arrowView: UIView = {
        let view = UIView()
        view.translatesAutoresizingMaskIntoConstraints = false
        return view
    }()
    
    private let arrowImageView: UIImageView = {
        let imageView = UIImageView()
        imageView.translatesAutoresizingMaskIntoConstraints = false
        
        let config = UIImage.SymbolConfiguration(weight: .thin)
        imageView.image = UIImage(systemName: "arrow.right.circle", withConfiguration: config)
        imageView.tintColor = .systemGray
        imageView.contentMode = .scaleAspectFit
        return imageView
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
    
    private let microphoneButtonContainerView: UIView = {
        let view = UIView()
        view.translatesAutoresizingMaskIntoConstraints = false
        view.backgroundColor = .mtSystemBackground
        return view
    }()
    
    private let microphoneButtonOutterLightView: UIView = {
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
    
    private let microphoneButtonOutterDarkView: UIView = {
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
    
    private let microphoneButtonInnerLightView: SwiftyInnerShadowView = {
        let view = SwiftyInnerShadowView()
        view.translatesAutoresizingMaskIntoConstraints = false

        view.shadowLayer.shadowRadius = 10
        view.shadowLayer.shadowColor = UIColor.mtSystemBackground.lighter().cgColor
        view.shadowLayer.shadowOpacity = 0.5
        view.shadowLayer.shadowOffset = CGSize.zero
        return view
    }()
    
    private let microphoneButtonInnerDarkView: SwiftyInnerShadowView = {
        let view = SwiftyInnerShadowView()
        view.translatesAutoresizingMaskIntoConstraints = false

        view.shadowLayer.shadowRadius = 10
        view.shadowLayer.shadowColor = UIColor.mtSystemBackground.darkened().cgColor
        view.shadowLayer.shadowOpacity = 0.5
        view.shadowLayer.shadowOffset = CGSize.zero
        return view
    }()
    
    private let microphoneButton: UIButton = {
        let button = UIButton()
        let config = UIImage.SymbolConfiguration(pointSize: 50, weight: .thin, scale: .large)
        button.translatesAutoresizingMaskIntoConstraints = false
        
        button.setImage(UIImage(systemName: "mic", withConfiguration: config), for: .normal)
        button.tintColor = .systemBlue
        button.contentMode = .scaleAspectFill
        return button
    }()
    
    // MARK: - ViewController Life Cirecle
    
    override func loadView() {
        super.loadView()
        
        let viewHeight = view.frame.height
        let viewWidth = view.frame.width
        
        view.addSubview(container)
        container.edgeTo(view, safeArea: .top)
        
        container.VStack(languageSelectView.setHeight(viewHeight * 0.12),
                         buttonView,
                         paddingView2.setHeight(viewHeight * 0.2),
                         spacing: 5,
                         alignment: .fill,
                         distribution: .fill)
        
        languageSelectView.HStack(sourceLanguageView,
                                  arrowView.setWidth(viewWidth * 0.12),
                                  targetLanguageView,
                                  spacing: 0,
                                  alignment: .fill,
                                  distribution: .fill)
        
        arrowView.centerXAnchor.constraint(equalTo: languageSelectView.centerXAnchor).isActive = true
        
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
        
        arrowView.addSubview(arrowImageView)
        arrowImageView.centerYAnchor.constraint(equalTo: sourceLanguageButtonContainerView.centerYAnchor).isActive = true
        arrowImageView.centerXAnchor.constraint(equalTo: arrowView.centerXAnchor).isActive = true
        arrowImageView.setHeight(30).setWidth(30)
        
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
        
        buttonView.addSubview(microphoneButtonContainerView)
        microphoneButtonContainerView.setWidth(viewWidth * 0.4).setHeight(viewWidth * 0.4)
        microphoneButtonContainerView.centerXAnchor.constraint(equalTo: container.centerXAnchor).isActive = true
        microphoneButtonContainerView.centerYAnchor.constraint(equalTo: container.centerYAnchor).isActive = true
        
        microphoneButtonContainerView.addSubview(microphoneButtonOutterDarkView)
        microphoneButtonOutterDarkView.edgeTo(microphoneButtonContainerView)
        
        microphoneButtonContainerView.addSubview(microphoneButtonOutterLightView)
        microphoneButtonOutterLightView.edgeTo(microphoneButtonContainerView)
        
        microphoneButtonContainerView.addSubview(microphoneButtonInnerDarkView)
        microphoneButtonInnerDarkView.topAnchor.constraint(equalTo: microphoneButtonContainerView.topAnchor).isActive = true
        microphoneButtonInnerDarkView.leadingAnchor.constraint(equalTo: microphoneButtonContainerView.leadingAnchor).isActive = true
        microphoneButtonInnerDarkView.bottomAnchor.constraint(equalTo: microphoneButtonContainerView.bottomAnchor, constant: viewWidth * 0.22).isActive = true
        microphoneButtonInnerDarkView.trailingAnchor.constraint(equalTo: microphoneButtonContainerView.trailingAnchor, constant: viewWidth * 0.22).isActive = true
        
        microphoneButtonContainerView.addSubview(microphoneButtonInnerLightView)
        microphoneButtonInnerLightView.bottomAnchor.constraint(equalTo: microphoneButtonContainerView.bottomAnchor).isActive = true
        microphoneButtonInnerLightView.trailingAnchor.constraint(equalTo: microphoneButtonContainerView.trailingAnchor).isActive = true
        microphoneButtonInnerLightView.topAnchor.constraint(equalTo: microphoneButtonContainerView.topAnchor, constant: -viewWidth * 0.4).isActive = true
        microphoneButtonInnerLightView.leadingAnchor.constraint(equalTo: microphoneButtonContainerView.leadingAnchor, constant: -viewWidth * 0.4).isActive = true
        
        microphoneButtonContainerView.addSubview(microphoneButton)
        microphoneButton.topAnchor.constraint(equalTo: microphoneButtonContainerView.topAnchor, constant: viewWidth * 0.02).isActive = true
        microphoneButton.leadingAnchor.constraint(equalTo: microphoneButtonContainerView.leadingAnchor, constant: viewWidth * 0.02).isActive = true
        microphoneButton.trailingAnchor.constraint(equalTo: microphoneButtonContainerView.trailingAnchor, constant: -viewWidth * 0.02).isActive = true
        microphoneButton.bottomAnchor.constraint(equalTo: microphoneButtonContainerView.bottomAnchor, constant: -viewWidth * 0.02).isActive = true
        
        microphoneButtonContainerView.layer.cornerRadius =  viewWidth * 0.4 / 2
        microphoneButtonOutterLightView.layer.cornerRadius = viewWidth * 0.4 / 2
        microphoneButtonOutterDarkView.layer.cornerRadius = viewWidth * 0.4 / 2
        microphoneButtonInnerLightView.cornerRadius = viewWidth * 0.4 / 2
        microphoneButtonInnerDarkView.cornerRadius = viewWidth * 0.4 / 2
    }

    override func viewDidLoad() {
        super.viewDidLoad()

        let sourceLanguage = SupportedLanguages.speechRecognizerSupportedLanguage[temporarySourceLanguageIndex]
        let targetLanguage = SupportedLanguages.gcpLanguageList[temporaryTargetLanguageIndex]
        sourceLanguageButton.setTitle(sourceLanguage, for: .normal)
        sourceLanguageButton.addTarget(self, action: #selector(sourceLanguageButtonTouchDown), for: .touchDown)
        sourceLanguageButton.addTarget(self, action: #selector(sourceLanguageButtonTouchUpInside), for: .touchUpInside)
        targetLanguageButton.setTitle(targetLanguage, for: .normal)
        targetLanguageButton.addTarget(self, action: #selector(targetLanguageButtonTouchDown), for: .touchDown)
        targetLanguageButton.addTarget(self, action: #selector(targetLanguageButtonTouchUpInside), for: .touchUpInside)
        microphoneButton.addTarget(self, action: #selector(microphoneButtonTouchDown), for: .touchDown)
        microphoneButton.addTarget(self, action: #selector(microphoneButtonTouchUpInside), for: .touchUpInside)
        
        sourceLanguageButtonInnerLightView.isHidden = true
        sourceLanguageButtonInnerDarkView.isHidden = true
        targetLanguageButtonInnerLightView.isHidden = true
        targetLanguageButtonInnerDarkView.isHidden = true
        microphoneButtonInnerDarkView.isHidden = true
        microphoneButtonInnerLightView.isHidden = true
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        
        if defaultSourceLanguageIndex != UserDefaults.standard.integer(forKey: Constants.voiceSourceLanguageIndexKey) {
            temporarySourceLanguageIndex = UserDefaults.standard.integer(forKey: Constants.voiceTargetLanguageIndexKey)
            defaultSourceLanguageIndex = temporarySourceLanguageIndex
            let sourceLanguage = SupportedLanguages.speechRecognizerSupportedLanguage[temporarySourceLanguageIndex]
            sourceLanguageButton.setTitle(sourceLanguage, for: .normal)
            print("defaultSourceLanguageIndex changed")
        }
        
        if defaultTargetLanguageIndex != UserDefaults.standard.integer(forKey: Constants.voiceTargetLanguageIndexKey) {
            temporaryTargetLanguageIndex = UserDefaults.standard.integer(forKey: Constants.voiceTargetLanguageIndexKey)
            defaultTargetLanguageIndex = temporaryTargetLanguageIndex
            let targetLanguage = SupportedLanguages.gcpLanguageList[temporaryTargetLanguageIndex]
            targetLanguageButton.setTitle(targetLanguage, for: .normal)
            print("defaultTargetLanguageIndex changed")
        }
        
        let titleInfo = ["title" : "Voice"]
        NotificationCenter.default.post(name: .translationViewControllerDidChange, object: nil, userInfo: titleInfo)
    }
    
    // MARK: - UIButton Implementation
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
    
    @objc func microphoneButtonTouchDown() {
        microphoneButtonOutterDarkView.isHidden = true
        microphoneButtonOutterLightView.isHidden = true
        microphoneButtonInnerDarkView.isHidden = false
        microphoneButtonInnerLightView.isHidden = false
        
        microphoneButtonContainerView.layer.masksToBounds = true
    }
    
    @objc func microphoneButtonTouchUpInside() {
        microphoneButtonOutterDarkView.isHidden = false
        microphoneButtonOutterLightView.isHidden = false
        microphoneButtonInnerDarkView.isHidden = true
        microphoneButtonInnerLightView.isHidden = true
        
        microphoneButtonContainerView.layer.masksToBounds = false
        
        requestMicrophonePermission()
    }
    
    // MARK: - Other Function Implementation
    func requestMicrophonePermission() {
        print("Use microphone tapped.")
        if AVCaptureDevice.authorizationStatus(for: .audio) ==  .authorized {
            //already authorized
            requestTranscribePermissions()
        } else {
            AVCaptureDevice.requestAccess(for: .audio, completionHandler: { [unowned self] (granted: Bool) in
                DispatchQueue.main.async {
                    if granted {
                        //access allowed
                        self.requestTranscribePermissions()
                    } else {
                        //access denied
                        let alert = PMAlertController(title: "Microphone access not allowed", description: "Use microphone to record voice", image: UIImage(named: "color_microphone"), style: .alert)
                        let cancelAction = PMAlertAction(title: "Cancel", style: .cancel)
                        let defaultAction = PMAlertAction(title: "Setting", style: .default) {
                            guard let settingsUrl = URL(string: UIApplication.openSettingsURLString) else { return }
                            
                            if UIApplication.shared.canOpenURL(settingsUrl) {
                                UIApplication.shared.open(settingsUrl, completionHandler: { (success) in
                                    print("Settings opened: \(success)")
                                })
                            }
                        }
                        alert.addAction(cancelAction)
                        alert.addAction(defaultAction)
                        self.present(alert, animated: true, completion: nil)
                    }
                }
            })
        }
    }
    
    func requestTranscribePermissions() {
        if SFSpeechRecognizer.authorizationStatus() == .authorized {
            presentRecorder()
        } else {
            SFSpeechRecognizer.requestAuthorization { [unowned self] authStatus in
                DispatchQueue.main.async {
                    if authStatus == .authorized {
                        print("Good to go!")
                        self.presentRecorder()
                    } else {
                        print("Transcription permission was declined.")
                        let alert = PMAlertController(title: "Speech recognizer", description: "Detect word in speech", image: UIImage(named: "color_microphone"), style: .alert)
                        let cancelAction = PMAlertAction(title: "Cancel", style: .cancel)
                        let defaultAction = PMAlertAction(title: "Setting", style: .default) {
                            guard let settingsUrl = URL(string: UIApplication.openSettingsURLString) else { return }
                            
                            if UIApplication.shared.canOpenURL(settingsUrl) {
                                UIApplication.shared.open(settingsUrl, completionHandler: { (success) in
                                    print("Settings opened: \(success)")
                                })
                            }
                        }
                        alert.addAction(cancelAction)
                        alert.addAction(defaultAction)
                        self.present(alert, animated: true, completion: nil)
                    }
                }
            }
        }
    }
    
    func presentRecorder() {
        let viewController = VoiceRecorderViewController(with: temporarySourceLanguageIndex)
        viewController.modalPresentationStyle = .automatic
        viewController.presentationController?.delegate = self
        viewController.delegate = self
        present(viewController, animated: true, completion: nil)
    }
    
    func selectLanguage() {
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
        if !detectedResultString.isEmpty {
            let sourceLanguage = SupportedLanguages.speechRecognizerSupportedLanguage[self.temporarySourceLanguageIndex]
            guard let index = SupportedLanguages.gcpLanguageList.firstIndex(of: sourceLanguage) else { return }
            
            let viewController = TextTranslateViewController()
            viewController.temporarySourceLanguageGCPIndex = index
            viewController.temporaryTargetLanguageGCPIndex = temporaryTargetLanguageIndex
            viewController.sourceInputText.text = detectedResultString
            viewController.languagePickerType = .targetLanguage
            viewController.isTranslateTypeNeedPro = true
            
            let navController = UINavigationController(rootViewController: viewController)
            present(navController, animated: true, completion: nil)
        }
    }
}

extension VoiceTranslateViewController: SourceTextInputDelegate {
    func didSetSourceText(detectedResult: String) {
        self.detectedResultString = detectedResult
    }
}

extension VoiceTranslateViewController: LanguagePickerDelegate {
    func didSelectedLanguagePicker(temporarySourceLanguageGCPIndex: Int, temporaryTargetLanguageGCPIndex: Int) {
        let sourceLanguage = SupportedLanguages.speechRecognizerSupportedLocale[temporarySourceLanguageGCPIndex]
        let targetLanguage = SupportedLanguages.gcpLanguageList[temporaryTargetLanguageGCPIndex]
        sourceLanguageButton.setTitle(sourceLanguage, for: .normal)
        targetLanguageButton.setTitle(targetLanguage, for: .normal)
        self.temporarySourceLanguageIndex = temporarySourceLanguageGCPIndex
        self.temporaryTargetLanguageIndex = temporaryTargetLanguageGCPIndex
    }
}
