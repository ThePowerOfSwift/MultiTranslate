//
//  NotificationNameExtension.swift
//  MultiTranslate
//
//  Created by Keishin CHOU on 2020/02/14.
//  Copyright © 2020 Keishin CHOU. All rights reserved.
//

import Foundation

extension Notification.Name {
    static let fbDownloadedLanguagesDidUpdate = Notification.Name(rawValue: "fbDownloadedLanguagesDidUpdate")
    static let translationViewControllerDidChange = Notification.Name(rawValue: "translationViewControllerDidChange")
    static let savedTranlationsDidShow = Notification.Name(rawValue: "savedTranlationsDidShow")
    static let firstSavedTranslationDeleted = Notification.Name(rawValue: "firstSavedTranslationDeleted")
}
