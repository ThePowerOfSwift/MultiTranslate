//
//  FBOfflineTranslate.swift
//  MultiTranslate
//
//  Created by Keishin CHOU on 2020/02/13.
//  Copyright © 2020 Keishin CHOU. All rights reserved.
//

import Foundation

import Firebase

struct A {
    
    static var downloadedLanguageCodes = [String]()
    static var unDownloadedLanguageCodes = [String]()
    static var downloadedLanguages = [String]()
    static var unDownloadedLanguages = [String]()
    
    static func model(forLanguage language: TranslateLanguage) -> TranslateRemoteModel {
      return TranslateRemoteModel.translateRemoteModel(language: language)
    }

    static func isLanguageDownloaded(language: TranslateLanguage) -> Bool {
      let model = self.model(forLanguage: language)
      let modelManager = ModelManager.modelManager()
      return modelManager.isModelDownloaded(model)
    }
}
