//
//  Conversation.swift
//  MultiTranslate
//
//  Created by Keishin CHOU on 2020/01/15.
//  Copyright © 2020 Keishin CHOU. All rights reserved.
//

import Foundation
import RealmSwift

class Conversation: Object {

    @objc dynamic var sourceMessage: String = ""
    @objc dynamic var targetMessage: String = ""
    @objc dynamic var isSource: Bool = true
    
}
