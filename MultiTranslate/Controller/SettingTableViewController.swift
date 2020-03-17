//
//  SettingTableViewController.swift
//  MultiTranslate
//
//  Created by Keishin CHOU on 2020/02/11.
//  Copyright © 2020 Keishin CHOU. All rights reserved.
//

import UIKit

import Firebase

class SettingTableViewController: UITableViewController {

    private let sections = ["Text translate language".localized(),
                            "Camera translate language".localized(),
                            "Voice translate language".localized(),
                            "Conversation translate language".localized(),
                            "AR translate language".localized(),
                            "Documnet translate language".localized(),
                            "Image translate language".localized(),
                            "Offline translation module".localized()]
    
    private let textTranslateLanguageSection = ["Source".localized(), "Target".localized()]
    private let cameraTranslateLanguageSection = ["Source".localized(), "Target".localized()]
    private let voiceTranslateLanguageSection = ["Source".localized(), "Target".localized()]
    private let conversationTranslateLanguageSection = ["Source".localized(), "Target".localized()]
    private let arTranslateLanguageSection = ["Target".localized()]
    private let documentTranslateLanguageSection = ["Source".localized(), "Target".localized()]
    private let imageTranslateLanguageSection = ["Source".localized(), "Target".localized()]
    private let offlineLanguagesSection = ["Offline languages".localized()]
    private var sectionList = [[String]]()
    
    private var textSourceLanguageIndex = UserDefaults.standard.integer(forKey: Constants.textSourceLanguageIndexKey)
    private var textTargetLanguageIndex = UserDefaults.standard.integer(forKey: Constants.textTargetLanguageIndexKey)
    private var cameraSourceLanguageIndex = UserDefaults.standard.integer(forKey: Constants.cameraSourceLanguageIndexKey)
    private var cameraTargetLanguageIndex = UserDefaults.standard.integer(forKey: Constants.cameraTargetLanguageIndexKey)
    private var voiceSourceLanguageIndex = UserDefaults.standard.integer(forKey: Constants.voiceSourceLanguageIndexKey)
    private var voiceTargetLanguageIndex = UserDefaults.standard.integer(forKey: Constants.voiceTargetLanguageIndexKey)
    private var conversationSourceLanguageIndex = UserDefaults.standard.integer(forKey: Constants.conversationSourceLanguageIndexKey)
    private var conversationTargetLanguageIndex = UserDefaults.standard.integer(forKey: Constants.conversationTargetLanguageIndexKey)
    private var arTargetLanguageIndex = UserDefaults.standard.integer(forKey: Constants.arTargetLanguageIndexKey)
    private var documentSourceLanguageIndex = UserDefaults.standard.integer(forKey: Constants.docSourceLanguageIndexKey)
    private var documentTargetLanguageIndex = UserDefaults.standard.integer(forKey: Constants.docTargetLanguageIndexKey)
    private var imageSourceLanguageIndex = UserDefaults.standard.integer(forKey: Constants.imageSourceLanguageIndexKey)
    private var imageTargetLanguageIndex = UserDefaults.standard.integer(forKey: Constants.imageTargetLanguageIndexKey)
    
    enum LanguageSettingType {
        case textSource
        case textTarget
        case cameraSource
        case cameraTarget
        case voiceSource
        case voiceTarget
        case conversationSource
        case conversationTarget
        case arTarget
        case documentSource
        case documentTarget
        case imageSource
        case imageTarget
    }
    
    private var languageSettingType = LanguageSettingType.textSource
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        title = "Setting".localized()
        clearsSelectionOnViewWillAppear = true
        view.backgroundColor = .mtSystemBackground
        sectionList = [textTranslateLanguageSection,
                       cameraTranslateLanguageSection,
                       voiceTranslateLanguageSection,
                       conversationTranslateLanguageSection,
                       arTranslateLanguageSection,
                       documentTranslateLanguageSection,
                       imageTranslateLanguageSection,
                       offlineLanguagesSection]
        
        tableView.register(UITableViewCell.self, forCellReuseIdentifier: Constants.settingTableViewCellIdentifier)
        tableView.separatorStyle = .none
    }
    
    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(animated)

        tableView.reloadData()
    }

    // MARK: - Table view data source

    override func numberOfSections(in tableView: UITableView) -> Int {
        // #warning Incomplete implementation, return the number of sections
        return sections.count
    }
    
//    override func tableView(_ tableView: UITableView, titleForHeaderInSection section: Int) -> String? {
//        return sections[section]
//    }
    
    override func tableView(_ tableView: UITableView, viewForHeaderInSection section: Int) -> UIView? {
        let headerView = UIView(frame: CGRect(x: 0, y: 0, width: tableView.bounds.size.width, height: 30))
        let sectionTitle = UILabel(frame: CGRect(x: 20, y: 0, width: headerView.bounds.size.width, height: headerView.bounds.size.height))
        headerView.backgroundColor = .mtSettingSectionTitle
        headerView.addSubview(sectionTitle)
        sectionTitle.text = sections[section]
        sectionTitle.font = UIFont.boldSystemFont(ofSize: 18)
        return headerView
    }

    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        // #warning Incomplete implementation, return the number of rows
        switch section {
        case 0:
            return textTranslateLanguageSection.count
        case 1:
            return cameraTranslateLanguageSection.count
        case 2:
            return voiceTranslateLanguageSection.count
        case 3:
            return conversationTranslateLanguageSection.count
        case 4:
            return arTranslateLanguageSection.count
        case 5:
            return documentTranslateLanguageSection.count
        case 6:
            return imageTranslateLanguageSection.count
        case 7:
            return offlineLanguagesSection.count
        default:
            return 0
        }
    }

    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
//        let cell = tableView.dequeueReusableCell(withIdentifier: Constants.settingTableViewCellIdentifier, for: indexPath)
        let cell = UITableViewCell(style: .value1, reuseIdentifier: Constants.settingTableViewCellIdentifier)
        cell.textLabel?.text = sectionList[indexPath.section][indexPath.row]
        cell.accessoryType = .disclosureIndicator
        cell.backgroundColor = .mtSystemBackground
        
        switch indexPath.section {
        case 0:
            if indexPath.row == 0 {
                cell.detailTextLabel?.text = SupportedLanguages.gcpLanguageList[textSourceLanguageIndex]
            } else {
                cell.detailTextLabel?.text = SupportedLanguages.gcpLanguageList[textTargetLanguageIndex]
            }
        case 1:
            if indexPath.row == 0 {
                cell.detailTextLabel?.text = SupportedLanguages.visionRecognizerSupportedLanguage[cameraSourceLanguageIndex]
            } else {
                cell.detailTextLabel?.text = SupportedLanguages.gcpLanguageList[cameraTargetLanguageIndex]
            }
        case 2:
            if indexPath.row == 0 {
                cell.detailTextLabel?.text = SupportedLanguages.speechRecognizerSupportedLocale[voiceSourceLanguageIndex]
            } else {
                cell.detailTextLabel?.text = SupportedLanguages.gcpLanguageList[voiceTargetLanguageIndex]
            }
        case 3:
            if indexPath.row == 0 {
                cell.detailTextLabel?.text = SupportedLanguages.speechRecognizerSupportedLocale[conversationSourceLanguageIndex]
            } else {
                cell.detailTextLabel?.text = SupportedLanguages.speechRecognizerSupportedLocale[conversationTargetLanguageIndex]
            }
        case 4:
            cell.detailTextLabel?.text = SupportedLanguages.gcpLanguageList[arTargetLanguageIndex]
        case 5:
            if indexPath.row == 0 {
                cell.detailTextLabel?.text = SupportedLanguages.visionRecognizerSupportedLanguage[documentSourceLanguageIndex]
            } else {
                cell.detailTextLabel?.text = SupportedLanguages.gcpLanguageList[documentTargetLanguageIndex]
            }
        case 6:
            if indexPath.row == 0 {
                cell.detailTextLabel?.text = SupportedLanguages.visionRecognizerSupportedLanguage[imageSourceLanguageIndex]
            } else {
                cell.detailTextLabel?.text = SupportedLanguages.gcpLanguageList[imageTargetLanguageIndex]
            }
        case 7:
            return cell
        default:
            return cell
        }
        
        return cell
    }
    
    // MARK: - Table view delegate
    
    override func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
//        tableView.deselectRow(at: indexPath, animated: true)
        switch indexPath.section {
        case 0:
            if indexPath.row == 0 {
                languageSettingType = .textSource
                didSelectRow(section: 0, row: 0)
                
                presentLanguagePicker(languagePickerType: .textSourceSetting, sourceLanguageRow: textSourceLanguageIndex, targetLanguageRow: 0)
            } else {
                languageSettingType = .textTarget
                didSelectRow(section: 0, row: 1)
                
                presentLanguagePicker(languagePickerType: .targetLanguage, sourceLanguageRow: 0, targetLanguageRow: textTargetLanguageIndex)
            }
        case 1:
            if indexPath.row == 0 {
                languageSettingType = .cameraSource
                didSelectRow(section: 1, row: 0)
                
                presentLanguagePicker(languagePickerType: .visionSourceSetting, sourceLanguageRow: cameraSourceLanguageIndex, targetLanguageRow: 0)
            } else {
                languageSettingType = .cameraTarget
                didSelectRow(section: 1, row: 1)
                
                presentLanguagePicker(languagePickerType: .targetLanguage, sourceLanguageRow: 0, targetLanguageRow: cameraTargetLanguageIndex)
            }
        case 2:
            if indexPath.row == 0 {
                languageSettingType = .voiceSource
                didSelectRow(section: 2, row: 0)
                
                presentLanguagePicker(languagePickerType: .speechSourceSetting, sourceLanguageRow: voiceSourceLanguageIndex, targetLanguageRow: 0)
            } else {
                languageSettingType = .voiceTarget
                didSelectRow(section: 2, row: 1)
                
                presentLanguagePicker(languagePickerType: .targetLanguage, sourceLanguageRow: 0, targetLanguageRow: voiceTargetLanguageIndex)
            }
        case 3:
            if indexPath.row == 0 {
                languageSettingType = .conversationSource
                didSelectRow(section: 3, row: 0)
                
                presentLanguagePicker(languagePickerType: .speechSourceSetting, sourceLanguageRow: conversationSourceLanguageIndex, targetLanguageRow: 0)
            } else {
                languageSettingType = .conversationTarget
                didSelectRow(section: 3, row: 1)
                
                presentLanguagePicker(languagePickerType: .speechSourceSetting, sourceLanguageRow: conversationTargetLanguageIndex, targetLanguageRow: 0)
            }
        case 4:
            languageSettingType = .arTarget
            didSelectRow(section: 4, row: 0)
            
            presentLanguagePicker(languagePickerType: .targetLanguage, sourceLanguageRow: 0, targetLanguageRow: arTargetLanguageIndex)
        case 5:
            if indexPath.row == 0 {
                languageSettingType = .documentSource
                didSelectRow(section: 4, row: 0)
                
                presentLanguagePicker(languagePickerType: .visionSourceSetting, sourceLanguageRow: documentSourceLanguageIndex, targetLanguageRow: 0)
            } else {
                languageSettingType = .documentTarget
                didSelectRow(section: 4, row: 1)
                
                presentLanguagePicker(languagePickerType: .targetLanguage, sourceLanguageRow: 0, targetLanguageRow: documentTargetLanguageIndex)
            }
        case 6:
            if indexPath.row == 0 {
                languageSettingType = .imageSource
                didSelectRow(section: 5, row: 0)
                
                presentLanguagePicker(languagePickerType: .visionSourceSetting, sourceLanguageRow: imageSourceLanguageIndex, targetLanguageRow: 0)
            } else {
                languageSettingType = .imageTarget
                didSelectRow(section: 5, row: 1)
                
                presentLanguagePicker(languagePickerType: .targetLanguage, sourceLanguageRow: 0, targetLanguageRow: imageTargetLanguageIndex)
            }
        case 7:
            presentFBLanguageTable()
        default:
            return
        }
    }

    func didSelectRow(section: Int, row: Int) {
        print("did select row at section: \(section), row: \(row)")
        print("language setting type is \(languageSettingType)")
    }
    
    func presentLanguagePicker(languagePickerType: LanguagePickerType, sourceLanguageRow: Int, targetLanguageRow: Int) {
        let viewController = LanguagePickerViewController()
        viewController.languagePickerType = languagePickerType
        viewController.sourceLanguageRow = sourceLanguageRow
        viewController.targetLanguageRow = targetLanguageRow
        viewController.isSetting = true
        viewController.delegate = self
        
        navigationController?.pushViewController(viewController, animated: true)
    }
    
    func presentFBLanguageTable() {
        let viewController = FBLanguageTableViewController()
        navigationController?.pushViewController(viewController, animated: true)
    }

}

// MARK: - Extensions

extension SettingTableViewController: LanguagePickerDelegate {
    func didSelectedLanguagePicker(temporarySourceLanguageGCPIndex: Int, temporaryTargetLanguageGCPIndex: Int) {
        let userDefaults = UserDefaults.standard
        
        switch languageSettingType {
        case .textSource:
            textSourceLanguageIndex = temporarySourceLanguageGCPIndex
            userDefaults.set(textSourceLanguageIndex, forKey: Constants.textSourceLanguageIndexKey)
            
        case .textTarget:
            textTargetLanguageIndex = temporaryTargetLanguageGCPIndex
            userDefaults.set(textTargetLanguageIndex, forKey: Constants.textTargetLanguageIndexKey)
            
        case .cameraSource:
            cameraSourceLanguageIndex = temporarySourceLanguageGCPIndex
            userDefaults.set(cameraSourceLanguageIndex, forKey: Constants.cameraSourceLanguageIndexKey)
            
        case .cameraTarget:
            cameraTargetLanguageIndex = temporaryTargetLanguageGCPIndex
            userDefaults.set(cameraTargetLanguageIndex, forKey: Constants.cameraTargetLanguageIndexKey)
            
        case .voiceSource:
            voiceSourceLanguageIndex = temporarySourceLanguageGCPIndex
            userDefaults.set(voiceSourceLanguageIndex, forKey: Constants.voiceSourceLanguageIndexKey)
            
        case .voiceTarget:
            voiceTargetLanguageIndex = temporaryTargetLanguageGCPIndex
            userDefaults.set(voiceTargetLanguageIndex, forKey: Constants.voiceTargetLanguageIndexKey)
            
        case .conversationSource:
            conversationSourceLanguageIndex = temporarySourceLanguageGCPIndex
            userDefaults.set(conversationSourceLanguageIndex, forKey: Constants.conversationSourceLanguageIndexKey)
            
        case .conversationTarget:
            conversationTargetLanguageIndex = temporarySourceLanguageGCPIndex
            userDefaults.set(conversationTargetLanguageIndex, forKey: Constants.conversationTargetLanguageIndexKey)
            
        case .arTarget:
            arTargetLanguageIndex = temporaryTargetLanguageGCPIndex
            userDefaults.set(arTargetLanguageIndex, forKey: Constants.arTargetLanguageIndexKey)
            
        case .documentSource:
            documentSourceLanguageIndex = temporarySourceLanguageGCPIndex
            userDefaults.set(documentSourceLanguageIndex, forKey: Constants.docSourceLanguageIndexKey)
            
        case .documentTarget:
            documentTargetLanguageIndex = temporaryTargetLanguageGCPIndex
            userDefaults.set(documentTargetLanguageIndex, forKey: Constants.docTargetLanguageIndexKey)
            
        case .imageSource:
            imageSourceLanguageIndex = temporarySourceLanguageGCPIndex
            userDefaults.set(imageSourceLanguageIndex, forKey: Constants.imageSourceLanguageIndexKey)
            
        case .imageTarget:
            imageTargetLanguageIndex = temporaryTargetLanguageGCPIndex
            userDefaults.set(imageTargetLanguageIndex, forKey: Constants.imageTargetLanguageIndexKey)
        }
    }
}

