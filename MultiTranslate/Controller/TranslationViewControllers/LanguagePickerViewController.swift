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
    
    var languagePickerType: LanguagePickerType = .textTranslate
    var isSetting: Bool = false
    
    private let container: UIView = {
        let view = UIView()
        view.translatesAutoresizingMaskIntoConstraints = false
        return view
    }()
    
    private let labelContainer: UIView = {
        let view = UIView()
        view.translatesAutoresizingMaskIntoConstraints = false
        return view
    }()
    
    private let fromLabel: UILabel = {
        let label = UILabel()
        label.translatesAutoresizingMaskIntoConstraints = false
        label.text = "From"
        label.textAlignment = .center
        label.font = UIFont.systemFont(ofSize: 20, weight: .black)
        label.textColor = .white
        return label
    }()
    
    private let toLabel: UILabel = {
        let label = UILabel()
        label.translatesAutoresizingMaskIntoConstraints = false
        label.text = "To"
        label.textAlignment = .center
        label.font = UIFont.systemFont(ofSize: 20, weight: .black)
        label.textColor = .white
        return label
    }()
    
    private let pickerView: UIPickerView = {
        let picker = UIPickerView()
        picker.translatesAutoresizingMaskIntoConstraints = false
        picker.backgroundColor = .mtSystemBackground
        return picker
    }()
    
    var delegate: LanguagePickerDelegate?

    override func loadView() {
        super.loadView()
        
        view.addSubview(container)
        container.edgeTo(view, safeArea: .top)
        
        container.addSubview(pickerView)
        pickerView.edgeTo(container)
        
        container.addSubview(labelContainer)
        labelContainer.topAnchor.constraint(equalTo: container.topAnchor).isActive = true
        labelContainer.leadingAnchor.constraint(equalTo: container.leadingAnchor).isActive = true
        labelContainer.trailingAnchor.constraint(equalTo: container.trailingAnchor).isActive = true
        labelContainer.heightAnchor.constraint(equalToConstant: 200).isActive = true
        
        labelContainer.HStack(fromLabel,
                              toLabel,
                              spacing: 0,
                              alignment: .center,
                              distribution: .fillEqually)
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()

        view.backgroundColor = .mtSystemBackground
        title = "Language selector".localized()

        pickerView.delegate = self
        pickerView.dataSource = self
        
        if !isSetting {
            navigationItem.rightBarButtonItem = UIBarButtonItem(barButtonSystemItem: .done,
                                                                target: self,
                                                                action: #selector(doneChange))
            navigationItem.leftBarButtonItem = UIBarButtonItem(barButtonSystemItem: .cancel,
                                                               target: self,
                                                               action: #selector(cancelChange))
        }
        
        switch languagePickerType {
        case .targetLanguage:
            fromLabel.isHidden = true
            toLabel.isHidden = false
        case .textSourceSetting, .visionSourceSetting, .speechSourceSetting:
            fromLabel.isHidden = false
            toLabel.isHidden = true
        default:
            fromLabel.isHidden = false
            toLabel.isHidden = false
        }
    }
    
    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(true)
        
        switch languagePickerType {
        case .targetLanguage:
            pickerView.selectRow(targetLanguageRow, inComponent: 0, animated: true)
            
        case .textSourceSetting, .visionSourceSetting, .speechSourceSetting:
            pickerView.selectRow(sourceLanguageRow, inComponent: 0, animated: true)
            
        default:
            pickerView.selectRow(sourceLanguageRow, inComponent: 0, animated: true)
            pickerView.selectRow(targetLanguageRow, inComponent: 1, animated: true)
        }
    }
    
    override func viewWillDisappear(_ animated: Bool) {
        if isSetting {
            delegate?.didSelectedLanguagePicker(temporarySourceLanguageGCPIndex: sourceLanguageRow, temporaryTargetLanguageGCPIndex: targetLanguageRow)
        }
    }
    
    @objc func doneChange() {
        dismiss(animated: true, completion: nil)
        delegate?.didSelectedLanguagePicker(temporarySourceLanguageGCPIndex: sourceLanguageRow, temporaryTargetLanguageGCPIndex: targetLanguageRow)
    }
    
    @objc func cancelChange() {
        dismiss(animated: true, completion: nil)
    }
    
    deinit {
        print("LanguagePickerViewController deallocated.")
    }

}

extension LanguagePickerViewController : UIPickerViewDelegate, UIPickerViewDataSource {
 
    func numberOfComponents(in pickerView: UIPickerView) -> Int {
        switch languagePickerType {
        case .textSourceSetting, .visionSourceSetting, .speechSourceSetting, .targetLanguage:
            return 1
        default:
            return 2
        }
        
    }
    
    func pickerView(_ pickerView: UIPickerView, numberOfRowsInComponent component: Int) -> Int {
        
        switch languagePickerType {
        case .textTranslate:
            if component == 0 {
                return SupportedLanguages.gcpLanguageList.count
            } else {
                return SupportedLanguages.gcpLanguageList.count
            }
        case .visionTranslate:
            if component == 0 {
                return SupportedLanguages.visionRecognizerSupportedLanguage.count
            } else {
                return SupportedLanguages.gcpLanguageList.count
            }
        case .speechTranslate:
            if component == 0 {
                return SupportedLanguages.speechRecognizerSupportedLocale.count
            } else {
                return SupportedLanguages.gcpLanguageList.count
            }
        case .conversationTranslate:
            if component == 0 {
                return SupportedLanguages.speechRecognizerSupportedLocale.count
            } else {
                return SupportedLanguages.speechRecognizerSupportedLocale.count
            }
        case .textSourceSetting:
            return SupportedLanguages.gcpLanguageList.count
        case .visionSourceSetting:
            return SupportedLanguages.visionRecognizerSupportedLanguage.count
        case .speechSourceSetting:
            return SupportedLanguages.speechRecognizerSupportedLocale.count
        case .targetLanguage:
            return SupportedLanguages.gcpLanguageList.count
        }
    }
    
    func pickerView(_ pickerView: UIPickerView, titleForRow row: Int, forComponent component: Int) -> String? {
        
        switch languagePickerType {
        case .textTranslate:
            if component == 0 {
                return SupportedLanguages.gcpLanguageList[row]
            } else {
                return SupportedLanguages.gcpLanguageList[row]
            }
        case .visionTranslate:
            if component == 0 {
                return SupportedLanguages.visionRecognizerSupportedLanguage[row]
            } else {
                return SupportedLanguages.gcpLanguageList[row]
            }
        case .speechTranslate:
            if component == 0 {
                return SupportedLanguages.speechRecognizerSupportedLocale[row]
            } else {
                return SupportedLanguages.gcpLanguageList[row]
            }
        case .conversationTranslate:
            if component == 0 {
                return SupportedLanguages.speechRecognizerSupportedLocale[row]
            } else {
                return SupportedLanguages.speechRecognizerSupportedLocale[row]
            }
        case .textSourceSetting:
            return SupportedLanguages.gcpLanguageList[row]
        case .visionSourceSetting:
            return SupportedLanguages.visionRecognizerSupportedLanguage[row]
        case .speechSourceSetting:
            return SupportedLanguages.speechRecognizerSupportedLocale[row]
        case .targetLanguage:
            return SupportedLanguages.gcpLanguageList[row]
        }
        
    }
    
    func pickerView(_ pickerView: UIPickerView, didSelectRow row: Int, inComponent component: Int) {
        switch languagePickerType {
            
        case .targetLanguage:
            targetLanguageRow = row
        case .textSourceSetting, .visionSourceSetting, .speechSourceSetting:
            sourceLanguageRow = row
        default:
            if component == 0 {
                sourceLanguageRow = row
            } else {
                targetLanguageRow = row
            }
        }
    }

}
