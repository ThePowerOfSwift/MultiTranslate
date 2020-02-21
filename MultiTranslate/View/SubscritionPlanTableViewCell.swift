//
//  SubscritionPlanTableViewCell.swift
//  MultiTranslate
//
//  Created by Keishin CHOU on 2020/02/19.
//  Copyright © 2020 Keishin CHOU. All rights reserved.
//

import UIKit

class SubscritionPlanTableViewCell: UITableViewCell {

    let container: UIView = {
        let view = UIView()
        view.translatesAutoresizingMaskIntoConstraints = false
        return view
    }()
    
    private let illustrationView: UIView = {
        let view = UIView()
        view.translatesAutoresizingMaskIntoConstraints = false
        return view
    }()
    
    private let titleView: UIView = {
        let view = UIView()
        view.translatesAutoresizingMaskIntoConstraints = false
        return view
    }()
    
    private let priceView: UIView = {
        let view = UIView()
        view.translatesAutoresizingMaskIntoConstraints = false
        return view
    }()
    
    let illustration: UIImageView = {
        let view = UIImageView()
        view.translatesAutoresizingMaskIntoConstraints = false
        view.contentMode = .scaleAspectFill
        view.tintColor = .white
        return view
    }()
    
    let titleLabel: UILabel = {
        let label = UILabel()
        label.translatesAutoresizingMaskIntoConstraints = false
        label.textAlignment = .natural
        label.textColor = .white
        label.font = UIFont.boldSystemFont(ofSize: 16)
        label.sizeToFit()
        return label
    }()
    
    let subTitleLabel: UILabel = {
        let label = UILabel()
        label.translatesAutoresizingMaskIntoConstraints = false
        label.textAlignment = .natural
        label.textColor = .systemGray3
//        label.font = UIFont.systemFont(ofSize: 16)
        label.sizeToFit()
        return label
    }()
    
    let priceLabel: UILabel = {
        let label = UILabel()
        label.translatesAutoresizingMaskIntoConstraints = false
        label.textAlignment = .natural
        label.textColor = .white
//        label.font = UIFont.systemFont(ofSize: 16)
        label.sizeToFit()
        return label
    }()
    
    let priceExplanationLabel: UILabel = {
        let label = UILabel()
        label.translatesAutoresizingMaskIntoConstraints = false
        label.textAlignment = .natural
        label.textColor = .white
//        label.font = UIFont.systemFont(ofSize: 16)
        label.sizeToFit()
        return label
    }()


    override init(style: UITableViewCell.CellStyle, reuseIdentifier: String?) {
        super.init(style: style, reuseIdentifier: reuseIdentifier)
        
        self.addSubview(container)
        container.topAnchor.constraint(equalTo: self.topAnchor, constant: 8).isActive = true
        container.bottomAnchor.constraint(equalTo: self.bottomAnchor, constant: -16).isActive = true
        container.leadingAnchor.constraint(equalTo: self.leadingAnchor, constant: 32).isActive = true
        container.trailingAnchor.constraint(equalTo: self.trailingAnchor, constant: -32).isActive = true
        container.heightAnchor.constraint(equalToConstant: 64).isActive = true
        container.layer.cornerRadius = 32
        
        container.hstack(illustrationView.setWidth(60),
                         titleView,
                         priceView.setWidth(75),
                         spacing: 0,
                         alignment: .fill,
                         distribution: .fill)
        
        illustrationView.addSubview(illustration)
        illustration.leadingAnchor.constraint(equalTo: illustrationView.leadingAnchor, constant: 16).isActive = true
        illustration.centerYAnchor.constraint(equalTo: illustrationView.centerYAnchor).isActive = true
        illustration.heightAnchor.constraint(equalToConstant: 36).isActive = true
        illustration.widthAnchor.constraint(equalTo: illustration.heightAnchor).isActive = true
        
        titleView.addSubview(titleLabel)
        titleLabel.leadingAnchor.constraint(equalTo: titleView.leadingAnchor, constant: 8).isActive = true
        titleLabel.bottomAnchor.constraint(equalTo: titleView.centerYAnchor).isActive = true
        
        titleView.addSubview(subTitleLabel)
        subTitleLabel.leadingAnchor.constraint(equalTo: titleLabel.leadingAnchor).isActive = true
        subTitleLabel.topAnchor.constraint(equalTo: titleView.centerYAnchor).isActive = true
        
        priceView.addSubview(priceLabel)
        priceLabel.leadingAnchor.constraint(equalTo: priceView.leadingAnchor, constant: 8).isActive = true
        priceLabel.bottomAnchor.constraint(equalTo: priceView.centerYAnchor).isActive = true
        
        priceView.addSubview(priceExplanationLabel)
        priceExplanationLabel.leadingAnchor.constraint(equalTo: priceLabel.leadingAnchor).isActive = true
        priceExplanationLabel.topAnchor.constraint(equalTo: priceView.centerYAnchor).isActive = true
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
}
