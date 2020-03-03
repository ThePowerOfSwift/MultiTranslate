//
//  PDFTranslateViewController.swift
//  MultiTranslate
//
//  Created by Keishin CHOU on 2020/01/06.
//  Copyright © 2020 Keishin CHOU. All rights reserved.
//

import AVFoundation
import UIKit
import Vision

import KRProgressHUD
import SPAlert
import WeScan

class PDFTranslateViewController: UIViewController {
    
    var detectedResultString = ""
    private var temporarySourceLanguageIndex = UserDefaults.standard.integer(forKey: Constants.docSourceLanguageIndexKey)
    private var temporaryTargetLanguageIndex = UserDefaults.standard.integer(forKey: Constants.docTargetLanguageIndexKey)
    private var defaultSourceLanguageIndex = UserDefaults.standard.integer(forKey: Constants.docSourceLanguageIndexKey)
    private var defaultTargetLanguageIndex = UserDefaults.standard.integer(forKey: Constants.docTargetLanguageIndexKey)
    
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
    
    private let cameraButtonContainerView: UIView = {
        let view = UIView()
        view.translatesAutoresizingMaskIntoConstraints = false
        view.backgroundColor = UIColor(rgb: 0xC1D2EB)
        return view
    }()
    
    private let cameraButtonOutterLightView: UIView = {
        let view = UIView()
        view.translatesAutoresizingMaskIntoConstraints = false
        view.backgroundColor = UIColor(rgb: 0xC1D2EB)
        
        view.layer.masksToBounds = false
        
        view.layer.shadowColor = UIColor.white.cgColor
        view.layer.shadowOpacity = 0.5
        view.layer.shadowOffset = CGSize(width: -5, height: -5)
        view.layer.shadowRadius = 5
        return view
    }()
    
    private let cameraButtonOutterDarkView: UIView = {
        let view = UIView()
        view.translatesAutoresizingMaskIntoConstraints = false
        view.backgroundColor = UIColor(rgb: 0xC1D2EB)
        
        view.layer.masksToBounds = false
        
        view.layer.shadowColor = UIColor.black.cgColor
        view.layer.shadowOpacity = 0.2
        view.layer.shadowOffset = CGSize(width: 5, height: 5)
        view.layer.shadowRadius = 5
        return view
    }()
    
    private let cameraButtonInnerLightView: SwiftyInnerShadowView = {
        let view = SwiftyInnerShadowView()
        view.translatesAutoresizingMaskIntoConstraints = false

        view.shadowLayer.shadowRadius = 10
        view.shadowLayer.shadowColor = UIColor.white.cgColor
        view.shadowLayer.shadowOpacity = 1
        view.shadowLayer.shadowOffset = CGSize.zero
        return view
    }()
    
    private let cameraButtonInnerDarkView: SwiftyInnerShadowView = {
        let view = SwiftyInnerShadowView()
        view.translatesAutoresizingMaskIntoConstraints = false

        view.shadowLayer.shadowRadius = 5
        view.shadowLayer.shadowColor = UIColor.black.cgColor
        view.shadowLayer.shadowOpacity = 0.5
        view.shadowLayer.shadowOffset = CGSize.zero
        return view
    }()
    
    private let cameraButton: UIButton = {
        let button = UIButton()
        let config = UIImage.SymbolConfiguration(pointSize: 50, weight: .thin, scale: .large)
        button.translatesAutoresizingMaskIntoConstraints = false
        
        button.setImage(UIImage(systemName: "camera", withConfiguration: config), for: .normal)
        button.tintColor = .systemBlue
        button.contentMode = .scaleAspectFill
        return button
    }()
    
    lazy private var textDetectionRequest: VNRecognizeTextRequest = {
        let request = VNRecognizeTextRequest(completionHandler: self.handleDetectedText)
        request.recognitionLevel = .accurate
        request.recognitionLanguages = ["en_US"]
        request.usesLanguageCorrection = true
        return request
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
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        
        if defaultSourceLanguageIndex != UserDefaults.standard.integer(forKey: Constants.docSourceLanguageIndexKey) {
            temporarySourceLanguageIndex = UserDefaults.standard.integer(forKey: Constants.docSourceLanguageIndexKey)
            defaultSourceLanguageIndex = temporarySourceLanguageIndex
            let sourceLanguage = SupportedLanguages.visionRecognizerSupportedLanguage[temporarySourceLanguageIndex]
            sourceLanguageButton.setTitle(sourceLanguage, for: .normal)
            print("defaultSourceLanguageIndex changed")
        }
        
        if defaultTargetLanguageIndex != UserDefaults.standard.integer(forKey: Constants.docTargetLanguageIndexKey) {
            temporaryTargetLanguageIndex = UserDefaults.standard.integer(forKey: Constants.docTargetLanguageIndexKey)
            defaultTargetLanguageIndex = temporaryTargetLanguageIndex
            let targetLanguage = SupportedLanguages.gcpLanguageList[temporaryTargetLanguageIndex]
            targetLanguageButton.setTitle(targetLanguage, for: .normal)
            print("defaultTargetLanguageIndex changed")
        }
        
        let titleInfo = ["title" : "Document"]
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
        
        requestMicrophonePermission()
    }
    
    func selectLanguage() {
        //present picker view modal
        let viewController = LanguagePickerViewController()
        viewController.sourceLanguageRow = temporarySourceLanguageIndex
        viewController.targetLanguageRow = temporaryTargetLanguageIndex
        viewController.languagePickerType = .visionTranslate
        viewController.delegate = self
        let navController = UINavigationController(rootViewController: viewController)
        
        self.navigationController?.present(navController, animated: true, completion: nil)
    }
    
    func requestMicrophonePermission() {
        if UIImagePickerController.isSourceTypeAvailable(.camera) {
            if AVCaptureDevice.authorizationStatus(for: .video) ==  .authorized {
                //already authorized
                scanDocument()
            } else {
                AVCaptureDevice.requestAccess(for: .video, completionHandler: { (granted: Bool) in
                    DispatchQueue.main.async {
                        if granted {
                            //access allowed
                            self.scanDocument()
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

    func scanDocument() {
        let scannerViewController = ImageScannerController(image: nil, delegate: self)
        scannerViewController.modalPresentationStyle = .fullScreen
        present(scannerViewController, animated: true)
    }
    
    func handleDetectedText(request: VNRequest?, error: Error?) {
        if error == nil {
            guard let observations = request?.results as? [VNRecognizedTextObservation] else {
                print("Detecting error.")
                SPAlert.present(title: "Error",
                                message: "Cannot recognize text in this photo.",
                                image: UIImage(systemName: "exclamationmark.triangle")!)
                return
            }
            
            if observations.count == 0 {
                print("Cannot detect text in the image.")
                detectedResultString = ""
            } else {
                for observation in observations {
                    let bestObservation = observation.topCandidates(1).first
                    print(bestObservation?.string ?? "No text")
                    print(bestObservation?.confidence ?? 0)
                    guard let string = bestObservation?.string else { return }
                    detectedResultString += (string + " ")
                }
            }
            
        } else {
            print(error!.localizedDescription)
            SPAlert.present(title: "Error",
                            message: error!.localizedDescription,
                            image: UIImage(systemName: "exclamationmark.triangle")!)
        }
    }

}

extension PDFTranslateViewController: UINavigationControllerDelegate, ImageScannerControllerDelegate {
    
    func imageScannerController(_ scanner: ImageScannerController, didFinishScanningWithResults results: ImageScannerResults) {

        KRProgressHUD.show()
        
        let resultImage: UIImage?
        if results.doesUserPreferEnhancedImage == true {
            resultImage = results.enhancedImage
        } else {
            resultImage = results.scannedImage
        }
        
        guard let cgImage = resultImage?.cgImage else { return }
        let requests = [textDetectionRequest]
        let imageRequestHandler = VNImageRequestHandler(cgImage: cgImage, options: [:])
        
        do {
            try imageRequestHandler.perform(requests)
        } catch {
            print("Process image error: \(error.localizedDescription)")
            SPAlert.present(title: "Error",
                            message: error.localizedDescription,
                            image: UIImage(systemName: "exclamationmark.triangle")!)
        }
        
        KRProgressHUD.dismiss()
        dismiss(animated: true) {
            if self.detectedResultString.isEmpty {
                let alert = PMAlertController(title: "No text",
                                              description: "Cannot recognize text in this photo. Please try again.",
                                              image: UIImage(named: "error"),
                                              style: .alert)
                let defaultAction = PMAlertAction(title: "Try again", style: .default)
                alert.addAction(defaultAction)
                self.present(alert, animated: true, completion: nil)
            } else {
                let sourceLanguage = SupportedLanguages.visionRecognizerSupportedLanguage[self.temporarySourceLanguageIndex]
                guard let index = SupportedLanguages.gcpLanguageList.firstIndex(of: sourceLanguage) else { return }
                
                let viewController = TextTranslateViewController()
                viewController.temporarySourceLanguageGCPIndex = index
                viewController.temporaryTargetLanguageGCPIndex = self.temporaryTargetLanguageIndex
                viewController.sourceInputText.text = self.detectedResultString
                viewController.languagePickerType = .targetLanguage
                
                let navController = UINavigationController(rootViewController: viewController)
                self.present(navController, animated: true, completion: nil)
                
                self.detectedResultString = ""
            }
        }
    }

    func imageScannerControllerDidCancel(_ scanner: ImageScannerController) {
        scanner.dismiss(animated: true, completion: nil)
    }

    func imageScannerController(_ scanner: ImageScannerController, didFailWithError error: Error) {
        print(error.localizedDescription)
        scanner.dismiss(animated: true, completion: nil)
    }
}

extension PDFTranslateViewController: LanguagePickerDelegate {
    func didSelectedLanguagePicker(temporarySourceLanguageGCPIndex: Int, temporaryTargetLanguageGCPIndex: Int) {
        let sourceLanguage = SupportedLanguages.visionRecognizerSupportedLanguage[temporarySourceLanguageGCPIndex]
        let targetLanguage = SupportedLanguages.gcpLanguageList[temporaryTargetLanguageGCPIndex]
        sourceLanguageButton.setTitle(sourceLanguage, for: .normal)
        targetLanguageButton.setTitle(targetLanguage, for: .normal)
        self.temporarySourceLanguageIndex = temporarySourceLanguageGCPIndex
        self.temporaryTargetLanguageIndex = temporaryTargetLanguageGCPIndex
    }
}
