//
//  ConversationTranslateViewController.swift
//  MultiTranslate
//
//  Created by Keishin CHOU on 2020/01/12.
//  Copyright © 2020 Keishin CHOU. All rights reserved.
//

import Speech
import UIKit

import Alamofire
import LBTATools
import RealmSwift
import SPAlert
import SwiftyJSON

class ConversationTranslateViewController: UIViewController {
    
    //MARK: - Varities and Constants Declaration
    private var temporarySourceLanguageSpeechIndex = UserDefaults.standard.integer(forKey: Constants.conversationSourceLanguageIndexKey)
    private var temporaryTargetLanguageSpeechIndex = UserDefaults.standard.integer(forKey: Constants.conversationTargetLanguageIndexKey)
    private var defaultSourceLanguageIndex = UserDefaults.standard.integer(forKey: Constants.conversationSourceLanguageIndexKey)
    private var defaultTargetLanguageIndex = UserDefaults.standard.integer(forKey: Constants.conversationTargetLanguageIndexKey)
    
    private var audioRecorder: AVAudioRecorder?
    private var audioFileURL: URL?
    private var extractedText = ""
    
    private let realm = try! Realm()
    private var conversations: Results<Conversation>!
    private var isSource: Bool = true
    
    //MARK: - UI Parts Declaration
    private let container: UIView = {
        let view = UIView()
        view.translatesAutoresizingMaskIntoConstraints = false
        view.backgroundColor = .mtSystemBackground
        return view
    }()
    
    private let conversationTableView: UITableView = {
        let tableView = UITableView()
        tableView.translatesAutoresizingMaskIntoConstraints = false
        tableView.backgroundColor = .mtSystemBackground
        return tableView
    }()

    private let buttonsContainer: UIView = {
        let view = UIView()
        view.backgroundColor = UIColor(rgb: 0x4d80e4)
        view.layer.cornerRadius = 16
        view.layer.maskedCorners = [.layerMinXMinYCorner, .layerMaxXMinYCorner]
        view.layer.masksToBounds = true
        return view
    }()

    private let languageButtonsView: UIView = {
        let view = UIView()
        view.translatesAutoresizingMaskIntoConstraints = false
//        view.backgroundColor = .systemYellow
        return view
    }()
    private let recordButtonView: UIView = {
        let view = UIView()
        view.translatesAutoresizingMaskIntoConstraints = false
//        view.backgroundColor = .black
        return view
    }()
    
    private let languageSelector: UISegmentedControl = {
        let selector = UISegmentedControl(items: ["left", "right"])
        selector.translatesAutoresizingMaskIntoConstraints = false
        selector.selectedSegmentIndex = 0
        selector.backgroundColor = .mtSystemBackground
        selector.selectedSegmentTintColor = UIColor(rgb: 0x4d80e4)
        selector.layer.borderWidth = 1
        selector.layer.borderColor = UIColor.white.cgColor
        return selector
    }()
    
    private let languageListButton: UIButton = {
        let button = UIButton()
        button.translatesAutoresizingMaskIntoConstraints = false
        let config = UIImage.SymbolConfiguration(pointSize: 25, weight: .regular, scale: .medium)
        button.setImage(UIImage(systemName: "list.bullet", withConfiguration: config), for: .normal)
        button.tintColor = .white
        return button
    }()
    
    private let clearButton: UIButton = {
        let button = UIButton()
        button.translatesAutoresizingMaskIntoConstraints = false
        let config = UIImage.SymbolConfiguration(pointSize: 25, weight: .regular, scale: .medium)
        button.setImage(UIImage(systemName: "trash", withConfiguration: config), for: .normal)
        button.tintColor = .white
        return button
    }()
    
    private let recorderButton: UIButton = {
        let button = UIButton()
        button.backgroundColor = .red
        button.heightAnchor.constraint(equalToConstant: 50).isActive = true
        button.widthAnchor.constraint(equalToConstant: 50).isActive = true
        button.layer.cornerRadius = 25
        button.layer.masksToBounds = true
        button.translatesAutoresizingMaskIntoConstraints = false
        
        return button
    }()
    
    private let recorderButtonBorder: UIView = {
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
    
    //MARK: - ViewController life circle
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
                                recordButtonView,
                                alignment: .fill,
                                distribution: .fillEqually)

        languageButtonsView.addSubview(languageSelector)
        languageSelector.centerInSuperview()
        languageSelector.widthAnchor.constraint(equalToConstant: view.frame.width - 125).isActive = true
        languageSelector.heightAnchor.constraint(equalToConstant: 45).isActive = true
        
        languageButtonsView.addSubview(languageListButton)
        languageListButton.leadingAnchor.constraint(equalTo: languageSelector.trailingAnchor, constant: 8).isActive = true
        languageListButton.heightAnchor.constraint(equalToConstant: 45).isActive = true
        languageListButton.widthAnchor.constraint(equalTo: languageListButton.heightAnchor).isActive = true
        languageListButton.centerYAnchor.constraint(equalTo: languageSelector.centerYAnchor).isActive = true
        
        languageButtonsView.addSubview(clearButton)
        clearButton.trailingAnchor.constraint(equalTo: languageSelector.leadingAnchor, constant: -8).isActive = true
        clearButton.heightAnchor.constraint(equalToConstant: 45).isActive = true
        clearButton.widthAnchor.constraint(equalTo: clearButton.heightAnchor).isActive = true
        clearButton.centerYAnchor.constraint(equalTo: languageSelector.centerYAnchor).isActive = true
        
        recordButtonView.addSubview(recorderButtonBorder)
        recorderButtonBorder.centerInSuperview()

        recordButtonView.addSubview(recorderButton)
        recorderButton.centerInSuperview()
        
        container.addSubview(conversationTableView)
        conversationTableView.topAnchor.constraint(equalTo: container.topAnchor).isActive = true
        conversationTableView.leadingAnchor.constraint(equalTo: container.leadingAnchor).isActive = true
        conversationTableView.trailingAnchor.constraint(equalTo: container.trailingAnchor).isActive = true
        conversationTableView.bottomAnchor.constraint(equalTo: buttonsContainer.topAnchor).isActive = true

    }
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        view.backgroundColor = .mtSystemBackground
        
        conversations = realm.objects(Conversation.self)
        
        conversationTableView.delegate = self
        conversationTableView.dataSource = self
        
        conversationTableView.register(ConversationCell.self, forCellReuseIdentifier: Constants.conversationTableViewCellIdentifier)
        conversationTableView.separatorStyle = .none
        conversationTableView.allowsSelection = false
//        conversationTableView.showLastRow()
        
        let sourceLanguage = SupportedLanguages.speechRecognizerSupportedLanguage[temporarySourceLanguageSpeechIndex]
        let targetLanguage = SupportedLanguages.speechRecognizerSupportedLanguage[temporaryTargetLanguageSpeechIndex]
        languageSelector.setTitle(sourceLanguage, forSegmentAt: 0)
        languageSelector.setTitle(targetLanguage, forSegmentAt: 1)
        languageSelector.setTitleTextAttributes([NSAttributedString.Key.foregroundColor: UIColor.systemBackground], for: .selected)
        languageSelector.setTitleTextAttributes([NSAttributedString.Key.foregroundColor: UIColor.label], for: .normal)
        languageSelector.addTarget(self, action: #selector(handleLanguageSelectorValueChanged(_:)), for: .valueChanged)
        
        languageListButton.addTarget(self, action: #selector(changeLanguage), for: .touchUpInside)
        clearButton.addTarget(self, action: #selector(clearRecords), for: .touchUpInside)
        
        if conversations.isEmpty {
            clearButton.isHidden = true
        } else {
            clearButton.isHidden = false
        }
        
        recorderButton.addTarget(self, action: #selector(speechStartRecording), for: .touchDown)
        recorderButton.addTarget(self, action: #selector(speechEndRecording), for: .touchUpInside)
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        
        if defaultSourceLanguageIndex != UserDefaults.standard.integer(forKey: Constants.conversationSourceLanguageIndexKey) {
            temporarySourceLanguageSpeechIndex = UserDefaults.standard.integer(forKey: Constants.conversationSourceLanguageIndexKey)
            defaultSourceLanguageIndex = temporarySourceLanguageSpeechIndex
            let sourceLanguage = SupportedLanguages.speechRecognizerSupportedLanguage[temporarySourceLanguageSpeechIndex]
            languageSelector.setTitle(sourceLanguage, forSegmentAt: 0)
            print("defaultSourceLanguageIndex changed")
        }
        
        if defaultTargetLanguageIndex != UserDefaults.standard.integer(forKey: Constants.conversationTargetLanguageIndexKey) {
            temporaryTargetLanguageSpeechIndex = UserDefaults.standard.integer(forKey: Constants.conversationTargetLanguageIndexKey)
            defaultTargetLanguageIndex = temporaryTargetLanguageSpeechIndex
            let targetLanguage = SupportedLanguages.speechRecognizerSupportedLanguage[temporaryTargetLanguageSpeechIndex]
            languageSelector.setTitle(targetLanguage, forSegmentAt: 1)
            print("defaultTargetLanguageIndex changed")
        }
        
        let titleInfo = ["title" : "Conversation"]
        NotificationCenter.default.post(name: .translationViewControllerDidChange, object: nil, userInfo: titleInfo)
        
        perform(#selector(showBottom), with: nil, afterDelay: 0.05)
    }
    
    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(animated)
        
        requestMicrophonePermission()
        print(conversationTableView.frame.height)
        print(conversationTableView.frame.width)
    }
    
    func requestMicrophonePermission() {
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
                        let alert = PMAlertController(title: "Microphone access not allowed",
                                                      description: "Use microphone to record voice",
                                                      image: UIImage(named: "color_microphone"),
                                                      style: .alert)
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
            print("SFSpeechRecognizer is authorized.")
        } else {
            SFSpeechRecognizer.requestAuthorization { [unowned self] authStatus in
                DispatchQueue.main.async {
                    if authStatus == .authorized {
                        print("Good to go!")
                    } else {
                        print("Transcription permission was declined.")
                        let alert = PMAlertController(title: "Speech recognizer",
                                                      description: "Detect word in speech",
                                                      image: UIImage(named: "color_microphone"),
                                                      style: .alert)
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
    
    //MARK: - Functions
    @objc func showBottom() {
        if !conversations.isEmpty {
            let indexPath = IndexPath(row: conversations.count - 1, section: 0)
            conversationTableView.scrollToRow(at: indexPath, at: .bottom, animated: true)
        }
    }
    
    @objc func handleLanguageSelectorValueChanged(_ sender: UISegmentedControl) {
        switch sender.selectedSegmentIndex {
        case 0:
            isSource = true
        case 1:
            isSource = false
        default:
            isSource = true
        }
        print("Language selector value changed. isSource is \(isSource)")
    }
    
    @objc func changeLanguage() {
        //present picker view modal
        let viewController = LanguagePickerViewController()
        viewController.sourceLanguageRow = temporarySourceLanguageSpeechIndex
        viewController.targetLanguageRow = temporaryTargetLanguageSpeechIndex
        viewController.languagePickerType = .conversationTranslate
        viewController.delegate = self
        let navController = UINavigationController(rootViewController: viewController)
        
        self.navigationController?.present(navController, animated: true, completion: nil)
    }
    
    @objc func clearRecords() {
        let alert = PMAlertController(title: "Delete all records?",
                                      description: "The records cannot be recovered once deleted",
                                      image: UIImage(named: "trash_color"),
                                      style: .alert)
        let cancelAction = PMAlertAction(title: "Cancel", style: .cancel)
        let defaultAction = PMAlertAction(title: "Delete", style: .default) {
            do {
                try self.realm.write {
                    self.realm.delete(self.conversations)
                }
            } catch {
                print("Error adding item, \(error)")
                SPAlert.present(title: "Error",
                                message: error.localizedDescription,
                                image: UIImage(systemName: "exclamationmark.triangle")!)
            }
            SPAlert.present(title: "Records cleared",
                            message: nil,
                            image: UIImage(systemName: "trash.fill")!)
            self.conversationTableView.reloadData()
            self.clearButton.isHidden = true
        }
        alert.addAction(cancelAction)
        alert.addAction(defaultAction)
        present(alert, animated: true, completion: nil)
    }

    @objc func speechStartRecording() {
        UIView.animate(withDuration: 0.2) {
            self.recorderButton.transform = CGAffineTransform(scaleX: 0.7, y: 0.7)
            self.recorderButton.layer.cornerRadius = 3.0
        }
        startRecording()
    }
    
    @objc func speechEndRecording() {
        if AVCaptureDevice.authorizationStatus(for: .audio) ==  .authorized &&
            SFSpeechRecognizer.authorizationStatus() == .authorized {
            finishRecording(success: true)
        } else {
            finishRecording(success: false)
        }
        UIView.animate(withDuration: 0.2) {
            self.recorderButton.transform = CGAffineTransform(scaleX: 1.0, y: 1.0)
            self.recorderButton.layer.cornerRadius = 25
        }
    }
    
    
    func startRecording() {
        audioFileURL = getDocumentsDirectory().appendingPathComponent("recording.m4a")
        guard let url = audioFileURL else { return }

        let settings = [
            AVFormatIDKey: Int(kAudioFormatMPEG4AAC),
            AVSampleRateKey: 12000,
            AVNumberOfChannelsKey: 1,
            AVEncoderAudioQualityKey: AVAudioQuality.high.rawValue
            ]

        do {
            audioRecorder = try AVAudioRecorder(url: url, settings: settings)
            audioRecorder?.delegate = self
            audioRecorder?.prepareToRecord()
            audioRecorder?.isMeteringEnabled = true
            audioRecorder?.record()

        } catch {
            finishRecording(success: false)
            SPAlert.present(title: "Error",
                            message: error.localizedDescription,
                            image: UIImage(systemName: "exclamationmark.triangle")!)
        }
    }

    func finishRecording(success: Bool) {
        audioRecorder!.stop()
        audioRecorder = nil

        if success {
            print("Recording successed.")
            transcribeAudio(url: self.audioFileURL!)
        } else {
            print("Recording failed.")
            //Show alert
            if AVCaptureDevice.authorizationStatus(for: .audio) !=  .authorized ||
                SFSpeechRecognizer.authorizationStatus() != .authorized {
                let alert = PMAlertController(title: "Chech app setting",
                                              description: "Please allow microphone and speech recognizer",
                                              image: UIImage(named: "color_microphone"),
                                              style: .alert)
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
        print(isSource)
    }
    
    func transcribeAudio(url: URL) {
        let identifier = isSource ? SupportedLanguages.speechRecognizerSupportedLocaleIdentifier[temporarySourceLanguageSpeechIndex] : SupportedLanguages.speechRecognizerSupportedLocaleIdentifier[temporaryTargetLanguageSpeechIndex]
        print("speech identifier is \(identifier)")
        let recognizer = SFSpeechRecognizer(locale: Locale(identifier: identifier))
        let request = SFSpeechURLRecognitionRequest(url: url)

        recognizer?.recognitionTask(with: request) { [unowned self] (result, error) in
            guard let result = result else {
                print("There was an error: \(error!.localizedDescription)")
                print("Cannot extract any text from the audio")
                // show alert
                let alert = PMAlertController(title: "No text",
                                              description: "Cannot extract any text from the speech, please try again.",
                                              image: UIImage(named: "question_mark"),
                                              style: .alert)
                let defaultAction = PMAlertAction(title: "Try again", style: .default)
                alert.addAction(defaultAction)
                self.present(alert, animated: true, completion: nil)
                
                return
            }

            if result.isFinal {
                self.extractedText = result.bestTranscription.formattedString
                print(self.extractedText)

                self.translateText()
            }
        }
    }
    
    func translateText() {
        
        guard let sourceLanguageText = languageSelector.titleForSegment(at: 0),
            let targetLanuageText = languageSelector.titleForSegment(at: 1) else {
                return
        }
        
        let textToTranslate = extractedText

        let sourceLanguageCode: String
        let targetLanguageCode: String
        let sourceLanguage: String
        let targetLanguage: String
        
        if isSource {
            sourceLanguageCode = SupportedLanguages.speechRecognizerSupportedLanguageCode[temporarySourceLanguageSpeechIndex]
            targetLanguageCode = SupportedLanguages.speechRecognizerSupportedLanguageCode[temporaryTargetLanguageSpeechIndex]
            sourceLanguage = sourceLanguageText
            targetLanguage = targetLanuageText
        } else {
            sourceLanguageCode = SupportedLanguages.speechRecognizerSupportedLanguageCode[temporaryTargetLanguageSpeechIndex]
            targetLanguageCode = SupportedLanguages.speechRecognizerSupportedLanguageCode[temporarySourceLanguageSpeechIndex]
            sourceLanguage = targetLanuageText
            targetLanguage = sourceLanguageText
        }

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
                self.createNewConversation(using: result)
                print("the FB translation is: \(result)")
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
                self.createNewConversation(using: result)
                print("the GCP translation is: \(result)")
            } else {
                print(error!.localizedDescription)
                SPAlert.present(title: "Error",
                                message: error?.localizedDescription,
                                image: UIImage(systemName: "exclamationmark.triangle")!)
            }
        }
    }
    
    func createNewConversation(using translatedText: String) {
        let conversation = Conversation()
        conversation.sourceMessage = extractedText
        conversation.targetMessage = translatedText
        conversation.isSource = isSource
        
        try! realm.write {
            realm.add(conversation)
        }
        
        conversationTableView.reloadData()
        conversationTableView.showLastRow()
        clearButton.isHidden = false
    }


    func getDocumentsDirectory() -> URL {
        let paths = FileManager.default.urls(for: .documentDirectory, in: .userDomainMask)
        print(paths[0])
        return paths[0]
    }

}


// MARK: - Extensions
extension UITableView {
    func showLastRow() {
        guard self.numberOfRows(inSection: 0) > 0 else { return }
        DispatchQueue.main.async {
            let indexPath = IndexPath(row: self.numberOfRows(inSection: 0) - 1, section: 0)
            self.scrollToRow(at: indexPath, at: .bottom, animated: true)
        }
    }
}

extension ConversationTranslateViewController: UITableViewDelegate {
//    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
//        tableView.deselectRow(at: indexPath, animated: true)
//    }
}

extension ConversationTranslateViewController: UITableViewDataSource {
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return conversations.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: Constants.conversationTableViewCellIdentifier, for: indexPath) as! ConversationCell
        cell.conversation = conversations[indexPath.row]
        return cell
    }
}

extension ConversationTranslateViewController: LanguagePickerDelegate {
    func didSelectedLanguagePicker(temporarySourceLanguageGCPIndex: Int, temporaryTargetLanguageGCPIndex: Int) {
        let sourceLanguage = SupportedLanguages.speechRecognizerSupportedLanguage[temporarySourceLanguageGCPIndex]
        let targetLanguage = SupportedLanguages.speechRecognizerSupportedLanguage[temporaryTargetLanguageGCPIndex]
        languageSelector.setTitle(sourceLanguage, forSegmentAt: 0)
        languageSelector.setTitle(targetLanguage, forSegmentAt: 1)
        self.temporarySourceLanguageSpeechIndex = temporarySourceLanguageGCPIndex
        self.temporaryTargetLanguageSpeechIndex = temporaryTargetLanguageGCPIndex
    }
}

extension ConversationTranslateViewController: AVAudioRecorderDelegate {
    func audioRecorderDidFinishRecording(_ recorder: AVAudioRecorder, successfully flag: Bool) {
        if !flag {
            finishRecording(success: false)
        }
    }
}
