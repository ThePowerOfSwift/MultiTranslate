//
//  CloudKitManager.swift
//  MultiTranslate
//
//  Created by Keishin CHOU on 2020/01/29.
//  Copyright © 2020 Keishin CHOU. All rights reserved.
//

import CloudKit
import Foundation

struct CloudKitManager {
    static let CloudDatabase = CKContainer.default().privateCloudDatabase
    
    static func initializeCloudDatabase() {
        let query = CKQuery(recordType: Constants.iCloudTypeKey, predicate: NSPredicate(value: true))
        let initialRecord = CKRecord(recordType: Constants.iCloudTypeKey)
        initialRecord.setValue(0, forKey: Constants.iCloudRecordKey)
        
        CloudDatabase.perform(query, inZoneWith: nil) { (records, error) in
            if let retrievedRecords = records {
                if retrievedRecords.count == 0 {
                    CloudDatabase.save(initialRecord) { (record, error) in
                        if let retrievedRecord = record {
                            print(retrievedRecord)
                        } else {
                            print(error!.localizedDescription)
                        }
                    }
                }
            } else {
                print(error!.localizedDescription)
            }
        }
    }
    
    static func refreshCloudDatabaseCountData() {
        let query = CKQuery(recordType: Constants.iCloudTypeKey, predicate: NSPredicate(value: true))
        
        CloudDatabase.perform(query, inZoneWith: nil) { (records, error) in
            if let retrievedRecords = records {
                guard let record = retrievedRecords.last else {
                    print("there is no records.last")
                    return
                }
                record.setValue(0, forKey: Constants.iCloudRecordKey)
                CloudDatabase.save(record) { (record, error) in
                    if let savedRecord = record {
                        print(savedRecord)
                    } else {
                        print(error!.localizedDescription)
                    }
                }
            } else {
                print(error!.localizedDescription)
            }
        }
    }
    
    static func isCountRecordEmpty(completionHandler: @escaping (Bool) -> Void) {

        let query = CKQuery(recordType: Constants.iCloudTypeKey, predicate: NSPredicate(value: true))
        CloudDatabase.perform(query, inZoneWith: nil) { (records, error) in
            if let retrievedRecords = records {
                if retrievedRecords.isEmpty {
                    print("isCountRecordEmpty is true")
                    completionHandler(true)
                } else {
                    print("isCountRecordEmpty is false")
                    completionHandler(false)
                }
            }
        }

    }
    
    static func queryCloudDatabaseCountData(completionHandler: @escaping (Int?, Error?) -> Void) {
        let query = CKQuery(recordType: Constants.iCloudTypeKey, predicate: NSPredicate(value: true))
        CloudDatabase.perform(query, inZoneWith: nil) { (records, error) in
            if let retrievedRecords = records {
                let record = retrievedRecords.last!
                let count = record.object(forKey: "translatedCharactersCurrentMonth") as! Int
                print(count)
                completionHandler(count, nil)
            } else {
                completionHandler(nil, error!)
            }
        }
    }
    
    static func updateCountData(to updatedCountData: Int) {
        let query = CKQuery(recordType: Constants.iCloudTypeKey, predicate: NSPredicate(value: true))
        CloudDatabase.perform(query, inZoneWith: nil) { (records, error) in
            if let retrievedRecords = records {
                
                guard let record = retrievedRecords.last else {
                    print("there is no records.last too")
                    print("please sign in to iCloud")
//                    if let settingsURL = URL(string: UIApplication.openSettingsURLString) {
//                        DispatchQueue.main.async {
//                            UIApplication.shared.open(settingsURL, options: [:], completionHandler: nil)
//                        }
//                    }
                    return
                }
                record.setValue(updatedCountData, forKey: "translatedCharactersCurrentMonth")
                self.CloudDatabase.save(record) { (record, error) in
                    if let retrievedRecord = record {
                        print(retrievedRecord)
                    } else {
                        print(error!.localizedDescription)
                    }
                }
            } else {
                print(error!.localizedDescription)
            }
        }
    }
    
}
