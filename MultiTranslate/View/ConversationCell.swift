//
//  ConversationCell.swift
//  MultiTranslate
//
//  Created by Keishin CHOU on 2020/01/16.
//  Copyright © 2020 Keishin CHOU. All rights reserved.
//

import UIKit

class ConversationCell: UITableViewCell {
    
    private var leadingConstraints: [NSLayoutConstraint]!
    private var trailingConstraints: [NSLayoutConstraint]!

    var conversation: Conversation? {
        didSet {
            sourceLabel.text = conversation?.sourceMessage
            targetLabel.text = conversation?.targetMessage
            
            if conversation?.isSource == true {
                bubbleBackgroundView.backgroundColor = UIColor(rgb: 0x40e0d0)
                for eachConstraint in leadingConstraints {
                    eachConstraint.isActive = true
                }
                for eachConstraint in trailingConstraints {
                    eachConstraint.isActive = false
                }
                bubbleBackgroundView.layer.cornerRadius = 32
                bubbleBackgroundView.layer.maskedCorners = [.layerMinXMinYCorner, .layerMaxXMinYCorner, .layerMaxXMaxYCorner]
                sourceLabel.textAlignment = .left
                targetLabel.textAlignment = .left
            } else {
                bubbleBackgroundView.backgroundColor = UIColor(rgb: 0xec7373)
                for eachConstraint in trailingConstraints {
                    eachConstraint.isActive = true
                }
                for eachConstraint in leadingConstraints {
                    eachConstraint.isActive = false
                }
                bubbleBackgroundView.layer.cornerRadius = 32
                bubbleBackgroundView.layer.maskedCorners = [.layerMinXMinYCorner, .layerMaxXMinYCorner, .layerMinXMaxYCorner]
                sourceLabel.textAlignment = .right
                targetLabel.textAlignment = .right
            }
        }
    }
    
    private let bubbleBackgroundView: UIView = {
        let view = UIView()
        view.translatesAutoresizingMaskIntoConstraints = false
//        view.backgroundColor = .systemYellow
        
        return view
    }()
    
    private let sourceLabel: UILabel = {
        let label = UILabel()
        label.translatesAutoresizingMaskIntoConstraints = false
        label.numberOfLines = 0
//        label.backgroundColor = .systemBlue
        
        return label
    }()
    
    private let targetLabel: UILabel = {
        let label = UILabel()
        label.translatesAutoresizingMaskIntoConstraints = false
        label.numberOfLines = 0
//        label.backgroundColor = .systemIndigo

        return label
    }()
    
    private let deviderView: UIView = {
        let view = UIView()
        view.translatesAutoresizingMaskIntoConstraints = false
        view.backgroundColor = UIColor(white: 0.9, alpha: 1)

        return view
    }()
    
    
    override init(style: UITableViewCell.CellStyle, reuseIdentifier: String?) {
        super.init(style: style, reuseIdentifier: reuseIdentifier)
        
        self.backgroundColor = UIColor(rgb: 0xC1D2EB)
        
        self.addSubview(bubbleBackgroundView)
        bubbleBackgroundView.topAnchor.constraint(equalTo: self.topAnchor, constant: 16).isActive = true
        bubbleBackgroundView.bottomAnchor.constraint(equalTo: self.bottomAnchor, constant: -16).isActive = true
        bubbleBackgroundView.widthAnchor.constraint(lessThanOrEqualToConstant: 350).isActive = true
        bubbleBackgroundView.widthAnchor.constraint(greaterThanOrEqualToConstant: 150).isActive = true
        bubbleBackgroundView.heightAnchor.constraint(greaterThanOrEqualToConstant: 64).isActive = true
        
        bubbleBackgroundView.VStack(sourceLabel,
                                    deviderView.setHeight(1),
                                    targetLabel,
                                    spacing: 0,
                                    alignment: .fill,
                                    distribution: .fill).padTop(8).padBottom(8)
        
        leadingConstraints = [
            bubbleBackgroundView.leadingAnchor.constraint(equalTo: self.leadingAnchor, constant: 16),
            sourceLabel.leadingAnchor.constraint(equalTo: bubbleBackgroundView.leadingAnchor, constant: 32),
            sourceLabel.trailingAnchor.constraint(equalTo: bubbleBackgroundView.trailingAnchor, constant: -32),
            targetLabel.leadingAnchor.constraint(equalTo: sourceLabel.leadingAnchor),
            targetLabel.trailingAnchor.constraint(equalTo: sourceLabel.trailingAnchor)
        ]
        trailingConstraints = [
            bubbleBackgroundView.trailingAnchor.constraint(equalTo: self.trailingAnchor, constant: -16),
            sourceLabel.leadingAnchor.constraint(equalTo: bubbleBackgroundView.leadingAnchor, constant: 32),
            sourceLabel.trailingAnchor.constraint(equalTo: bubbleBackgroundView.trailingAnchor, constant: -32),
            targetLabel.leadingAnchor.constraint(equalTo: sourceLabel.leadingAnchor),
            targetLabel.trailingAnchor.constraint(equalTo: sourceLabel.trailingAnchor)
        ]
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
}
