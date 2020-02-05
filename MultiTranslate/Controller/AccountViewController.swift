//
//  AccountViewController.swift
//  MultiTranslate
//
//  Created by Keishin CHOU on 2020/01/27.
//  Copyright © 2020 Keishin CHOU. All rights reserved.
//

import UIKit
import StoreKit
import SwiftyStoreKit

class AccountViewController: UIViewController {

    private let container: UIView = {
        let view = UIView()
        view.translatesAutoresizingMaskIntoConstraints = false
        
        return view
    }()
    
    private let subscritionPlanTableView: UITableView = {
        let tableView = UITableView()
        tableView.translatesAutoresizingMaskIntoConstraints = false
        
        return tableView
    }()
    
    override func loadView() {
        super.loadView()
        
        view.addSubview(container)
        container.topAnchor.constraint(equalTo: view.safeAreaLayoutGuide.topAnchor).isActive = true
        container.bottomAnchor.constraint(equalTo: view.safeAreaLayoutGuide.bottomAnchor).isActive = true
        container.leadingAnchor.constraint(equalTo: view.leadingAnchor).isActive = true
        container.trailingAnchor.constraint(equalTo: view.trailingAnchor).isActive = true
        
        container.addSubview(subscritionPlanTableView)
        subscritionPlanTableView.topAnchor.constraint(equalTo: container.topAnchor).isActive = true
        subscritionPlanTableView.bottomAnchor.constraint(equalTo: container.bottomAnchor).isActive = true
        subscritionPlanTableView.leadingAnchor.constraint(equalTo: container.leadingAnchor).isActive = true
        subscritionPlanTableView.trailingAnchor.constraint(equalTo: container.trailingAnchor).isActive = true
    }


    override func viewDidLoad() {
        super.viewDidLoad()

        // Do any additional setup after loading the view.
        
        navigationItem.rightBarButtonItem = UIBarButtonItem(title: "Restore", style: .plain, target: self, action: #selector(restorePurchase))
        navigationItem.leftBarButtonItem = UIBarButtonItem(title: "Purchase", style: .plain, target: self, action: #selector(purchaseTest))
        
        print(retrievedProducts)
        subscritionPlanTableView.dataSource = self
        subscritionPlanTableView.delegate = self
        
        subscritionPlanTableView.register(UITableViewCell.self, forCellReuseIdentifier: Constants.subscritionPlanTableViewCellIdentifier)
        subscritionPlanTableView.separatorStyle = .none
    }
    
    @objc func restorePurchase() {
        InAppPurchaseManager.restorePurchase()
    }
    
    @objc func purchaseTest() {
        let vc = PurchasePageViewController()
        vc.modalPresentationStyle = .pageSheet
        present(vc, animated: true, completion: nil)
    }

}

extension AccountViewController: UITableViewDataSource {
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return retrievedProducts.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: Constants.subscritionPlanTableViewCellIdentifier, for: indexPath)
        cell.textLabel?.text = "Product: \(retrievedProducts[indexPath.row].localizedTitle),description: \(retrievedProducts[indexPath.row].localizedDescription), price: \(retrievedProducts[indexPath.row].localizedPrice!)"
        cell.textLabel?.numberOfLines = 0
        return cell
    }
    
    
}

extension AccountViewController: UITableViewDelegate {
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        tableView.deselectRow(at: indexPath, animated: true)
        
        InAppPurchaseManager.purchaseProduct(with: retrievedProducts[indexPath.row].productIdentifier)
    }
}

