//
//  TermsOfUseViewController.swift
//  MultiTranslate
//
//  Created by Keishin CHOU on 2020/02/21.
//  Copyright © 2020 Keishin CHOU. All rights reserved.
//

import UIKit

class TermsOfUseViewController: UIViewController {
    
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
        label.text = "Terms of use".localized()
        label.textAlignment = .natural
        label.font = UIFont.preferredFont(forTextStyle: .largeTitle)
        label.numberOfLines = 0
        label.lineBreakMode = .byWordWrapping
        return label
    }()
    
    private let contentLabel: UILabel = {
        let label = UILabel()
        label.translatesAutoresizingMaskIntoConstraints = false
        label.text = """
            By downloading or using the app, these terms will automatically apply to you – you should make sure therefore that you read them carefully before using the app. You’re not allowed to copy, or modify the app, any part of the app, or our trademarks in any way. You’re not allowed to attempt to extract the source code of the app, and you also shouldn’t try to translate the app into other languages, or make derivative versions. The app itself, and all the trade marks, copyright, database rights and other intellectual property rights related to it, still belong to Keishin Chou.

            Keishin Chou is committed to ensuring that the app is as useful and efficient as possible. For that reason, we reserve the right to make changes to the app or to charge for its services, at any time and for any reason. We will never charge you for the app or its services without making it very clear to you exactly what you’re paying for.

            The Multi Translate app stores and processes personal data that you have provided to us, in order to provide my Service. It’s your responsibility to keep your phone and access to the app secure. We therefore recommend that you do not jailbreak or root your phone, which is the process of removing software restrictions and limitations imposed by the official operating system of your device. It could make your phone vulnerable to malware/viruses/malicious programs, compromise your phone’s security features and it could mean that the Multi Translate app won’t work properly or at all.

            You should be aware that there are certain things that Keishin Chou will not take responsibility for. Certain functions of the app will require the app to have an active internet connection. The connection can be Wi-Fi, or provided by your mobile network provider, but Keishin Chou cannot take responsibility for the app not working at full functionality if you don’t have access to Wi-Fi, and you don’t have any of your data allowance left.

            If you’re using the app outside of an area with Wi-Fi, you should remember that your terms of the agreement with your mobile network provider will still apply. As a result, you may be charged by your mobile provider for the cost of data for the duration of the connection while accessing the app, or other third party charges. In using the app, you’re accepting responsibility for any such charges, including roaming data charges if you use the app outside of your home territory (i.e. region or country) without turning off data roaming. If you are not the bill payer for the device on which you’re using the app, please be aware that we assume that you have received permission from the bill payer for using the app.

            Along the same lines, Keishin Chou cannot always take responsibility for the way you use the app i.e. You need to make sure that your device stays charged – if it runs out of battery and you can’t turn it on to avail the Service, Keishin Chou cannot accept responsibility.

            With respect to Keishin Chou’s responsibility for your use of the app, when you’re using the app, it’s important to bear in mind that although we endeavour to ensure that it is updated and correct at all times, we do rely on third parties to provide information to us so that we can make it available to you. Keishin Chou accepts no liability for any loss, direct or indirect, you experience as a result of relying wholly on this functionality of the app.

            At some point, we may wish to update the app. The app is currently available on iOS – the requirements for system (and for any additional systems we decide to extend the availability of the app to) may change, and you’ll need to download the updates if you want to keep using the app. Keishin Chou does not promise that it will always update the app so that it is relevant to you and/or works with the iOS version that you have installed on your device. However, you promise to always accept updates to the application when offered to you, We may also wish to stop providing the app, and may terminate use of it at any time without giving notice of termination to you. Unless we tell you otherwise, upon any termination, (a) the rights and licenses granted to you in these terms will end; (b) you must stop using the app, and (if needed) delete it from your device.

            Changes to This Terms and Conditions

            I may update our Terms and Conditions from time to time. Thus, you are advised to review this page periodically for any changes. I will notify you of any changes by posting the new Terms and Conditions on this page. These changes are effective immediately after they are posted on this page.

            Contact Us

            If you have any questions or suggestions about my Terms and Conditions, do not hesitate to contact me at keishin.chou@gmail.com.
            """.localized()

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
        
        self.title = "Terms of use".localized()
        navigationItem.rightBarButtonItem = UIBarButtonItem(image: UIImage(systemName: "xmark"),
                                                            style: .plain,
                                                            target: self,
                                                            action: #selector(dismissPage))
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
