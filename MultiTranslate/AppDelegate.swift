//
//  AppDelegate.swift
//  MultiTranslate
//
//  Created by Keishin CHOU on 2020/01/06.
//  Copyright © 2020 Keishin CHOU. All rights reserved.
//

import AVFoundation
import UIKit
import StoreKit

import Firebase
//import IQKeyboardManager
import RealmSwift
import SPAlert
import SwiftyStoreKit

@UIApplicationMain
class AppDelegate: UIResponder, UIApplicationDelegate {

    func application(_ application: UIApplication, didFinishLaunchingWithOptions launchOptions: [UIApplication.LaunchOptionsKey: Any]?) -> Bool {
        // Override point for customization after application launch.
        
//        IQKeyboardManager.shared().isEnabled = true
        
        if let fileURL = Realm.Configuration.defaultConfiguration.fileURL {
            print(fileURL)
        }
        
        initializeInAppPurchase()

        initializeRealm()
        
        initializeUserDefaults()
        
        initializeCloudDatabase()
        
        initializeFirebase()
        
        FBOfflineTranslate.initializeFBTranslation()
        
        initializeAVAudioSession()
        
        return true
    }

    // MARK: UISceneSession Lifecycle

    func application(_ application: UIApplication, configurationForConnecting connectingSceneSession: UISceneSession, options: UIScene.ConnectionOptions) -> UISceneConfiguration {
        // Called when a new scene session is being created.
        // Use this method to select a configuration to create the new scene with.
        return UISceneConfiguration(name: "Default Configuration", sessionRole: connectingSceneSession.role)
    }

    func application(_ application: UIApplication, didDiscardSceneSessions sceneSessions: Set<UISceneSession>) {
        // Called when the user discards a scene session.
        // If any sessions were discarded while the application was not running, this will be called shortly after application:didFinishLaunchingWithOptions.
        // Use this method to release any resources that were specific to the discarded scenes, as they will not return.
    }

    func initializeUserDefaults() {
        let userDefaults = UserDefaults.standard
        
        userDefaults.set("GuestUser", forKey: Constants.userTypeKey)
        
        let lastLaunchMonth = userDefaults.integer(forKey: Constants.lastLaunchMonthKey)
        
        let now = Date()
        let dateFormatter = DateFormatter()
        dateFormatter.dateFormat = "LL"
        let nameOfMonth = dateFormatter.string(from: now)
        if let intValueOfCurrentMonth = Int(nameOfMonth) {
            print("This month is \(intValueOfCurrentMonth)")
            
            if lastLaunchMonth == 0 {
                //First launch of the app.
                userDefaults.set(intValueOfCurrentMonth, forKey: Constants.lastLaunchMonthKey)
            } else if lastLaunchMonth != intValueOfCurrentMonth {
                //Month has changed since last launch.
                userDefaults.set(0, forKey: Constants.translatedCharactersCountKey)
                CloudKitManager.refreshCloudDatabaseCountData()
            }
            print(userDefaults.integer(forKey: Constants.lastLaunchMonthKey))
            print(userDefaults.integer(forKey: Constants.translatedCharactersCountKey))
        }
    }
    
    func initializeRealm() {
//        let config = Realm.Configuration(
//          // 新しいスキーマバージョンを設定します。以前のバージョンより大きくなければなりません。
//          // （スキーマバージョンを設定したことがなければ、最初は0が設定されています）
//          schemaVersion: 1,
//
//          // マイグレーション処理を記述します。古いスキーマバージョンのRealmを開こうとすると
//          // 自動的にマイグレーションが実行されます。
//          migrationBlock: { migration, oldSchemaVersion in
//            // 最初のマイグレーションの場合、`oldSchemaVersion`は0です
//            if (oldSchemaVersion < 1) {
//              // 何もする必要はありません！1
//              // Realmは自動的に新しく追加されたプロパティと、削除されたプロパティを認識します。
//              // そしてディスク上のスキーマを自動的にアップデートします。
//            }
//          })
//
//        // デフォルトRealmに新しい設定を適用します
//        Realm.Configuration.defaultConfiguration = config
        
        _ = try! Realm()
    }
    
    func initializeCloudDatabase() {
        CloudKitManager.isCountRecordEmpty { (isEmpty) in
            if isEmpty {
                CloudKitManager.initializeCloudDatabase()
            }
        }
    }
    
    func initializeFirebase() {
        FirebaseApp.configure()
    }
    
    func initializeInAppPurchase() {
        let skProduct = SKProduct()
        for _ in 0 ... 5 {
            InAppPurchaseManager.retrievedProducts.append(skProduct)
        }
        
        InAppPurchaseManager.retrieveProductsInfo(with: Constants.inAppPurchaseProductIdentifiersSet)
        
        for id in Constants.inAppPurchaseProductIdentifiers {
            InAppPurchaseManager.verifyPurchase(with: id)
        }
        
        InAppPurchaseManager.completeIAPTransactions()
    }
    
    func initializeAVAudioSession() {
        // Get the singleton instance.
        let recordingSession = AVAudioSession.sharedInstance()
        do {
            // Set the audio session category, mode, and options.
            try recordingSession.setCategory(.playAndRecord, mode: .default, options: [.defaultToSpeaker])
            try recordingSession.setActive(true)
        } catch {
            print("Failed to set audio session category.")
        }
        ///https://developer.apple.com/documentation/avfoundation/avaudiosession
        ///https://developer.apple.com/documentation/avfoundation/avaudiosession/category
        ///https://developer.apple.com/documentation/avfoundation/avaudiosession/mode
        ///https://developer.apple.com/documentation/avfoundation/avaudiosession/categoryoptions
        ///https://stackoverflow.com/questions/51010390/avaudiosession-setcategory-swift-4-2-ios-12-play-sound-on-silent
        ///https://stackoverflow.com/questions/1022992/how-to-get-avaudioplayer-output-to-the-speaker
    }
    
}
