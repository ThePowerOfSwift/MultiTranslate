//
//  SavedTranslationsTableViewController.swift
//  MultiTranslate
//
//  Created by Keishin CHOU on 2020/01/21.
//  Copyright © 2020 Keishin CHOU. All rights reserved.
//

import UIKit

import RealmSwift

class SavedTranslationsTableViewController: UITableViewController {
    
    private let realm = try! Realm()
    private var savedTranslations: Results<SavedTranslation>!

    override func viewDidLoad() {
        super.viewDidLoad()

        // Uncomment the following line to preserve selection between presentations
        // self.clearsSelectionOnViewWillAppear = false

        // Uncomment the following line to display an Edit button in the navigation bar for this view controller.
        // self.navigationItem.rightBarButtonItem = self.editButtonItem
        
        self.title = "Saved Translations"
        view.backgroundColor = UIColor(rgb: 0xC1D2EB)
        
        savedTranslations = realm.objects(SavedTranslation.self).sorted(byKeyPath: "dateCreated", ascending: false)
//        savedTranslations = realm.objects(SavedTranslation.self)
        
        tableView.register(SavedTranslationsTableViewCell.self, forCellReuseIdentifier: Constants.savedTranslationsTableViewCellIdentifier)
        tableView.separatorStyle = .none
        tableView.allowsSelection = false
        
        if !savedTranslations.isEmpty {
            self.navigationItem.rightBarButtonItem = UIBarButtonItem(barButtonSystemItem: .trash, target: self, action: #selector(clearRecords))
        }
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        
        tableView.reloadData()
        
        if let tabBarItems = tabBarController?.tabBar.items {
            let tabItem = tabBarItems[1]
            tabItem.badgeValue = nil
        }
        NotificationCenter.default.post(name: .savedTranlationsDidShow, object: nil)
        
        if !savedTranslations.isEmpty {
            self.navigationItem.rightBarButtonItem = UIBarButtonItem(barButtonSystemItem: .trash, target: self, action: #selector(clearRecords))
        } else {
            self.navigationItem.rightBarButtonItem = nil
        }
    }
    
    @objc func clearRecords() {
        do {
            try realm.write {
                realm.delete(savedTranslations)
            }
            tableView.reloadData()
        } catch {
            print("Error adding item, \(error)")
        }
        self.navigationItem.rightBarButtonItem = nil
    }

    // MARK: - Table view data source

    override func numberOfSections(in tableView: UITableView) -> Int {
        // #warning Incomplete implementation, return the number of sections
        return 1
    }

    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        // #warning Incomplete implementation, return the number of rows
        return savedTranslations.count
    }

    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: Constants.savedTranslationsTableViewCellIdentifier, for: indexPath) as! SavedTranslationsTableViewCell
        cell.savedTranslation = savedTranslations[indexPath.row]

        return cell
    }
    

    //MARK: - Tableview delegates
    override func tableView(_ tableView: UITableView, canEditRowAt indexPath: IndexPath) -> Bool {
        return true
    }
    
    override func tableView(_ tableView: UITableView, trailingSwipeActionsConfigurationForRowAt indexPath: IndexPath) -> UISwipeActionsConfiguration? {
        let savedTranslation = savedTranslations[indexPath.row]
        let deleteAction = UIContextualAction(style: .normal, title: "Delete") { (action, view, completion) in
            do {
                try self.realm.write {
                    self.realm.delete(savedTranslation)
                }
            } catch {
                print("Error adding item, \(error)")
            }
            tableView.reloadData()
            if self.savedTranslations.isEmpty {
                self.navigationItem.rightBarButtonItem = nil
            }
        }
        let config = UIImage.SymbolConfiguration(weight: .regular)
        deleteAction.image = UIImage(systemName: "trash", withConfiguration: config)
        deleteAction.backgroundColor = .systemRed
        
        return UISwipeActionsConfiguration(actions: [deleteAction])
    }

}
