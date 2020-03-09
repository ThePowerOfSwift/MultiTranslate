//
//  InAppPurchaseManager.swift
//  MultiTranslate
//
//  Created by Keishin CHOU on 2020/01/27.
//  Copyright © 2020 Keishin CHOU. All rights reserved.
//

import Foundation
import SPAlert
import StoreKit
import SwiftyStoreKit

//var retrievedProducts = [SKProduct]()

enum UserType: String {
    case guestUser = "GuestUser"
    case tenKUser = "10KUser"
    case fiftyKUser = "50KUser"
    case noLimitUset = "NoLimitUser"
}

struct InAppPurchaseManager {
    
    static var retrievedProducts = [SKProduct]()
    
    static func retrieveProductsInfo(with productIdentifierSet: Set<String>) {
        SwiftyStoreKit.retrieveProductsInfo(productIdentifierSet) { (result) in
            if result.error == nil {
                for product in result.retrievedProducts {
                    if let index = Constants.inAppPurchaseProductIdentifiers.firstIndex(of: product.productIdentifier) {
                        self.retrievedProducts[index] = product
                    }
                }
                
                for product in self.retrievedProducts {
                    print(product.productIdentifier)
                }
                
                if !result.invalidProductIDs.isEmpty {
                    for invalidProductID in result.invalidProductIDs {
                        print("Invalid product identifier: \(invalidProductID)")
                    }
                }
                
            } else {
                print("Error: \(result.error!)")
            }
        }
    }
    
    static func verifyPurchase(with productIdentifier: String) {
        
        let appleValidator = AppleReceiptValidator(service: .production, sharedSecret: Constants.appSpecificSharedSecret)
        
        SwiftyStoreKit.verifyReceipt(using: appleValidator) { result in
            
            switch result {
                
            case .success(let receipt):
                // Verify purchases of Auto Renewable Subscription
                let purchaseResult = SwiftyStoreKit.verifySubscription(
                    ofType: .autoRenewable,
                    productId: productIdentifier,
                    inReceipt: receipt)
                
                switch purchaseResult {
                case .purchased(let expiryDate, let items):
                    print("\(productIdentifier) is valid until \(expiryDate)\n\(items)\n")
                    
                    if productIdentifier.contains("10K") {
                        UserDefaults.standard.set("10KUser", forKey: Constants.userTypeKey)
                    } else if productIdentifier.contains("50K") {
                        UserDefaults.standard.set("50KUser", forKey: Constants.userTypeKey)
                    } else if productIdentifier.contains("NoLimit") {
                        UserDefaults.standard.set("NoLimitUser", forKey: Constants.userTypeKey)
                    }
                    
                case .expired(let expiryDate, let items):
                    print("\(productIdentifier) is expired since \(expiryDate)\n\(items)\n")
                case .notPurchased:
                    print("The user has never purchased \(productIdentifier)")
                }

            case .error(let error):
                print("Receipt verification failed: \(error)")
            }
        }
    }
    
    static func purchaseProduct(with productIdentifier: String) {
        SwiftyStoreKit.purchaseProduct(productIdentifier, atomically: true) { (result) in
            switch result {
            case .success(let purchase):
                print("Subscription successed.")
                // Deliver content from server, then:
                if purchase.needsFinishTransaction {
                    SwiftyStoreKit.finishTransaction(purchase.transaction)
                    print("finished transaction.")
                }
                InAppPurchaseManager.verifyPurchase(with: productIdentifier)
                SPAlert.present(title: "Purchase successfully.", preset: .done)
                
            case .error(let error):
                print(error.localizedDescription)
                SPAlert.present(title: "Purchase failed.", message: error.localizedDescription, preset: .error)
            }
        }
    }
    
    static func completeIAPTransactions() {
        SwiftyStoreKit.completeTransactions(atomically: true) { purchases in
            for purchase in purchases {
                switch purchase.transaction.transactionState {
                case .purchased, .restored:
                    if purchase.needsFinishTransaction {
                        // Deliver content from server, then:
                        SwiftyStoreKit.finishTransaction(purchase.transaction)
                    }
                // Unlock content
                case .failed, .purchasing, .deferred:
                break // do nothing
                @unknown default:
                    break
                }
            }
        }
    }
    
    static func restorePurchase() {
        SwiftyStoreKit.restorePurchases(atomically: true) { results in
            if results.restoreFailedPurchases.count > 0 {
                print("Restore Failed: \(results.restoreFailedPurchases)")
                SPAlert.present(title: "Restore purchase failed.", message: "Please try again.", preset: .error)
            }
            else if results.restoredPurchases.count > 0 {
                print("Restore Success: \(results.restoredPurchases)")
                SPAlert.present(title: "Restored purchase successfully.", preset: .done)
            }
            else {
                print("Nothing to Restore")
                SPAlert.present(title: "No purchase restored.", preset: .error)
            }
        }
        
        for product in self.retrievedProducts {
            verifyPurchase(with: product.productIdentifier)
        }
    }

}

