//
//  SavedTranslation.swift
//  MultiTranslate
//
//  Created by Keishin CHOU on 2020/01/21.
//  Copyright © 2020 Keishin CHOU. All rights reserved.
//

import Foundation
import RealmSwift

class SavedTranslation: Object {

    @objc dynamic var sourceLanguage: String = ""
    @objc dynamic var targetLanguage: String = ""
    @objc dynamic var sourceText: String = ""
    @objc dynamic var targetText: String = ""
    @objc dynamic var dateCreated: Date?

}
