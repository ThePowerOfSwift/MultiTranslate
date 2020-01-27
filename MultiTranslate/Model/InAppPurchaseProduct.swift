//
//  InAppPurchaseProduct.swift
//  MultiTranslate
//
//  Created by Keishin CHOU on 2020/01/26.
//  Copyright © 2020 Keishin CHOU. All rights reserved.
//

import Foundation
import RealmSwift

class InAppPurchaseProduct: Object {
    @objc dynamic var productID: String = ""
    @objc dynamic var type: String = ""
    @objc dynamic var order: Int = 0
}

