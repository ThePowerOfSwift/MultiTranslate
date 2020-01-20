//
//  GoogleCloudTranslate.swift
//  MultiTranslate
//
//  Created by Keishin CHOU on 2020/01/20.
//  Copyright © 2020 Keishin CHOU. All rights reserved.
//

import Foundation
import Alamofire
import SwiftyJSON

class GoogleCloudTranslate {
    
    static func textTranslate(sourceLanguage: String,
                              targetLanguage: String,
                              textToTranslate: String,
                              complition: @escaping ((_ text: String?, _ error: Error?) -> Void)) {
    
        let url = "https://translation.googleapis.com/language/translate/v2"
        let parameters: [String : String] = [
            "key": Constants.googleTranslateAPIKey,
            "q": textToTranslate,
            "target": targetLanguage,
            "source": sourceLanguage,
            "format": "text",
            "model": "base"
        ]
        
        Alamofire.request(url, method: .post, parameters: parameters).responseJSON { (response) in
            if response.result.isSuccess {
                print("response is \(response.result.value!)")
                
                let responseJSON = JSON(response.result.value!)
                let translatedTextJSON = JSON(responseJSON["data"]["translations"][0])
                let translatedText = translatedTextJSON["translatedText"].stringValue
                print(translatedText)
                
                complition(translatedText, nil)
            } else {
                print(response.result.error!)
                complition(nil, response.result.error!)
            }
        }
    }
}
