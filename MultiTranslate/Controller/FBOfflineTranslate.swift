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
        
        FBOfflineTranslate.downloadedLanguageCodes.removeAll()
        FBOfflineTranslate.downloadedLanguages.removeAll()
        FBOfflineTranslate.unDownloadedLanguages.removeAll()
        FBOfflineTranslate.unDownloadedLanguageCodes.removeAll()
        
        let allLanguages = TranslateLanguage.allLanguages().compactMap {
            TranslateLanguage(rawValue: $0.uintValue)
        }
        
        for language in allLanguages {
            if FBOfflineTranslate.isLanguageDownloaded(language: language) {
                FBOfflineTranslate.downloadedLanguageCodes.append(language.toLanguageCode())
            } else {
                FBOfflineTranslate.unDownloadedLanguageCodes.append(language.toLanguageCode())
            }
        }
        
        for code in FBOfflineTranslate.downloadedLanguageCodes {
            if let index = SupportedLanguages.fbSupportedLanguageCode.firstIndex(of: code) {
                let language = SupportedLanguages.fbSupportedLanguage[index]
                FBOfflineTranslate.downloadedLanguages.append(language)
            }
        }
        FBOfflineTranslate.unDownloadedLanguages = SupportedLanguages.fbSupportedLanguage.subtracting(from: FBOfflineTranslate.downloadedLanguages)
        FBOfflineTranslate.unDownloadedLanguages.sort()
        FBOfflineTranslate.downloadedLanguages.sort()
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
}
