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
import SwiftyJSON

class ConversationTranslateViewController: UIViewController {
    
    //MARK: - Varities and Constants Declaration
    private var temporarySourceLanguageSpeechIndex = UserDefaults.standard.integer(forKey: Constants.conversationSourceLanguageIndexKey)
    private var temporaryTargetLanguageSpeechIndex = UserDefaults.standard.integer(forKey: Constants.conversationTargetLanguageIndexKey)
    private var defaultSourceLanguageIndex = UserDefaults.standard.integer(forKey: Constants.conversationSourceLanguageIndexKey)
    private var defaultTargetLanguageIndex = UserDefaults.standard.integer(forKey: Constants.conversationTargetLanguageIndexKey)
    
    private var recordingSession: AVAudioSession!
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
        view.backgroundColor = UIColor(rgb: 0xe1f2fb)
        return view
    }()
    
    private let conversationTableView: UITableView = {
        let tableView = UITableView()
        tableView.translatesAutoresizingMaskIntoConstraints = false
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
        selector.backgroundColor = UIColor(rgb: 0xe1f2fb)
        selector.selectedSegmentTintColor = UIColor(rgb: 0x4d80e4)
        selector.layer.borderWidth = 1
        selector.layer.borderColor = UIColor.white.cgColor
        return selector
    }()
    
    let languageListButton: UIButton = {
        let button = UIButton()
        button.translatesAutoresizingMaskIntoConstraints = false
        let config = UIImage.SymbolConfiguration(pointSize: 25, weight: .regular, scale: .medium)
        button.setImage(UIImage(systemName: "list.bullet", withConfiguration: config), for: .normal)
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
        
        recorderButton.addTarget(self, action: #selector(speechStartRecording), for: .touchDown)
        recorderButton.addTarget(self, action: #selector(speechEndRecording), for: .touchUpInside)
        
        recordingSession = AVAudioSession.sharedInstance()

        do {
            try recordingSession.setCategory(.playAndRecord, mode: .default)
            try recordingSession.setActive(true)
            recordingSession.requestRecordPermission() { [unowned self] allowed in
                DispatchQueue.main.async {
                    if !allowed {
                        print("Failed to record!")
                    }
                }
            }
        } catch {
            print("Failed to record!")
        }
        
        perform(#selector(showBottom), with: nil, afterDelay: 0.05)
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
    }
    
    //MARK: - Functions
    @objc func showBottom() {
        if !conversations.isEmpty {
            let indexPath = IndexPath(row: conversations.count - 1, section: 0)
            conversationTableView.scrollToRow(at: indexPath, at: .bottom, animated: false)
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

    @objc func speechStartRecording() {
        UIView.animate(withDuration: 0.2) {
            self.recorderButton.transform = CGAffineTransform(scaleX: 0.7, y: 0.7)
            self.recorderButton.layer.cornerRadius = 3.0
        }
        startRecording()
    }
    
    @objc func speechEndRecording() {
        print("sourceLanguage button tap canceled")
        
        finishRecording(success: true)
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
        }
    }

    func finishRecording(success: Bool) {
        audioRecorder!.stop()
        audioRecorder = nil

        if success {
            print("Recording successed.")
            
            requestTranscribePermissions()
            
        } else {
            print("Recording failed.")
            //Show alert
        }
        print(isSource)
    }
    
    func requestTranscribePermissions() {
        SFSpeechRecognizer.requestAuthorization { [unowned self] authStatus in
            DispatchQueue.main.async {
                if authStatus == .authorized {
                    print("Good to go!")
                    self.transcribeAudio(url: self.audioFileURL!)
                } else {
                    print("Transcription permission was declined.")
                }
            }
        }
    }
    
    func transcribeAudio(url: URL) {
        let identifier = isSource ? SupportedLanguages.speechRecognizerSupportedLocaleIdentifier[temporarySourceLanguageSpeechIndex] : SupportedLanguages.speechRecognizerSupportedLocaleIdentifier[temporaryTargetLanguageSpeechIndex]
        print("speech identifier is \(identifier)")
        let recognizer = SFSpeechRecognizer(locale: Locale(identifier: identifier))
        let request = SFSpeechURLRecognitionRequest(url: url)

        recognizer?.recognitionTask(with: request) { [unowned self] (result, error) in
            guard let result = result else {
                print("There was an error: \(error!)")
                print("Cannot extract any text from the audio")
                // show alert
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
                self.createNewConversation(using: result)
                print("the FB translation is: \(result)")
            } else {
                print(error!.localizedDescription)
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
