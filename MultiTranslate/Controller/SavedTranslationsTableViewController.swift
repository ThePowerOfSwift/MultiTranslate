//
//  SavedTranslationsTableViewController.swift
//  MultiTranslate
//
//  Created by Keishin CHOU on 2020/01/21.
//  Copyright © 2020 Keishin CHOU. All rights reserved.
//

import UIKit

import RealmSwift
import SPAlert

class SavedTranslationsTableViewController: UITableViewController {
    
    private let realm = try! Realm()
    private var savedTranslations: Results<SavedTranslation>!
    
    private let container: UIView = {
        let view = UIView()
        view.translatesAutoresizingMaskIntoConstraints = false
        return view
    }()
    
    private let contentView: UIView = {
        let view = UIView()
        view.translatesAutoresizingMaskIntoConstraints = false
        return view
    }()
    
    private let emptyBoxImageView: UIImageView = {
        let view = UIImageView()
        view.translatesAutoresizingMaskIntoConstraints = false
        view.image = UIImage(named: "emptybox")
        view.contentMode = .scaleAspectFill
        return view
    }()
    
    private let noItemLabel: UILabel = {
        let label = UILabel()
        label.translatesAutoresizingMaskIntoConstraints = false
        label.text = "No item".localized()
        label.font = UIFont.systemFont(ofSize: 30, weight: .thin)
        label.textAlignment = .center
        return label
    }()
    
    override func loadView() {
        super.loadView()
                
        view.addSubview(container)
        container.edgeTo(view, safeArea: .all)
        
        container.addSubview(emptyBoxImageView)
        emptyBoxImageView.centerXAnchor.constraint(equalTo: container.centerXAnchor, constant: 20).isActive = true
        emptyBoxImageView.centerYAnchor.constraint(equalTo: container.centerYAnchor).isActive = true
        emptyBoxImageView.heightAnchor.constraint(equalToConstant: 150).isActive = true
        emptyBoxImageView.widthAnchor.constraint(equalToConstant: 150).isActive = true
        
        container.addSubview(noItemLabel)
        noItemLabel.topAnchor.constraint(equalTo: emptyBoxImageView.bottomAnchor, constant: 30).isActive = true
        noItemLabel.centerXAnchor.constraint(equalTo: container.centerXAnchor).isActive = true
    }

    override func viewDidLoad() {
        super.viewDidLoad()
        
        title = "Saved Translations".localized()
        view.backgroundColor = .mtSystemBackground
        
        savedTranslations = realm.objects(SavedTranslation.self).sorted(byKeyPath: "dateCreated", ascending: false)
//        savedTranslations = realm.objects(SavedTranslation.self)
        
        tableView.register(SavedTranslationsTableViewCell.self, forCellReuseIdentifier: Constants.savedTranslationsTableViewCellIdentifier)
        tableView.separatorStyle = .none
        tableView.allowsSelection = false
        
        if !savedTranslations.isEmpty {
            navigationItem.rightBarButtonItem = UIBarButtonItem(barButtonSystemItem: .trash, target: self, action: #selector(clearRecords))
            container.isHidden = true
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
            navigationItem.rightBarButtonItem = UIBarButtonItem(barButtonSystemItem: .trash, target: self, action: #selector(clearRecords))
            container.isHidden = true
        } else {
            navigationItem.rightBarButtonItem = nil
            container.isHidden = false
        }
    }
    
    @objc func clearRecords() {
        let alert = PMAlertController(title: "Clear records?".localized(),
                                      description: "Records cannot be recovered once deleted.".localized(),
                                      image: UIImage(named: "trash_color"),
                                      style: .alert)
        let cancelAction = PMAlertAction(title: "Cancel", style: .cancel)
        let defaultAction = PMAlertAction(title: "Clear records", style: .default) { [weak self] in
            guard let records = self?.savedTranslations else { return }
            do {
                try self?.realm.write {
                    self?.realm.delete(records)
                }
            } catch {
                print("Error adding item, \(error)")
            }
            SPAlert.present(title: "Records cleared".localized(), message: nil, image: UIImage(systemName: "trash.fill")!)
            self?.tableView.reloadData()
            self?.navigationItem.rightBarButtonItem = nil
            self?.container.isHidden = false
        }
        alert.addAction(cancelAction)
        alert.addAction(defaultAction)
        present(alert, animated: true, completion: nil)
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
        let deleteAction = UIContextualAction(style: .destructive, title: "Delete".localized()) { (action, view, completion) in

            if indexPath.row == 0 {
                NotificationCenter.default.post(name: .firstSavedTranslationDeleted, object: nil)
            }

            do {
                try self.realm.write {
                    self.realm.delete(savedTranslation)
                }
            } catch {
                print("Error adding item, \(error)")
            }
            SPAlert.present(title: "Translation deleted".localized(), message: nil, image: UIImage(systemName: "trash.fill")!)
            tableView.reloadData()
            if self.savedTranslations.isEmpty {
                self.navigationItem.rightBarButtonItem = nil
                self.container.isHidden = false
            }
        }
        let config = UIImage.SymbolConfiguration(weight: .regular)
        deleteAction.image = UIImage(systemName: "trash", withConfiguration: config)
        deleteAction.backgroundColor = .systemRed
        
        return UISwipeActionsConfiguration(actions: [deleteAction])
    }

}
