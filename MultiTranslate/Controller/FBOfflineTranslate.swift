//
//  FBOfflineTranslate.swift
//  MultiTranslate
//
//  Created by Keishin CHOU on 2020/02/13.
//  Copyright © 2020 Keishin CHOU. All rights reserved.
//

import Foundation

import Firebase

struct FBOfflineTranslate {
    
    static var downloadedLanguageCodes = [String]()
    static var unDownloadedLanguageCodes = [String]()
    static var downloadedLanguages = [String]()
    static var unDownloadedLanguages = [String]()
    
    static func initializeFBTranslation() {
        
        self.downloadedLanguageCodes.removeAll()
        self.downloadedLanguages.removeAll()
        self.unDownloadedLanguages.removeAll()
        self.unDownloadedLanguageCodes.removeAll()
        
        let allLanguages = TranslateLanguage.allLanguages().compactMap {
            TranslateLanguage(rawValue: $0.uintValue)
        }
        
        for language in allLanguages {
            if self.isLanguageDownloaded(language: language) {
                self.downloadedLanguageCodes.append(language.toLanguageCode())
            } else {
                self.unDownloadedLanguageCodes.append(language.toLanguageCode())
            }
        }
        
        for code in self.downloadedLanguageCodes {
            if let index = SupportedLanguages.fbSupportedLanguageCode.firstIndex(of: code) {
                let language = SupportedLanguages.fbSupportedLanguage[index]
                self.downloadedLanguages.append(language)
            }
        }
        self.unDownloadedLanguages = SupportedLanguages.fbSupportedLanguage.subtracting(from: self.downloadedLanguages)
        self.unDownloadedLanguages.sort()
        self.downloadedLanguages.sort()
    }
    
    static func model(forLanguage language: TranslateLanguage) -> TranslateRemoteModel {
        return TranslateRemoteModel.translateRemoteModel(language: language)
    }
    
    static func createLanguageModel(from language: String) -> TranslateRemoteModel? {
        guard let index = SupportedLanguages.fbSupportedLanguage.firstIndex(of: language),
            let translateLanguage = TranslateLanguage(rawValue: UInt(index)) else {
            return nil
        }
        
        let model = self.model(forLanguage: translateLanguage)
        return model
    }

    static func isLanguageDownloaded(language: TranslateLanguage) -> Bool {
        let model = self.model(forLanguage: language)
        let modelManager = ModelManager.modelManager()
        return modelManager.isModelDownloaded(model)
    }
    
    static func generateFBTranslator(from sourceLanguage: String, to targetLanguage: String) -> Translator? {
        guard let sourceLanguageIndex = SupportedLanguages.fbSupportedLanguage.firstIndex(of: sourceLanguage),
            let targetLanguageIndex = SupportedLanguages.fbSupportedLanguage.firstIndex(of: targetLanguage),
            let sourceLanguageEnum = TranslateLanguage(rawValue: UInt(sourceLanguageIndex)),
            let targetLanguageEnum = TranslateLanguage(rawValue: UInt(targetLanguageIndex)) else {
                return nil
        }
        
        let options = TranslatorOptions(sourceLanguage: sourceLanguageEnum, targetLanguage: targetLanguageEnum)
        let translator = NaturalLanguage.naturalLanguage().translator(options: options)
        
        return translator
    }
}
