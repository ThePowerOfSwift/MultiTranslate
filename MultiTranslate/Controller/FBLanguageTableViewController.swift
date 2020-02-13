//
//  FBLanguageTableViewController.swift
//  MultiTranslate
//
//  Created by Keishin CHOU on 2020/02/13.
//  Copyright © 2020 Keishin CHOU. All rights reserved.
//

import UIKit

class FBLanguageTableViewController: UITableViewController {
    
    private let sectionTitles = ["Downloaded languages","Undownloaded languages"]
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        tableView.register(UITableViewCell.self, forCellReuseIdentifier: Constants.fbLanguageTableViewCellIdentifier)
        tableView.allowsSelection = false

    }

    // MARK: - Table view data source

    override func numberOfSections(in tableView: UITableView) -> Int {
        return 2
    }
    
    override func tableView(_ tableView: UITableView, titleForHeaderInSection section: Int) -> String? {
        return sectionTitles[section]
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
        let cell = tableView.dequeueReusableCell(withIdentifier: Constants.fbLanguageTableViewCellIdentifier, for: indexPath)
        
        switch indexPath.section {
        case 0:
            cell.textLabel?.text = FBOfflineTranslate.downloadedLanguages[indexPath.row]
        case 1:
            cell.textLabel?.text = FBOfflineTranslate.unDownloadedLanguages[indexPath.row]
        default:
            return cell
        }
        
        return cell
    }

}

