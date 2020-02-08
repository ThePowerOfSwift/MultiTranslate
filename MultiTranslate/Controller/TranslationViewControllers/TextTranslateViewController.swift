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
    var temporarySourceLanguageGCPIndex = UserDefaults.standard.integer(forKey: Constants.sourceLanguageGCPIndexKey)
    var temporaryTargetLanguageGCPIndex = UserDefaults.standard.integer(forKey: Constants.targetLanguageGCPIndexKey)
    var translateType: TranslateType = .text
    
    private var isStarButtonTapped: Bool = false
    
    private var translatedCharactersCurrentMonth = 0
    
    private let realm = try! Realm()
    private var savedTranslations: Results<SavedTranslation>!
    
    private var cloudDBTranslatedCharacters = 0
    
//    private let sourceLanguageGCPIndex = UserDefaults.standard.integer(forKey: Constants.sourceLanguageGCPIndexKey)
//    private let targetLanguageGCPIndex = UserDefaults.standard.integer(forKey: Constants.targetLanguageGCPIndexKey)
    
    //MARK: - UI Parts Declaration
    
    private let container: UIView = {
        let view = UIView()
        view.translatesAutoresizingMaskIntoConstraints = false
        
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
    
    private let exchangeButtonView: UIView = {
        let view = UIView()
        view.translatesAutoresizingMaskIntoConstraints = false
        return view
    }()
    
    private let targetLanguageView: UIView = {
        let view = UIView()
        view.translatesAutoresizingMaskIntoConstraints = false
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
//        button.backgroundColor = .blue
//        button.layer.borderWidth = 2.0
//        button.layer.borderColor = UIColor.purple.cgColor
        button.layer.cornerRadius = 15.0
        button.setTitleColor(.white, for: .normal)
        button.setTitleColor(.darkGray, for: .highlighted)
        button.backgroundColor = .systemBlue
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
    
    private let sourceLanguageLabel: UILabel = {
        let label = UILabel()
//        label.backgroundColor = #colorLiteral(red: 0.4745098054, green: 0.8392156959, blue: 0.9764705896, alpha: 1)
        label.isUserInteractionEnabled = true
        label.textAlignment = .center
        label.numberOfLines = 0
        label.lineBreakMode = .byWordWrapping
        label.frame = .zero
        label.translatesAutoresizingMaskIntoConstraints = false
//        label.text = languageList[1]
        return label
    }()
    
    private let targetLanguageLabel: UILabel = {
        let label = UILabel()
//        label.backgroundColor = #colorLiteral(red: 0.4745098054, green: 0.8392156959, blue: 0.9764705896, alpha: 1)
        label.isUserInteractionEnabled = true
        label.textAlignment = .center
        label.numberOfLines = 0
        label.lineBreakMode = .byWordWrapping
        label.frame = .zero
        label.translatesAutoresizingMaskIntoConstraints = false
//        label.text = languageList[2]
        return label
    }()
    
    private let sourceInputLabel: UILabel = {
        let label = UILabel()
        label.text = "Enter text"
//        label.backgroundColor = .systemBackground
        label.translatesAutoresizingMaskIntoConstraints = false
        return label
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
    
    private let sourceInputLabelView: UIView = {
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
        
        view.addSubview(container)
        container.edgeTo(view, safeArea: .top)
        
        container.VStack(languageSelectView.setHeight(75),
                         sourceInputView.setHeight(200),
                         translateButtonView.setHeight(50),
                         targetOutputView,
                         spacing: 5,
                         alignment: .fill,
                         distribution: .fill)
        
        languageSelectView.HStack(sourceLanguageView,
                                  exchangeButtonView.setWidth(65),
                                  targetLanguageView,
                                  spacing: 5,
                                  alignment: .fill,
                                  distribution: .fill)
        exchangeButtonView.centerXAnchor.constraint(equalTo: languageSelectView.centerXAnchor).isActive = true

        
        sourceLanguageView.addSubview(sourceLanguageLabel)
        sourceLanguageLabel.centerYAnchor.constraint(equalTo: sourceLanguageView.centerYAnchor).isActive = true
        sourceLanguageLabel.widthAnchor.constraint(equalTo: sourceLanguageView.widthAnchor).isActive = true
        
        exchangeButtonView.addSubview(exchangeButton)
        exchangeButton.centerXAnchor.constraint(equalTo: exchangeButtonView.centerXAnchor).isActive = true
        exchangeButton.centerYAnchor.constraint(equalTo: exchangeButtonView.centerYAnchor).isActive = true

        targetLanguageView.addSubview(targetLanguageLabel)
        targetLanguageLabel.centerYAnchor.constraint(equalTo: targetLanguageView.centerYAnchor).isActive = true
        targetLanguageLabel.widthAnchor.constraint(equalTo: targetLanguageView.widthAnchor).isActive = true

        if translateType == .targetOnly {
            sourceLanguageView.isHidden = true
            exchangeButtonView.isHidden = true
        }
        
        sourceInputView.VStack(sourceInputLabelView.setHeight(30),
                               sourceInputTextView,
                               spacing: 5,
                               alignment: .fill,
                               distribution: .fill)
        
        sourceInputLabelView.addSubview(sourceInputLabel)
        sourceInputLabel.leadingAnchor.constraint(equalTo: sourceInputLabelView.leadingAnchor, constant: 20).isActive = true
        sourceInputLabel.topAnchor.constraint(equalTo: sourceInputLabelView.topAnchor).isActive = true
        sourceInputLabel.bottomAnchor.constraint(equalTo: sourceInputLabelView.bottomAnchor).isActive = true
        sourceInputLabel.widthAnchor.constraint(equalTo: sourceInputLabelView.widthAnchor, multiplier: 0.5).isActive = true
        
        sourceInputTextView.addSubview(sourceInputText)
        sourceInputText.leadingAnchor.constraint(equalTo: sourceInputTextView.leadingAnchor, constant: 10).isActive = true
        sourceInputText.trailingAnchor.constraint(equalTo: sourceInputTextView.trailingAnchor, constant: -10).isActive = true
        sourceInputText.topAnchor.constraint(equalTo: sourceInputTextView.topAnchor, constant: 10).isActive = true
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
        
        view.backgroundColor = UIColor(rgb: 0xe1f2fb)
        
        savedTranslations = realm.objects(SavedTranslation.self)
        
        sourceLanguageLabel.text = SupportedLanguages.gcpLanguageList[temporarySourceLanguageGCPIndex]
        targetLanguageLabel.text = SupportedLanguages.gcpLanguageList[temporaryTargetLanguageGCPIndex]
        
        let sourceLanguageRecognizer = UITapGestureRecognizer(target: self, action: #selector(selectLanguage))
        sourceLanguageLabel.addGestureRecognizer(sourceLanguageRecognizer)
        let targetLanguageRecognizer = UITapGestureRecognizer(target: self, action: #selector(selectLanguage))
        targetLanguageLabel.addGestureRecognizer(targetLanguageRecognizer)
        
        exchangeButton.addTarget(self, action: #selector(exchangeLanguage), for: .touchUpInside)
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
    
    
    // MARK: - UIButton Implementation
    @objc func doneButtonTapped() {
        dismiss(animated: true, completion: nil)
    }
    
    @objc func selectLanguage() {
        //present picker view modal
        let viewController = LanguagePickerViewController()
        viewController.sourceLanguageRow = temporarySourceLanguageGCPIndex
        viewController.targetLanguageRow = temporaryTargetLanguageGCPIndex
        viewController.translateType = self.translateType
        viewController.delegate = self
        let navController = UINavigationController(rootViewController: viewController)
        
        self.navigationController?.present(navController, animated: true, completion: nil)
    }
    
    @objc func exchangeLanguage() {
        
        let exchangeText = targetLanguageLabel.text
        
        UIView.animate(withDuration: 0.25, animations: {
            self.exchangeButton.transform = CGAffineTransform(rotationAngle: CGFloat.pi)
            self.exchangeButton.transform = self.exchangeButton.transform.rotated(by: CGFloat.pi)
            self.targetLanguageLabel.text = self.sourceLanguageLabel.text
            self.sourceLanguageLabel.text = exchangeText
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
        guard let text = sourceInputText.text else { return }
        let sourceLanguageCode = SupportedLanguages.gcpLanguageCode[temporarySourceLanguageGCPIndex]
        let targetLanguageCode = SupportedLanguages.gcpLanguageCode[temporaryTargetLanguageGCPIndex]
        print("sourceLanguageCode is \(sourceLanguageCode)")
        print("targetLanguageCode is \(targetLanguageCode)")
        
        GoogleCloudTranslate.textTranslate(sourceLanguage: sourceLanguageCode, targetLanguage: targetLanguageCode, textToTranslate: text) { (translatedText, error) in
            if let text = translatedText {
                self.starButton.isHidden = false
                self.isStarButtonTapped = false
                self.starButton.setImage(UIImage(systemName: "star"), for: .normal)
                self.starButton.tintColor = .gray
                
                self.speechButton.isHidden = false
                
                self.targetOutputText.isHidden = false
                self.targetOutputText.text = text
            } else {
                print(error!.localizedDescription)
            }
        }
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
        sourceInputLabelView.addSubview(clearButton)
        clearButton.topAnchor.constraint(equalTo: sourceInputLabelView.topAnchor).isActive = true
        clearButton.bottomAnchor.constraint(equalTo: sourceInputLabelView.bottomAnchor).isActive = true
        clearButton.trailingAnchor.constraint(equalTo: sourceInputLabelView.trailingAnchor, constant: -10).isActive = true
        clearButton.widthAnchor.constraint(equalToConstant: 75).isActive = true
        
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
        sourceLanguageLabel.text = SupportedLanguages.gcpLanguageList[temporarySourceLanguageGCPIndex]
        targetLanguageLabel.text = SupportedLanguages.gcpLanguageList[temporaryTargetLanguageGCPIndex]
        self.temporarySourceLanguageGCPIndex = temporarySourceLanguageGCPIndex
        self.temporaryTargetLanguageGCPIndex = temporaryTargetLanguageGCPIndex
    }
    
    
}

