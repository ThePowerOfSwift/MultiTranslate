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

    private var isYearlyPlan: Bool = true
    private let colors = [UIColor(rgb: 0xff4d4d), UIColor(rgb: 0x46b3e6), UIColor(rgb: 0x738598)]
    private let titles = ["No Limit", "50k characters/month", "10k characters/month"]
    private let subTitles = ["For a pro translater", "Most popular", "Limited"]
    private let illustrations = [UIImage(named: "crown"), UIImage(named: "firework"), UIImage(named: "diamond")]
    
    private let container: UIView = {
        let view = UIView()
        view.translatesAutoresizingMaskIntoConstraints = false
        view.backgroundColor = UIColor(rgb: 0xC1D2EB)
        return view
    }()
    
    private let expressionContainerView: UIView = {
        let view = UIView()
        view.translatesAutoresizingMaskIntoConstraints = false
        return view
    }()
    
    private let titleContainerView: UIView = {
        let view = UIView()
        view.translatesAutoresizingMaskIntoConstraints = false
        return view
    }()
    
    private let imageContainerView: UIView = {
        let view = UIView()
        view.translatesAutoresizingMaskIntoConstraints = false
        return view
    }()
    
    private let subtitleContainerView: UIView = {
        let view = UIView()
        view.translatesAutoresizingMaskIntoConstraints = false
        return view
    }()
    
    private let titleLabel: UILabel = {
        let label = UILabel()
        label.translatesAutoresizingMaskIntoConstraints = false
        label.text = "Get Multi-Translate PRO"
        label.textAlignment = .center
        label.font = UIFont.boldSystemFont(ofSize: 20.0)
        return label
    }()
    
    private let imageView: UIImageView = {
        let view = UIImageView()
        view.translatesAutoresizingMaskIntoConstraints = false
        view.image = UIImage(named: "reading")
        view.contentMode = .scaleAspectFill
        return view
    }()
    
    private let subtitleLabel: UILabel = {
        let label = UILabel()
        label.translatesAutoresizingMaskIntoConstraints = false
        label.text = "Multiple ways to translate with high accuracy!"
        label.textAlignment = .center
        label.font = UIFont.systemFont(ofSize: 17)
        label.textColor = .systemGray
        return label
    }()
    
    private let selectorContainer: UIView = {
        let view = UIView()
        view.translatesAutoresizingMaskIntoConstraints = false
        return view
    }()
    
    private let planSelector: UISegmentedControl = {
        let selector = UISegmentedControl(items: ["Yearly plan", "Monthly plan"])
        selector.translatesAutoresizingMaskIntoConstraints = false
        selector.selectedSegmentIndex = 0
//        selector.backgroundColor = UIColor(rgb: 0xe1f2fb)
//        selector.selectedSegmentTintColor = UIColor(rgb: 0x4d80e4)
        selector.layer.borderWidth = 1
        selector.layer.borderColor = UIColor.white.cgColor
        return selector
    }()
    
    private let tableContainerView: UIView = {
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
        
        container.VStack(expressionContainerView.setHeight(250),
                         selectorContainer.setHeight(45),
                         tableContainerView,
                         spacing: 0,
                         alignment: .fill,
                         distribution: .fill).padTop(48)
        
        expressionContainerView.VStack(titleContainerView,
                                       imageContainerView.setHeight(175),
                                       subtitleContainerView,
                                       spacing: 0,
                                       alignment: .fill,
                                       distribution: .fill)
        
        titleContainerView.heightAnchor.constraint(equalTo: subtitleContainerView.heightAnchor).isActive = true
        
        titleContainerView.addSubview(titleLabel)
        titleLabel.centerInSuperview()
        
        imageContainerView.addSubview(imageView)
        imageView.centerInSuperview()
        imageView.heightAnchor.constraint(equalTo: imageView.widthAnchor).isActive = true
        imageView.topAnchor.constraint(equalTo: imageContainerView.topAnchor).isActive = true
        imageView.bottomAnchor.constraint(equalTo: imageContainerView.bottomAnchor).isActive = true
        
        subtitleContainerView.addSubview(subtitleLabel)
        subtitleLabel.centerInSuperview()
        
        selectorContainer.addSubview(planSelector)
        planSelector.topAnchor.constraint(equalTo: selectorContainer.topAnchor, constant: 15).isActive = true
        planSelector.bottomAnchor.constraint(equalTo: selectorContainer.bottomAnchor).isActive = true
        planSelector.leadingAnchor.constraint(equalTo: selectorContainer.leadingAnchor, constant: 88).isActive = true
        planSelector.trailingAnchor.constraint(equalTo: selectorContainer.trailingAnchor, constant: -88).isActive = true

        tableContainerView.addSubview(subscritionPlanTableView)
        subscritionPlanTableView.topAnchor.constraint(equalTo: tableContainerView.topAnchor, constant: 32).isActive = true
        subscritionPlanTableView.leadingAnchor.constraint(equalTo: tableContainerView.leadingAnchor).isActive = true
        subscritionPlanTableView.bottomAnchor.constraint(equalTo: tableContainerView.bottomAnchor).isActive = true
        subscritionPlanTableView.trailingAnchor.constraint(equalTo: tableContainerView.trailingAnchor).isActive = true
    }


    override func viewDidLoad() {
        super.viewDidLoad()

        // Do any additional setup after loading the view.
        
        navigationItem.rightBarButtonItem = UIBarButtonItem(title: "Restore", style: .plain, target: self, action: #selector(restorePurchase))
        navigationItem.leftBarButtonItem = UIBarButtonItem(title: "Purchase", style: .plain, target: self, action: #selector(purchaseTest))
        
        planSelector.addTarget(self, action: #selector(planSelectorValueChanged(_:)), for: .valueChanged)
        
        print(InAppPurchaseManager.retrievedProducts)
        subscritionPlanTableView.dataSource = self
        subscritionPlanTableView.delegate = self
        
        subscritionPlanTableView.register(SubscritionPlanTableViewCell.self, forCellReuseIdentifier: Constants.subscritionPlanTableViewCellIdentifier)
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
    
    @objc func planSelectorValueChanged(_ sender: UISegmentedControl) {
        switch sender.selectedSegmentIndex {
        case 0:
            print("yearly plan")
            isYearlyPlan = true
            subscritionPlanTableView.reloadData()
        case 1:
            print("monthly plan")
            isYearlyPlan = false
            subscritionPlanTableView.reloadData()
        default:
            print("default plan...")
        }
    }

}

extension AccountViewController: UITableViewDataSource {
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return 3
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: Constants.subscritionPlanTableViewCellIdentifier, for: indexPath) as! SubscritionPlanTableViewCell
        
        if isYearlyPlan {
            cell.priceLabel.text = InAppPurchaseManager.retrievedProducts[indexPath.row * 2].localizedPrice!
            cell.priceExplanationLabel.text = "/year"
        } else {
            cell.priceLabel.text = InAppPurchaseManager.retrievedProducts[indexPath.row * 2 + 1].localizedPrice!
            cell.priceExplanationLabel.text = "/month"
        }
        
        cell.illustration.image = illustrations[indexPath.row]
        cell.titleLabel.text = titles[indexPath.row]
        cell.subTitleLabel.text = subTitles[indexPath.row]
        cell.container.backgroundColor = colors[indexPath.row]
        
        
//        let colors = [UIColor(rgb: 0xff4d4d), UIColor(rgb: 0x46b3e6), UIColor(rgb: 0x738598)]
        
//        if isYearlyPlan {
//            cell.textLabel?.text = "Product: \(retrievedProducts[indexPath.row * 2].localizedTitle),description: \(retrievedProducts[indexPath.row * 2].localizedDescription), price: \(retrievedProducts[indexPath.row * 2].localizedPrice!)"
//        } else {
//            cell.textLabel?.text = "Product: \(retrievedProducts[indexPath.row * 2 + 1].localizedTitle),description: \(retrievedProducts[indexPath.row * 2 + 1].localizedDescription), price: \(retrievedProducts[indexPath.row * 2 + 1].localizedPrice!)"
//        }
//
//        cell.textLabel?.numberOfLines = 0
//        cell.backgroundColor = colors[indexPath.row]
        
//        let layer = CAGradientLayer()
//        layer.frame = cell.bounds
//        layer.colors = [UIColor.red.cgColor, UIColor.black.cgColor]
//        cell.layer.insertSublayer(layer, at: 0)
        
        return cell
    }
    
    
}

extension AccountViewController: UITableViewDelegate {
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        tableView.deselectRow(at: indexPath, animated: true)
        
        if isYearlyPlan {
            InAppPurchaseManager.purchaseProduct(with: InAppPurchaseManager.retrievedProducts[indexPath.row * 2].productIdentifier)
        } else {
            InAppPurchaseManager.purchaseProduct(with: InAppPurchaseManager.retrievedProducts[indexPath.row * 2 + 1].productIdentifier)
        }
    }
}

