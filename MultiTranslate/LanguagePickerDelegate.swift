//
//  LanguagePickerDelegate.swift
//  MultiTranslate
//
//  Created by Keishin CHOU on 2020/01/08.
//  Copyright © 2020 Keishin CHOU. All rights reserved.
//

import Foundation

protocol LanguagePickerDelegate {
    
    func didSelectedLanguagePicker(sourceLanguage: String, targetLanguage: String) -> Void
    
}
