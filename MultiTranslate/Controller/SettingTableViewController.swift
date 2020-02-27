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

    private let sections = ["Text translate language", "Camera translate language", "Voice translate language", "Conversation translate language", "Offline translation module"]
    
    private let textTranslateLanguageSection = ["Source", "Target"]
    private let cameraTranslateLanguageSection = ["Source", "Target"]
    private let voiceTranslateLanguageSection = ["Source", "Target"]
    private let conversationLanguageSection = ["Source", "Target"]
    private let offlineLanguagesSection = ["Offline languages"]
    private var sectionList = [Array<String>]()
    
    private var textSourceLanguageIndex = UserDefaults.standard.integer(forKey: Constants.textSourceLanguageIndexKey)
    private var textTargetLanguageIndex = UserDefaults.standard.integer(forKey: Constants.textTargetLanguageIndexKey)
    private var cameraSourceLanguageIndex = UserDefaults.standard.integer(forKey: Constants.cameraSourceLanguageIndexKey)
    private var cameraTargetLanguageIndex = UserDefaults.standard.integer(forKey: Constants.cameraTargetLanguageIndexKey)
    private var voiceSourceLanguageIndex = UserDefaults.standard.integer(forKey: Constants.voiceSourceLanguageIndexKey)
    private var voiceTargetLanguageIndex = UserDefaults.standard.integer(forKey: Constants.voiceTargetLanguageIndexKey)
    private var conversationSourceLanguageIndex = UserDefaults.standard.integer(forKey: Constants.conversationSourceLanguageIndexKey)
    private var conversationTargetLanguageIndex = UserDefaults.standard.integer(forKey: Constants.conversationTargetLanguageIndexKey)
    
    enum LanguageSettingType {
        case textSource
        case textTarget
        case cameraSource
        case cameraTarget
        case voiceSource
        case voiceTarget
        case conversationSource
        case conversationTarget
    }
    
    private var languageSettingType = LanguageSettingType.textSource
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        self.title = "Setting"
        self.clearsSelectionOnViewWillAppear = true
        view.backgroundColor = UIColor(rgb: 0xC1D2EB)
        sectionList = [textTranslateLanguageSection, cameraTranslateLanguageSection, voiceTranslateLanguageSection, conversationLanguageSection, offlineLanguagesSection]
        
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
    
    override func tableView(_ tableView: UITableView, viewForHeaderInSection section: Int) -> UIView?
    {
        let headerView = UIView(frame: CGRect(x: 0, y: 0, width: tableView.bounds.size.width, height: 30))
        let sectionTitle = UILabel(frame: CGRect(x: 20, y: 0, width: headerView.bounds.size.width, height: headerView.bounds.size.height))
        headerView.backgroundColor = UIColor(rgb: 0x9ab6df)
        headerView.addSubview(sectionTitle)
        sectionTitle.text = sections[section]
        sectionTitle.font = UIFont.boldSystemFont(ofSize: 16)
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
            return conversationLanguageSection.count
        case 4:
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
        cell.backgroundColor = UIColor(rgb: 0xC1D2EB)
        
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
                didSelectRow(section: 2, row: 0)
                
                presentLanguagePicker(languagePickerType: .speechSourceSetting, sourceLanguageRow: conversationSourceLanguageIndex, targetLanguageRow: 0)
            } else {
                languageSettingType = .conversationTarget
                didSelectRow(section: 2, row: 1)
                
                presentLanguagePicker(languagePickerType: .speechSourceSetting, sourceLanguageRow: conversationTargetLanguageIndex, targetLanguageRow: 0)
            }
        case 4:
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
        }
    }
}

