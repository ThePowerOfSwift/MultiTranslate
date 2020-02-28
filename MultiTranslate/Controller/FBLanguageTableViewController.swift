//
//  FBLanguageTableViewController.swift
//  MultiTranslate
//
//  Created by Keishin CHOU on 2020/02/13.
//  Copyright © 2020 Keishin CHOU. All rights reserved.
//

import UIKit

import Firebase
import SPAlert

class FBLanguageTableViewController: UITableViewController {
    
    private let sectionTitles = ["Downloaded languages","Undownloaded languages"]
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        view.backgroundColor = UIColor(rgb: 0xC1D2EB)
        
        tableView.register(FBLanguageTableViewCell.self, forCellReuseIdentifier: Constants.fbLanguageTableViewCellIdentifier)
        tableView.allowsSelection = false
        navigationItem.rightBarButtonItem = UIBarButtonItem(barButtonSystemItem: .refresh, target: self, action: #selector(reloadTableView))
        
        NotificationCenter.default.addObserver(forName: .fbDownloadedLanguagesDidUpdate, object: nil, queue: nil) { (notification) in
            SPAlert.present(title: "Language downloaded", message: nil, image: UIImage(systemName: "tray.and.arrow.down.fill")!)
            self.tableView.reloadData()
        }
        
        NotificationCenter.default.addObserver(forName: .firebaseMLModelDownloadDidFail, object: nil, queue: .main) { (notification) in
            print("Firebase language model download failded.")
            //Show UIAlert here.
        }
    }

    // MARK: - Table view data source

    override func numberOfSections(in tableView: UITableView) -> Int {
        return 2
    }
    
//    override func tableView(_ tableView: UITableView, titleForHeaderInSection section: Int) -> String? {
//        return sectionTitles[section]
//    }
    
    override func tableView(_ tableView: UITableView, viewForHeaderInSection section: Int) -> UIView?
    {
        let headerView = UIView(frame: CGRect(x: 0, y: 0, width: tableView.bounds.size.width, height: 30))
        let sectionTitle = UILabel(frame: CGRect(x: 20, y: 0, width: headerView.bounds.size.width, height: headerView.bounds.size.height))
        headerView.backgroundColor = UIColor(rgb: 0x9ab6df)
        headerView.addSubview(sectionTitle)
        sectionTitle.text = sectionTitles[section]
        sectionTitle.font = UIFont.boldSystemFont(ofSize: 18)
        return headerView
    }

    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        switch section {
        case 0:
            return FBOfflineTranslate.downloadedLanguageCodes.count
        case 1:
            return FBOfflineTranslate.unDownloadedLanguageCodes.count
        default:
            return 0
        }
    }

    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: Constants.fbLanguageTableViewCellIdentifier, for: indexPath) as! FBLanguageTableViewCell
//        let cell = FBLanguageTableViewCell()
        
        switch indexPath.section {
        case 0:
            cell.languageNameLabel.text = FBOfflineTranslate.downloadedLanguages[indexPath.row]
            cell.downloadButton.isHidden = true
            cell.downloadedImageView.isHidden = false
            cell.indicator.isHidden = true
            
        case 1:
            cell.languageNameLabel.text = FBOfflineTranslate.unDownloadedLanguages[indexPath.row]
            cell.downloadedImageView.isHidden = true
            cell.downloadButton.isHidden = false
            cell.indicator.isHidden = true
            
        default:
            return cell
        }
        
        return cell
    }
    
    override func tableView(_ tableView: UITableView, canEditRowAt indexPath: IndexPath) -> Bool {
        switch indexPath.section {
        case 0:
            return true
        case 1:
            return false
        default:
            return false
        }
    }
    
    override func tableView(_ tableView: UITableView, trailingSwipeActionsConfigurationForRowAt indexPath: IndexPath) -> UISwipeActionsConfiguration? {
        let cell = tableView.cellForRow(at: indexPath) as! FBLanguageTableViewCell
        guard let language = cell.languageNameLabel.text else { return nil }
        
        let deleteAction = UIContextualAction(style: .destructive, title: "Delete") { (action, view, completion) in
            if language == "English" {
                print("English language cannot be deleted.")
                //Show UIAlert
                completion(true)
            } else {
                self.deleteFBLanguage(of: language)
                print("delete \(language) language model")
                completion(true)
            }
            
        }
        
        let config = UIImage.SymbolConfiguration(weight: .regular)
        deleteAction.image = UIImage(systemName: "trash", withConfiguration: config)
        deleteAction.backgroundColor = .systemRed
        
        return UISwipeActionsConfiguration(actions: [deleteAction])
    }
    
    func deleteFBLanguage(of language: String) {
        guard let requestModel = FBOfflineTranslate.createTranslateRemoteModel(from: language) else { return }
        ModelManager.modelManager().deleteDownloadedModel(requestModel) { (error) in
            if error == nil {
                print("language \(language) is deleted successfully.")
                FBOfflineTranslate.initializeFBTranslation()
                SPAlert.present(title: "Language deleted", message: nil, image: UIImage(systemName: "trash.fill")!)
                self.tableView.reloadData()
            } else {
                print(error!.localizedDescription)
                let alert = PMAlertController(title: "Error", description: error?.localizedDescription, image: UIImage(named: "error"), style: .alert)
                let cancelAction = PMAlertAction(title: "cancel", style: .cancel)
                alert.addAction(cancelAction)
                self.present(alert, animated: true, completion: nil)
            }
        }
    }
    
    @objc func reloadTableView() {
        tableView.reloadData()
    }
}

