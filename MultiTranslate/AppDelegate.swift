//
//  AppDelegate.swift
//  MultiTranslate
//
//  Created by Keishin CHOU on 2020/01/06.
//  Copyright © 2020 Keishin CHOU. All rights reserved.
//

import UIKit

import Firebase
import IQKeyboardManager
import RealmSwift
import SwiftyStoreKit

@UIApplicationMain
class AppDelegate: UIResponder, UIApplicationDelegate {

    func application(_ application: UIApplication, didFinishLaunchingWithOptions launchOptions: [UIApplication.LaunchOptionsKey: Any]?) -> Bool {
        // Override point for customization after application launch.
        
        IQKeyboardManager.shared().isEnabled = true
        
        if let fileURL = Realm.Configuration.defaultConfiguration.fileURL {
            print(fileURL)
        }
                
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

        let realm = try! Realm()
        let inAppPurchaseProducts = realm.objects(InAppPurchaseProduct.self)
//        let realm: Realm
//        do {
//            realm = try Realm()
//        } catch {
//            print("Error initialising Realm, \(error.localizedDescription)")
//        }
        
        userdefaultsInitialize()
        
        FirebaseApp.configure()
        let db = Firestore.firestore()
        db.collection("InAppPurchaseProducts").getDocuments { (querySnapshot, error) in
            if error != nil {
                print(error!.localizedDescription)
            } else {
                
                do {
                    try realm.write {
                        realm.delete(inAppPurchaseProducts)
                    }
                } catch {
                    print("Error adding item, \(error)")
                }
                
                for document in querySnapshot!.documents {
                    let data = document.data()
                    
                    guard let productID = data["productID"] as? String,
                        let type = data["type"] as? String,
                        let order = data["order"] as? Int else { return }
                    
                    let inAppPurchaseProduct = InAppPurchaseProduct()
                    inAppPurchaseProduct.productID = productID
                    inAppPurchaseProduct.type = type
                    inAppPurchaseProduct.order = order
                    do {
                        try realm.write {
                            realm.add(inAppPurchaseProduct)
                        }
                    } catch {
                        print("Error adding item, \(error)")
                    }
                
                    InAppPurchaseManager.retrieveProductsInfo(with: productID)
                    InAppPurchaseManager.verifyPurchase(with: productID)
                    
                }
            }
        }
        
        InAppPurchaseManager.completeIAPTransactions()
        
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

    func userdefaultsInitialize() {
        let userDefaults = UserDefaults.standard
        
        userDefaults.set("GuestUser", forKey: Constants.userTypeKey)
        
        let lastLaunchMonth = userDefaults.integer(forKey: Constants.lastLaunchMonthKey)
        
        let now = Date()
        let dateFormatter = DateFormatter()
        dateFormatter.dateFormat = "LL"
        let nameOfMonth = dateFormatter.string(from: now)
        if let intValueOfCurrentMonth = Int(nameOfMonth) {
            print(intValueOfCurrentMonth)
            if lastLaunchMonth != intValueOfCurrentMonth {
                //Month has changed since last launch.
                userDefaults.set(intValueOfCurrentMonth, forKey: Constants.lastLaunchMonthKey)
                userDefaults.set(0, forKey: Constants.translatedCharactersCountKey)
            }
            print(userDefaults.integer(forKey: Constants.lastLaunchMonthKey))
            print(userDefaults.integer(forKey: Constants.translatedCharactersCountKey))
        }
    }

}
