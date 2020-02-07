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
    
    private var temporarySourceLanguageSpeechIndex = 0
    private var temporaryTargetLanguageSpeechIndex = 0
    
    private var recordingSession: AVAudioSession!
    private var audioRecorder: AVAudioRecorder?
    private var audioFileURL: URL?
    private var extractedText = ""
    
    private let realm = try! Realm()
    private var conversations: Results<Conversation>!
    private var isSource: Bool = true
    
    private let container: UIView = {
        let view = UIView()
        view.translatesAutoresizingMaskIntoConstraints = false
        return view
    }()
    
    private let conversationTableView: UITableView = {
        let tableView = UITableView()
        tableView.translatesAutoresizingMaskIntoConstraints = false
        return tableView
    }()

    private let buttonsContainer: UIView = {
        let view = UIView()
        view.backgroundColor = .gray
        view.layer.cornerRadius = 10
        view.layer.maskedCorners = [.layerMinXMinYCorner, .layerMaxXMinYCorner]
        view.layer.masksToBounds = true
        return view
    }()

    private let languageButtonsView = UIView(backgroundColor: .yellow)
    private let recordButtonsView = UIView(backgroundColor: .black)
    
    private let sourceLanguageView = UIView(backgroundColor: .red)
    private let languageExchangeView = UIView(backgroundColor: .systemBackground)
    private let targetLanguageView = UIView(backgroundColor: .green)

    private let sourceLanguageGCPIndex = UserDefaults.standard.integer(forKey: Constants.sourceLanguageGCPIndexKey)
    private let targetLanguageGCPIndex = UserDefaults.standard.integer(forKey: Constants.targetLanguageGCPIndexKey)
    
    private let sourceLanguageButton = UIButton(title: "languageList[0]", titleColor: .label)
    private let languageExchangeButton = UIButton(image: UIImage(named: "exchange")!)
    private let targetLanguageButton = UIButton(title: "languageList[2]", titleColor: .label)
    
    private let sourceRecorderButtonView = UIView()
    private let recorderButtonPaddingView = UIView()
    private let targetRecorderButtonView = UIView()
    
    private lazy var sourceRecorderButton: UIButton = {
        let button = UIButton()
        button.backgroundColor = .red
        button.heightAnchor.constraint(equalToConstant: 50).isActive = true
        button.widthAnchor.constraint(equalToConstant: 50).isActive = true
        button.layer.cornerRadius = 25
        button.layer.masksToBounds = true
        button.translatesAutoresizingMaskIntoConstraints = false
        
        return button
    }()
    
    private lazy var sourceRecorderButtonBorder: UIView = {
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
    
    private lazy var targetRecorderButton: UIButton = {
        let button = UIButton()
        button.backgroundColor = .red
        button.heightAnchor.constraint(equalToConstant: 50).isActive = true
        button.widthAnchor.constraint(equalToConstant: 50).isActive = true
        button.layer.cornerRadius = 25
        button.layer.masksToBounds = true
        button.translatesAutoresizingMaskIntoConstraints = false
        
        return button
    }()
    
    private lazy var targetRecorderButtonBorder: UIView = {
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
                                recordButtonsView,
                                alignment: .fill,
                                distribution: .fillEqually)
        
        languageButtonsView.HStack(sourceLanguageView,
                                   languageExchangeView.setWidth(50),
                                   targetLanguageView,
                                   spacing: 10,
                                   alignment: .fill,
                                   distribution: .fill)
        sourceLanguageView.widthAnchor.constraint(equalTo: targetLanguageView.widthAnchor).isActive = true
        
        sourceLanguageView.addSubview(sourceLanguageButton)
        sourceLanguageButton.centerInSuperview()
        sourceLanguageButton.leadingAnchor.constraint(equalTo: sourceLanguageView.leadingAnchor).isActive = true
        sourceLanguageButton.trailingAnchor.constraint(equalTo: sourceLanguageView.trailingAnchor).isActive = true
        sourceLanguageButton.titleLabel?.leadingAnchor.constraint(equalTo: sourceLanguageButton.leadingAnchor).isActive = true
        sourceLanguageButton.titleLabel?.trailingAnchor.constraint(equalTo: sourceLanguageButton.trailingAnchor).isActive = true
        sourceLanguageButton.titleLabel?.textAlignment = .center
        
        languageExchangeView.addSubview(languageExchangeButton)
        languageExchangeButton.setHeight(50)
        languageExchangeButton.setWidth(50)
        languageExchangeButton.centerInSuperview()
        
        targetLanguageView.addSubview(targetLanguageButton)
        targetLanguageButton.centerInSuperview()
        targetLanguageButton.leadingAnchor.constraint(equalTo: targetLanguageView.leadingAnchor).isActive = true
        targetLanguageButton.trailingAnchor.constraint(equalTo: targetLanguageView.trailingAnchor).isActive = true
        targetLanguageButton.titleLabel?.leadingAnchor.constraint(equalTo: targetLanguageButton.leadingAnchor).isActive = true
        targetLanguageButton.titleLabel?.trailingAnchor.constraint(equalTo: targetLanguageButton.trailingAnchor).isActive = true
        targetLanguageButton.titleLabel?.textAlignment = .center
        
        recordButtonsView.HStack(sourceRecorderButtonView,
                                 recorderButtonPaddingView.setWidth(50),
                                 targetRecorderButtonView,
                                 spacing: 10,
                                 alignment: .fill,
                                 distribution: .fill)
        sourceRecorderButtonView.widthAnchor.constraint(equalTo: targetRecorderButtonView.widthAnchor).isActive = true
        
        sourceRecorderButtonView.addSubview(sourceRecorderButtonBorder)
        sourceRecorderButtonBorder.centerInSuperview()

        sourceRecorderButtonView.addSubview(sourceRecorderButton)
        sourceRecorderButton.centerInSuperview()
        
        
        targetRecorderButtonView.addSubview(targetRecorderButtonBorder)
        targetRecorderButtonBorder.centerInSuperview()

        targetRecorderButtonView.addSubview(targetRecorderButton)
        targetRecorderButton.centerInSuperview()
        
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
        
        languageExchangeButton.addTarget(self, action: #selector(exchangeLanguage), for: .touchUpInside)
        sourceLanguageButton.setTitle(SupportedLanguages.speechRecognizerSupportedLanguage[sourceLanguageGCPIndex], for: .normal)
        targetLanguageButton.setTitle(SupportedLanguages.speechRecognizerSupportedLanguage[targetLanguageGCPIndex], for: .normal)
        sourceLanguageButton.addTarget(self, action: #selector(changeLanguage), for: .touchUpInside)
        targetLanguageButton.addTarget(self, action: #selector(changeLanguage), for: .touchUpInside)
        
        sourceRecorderButton.addTarget(self, action: #selector(sourceLanguageRecording), for: .touchDown)
        sourceRecorderButton.addTarget(self, action: #selector(sourceLanguageEndRecording), for: .touchUpInside)
        targetRecorderButton.addTarget(self, action: #selector(targetLanguageRecording), for: .touchDown)
        targetRecorderButton.addTarget(self, action: #selector(targetLanguageEndRecording), for: .touchUpInside)
        
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
    
    @objc func showBottom() {
        if !conversations.isEmpty {
            let indexPath = IndexPath(row: conversations.count - 1, section: 0)
            conversationTableView.scrollToRow(at: indexPath, at: .bottom, animated: false)
        }
    }
    
    @objc func exchangeLanguage() {
        UIView.animate(withDuration: 0.25, animations: {
            self.languageExchangeButton.transform = CGAffineTransform(rotationAngle: CGFloat.pi)
            self.languageExchangeButton.transform = self.languageExchangeButton.transform.rotated(by: CGFloat.pi)
            
            if let sourceLanguageButtonTitle = self.sourceLanguageButton.titleLabel?.text, let exchangeText = self.targetLanguageButton.titleLabel?.text {
                self.targetLanguageButton.setTitle(sourceLanguageButtonTitle, for: .normal)
                self.sourceLanguageButton.setTitle(exchangeText, for: .normal)
            }
            
            swap(&self.temporarySourceLanguageSpeechIndex, &self.temporaryTargetLanguageSpeechIndex)
            
        }, completion: nil)
        
        print("exchange button pressed.")
    }
    
    @objc func changeLanguage() {
        if let sourceLanguage = sourceLanguageButton.titleLabel?.text {
            temporarySourceLanguageSpeechIndex = SupportedLanguages.speechRecognizerSupportedLanguage.firstIndex(of: sourceLanguage) ?? 0
            print(temporarySourceLanguageSpeechIndex)
            print(sourceLanguage)
        }
        
        if let targetLanguage = targetLanguageButton.titleLabel?.text {
            temporaryTargetLanguageSpeechIndex = SupportedLanguages.speechRecognizerSupportedLanguage.firstIndex(of: targetLanguage) ?? 0
            print(temporaryTargetLanguageSpeechIndex)
            print(targetLanguage)
        }
        
        //present picker view modal
        let viewController = LanguagePickerViewController()
        viewController.sourceLanguageRow = temporarySourceLanguageSpeechIndex
        viewController.targetLanguageRow = temporaryTargetLanguageSpeechIndex
        viewController.translateType = .conversation
        viewController.delegate = self
        let navController = UINavigationController(rootViewController: viewController)
        
        self.navigationController?.present(navController, animated: true, completion: nil)
    }

    @objc func sourceLanguageRecording() {
        print("sourceLanguage button tapped down")

        startRecording()
        UIView.animate(withDuration: 0.2) {
            self.sourceRecorderButton.transform = CGAffineTransform(scaleX: 0.7, y: 0.7)
            self.sourceRecorderButton.layer.cornerRadius = 3.0
        }
        isSource = true
    }
    
    @objc func sourceLanguageEndRecording() {
        print("sourceLanguage button tap canceled")
        
        finishRecording(success: true)
        UIView.animate(withDuration: 0.2) {
            self.sourceRecorderButton.transform = CGAffineTransform(scaleX: 1.0, y: 1.0)
            self.sourceRecorderButton.layer.cornerRadius = 25
        }
    }
    
    @objc func targetLanguageRecording() {
        print("targetLanguage button tapped down")

        startRecording()
        UIView.animate(withDuration: 0.2) {
            self.targetRecorderButton.transform = CGAffineTransform(scaleX: 0.7, y: 0.7)
            self.targetRecorderButton.layer.cornerRadius = 3.0
        }
        isSource = false
    }
    
    @objc func targetLanguageEndRecording() {
        print("targetLanguage button tap canceled")

        finishRecording(success: true)
        UIView.animate(withDuration: 0.2) {
            self.targetRecorderButton.transform = CGAffineTransform(scaleX: 1.0, y: 1.0)
            self.targetRecorderButton.layer.cornerRadius = 25
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
        
        let textToTranslate = extractedText

        let sourceLanguageCode: String
        let targetLanguageCode: String
        if isSource {
            sourceLanguageCode = SupportedLanguages.speechRecognizerSupportedLanguageCode[temporarySourceLanguageSpeechIndex]
            targetLanguageCode = SupportedLanguages.speechRecognizerSupportedLanguageCode[temporaryTargetLanguageSpeechIndex]
        } else {
            sourceLanguageCode = SupportedLanguages.speechRecognizerSupportedLanguageCode[temporaryTargetLanguageSpeechIndex]
            targetLanguageCode = SupportedLanguages.speechRecognizerSupportedLanguageCode[temporarySourceLanguageSpeechIndex]
        }
        
        print("sourceLanguageCode is \(sourceLanguageCode)")
        print("targetLanguageCode is \(targetLanguageCode)")
        
        GoogleCloudTranslate.textTranslate(sourceLanguage: sourceLanguageCode, targetLanguage: targetLanguageCode, textToTranslate: textToTranslate) { (translatedText, error) in
            if let text = translatedText {
                self.createNewConversation(using: text)
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
        sourceLanguageButton.setTitle(SupportedLanguages.speechRecognizerSupportedLanguage[temporarySourceLanguageGCPIndex], for: .normal)
        targetLanguageButton.setTitle(SupportedLanguages.speechRecognizerSupportedLanguage[temporaryTargetLanguageGCPIndex], for: .normal)
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
