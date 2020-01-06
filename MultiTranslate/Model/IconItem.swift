//
//  IconItem.swift
//  MultiTranslate
//
//  Created by Keishin CHOU on 2020/01/06.
//  Copyright © 2020 Keishin CHOU. All rights reserved.
//

import UIKit

import Parchment

struct IconItem: PagingItem, Hashable, Comparable {
    
    let icon: String
    let index: Int
    let image: UIImage?
    
    init(icon: String, index: Int) {
        self.icon = icon
        self.index = index
        self.image = UIImage(named: icon)
    }
    
    var hashValue: Int {
        return icon.hashValue
    }
    
    static func <(lhs: IconItem, rhs: IconItem) -> Bool {
        return lhs.index < rhs.index
    }
    
    static func ==(lhs: IconItem, rhs: IconItem) -> Bool {
        return (
            lhs.index == rhs.index &&
                lhs.icon == rhs.icon
        )
    }
}
