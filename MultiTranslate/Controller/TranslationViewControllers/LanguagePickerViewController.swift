//
//  ChangeLanguageViewController.swift
//  MultiTranslate
//
//  Created by Keishin CHOU on 2020/01/07.
//  Copyright © 2020 Keishin CHOU. All rights reserved.
//

import UIKit

class LanguagePickerViewController: UIViewController {
    
    var sourceLanguageRow = 0
    var targetLanguageRow = 0
    
//    var isVoiceTranslate: Bool = false
    var translateType: TranslateType = .text
    
    private var pickerView = UIPickerView()
    
    var delegate: LanguagePickerDelegate?

    override func viewDidLoad() {
        super.viewDidLoad()

        // Do any additional setup after loading the view.
        // ViewContorller 背景色
        self.view.backgroundColor = UIColor(red: 0.92, green: 1.0, blue: 0.94, alpha: 1.0)
        
        // PickerView のサイズと位置
        pickerView.frame = CGRect(x: 0, y: 0, width: self.view.frame.width, height: self.view.frame.height / 2)
        pickerView.backgroundColor = UIColor(red: 0.69, green: 0.93, blue: 0.9, alpha: 1.0)
        
        // PickerViewはスクリーンの中央に設定
        pickerView.center = self.view.center
        
        // Delegate設定
        pickerView.delegate = self
        pickerView.dataSource = self
        
        self.view.addSubview(pickerView)
        
        navigationItem.rightBarButtonItem = UIBarButtonItem(barButtonSystemItem: .done, target: self, action: #selector(doneChange))
        navigationItem.leftBarButtonItem = UIBarButtonItem(barButtonSystemItem: .cancel, target: self, action: #selector(cancelChange))
    }
    
    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(true)
        
        switch translateType {
        case .targetOnly:
            pickerView.selectRow(targetLanguageRow, inComponent: 0, animated: true)
            
        default:
            pickerView.selectRow(sourceLanguageRow, inComponent: 0, animated: true)
            pickerView.selectRow(targetLanguageRow, inComponent: 1, animated: true)
        }
        
//        print(pickerView.selectedRow(inComponent: 0))
//        print(pickerView.selectedRow(inComponent: 1))
    }
    
    @objc func doneChange() {
        self.dismiss(animated: true, completion: nil)
        delegate?.didSelectedLanguagePicker(temporarySourceLanguageGCPIndex: sourceLanguageRow, temporaryTargetLanguageGCPIndex: targetLanguageRow)
    }
    
    @objc func cancelChange() {
        self.dismiss(animated: true, completion: nil)
    }

}

extension LanguagePickerViewController : UIPickerViewDelegate, UIPickerViewDataSource {
 
    // ドラムロールの列数
    func numberOfComponents(in pickerView: UIPickerView) -> Int {
        switch translateType {
        case .targetOnly:
            return 1
        default:
            return 2
        }
        
    }
    
    // ドラムロールの行数
    func pickerView(_ pickerView: UIPickerView, numberOfRowsInComponent component: Int) -> Int {
        
        switch translateType {
        case .text:
            if component == 0 {
                return SupportedLanguages.gcpLanguageList.count
            } else {
                return SupportedLanguages.gcpLanguageList.count
            }
        case .voice:
            if component == 0 {
                return SupportedLanguages.speechRecognizerSupportedLocale.count
            } else {
                return SupportedLanguages.gcpLanguageList.count
            }
        case .conversation:
            if component == 0 {
                return SupportedLanguages.speechRecognizerSupportedLocale.count
            } else {
                return SupportedLanguages.speechRecognizerSupportedLocale.count
            }
        case .targetOnly:
            return SupportedLanguages.gcpLanguageList.count
        }
    }
    
    // ドラムロールの各タイトル
    func pickerView(_ pickerView: UIPickerView, titleForRow row: Int, forComponent component: Int) -> String? {
        
        switch translateType {
        case .text:
            if component == 0 {
                return SupportedLanguages.gcpLanguageList[row]
            } else {
                return SupportedLanguages.gcpLanguageList[row]
            }
        case .voice:
            if component == 0 {
                return SupportedLanguages.speechRecognizerSupportedLocale[row]
            } else {
                return SupportedLanguages.gcpLanguageList[row]
            }
        case .conversation:
            if component == 0 {
                return SupportedLanguages.speechRecognizerSupportedLocale[row]
            } else {
                return SupportedLanguages.speechRecognizerSupportedLocale[row]
            }
        case .targetOnly:
            return SupportedLanguages.gcpLanguageList[row]
        }
        
    }
    
    // ドラムロール選択時
    func pickerView(_ pickerView: UIPickerView, didSelectRow row: Int, inComponent component: Int) {
        switch translateType {
            
        case .targetOnly:
            targetLanguageRow = row
            
        default:
            if component == 0 {
                sourceLanguageRow = row
            } else {
                targetLanguageRow = row
            }
        }
    }

}
