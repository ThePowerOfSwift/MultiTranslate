//
//  AboutSubscriptionViewController.swift
//  MultiTranslate
//
//  Created by Keishin CHOU on 2020/02/21.
//  Copyright © 2020 Keishin CHOU. All rights reserved.
//

import UIKit

class AboutSubscriptionViewController: UIViewController {

    override func viewDidLoad() {
        super.viewDidLoad()

        self.title = "About subscription"
        navigationItem.rightBarButtonItem = UIBarButtonItem(image: UIImage(systemName: "xmark"), style: .plain, target: self, action: #selector(dismissPage))
        view.backgroundColor = UIColor(rgb: 0xC1D2EB)
    }

    @objc func dismissPage() {
        dismiss(animated: true, completion: nil)
    }

}
