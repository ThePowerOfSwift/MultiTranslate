//
//  PrivacyPolicyViewController.swift
//  MultiTranslate
//
//  Created by Keishin CHOU on 2020/02/21.
//  Copyright © 2020 Keishin CHOU. All rights reserved.
//

import UIKit

class PrivacyPolicyViewController: UIViewController {

    private let scrollView: UIScrollView = {
           let view = UIScrollView()
           view.translatesAutoresizingMaskIntoConstraints = false
           
           return view
       }()
       
       private let container: UIView = {
           let view = UIView()
           view.translatesAutoresizingMaskIntoConstraints = false
           return view
       }()
       
       private let titleLabel: UILabel = {
           let label = UILabel()
           label.translatesAutoresizingMaskIntoConstraints = false
           label.text = "Privacy policy".localized()
           label.textAlignment = .natural
           label.font = UIFont.preferredFont(forTextStyle: .largeTitle)
           label.numberOfLines = 0
           label.lineBreakMode = .byWordWrapping
           return label
       }()
       
       private let contentLabel: UILabel = {
           let label = UILabel()
           label.translatesAutoresizingMaskIntoConstraints = false
           label.text = "Subscription payments will be charged to your iTunes account at confirmation of your purchase and upon commencement of each renewal term. \n Subscription with a free trial period will automatically renew to a paid subscription. You can cancel your subscription or free trial in the iTunes settings at least 24-hours before the end of each current subscription period. The cancellation will take effect the day after the last day of the current subscription period and you will be downgraded to the free service. Any unused portion of a free trial period (if offered) will be forfeited when you purchase a premium subscription during the free trial period. \n Subscription payments will be charged to your iTunes account at confirmation of your purchase and upon commencement of each renewal term. \n Subscription with a free trial period will automatically renew to a paid subscription. You can cancel your subscription or free trial in the iTunes settings at least 24-hours before the end of each current subscription period. The cancellation will take effect the day after the last day of the current subscription period and you will be downgraded to the free service. Any unused portion of a free trial period (if offered) will be forfeited when you purchase a premium subscription during the free trial period. \n Subscription payments will be charged to your iTunes account at confirmation of your purchase and upon commencement of each renewal term. \n Subscription with a free trial period will automatically renew to a paid subscription. You can cancel your subscription or free trial in the iTunes settings at least 24-hours before the end of each current subscription period. The cancellation will take effect the day after the last day of the current subscription period and you will be downgraded to the free service. Any unused portion of a free trial period (if offered) will be forfeited when you purchase a premium subscription during the free trial period. ".localized()
           label.textAlignment = .natural
           label.font = UIFont.preferredFont(forTextStyle: .body)
           label.numberOfLines = 0
           label.lineBreakMode = .byWordWrapping
           return label
       }()
       
       override func loadView() {
           super.loadView()
    
           view.addSubview(scrollView)
           scrollView.edgeTo(view, safeArea: .top)
           
           scrollView.addSubview(container)
           container.topAnchor.constraint(equalTo: scrollView.topAnchor).isActive = true
           container.leadingAnchor.constraint(equalTo: view.leadingAnchor).isActive = true
           container.trailingAnchor.constraint(equalTo: view.trailingAnchor).isActive = true
           
           let containerHeightConstraint = container.heightAnchor.constraint(equalTo: view.heightAnchor)
           containerHeightConstraint.isActive = true
           containerHeightConstraint.priority = UILayoutPriority(rawValue: 250)
           
           container.addSubview(titleLabel)
           titleLabel.topAnchor.constraint(equalTo: container.topAnchor, constant: 35).isActive = true
           titleLabel.leadingAnchor.constraint(equalTo: container.leadingAnchor, constant: 35).isActive = true
           titleLabel.trailingAnchor.constraint(equalTo: container.trailingAnchor, constant: -35).isActive = true
           
           container.addSubview(contentLabel)
           contentLabel.topAnchor.constraint(equalTo: titleLabel.bottomAnchor, constant: 35).isActive = true
           contentLabel.leadingAnchor.constraint(equalTo: titleLabel.leadingAnchor).isActive = true
           contentLabel.trailingAnchor.constraint(equalTo: titleLabel.trailingAnchor).isActive = true
           contentLabel.bottomAnchor.constraint(equalTo: container.bottomAnchor, constant: -35).isActive = true
       }

       override func viewDidLoad() {
           super.viewDidLoad()

           self.title = "Privacy policy".localized()
           navigationItem.rightBarButtonItem = UIBarButtonItem(image: UIImage(systemName: "xmark"), style: .plain, target: self, action: #selector(dismissPage))
           view.backgroundColor = .mtSystemBackground
       }
       
       override func viewDidLayoutSubviews() {

           super.viewDidLayoutSubviews()

           DispatchQueue.main.async { [weak self] in
               var contentRect = CGRect.zero
               guard let scrollViewSubviews = self?.scrollView.subviews else { return }

               for view in scrollViewSubviews {
                  contentRect = contentRect.union(view.frame)
               }

               self?.scrollView.contentSize = contentRect.size
           }
       }

    @objc func dismissPage() {
        dismiss(animated: true, completion: nil)
    }

}
