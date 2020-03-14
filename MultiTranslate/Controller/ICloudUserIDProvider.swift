//
//  ICloudUserIDProvider.swift
//  MultiTranslate
//
//  Created by Keishin CHOU on 2020/03/13.
//  Copyright © 2020 Keishin CHOU. All rights reserved.
//

import CloudKit
import Foundation

enum ICloudUserIDResponse {
    case success(record: CKRecord.ID)
    case failure(error: Error)
    case notSignedIn(accountStatus: CKAccountStatus)
}

class ICloudUserIDProvider: NSObject {

    class func getUserID(completion: @escaping (_ response: ICloudUserIDResponse) -> ()) {
        
        let container = CKContainer.default()
        container.accountStatus() { accountStatus, error in
            if accountStatus == .available {
                container.fetchUserRecordID() { recordID, error in
                    if let id = recordID {
                        completion(.success(record: id))
                    } else {
                        let err = error!
                        completion(.failure(error: err))
                    }
                }
            } else {
                completion(.notSignedIn(accountStatus: accountStatus))
            }
        }
    }
}
