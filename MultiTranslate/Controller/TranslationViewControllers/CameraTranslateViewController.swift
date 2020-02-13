//
//  CameraTranslateViewController.swift
//  MultiTranslate
//
//  Created by Keishin CHOU on 2020/01/06.
//  Copyright © 2020 Keishin CHOU. All rights reserved.
//

import UIKit
import Vision

import LBTATools
import PMSuperButton
import CropViewController
import KRProgressHUD


class CameraTranslateViewController: UIViewController {
    
    var detectedResultString = ""
    private var temporarySourceLanguageIndex = UserDefaults.standard.integer(forKey: Constants.cameraSourceLanguageIndexKey)
    private var temporaryTargetLanguageIndex = UserDefaults.standard.integer(forKey: Constants.cameraTargetLanguageIndexKey)
    private var defaultSourceLanguageIndex = UserDefaults.standard.integer(forKey: Constants.cameraSourceLanguageIndexKey)
    private var defaultTargetLanguageIndex = UserDefaults.standard.integer(forKey: Constants.cameraTargetLanguageIndexKey)
    
    private let container: UIView = {
        let view = UIView()
        view.translatesAutoresizingMaskIntoConstraints = false
        view.backgroundColor = UIColor(rgb: 0xe1f2fb)
        
        return view
    }()

    private let cameraImageContainer: PMSuperButton = {
        let button = PMSuperButton()
        button.gradientEnabled = true
        button.gradientStartColor = #colorLiteral(red: 0.4745098054, green: 0.8392156959, blue: 0.9764705896, alpha: 1)
        button.gradientEndColor = #colorLiteral(red: 0.2196078449, green: 0.007843137719, blue: 0.8549019694, alpha: 1)
        button.gradientHorizontal = true
        button.ripple = true
        button.rippleColor = #colorLiteral(red: 0.9880490899, green: 0.7656863332, blue: 0.9337566495, alpha: 0.5442262414)
        
        return button
    }()
    
    private let cameraImage = UIImageView(image: UIImage(named: "color_camera"), contentMode: .scaleAspectFit)
    private let cameraLabel = UILabel(text: "Use camera", font: .systemFont(ofSize: 50, weight: .thin), textAlignment: .center, numberOfLines: 1)
    
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
    
    private let imagePicker: UIImagePickerController = {
        let imagePicker = UIImagePickerController()
        imagePicker.allowsEditing = true
        
        if UIImagePickerController.isSourceTypeAvailable(.camera) {
            imagePicker.sourceType = .camera
        } else {
            // FIXME: Only on simylator
            imagePicker.sourceType = .photoLibrary
        }
        
        return imagePicker
    }()
    
    lazy private var textDetectionRequest: VNRecognizeTextRequest = {
        let request = VNRecognizeTextRequest(completionHandler: self.handleDetectedText)
        request.recognitionLevel = .accurate
        request.recognitionLanguages = ["en_US"]
        request.usesLanguageCorrection = true
        return request
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
        
        buttonView.VStack(cameraImageContainer.setWidth(150).setHeight(150),
                          cameraLabel,
                          spacing: 8,
                          alignment: .center,
                          distribution: .fillProportionally).padTop(50)
        
        cameraImageContainer.layer.cornerRadius = 75

        cameraImageContainer.addSubview(cameraImage)
        cameraImage.translatesAutoresizingMaskIntoConstraints = false
        cameraImage.centerXAnchor.constraint(equalTo: cameraImageContainer.centerXAnchor).isActive = true
        cameraImage.centerYAnchor.constraint(equalTo: cameraImageContainer.centerYAnchor).isActive = true
        cameraImage.setWidth(100)
        cameraImage.setHeight(100)
    }

    override func viewDidLoad() {
        super.viewDidLoad()

        cameraImageContainer.addTarget(self, action: #selector(useCamera), for: .touchUpInside)
        imagePicker.delegate = self
        
        sourceLanguageLabel.text = SupportedLanguages.visionRecognizerSupportedLanguage[temporarySourceLanguageIndex]
        targetLanguageLabel.text = SupportedLanguages.gcpLanguageList[temporaryTargetLanguageIndex]
        
        let sourceLanguageRecognizer = UITapGestureRecognizer(target: self, action: #selector(selectLanguage))
        sourceLanguageLabel.addGestureRecognizer(sourceLanguageRecognizer)
        let targetLanguageRecognizer = UITapGestureRecognizer(target: self, action: #selector(selectLanguage))
        targetLanguageLabel.addGestureRecognizer(targetLanguageRecognizer)
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        
        if defaultSourceLanguageIndex != UserDefaults.standard.integer(forKey: Constants.cameraSourceLanguageIndexKey) {
            temporarySourceLanguageIndex = UserDefaults.standard.integer(forKey: Constants.cameraSourceLanguageIndexKey)
            defaultSourceLanguageIndex = temporarySourceLanguageIndex
            sourceLanguageLabel.text = SupportedLanguages.visionRecognizerSupportedLanguage[temporarySourceLanguageIndex]
            print("defaultSourceLanguageIndex changed")
        }
        
        if defaultTargetLanguageIndex != UserDefaults.standard.integer(forKey: Constants.cameraTargetLanguageIndexKey) {
            temporaryTargetLanguageIndex = UserDefaults.standard.integer(forKey: Constants.cameraTargetLanguageIndexKey)
            defaultTargetLanguageIndex = temporaryTargetLanguageIndex
            targetLanguageLabel.text = SupportedLanguages.gcpLanguageList[temporaryTargetLanguageIndex]
            print("defaultTargetLanguageIndex changed")
        }
    }
    
    @objc func useCamera() {
        print("Use camera tapped.")
        
        if UIImagePickerController.isSourceTypeAvailable(.camera) {
            present(imagePicker, animated: true, completion: nil)
        } else {
            print("Camera is not available.")
        }
        
    }
    
    @objc func selectLanguage() {
        //present picker view modal
        let viewController = LanguagePickerViewController()
        viewController.sourceLanguageRow = temporarySourceLanguageIndex
        viewController.targetLanguageRow = temporaryTargetLanguageIndex
        viewController.languagePickerType = .visionTranslate
        viewController.delegate = self
        let navController = UINavigationController(rootViewController: viewController)
        
        self.navigationController?.present(navController, animated: true, completion: nil)
    }
    
    func handleDetectedText(request: VNRequest?, error: Error?) {
        if error == nil {
            guard let observations = request?.results as? [VNRecognizedTextObservation] else {
                print("Detecting error.")
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
        }
    }

}

extension CameraTranslateViewController: UIImagePickerControllerDelegate, UINavigationControllerDelegate, CropViewControllerDelegate {
    func imagePickerController(_ picker: UIImagePickerController, didFinishPickingMediaWithInfo info: [UIImagePickerController.InfoKey : Any]) {

        dismiss(animated: true) {
            guard let image = info[.editedImage] as? UIImage else { return }

            let cropViewController = CropViewController(image: image)
            cropViewController.delegate = self
            self.present(cropViewController, animated: true, completion: nil)
        }
    }
    
    func cropViewController(_ cropViewController: CropViewController, didCropImageToRect rect: CGRect, angle: Int) {
        KRProgressHUD.show()
    }
    
    func cropViewController(_ cropViewController: CropViewController, didCropToImage image: UIImage, withRect cropRect: CGRect, angle: Int) {
        
        guard let cgImage = image.cgImage else { return }
        let requests = [textDetectionRequest]
        let imageRequestHandler = VNImageRequestHandler(cgImage: cgImage, options: [:])
        
        do {
            try imageRequestHandler.perform(requests)
        } catch {
            print("Process image error: \(error.localizedDescription)")
        }
        
        KRProgressHUD.dismiss()
        
        dismiss(animated: true) {
            if self.detectedResultString.isEmpty {
                print("Result is empty.") // UIAlertViewController
            } else {
                guard let sourceLanguage = self.sourceLanguageLabel.text,
                    let index = SupportedLanguages.gcpLanguageList.firstIndex(of: sourceLanguage) else { return }
                
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
    
}

extension CameraTranslateViewController: LanguagePickerDelegate {
    func didSelectedLanguagePicker(temporarySourceLanguageGCPIndex: Int, temporaryTargetLanguageGCPIndex: Int) {
        sourceLanguageLabel.text = SupportedLanguages.visionRecognizerSupportedLanguage[temporarySourceLanguageGCPIndex]
        targetLanguageLabel.text = SupportedLanguages.gcpLanguageList[temporaryTargetLanguageGCPIndex]
        self.temporarySourceLanguageIndex = temporarySourceLanguageGCPIndex
        self.temporaryTargetLanguageIndex = temporaryTargetLanguageGCPIndex
    }
}
