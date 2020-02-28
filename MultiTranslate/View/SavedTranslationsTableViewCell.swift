//
//  SavedTranslationsTableViewCell.swift
//  MultiTranslate
//
//  Created by Keishin CHOU on 2020/01/21.
//  Copyright © 2020 Keishin CHOU. All rights reserved.
//

import AVFoundation
import Foundation

import SPAlert

class SavedTranslationsTableViewCell: UITableViewCell {
    
    var savedTranslation: SavedTranslation? {
        didSet {
            sourceTextLabel.text = savedTranslation?.sourceText
            sourceLanguageLabel.text = savedTranslation?.sourceLanguage
            targetTextLabel.text = savedTranslation?.targetText
            targetLanguageLabel.text = savedTranslation?.targetLanguage
        }
    }
    
    private let container: UIView = {
        let view = UIView()
        view.translatesAutoresizingMaskIntoConstraints = false
        view.backgroundColor = UIColor.init(white: 1, alpha: 0.35)
        view.layer.cornerRadius = 8
        
        return view
    }()
    
    let sourceView: UIView = {
        let view = UIView()
        view.translatesAutoresizingMaskIntoConstraints = false
        view.backgroundColor = UIColor(red: 250/250, green: 227/250, blue: 217/250, alpha: 0.98)
        view.layer.cornerRadius = 21
        view.layer.maskedCorners = [.layerMinXMinYCorner, .layerMaxXMinYCorner, .layerMaxXMaxYCorner]
        view.layer.masksToBounds = true
        
        return view
    }()
    
    let languageView: UIView = {
        let view = UIView()
        view.translatesAutoresizingMaskIntoConstraints = false
        
        return view
    }()
    
    let targetView: UIView = {
        let view = UIView()
        view.translatesAutoresizingMaskIntoConstraints = false
        view.backgroundColor = UIColor(red: 187/250, green: 222/250, blue: 214/250, alpha: 1.0)
        view.layer.cornerRadius = 21
        view.layer.maskedCorners = [.layerMinXMinYCorner, .layerMinXMaxYCorner, .layerMaxXMaxYCorner]
        view.layer.masksToBounds = true
        
        return view
    }()
    
    let buttonView: UIView = {
        let view = UIView()
        view.translatesAutoresizingMaskIntoConstraints = false
        return view
    }()
    
    let sourceTextLabel: UILabel = {
        let label = UILabel()
        label.translatesAutoresizingMaskIntoConstraints = false
        label.numberOfLines = 0
        label.textAlignment = .left
        label.sizeToFit()
        
        return label
    }()
    
    let targetTextLabel: UILabel = {
        let label = UILabel()
        label.translatesAutoresizingMaskIntoConstraints = false
        label.numberOfLines = 0
        label.textAlignment = .right
        label.sizeToFit()
        
        return label
    }()
    
    let sourceLanguageLabel: UILabel = {
        let label = UILabel()
        label.translatesAutoresizingMaskIntoConstraints = false
        label.numberOfLines = 0
        label.textAlignment = .left
        label.sizeToFit()
        label.text = "Chinese"
        
        return label
    }()
    
    let arrowView: UIImageView = {
        let view = UIImageView()
        view.translatesAutoresizingMaskIntoConstraints = false
        view.image = UIImage(systemName: "arrow.right.circle")
        view.tintColor = .systemGray
        view.contentMode = .scaleAspectFit
        
        return view
    }()
    
    let targetLanguageLabel: UILabel = {
        let label = UILabel()
        label.translatesAutoresizingMaskIntoConstraints = false
        label.numberOfLines = 0
        label.textAlignment = .right
        label.sizeToFit()
        label.text = "Japanese"
        
        return label
    }()
    
    private let copyButton: UIButton = {
        let button = UIButton()
        button.translatesAutoresizingMaskIntoConstraints = false
        button.setImage(UIImage(systemName: "doc.on.doc"), for: .normal)
        button.tintColor = .systemBlue
        return button
    }()
    
    private let speechButton: UIButton = {
        let button = UIButton()
        button.translatesAutoresizingMaskIntoConstraints = false
        button.setImage(UIImage(systemName: "speaker.2"), for: .normal)
        button.tintColor = .systemBlue
        return button
    }()
    
    private let spacerView: UIView = {
        let view = UIView()
        view.translatesAutoresizingMaskIntoConstraints = false
        return view
    }()
    
    
    override init(style: UITableViewCell.CellStyle, reuseIdentifier: String?) {
        super.init(style: style, reuseIdentifier: reuseIdentifier)
        
        self.backgroundColor = UIColor(rgb: 0xC1D2EB)
        
        self.addSubview(container)
        container.topAnchor.constraint(equalTo: self.topAnchor, constant: 16).isActive = true
        container.bottomAnchor.constraint(equalTo: self.bottomAnchor, constant: -16).isActive = true
        container.leadingAnchor.constraint(equalTo: self.leadingAnchor, constant: 16).isActive = true
        container.trailingAnchor.constraint(equalTo: self.trailingAnchor, constant: -16).isActive = true
        
        container.VStack(sourceView,
                         languageView.setHeight(30),
                         targetView,
                         buttonView.setHeight(30),
                         spacing: 0,
                         alignment: .fill,
                         distribution: .fill).padding([.allMargins], amount: 8)
        
        sourceView.heightAnchor.constraint(greaterThanOrEqualToConstant: 30).isActive = true
        targetView.heightAnchor.constraint(equalTo: sourceView.heightAnchor).isActive = true
        
        sourceView.addSubview(sourceTextLabel)
        sourceTextLabel.topAnchor.constraint(equalTo: sourceView.topAnchor,constant: 12).isActive = true
        sourceTextLabel.bottomAnchor.constraint(equalTo: sourceView.bottomAnchor, constant: -12).isActive = true
        sourceTextLabel.leadingAnchor.constraint(equalTo: sourceView.leadingAnchor, constant: 12).isActive = true
        sourceTextLabel.trailingAnchor.constraint(equalTo: sourceView.trailingAnchor, constant: -12).isActive = true
        
        targetView.addSubview(targetTextLabel)
        targetTextLabel.topAnchor.constraint(equalTo: targetView.topAnchor,constant: 12).isActive = true
        targetTextLabel.bottomAnchor.constraint(equalTo: targetView.bottomAnchor, constant: -12).isActive = true
        targetTextLabel.leadingAnchor.constraint(equalTo: targetView.leadingAnchor, constant: 12).isActive = true
        targetTextLabel.trailingAnchor.constraint(equalTo: targetView.trailingAnchor, constant: -12).isActive = true
        
        languageView.hstack(sourceLanguageLabel,
                            arrowView.setFrame(CGSize(width: 30, height: 30)),
                            targetLanguageLabel,
                            spacing: 0,
                            alignment: .fill,
                            distribution: .fill)
        
        sourceLanguageLabel.widthAnchor.constraint(equalTo: targetLanguageLabel.widthAnchor).isActive = true
        
        buttonView.HStack(spacerView,
                          speechButton,
                          copyButton,
                          spacing: 20,
                          alignment: .fill,
                          distribution: .fill)
        speechButton.widthAnchor.constraint(equalTo: speechButton.heightAnchor).isActive = true
        copyButton.widthAnchor.constraint(equalTo: copyButton.heightAnchor).isActive = true
        
        speechButton.addTarget(self, action: #selector(speakTargetText), for: .touchUpInside)
        copyButton.addTarget(self, action: #selector(copyTargetText), for: .touchUpInside)
    }
    
    @objc func copyTargetText() {
        let pasteboard = UIPasteboard.general
        pasteboard.string = targetTextLabel.text
        SPAlert.present(title: "Copied to clipboard", message: nil, image: UIImage(systemName: "doc.on.clipboard.fill")!)
    }
    
    @objc func speakTargetText() {
        guard let targetLanguage = targetLanguageLabel.text,
            let index = SupportedLanguages.speechRecognizerSupportedLanguage.firstIndex(of: targetLanguage),
            let translatedText = targetTextLabel.text else { return }

        let utterance = AVSpeechUtterance(string: translatedText)
        let speechCode = SupportedLanguages.speechRecognizerSupportedLocaleIdentifier[index]
        let synthesizer = AVSpeechSynthesizer()
        utterance.voice = AVSpeechSynthesisVoice(language: speechCode)
        utterance.rate = AVSpeechUtteranceDefaultSpeechRate
        synthesizer.speak(utterance)
        
        print("speechCode is \(speechCode)")
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
}
