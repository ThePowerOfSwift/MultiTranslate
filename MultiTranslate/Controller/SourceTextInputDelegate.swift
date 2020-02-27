//
//  SourceTextInputDelegate.swift
//  MultiTranslate
//
//  Created by Keishin CHOU on 2020/01/11.
//  Copyright © 2020 Keishin CHOU. All rights reserved.
//

import Foundation

protocol SourceTextInputDelegate {
    
    func didSetSourceText(detectedResult: String) -> Void
    
}
