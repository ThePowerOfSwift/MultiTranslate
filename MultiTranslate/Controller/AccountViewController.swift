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
        view.backgroundColor = .mtSystemBackground
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
//        view.backgroundColor = .systemRed
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
        
//        label.backgroundColor = .systemBlue
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
//        selector.backgroundColor = .mtSystemBackground
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
    
    private let additionalInformationView: UIView = {
        let view = UIView()
        view.translatesAutoresizingMaskIntoConstraints = false
        view.backgroundColor = .label
        return view
    }()
    
    private let subscriptionInformationView: UIView = {
        let view = UIView()
        view.translatesAutoresizingMaskIntoConstraints = false
//        view.backgroundColor = .systemBackground
        view.backgroundColor = .mtSystemBackground
        return view
    }()
    
    private let termsOfUseInformationView: UIView = {
        let view = UIView()
        view.translatesAutoresizingMaskIntoConstraints = false
//        view.backgroundColor = .systemBackground
        view.backgroundColor = .mtSystemBackground
        return view
    }()
    
    private let privacyPolicyInformationView: UIView = {
        let view = UIView()
        view.translatesAutoresizingMaskIntoConstraints = false
//        view.backgroundColor = .systemBackground
        view.backgroundColor = .mtSystemBackground
        return view
    }()
    
    private let subscriptionInformationButton: UIButton = {
        let button = UIButton()
        button.translatesAutoresizingMaskIntoConstraints = false
        button.setTitle("About subscription", for: .normal)
        button.setTitleColor(.systemGray2, for: .normal)
        button.setTitleColor(.systemGray5, for: .highlighted)
        button.titleLabel?.font = UIFont.systemFont(ofSize: 12)
        return button
    }()
    
    private let termsOfUseInformationButton: UIButton = {
        let button = UIButton()
        button.translatesAutoresizingMaskIntoConstraints = false
        button.setTitle("Terms of use", for: .normal)
        button.setTitleColor(.systemGray2, for: .normal)
        button.setTitleColor(.systemGray5, for: .highlighted)
        button.titleLabel?.font = UIFont.systemFont(ofSize: 12)
        return button
    }()
    
    private let privacyPolicyInformationButton: UIButton = {
        let button = UIButton()
        button.translatesAutoresizingMaskIntoConstraints = false
        button.setTitle("Privacy policy", for: .normal)
        button.setTitleColor(.systemGray2, for: .normal)
        button.setTitleColor(.systemGray5, for: .highlighted)
        button.titleLabel?.font = UIFont.systemFont(ofSize: 12)
        return button
    }()
    
    override func loadView() {
        super.loadView()
        
        let viewHeight = self.view.frame.height
        let viewWidth = self.view.frame.width
        
        print("viewHeight is \(viewHeight)")
        print("viewWidth is \(viewWidth)")
        
        view.addSubview(container)
        container.topAnchor.constraint(equalTo: view.safeAreaLayoutGuide.topAnchor).isActive = true
        container.bottomAnchor.constraint(equalTo: view.safeAreaLayoutGuide.bottomAnchor).isActive = true
        container.leadingAnchor.constraint(equalTo: view.leadingAnchor).isActive = true
        container.trailingAnchor.constraint(equalTo: view.trailingAnchor).isActive = true
        
        container.VStack(expressionContainerView.setHeight(viewHeight * 0.28),
                         selectorContainer.setHeight(viewHeight * 0.065),
                         tableContainerView,
                         additionalInformationView.setHeight(viewHeight * 0.015),
                         spacing: 0,
                         alignment: .fill,
                         distribution: .fill).padTop(viewHeight * 0.03).padBottom(viewHeight * 0.03)
        
        expressionContainerView.VStack(titleContainerView,
                                       imageContainerView.setHeight(viewHeight * 0.195),
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
        planSelector.topAnchor.constraint(equalTo: selectorContainer.topAnchor, constant: viewHeight * 0.027).isActive = true
        planSelector.bottomAnchor.constraint(equalTo: selectorContainer.bottomAnchor, constant: -1).isActive = true
        planSelector.leadingAnchor.constraint(equalTo: selectorContainer.leadingAnchor, constant: viewWidth * 0.21).isActive = true
        planSelector.trailingAnchor.constraint(equalTo: selectorContainer.trailingAnchor, constant: -viewWidth * 0.21).isActive = true

        tableContainerView.addSubview(subscritionPlanTableView)
        subscritionPlanTableView.topAnchor.constraint(equalTo: tableContainerView.topAnchor, constant: 15).isActive = true
        subscritionPlanTableView.leadingAnchor.constraint(equalTo: tableContainerView.leadingAnchor).isActive = true
        subscritionPlanTableView.bottomAnchor.constraint(equalTo: tableContainerView.bottomAnchor).isActive = true
        subscritionPlanTableView.trailingAnchor.constraint(equalTo: tableContainerView.trailingAnchor).isActive = true
        
        additionalInformationView.HStack(subscriptionInformationView,
                                         termsOfUseInformationView,
                                         privacyPolicyInformationView,
                                         spacing: 1,
                                         alignment: .fill,
                                         distribution: .fillEqually)
        
        subscriptionInformationView.addSubview(subscriptionInformationButton)
        subscriptionInformationButton.centerYAnchor.constraint(equalTo: subscriptionInformationView.centerYAnchor).isActive = true
        subscriptionInformationButton.trailingAnchor.constraint(equalTo: subscriptionInformationView.trailingAnchor, constant: -5).isActive = true
        
        termsOfUseInformationView.addSubview(termsOfUseInformationButton)
        termsOfUseInformationButton.centerInSuperview()
        
        privacyPolicyInformationView.addSubview(privacyPolicyInformationButton)
        privacyPolicyInformationButton.centerYAnchor.constraint(equalTo: privacyPolicyInformationView.centerYAnchor).isActive = true
        privacyPolicyInformationButton.leadingAnchor.constraint(equalTo: privacyPolicyInformationView.leadingAnchor, constant: 5).isActive = true
    }


    override func viewDidLoad() {
        super.viewDidLoad()
        
        view.backgroundColor = .mtSystemBackground

        // Do any additional setup after loading the view.
        subscritionPlanTableView.backgroundColor = .mtSystemBackground
        
        navigationItem.rightBarButtonItem = UIBarButtonItem(title: "Restore", style: .plain, target: self, action: #selector(restorePurchase))
        navigationItem.leftBarButtonItem = UIBarButtonItem(title: "Purchase", style: .plain, target: self, action: #selector(purchaseTest))
        
        planSelector.addTarget(self, action: #selector(planSelectorValueChanged(_:)), for: .valueChanged)
        planSelector.setTitleTextAttributes([NSAttributedString.Key.foregroundColor: UIColor.label], for: .selected)
        planSelector.setTitleTextAttributes([NSAttributedString.Key.foregroundColor: UIColor.systemBackground], for: .normal)
        
        print(InAppPurchaseManager.retrievedProducts)
        subscritionPlanTableView.dataSource = self
        subscritionPlanTableView.delegate = self
        
        subscritionPlanTableView.register(SubscritionPlanTableViewCell.self, forCellReuseIdentifier: Constants.subscritionPlanTableViewCellIdentifier)
        subscritionPlanTableView.separatorStyle = .none
        
        subscriptionInformationButton.addTarget(self, action: #selector(showAboutSubscription), for: .touchUpInside)
        termsOfUseInformationButton.addTarget(self, action: #selector(showTermsOfUse), for: .touchUpInside)
        privacyPolicyInformationButton.addTarget(self, action: #selector(showPrivacyPolicy), for: .touchUpInside)
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
    
    @objc func showAboutSubscription() {
        let viewController = AboutSubscriptionViewController()
        let navController = UINavigationController(rootViewController: viewController)
        navController.modalPresentationStyle = .pageSheet
        present(navController, animated: true, completion: nil)
    }
    
    @objc func showTermsOfUse() {
        let viewController = TermsOfUseViewController()
        let navController = UINavigationController(rootViewController: viewController)
        navController.modalPresentationStyle = .pageSheet
        present(navController, animated: true, completion: nil)
    }
    
    @objc func showPrivacyPolicy() {
        let viewController = PrivacyPolicyViewController()
        let navController = UINavigationController(rootViewController: viewController)
        navController.modalPresentationStyle = .pageSheet
        present(navController, animated: true, completion: nil)
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

