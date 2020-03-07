//
//  ARTranslateViewController.swift
//  MultiTranslate
//
//  Created by Keishin CHOU on 2020/01/06.
//  Copyright © 2020 Keishin CHOU. All rights reserved.
//

import AVFoundation
import UIKit
import Vision

import LBTATools
import PMSuperButton
import CropViewController
import KRProgressHUD
import SPAlert

class ARTranslateViewController: UIViewController {

//    override func viewDidLoad() {
//        super.viewDidLoad()
//
//        // Do any additional setup after loading the view.
//        print("ARTranslateViewController here.")
//
//        let label = UILabel(frame: .zero)
//        label.font = UIFont.systemFont(ofSize: 50, weight: UIFont.Weight.thin)
//        label.textColor = UIColor(red: 95/255, green: 102/255, blue: 108/255, alpha: 1)
//        label.text = "AR translation"
//        label.sizeToFit()
//
//        view.addSubview(label)
//        view.constrainCentered(label)
//        view.backgroundColor = .white
//
//    }

    //MARK: - Variables and Constants
    var detectedResultString = ""
    private var temporarySourceLanguageIndex = UserDefaults.standard.integer(forKey: Constants.arSourceLanguageIndexKey)
    private var temporaryTargetLanguageIndex = UserDefaults.standard.integer(forKey: Constants.arTargetLanguageIndexKey)
    private var defaultSourceLanguageIndex = UserDefaults.standard.integer(forKey: Constants.arSourceLanguageIndexKey)
    private var defaultTargetLanguageIndex = UserDefaults.standard.integer(forKey: Constants.arTargetLanguageIndexKey)
    
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
    
    private let cameraButtonContainerView: UIView = {
        let view = UIView()
        view.translatesAutoresizingMaskIntoConstraints = false
        view.backgroundColor = .mtSystemBackground
        return view
    }()
    
    private let cameraButtonOutterLightView: UIView = {
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
    
    private let cameraButtonOutterDarkView: UIView = {
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
    
    private let cameraButtonInnerLightView: SwiftyInnerShadowView = {
        let view = SwiftyInnerShadowView()
        view.translatesAutoresizingMaskIntoConstraints = false

        view.shadowLayer.shadowRadius = 10
        view.shadowLayer.shadowColor = UIColor.mtSystemBackground.lighter().cgColor
        view.shadowLayer.shadowOpacity = 0.5
        view.shadowLayer.shadowOffset = CGSize.zero
        return view
    }()
    
    private let cameraButtonInnerDarkView: SwiftyInnerShadowView = {
        let view = SwiftyInnerShadowView()
        view.translatesAutoresizingMaskIntoConstraints = false

        view.shadowLayer.shadowRadius = 10
        view.shadowLayer.shadowColor = UIColor.mtSystemBackground.darkened().cgColor
        view.shadowLayer.shadowOpacity = 0.5
        view.shadowLayer.shadowOffset = CGSize.zero
        return view
    }()
    
    private let cameraButton: UIButton = {
        let button = UIButton()
        let config = UIImage.SymbolConfiguration(pointSize: 50, weight: .thin, scale: .large)
        button.translatesAutoresizingMaskIntoConstraints = false
        
        button.setImage(UIImage(systemName: "arkit", withConfiguration: config), for: .normal)
        button.tintColor = .systemBlue
        button.contentMode = .scaleAspectFill
        return button
    }()
    
//    private let imagePicker: UIImagePickerController = {
//        let imagePicker = UIImagePickerController()
//        imagePicker.allowsEditing = true
//
//        if UIImagePickerController.isSourceTypeAvailable(.camera) {
//            imagePicker.sourceType = .camera
//        } else {
//            // FIXME: Only on simylator
//            imagePicker.sourceType = .photoLibrary
//        }
//
//        return imagePicker
//    }()
//
//    lazy private var textDetectionRequest: VNRecognizeTextRequest = {
//        let request = VNRecognizeTextRequest(completionHandler: self.handleDetectedText)
//        request.recognitionLevel = .accurate
//        request.recognitionLanguages = ["en_US"]
//        request.usesLanguageCorrection = true
//        return request
//    }()
    
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
        
        buttonView.addSubview(cameraButtonContainerView)
        cameraButtonContainerView.setWidth(viewWidth * 0.4).setHeight(viewWidth * 0.4)
        cameraButtonContainerView.centerXAnchor.constraint(equalTo: container.centerXAnchor).isActive = true
        cameraButtonContainerView.centerYAnchor.constraint(equalTo: container.centerYAnchor).isActive = true
        
        cameraButtonContainerView.addSubview(cameraButtonOutterDarkView)
        cameraButtonOutterDarkView.edgeTo(cameraButtonContainerView)
        
        cameraButtonContainerView.addSubview(cameraButtonOutterLightView)
        cameraButtonOutterLightView.edgeTo(cameraButtonContainerView)
        
        cameraButtonContainerView.addSubview(cameraButtonInnerDarkView)
        cameraButtonInnerDarkView.topAnchor.constraint(equalTo: cameraButtonContainerView.topAnchor).isActive = true
        cameraButtonInnerDarkView.leadingAnchor.constraint(equalTo: cameraButtonContainerView.leadingAnchor).isActive = true
        cameraButtonInnerDarkView.bottomAnchor.constraint(equalTo: cameraButtonContainerView.bottomAnchor, constant: viewWidth * 0.4).isActive = true
        cameraButtonInnerDarkView.trailingAnchor.constraint(equalTo: cameraButtonContainerView.trailingAnchor, constant: viewWidth * 0.4).isActive = true
        
        cameraButtonContainerView.addSubview(cameraButtonInnerLightView)
        cameraButtonInnerLightView.bottomAnchor.constraint(equalTo: cameraButtonContainerView.bottomAnchor).isActive = true
        cameraButtonInnerLightView.trailingAnchor.constraint(equalTo: cameraButtonContainerView.trailingAnchor).isActive = true
        cameraButtonInnerLightView.topAnchor.constraint(equalTo: cameraButtonContainerView.topAnchor, constant: -viewWidth * 0.4).isActive = true
        cameraButtonInnerLightView.leadingAnchor.constraint(equalTo: cameraButtonContainerView.leadingAnchor, constant: -viewWidth * 0.4).isActive = true
        
        cameraButtonContainerView.addSubview(cameraButton)
        cameraButton.topAnchor.constraint(equalTo: cameraButtonContainerView.topAnchor, constant: viewWidth * 0.02).isActive = true
        cameraButton.leadingAnchor.constraint(equalTo: cameraButtonContainerView.leadingAnchor, constant: viewWidth * 0.02).isActive = true
        cameraButton.trailingAnchor.constraint(equalTo: cameraButtonContainerView.trailingAnchor, constant: -viewWidth * 0.02).isActive = true
        cameraButton.bottomAnchor.constraint(equalTo: cameraButtonContainerView.bottomAnchor, constant: -viewWidth * 0.02).isActive = true
        
        cameraButtonContainerView.layer.cornerRadius =  viewWidth * 0.4 / 2
        cameraButtonOutterLightView.layer.cornerRadius = viewWidth * 0.4 / 2
        cameraButtonOutterDarkView.layer.cornerRadius = viewWidth * 0.4 / 2
        cameraButtonInnerLightView.cornerRadius = viewWidth * 0.4 / 2
        cameraButtonInnerDarkView.cornerRadius = viewWidth * 0.4 / 2
    }

    override func viewDidLoad() {
        super.viewDidLoad()
        
        let sourceLanguage = SupportedLanguages.visionRecognizerSupportedLanguage[temporarySourceLanguageIndex]
        let targetLanguage = SupportedLanguages.gcpLanguageList[temporaryTargetLanguageIndex]
        sourceLanguageButton.setTitle(sourceLanguage, for: .normal)
        sourceLanguageButton.addTarget(self, action: #selector(sourceLanguageButtonTouchDown), for: .touchDown)
        sourceLanguageButton.addTarget(self, action: #selector(sourceLanguageButtonTouchUpInside), for: .touchUpInside)
        targetLanguageButton.setTitle(targetLanguage, for: .normal)
        targetLanguageButton.addTarget(self, action: #selector(targetLanguageButtonTouchDown), for: .touchDown)
        targetLanguageButton.addTarget(self, action: #selector(targetLanguageButtonTouchUpInside), for: .touchUpInside)
        cameraButton.addTarget(self, action: #selector(cameraButtonTouchDown), for: .touchDown)
        cameraButton.addTarget(self, action: #selector(cameraButtonTouchUpInside), for: .touchUpInside)
        
        sourceLanguageButtonInnerLightView.isHidden = true
        sourceLanguageButtonInnerDarkView.isHidden = true
        targetLanguageButtonInnerLightView.isHidden = true
        targetLanguageButtonInnerDarkView.isHidden = true
        cameraButtonInnerDarkView.isHidden = true
        cameraButtonInnerLightView.isHidden = true
        
        sourceLanguageView.isHidden = true
        arrowView.isHidden = true
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        
        if defaultSourceLanguageIndex != UserDefaults.standard.integer(forKey: Constants.arSourceLanguageIndexKey) {
            temporarySourceLanguageIndex = UserDefaults.standard.integer(forKey: Constants.arSourceLanguageIndexKey)
            defaultSourceLanguageIndex = temporarySourceLanguageIndex
            let sourceLanguage = SupportedLanguages.visionRecognizerSupportedLanguage[temporarySourceLanguageIndex]
            sourceLanguageButton.setTitle(sourceLanguage, for: .normal)
            print("defaultSourceLanguageIndex changed")
        }
        
        if defaultTargetLanguageIndex != UserDefaults.standard.integer(forKey: Constants.arTargetLanguageIndexKey) {
            temporaryTargetLanguageIndex = UserDefaults.standard.integer(forKey: Constants.arTargetLanguageIndexKey)
            defaultTargetLanguageIndex = temporaryTargetLanguageIndex
            let targetLanguage = SupportedLanguages.gcpLanguageList[temporaryTargetLanguageIndex]
            targetLanguageButton.setTitle(targetLanguage, for: .normal)
            print("defaultTargetLanguageIndex changed")
        }
        
        let titleInfo = ["title" : "Augmented Reality"]
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
    
    @objc func cameraButtonTouchDown() {
        cameraButtonOutterDarkView.isHidden = true
        cameraButtonOutterLightView.isHidden = true
        cameraButtonInnerDarkView.isHidden = false
        cameraButtonInnerLightView.isHidden = false
        
        cameraButtonContainerView.layer.masksToBounds = true
    }
    
    @objc func cameraButtonTouchUpInside() {
        cameraButtonOutterDarkView.isHidden = false
        cameraButtonOutterLightView.isHidden = false
        cameraButtonInnerDarkView.isHidden = true
        cameraButtonInnerLightView.isHidden = true
        
        cameraButtonContainerView.layer.masksToBounds = false
        
        useCamera()
    }
    
    // MARK: - Other Function Implementation
    func useCamera() {
        print("Use camera tapped.")
        
        guard let targetLanguage = self.targetLanguageButton.titleLabel?.text,
            let raw = UserDefaults.standard.string(forKey: Constants.userTypeKey)else { return }
        
        let userType = UserType(rawValue: raw)!
        
        guard userType != .guestUser else {
            let viewController = PurchasePageViewController()
            viewController.modalPresentationStyle = .automatic
            present(viewController, animated: true, completion: nil)
            return
        }
        
        if UIImagePickerController.isSourceTypeAvailable(.camera) {
            if AVCaptureDevice.authorizationStatus(for: .video) ==  .authorized {
                //already authorized
                let viewController = ARViewController()
                viewController.targetLanguage = targetLanguage
                viewController.modalPresentationStyle = .fullScreen
                present(viewController, animated: true, completion: nil)
            } else {
                AVCaptureDevice.requestAccess(for: .video, completionHandler: { (granted: Bool) in
                    DispatchQueue.main.async {
                        if granted {
                            //access allowed
                            let viewController = ARViewController()
                            viewController.targetLanguage = targetLanguage
                            viewController.modalPresentationStyle = .fullScreen
                            self.present(viewController, animated: true, completion: nil)
                        } else {
                            //access denied
                            let alert = PMAlertController(title: "Camera access not allowed", description: "Use camera to detect words", image: UIImage(named: "color_camera"), style: .alert)
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
            
        } else {
            print("Camera is not available.")
            let alert = PMAlertController(title: "No camera", description: "Camera is not supported on this device", image: UIImage(named: "error"), style: .alert)
            let cancelAction = PMAlertAction(title: "Cancel", style: .cancel)
            alert.addAction(cancelAction)
            present(alert, animated: true, completion: nil)
        }
        
    }
    
    func selectLanguage() {
        //present picker view modal
        let viewController = LanguagePickerViewController()
        viewController.sourceLanguageRow = temporarySourceLanguageIndex
        viewController.targetLanguageRow = temporaryTargetLanguageIndex
        viewController.languagePickerType = .targetLanguage
        viewController.delegate = self
        let navController = UINavigationController(rootViewController: viewController)
        
        self.navigationController?.present(navController, animated: true, completion: nil)
    }

}

extension ARTranslateViewController: LanguagePickerDelegate {
    func didSelectedLanguagePicker(temporarySourceLanguageGCPIndex: Int, temporaryTargetLanguageGCPIndex: Int) {
        let sourceLanguage = SupportedLanguages.visionRecognizerSupportedLanguage[temporarySourceLanguageGCPIndex]
        let targetLanguage = SupportedLanguages.gcpLanguageList[temporaryTargetLanguageGCPIndex]
        sourceLanguageButton.setTitle(sourceLanguage, for: .normal)
        targetLanguageButton.setTitle(targetLanguage, for: .normal)
        self.temporarySourceLanguageIndex = temporarySourceLanguageGCPIndex
        self.temporaryTargetLanguageIndex = temporaryTargetLanguageGCPIndex
    }
}
