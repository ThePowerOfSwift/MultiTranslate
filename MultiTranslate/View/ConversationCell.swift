//
//  ConversationCell.swift
//  MultiTranslate
//
//  Created by Keishin CHOU on 2020/01/16.
//  Copyright © 2020 Keishin CHOU. All rights reserved.
//

import UIKit

class ConversationCell: UITableViewCell {
    
    var leadingConstraint: NSLayoutConstraint!
    var trailingConstraint: NSLayoutConstraint!

    var conversation: Conversation? {
        didSet {
            sourceLabel.text = conversation?.sourceMessage
            targetLabel.text = conversation?.targetMessage
            
            if conversation?.sender == .source {
                bubbleBackgroundView.backgroundColor = .systemPink
                leadingConstraint.isActive = true
                trailingConstraint.isActive = false
            } else {
                bubbleBackgroundView.backgroundColor = .systemOrange
                leadingConstraint.isActive = false
                trailingConstraint.isActive = true
            }
        }
    }
    
    private let bubbleBackgroundView: UIView = {
        let view = UIView()
        view.translatesAutoresizingMaskIntoConstraints = false
        view.backgroundColor = .systemYellow
        view.layer.cornerRadius = 5
        
        return view
    }()
    
    private let sourceLabel: UILabel = {
        let label = UILabel()
        label.translatesAutoresizingMaskIntoConstraints = false
        label.numberOfLines = 0
        label.backgroundColor = .systemBlue
        
        return label
    }()
    
    private let targetLabel: UILabel = {
        let label = UILabel()
        label.translatesAutoresizingMaskIntoConstraints = false
        label.numberOfLines = 0
        label.backgroundColor = .systemIndigo

        return label
    }()
    
    private let deviderView: UIView = {
        let view = UIView()
        view.backgroundColor = .systemBackground

        return view
    }()
    
    
    override init(style: UITableViewCell.CellStyle, reuseIdentifier: String?) {
        super.init(style: style, reuseIdentifier: reuseIdentifier)
        
        self.addSubview(bubbleBackgroundView)
        bubbleBackgroundView.topAnchor.constraint(equalTo: self.topAnchor, constant: 16).isActive = true
        bubbleBackgroundView.bottomAnchor.constraint(equalTo: self.bottomAnchor, constant: -16).isActive = true
        bubbleBackgroundView.widthAnchor.constraint(lessThanOrEqualToConstant: 250).isActive = true
        
        bubbleBackgroundView.addSubview(sourceLabel)
        sourceLabel.topAnchor.constraint(equalTo: bubbleBackgroundView.topAnchor, constant: 8).isActive = true
        sourceLabel.leadingAnchor.constraint(equalTo: bubbleBackgroundView.leadingAnchor, constant: 8).isActive = true
        sourceLabel.trailingAnchor.constraint(equalTo: bubbleBackgroundView.trailingAnchor, constant: -8).isActive = true
        sourceLabel.bottomAnchor.constraint(equalTo: bubbleBackgroundView.centerYAnchor).isActive = true
        
        bubbleBackgroundView.addSubview(targetLabel)
        targetLabel.topAnchor.constraint(equalTo: bubbleBackgroundView.centerYAnchor).isActive = true
        targetLabel.leadingAnchor.constraint(equalTo: sourceLabel.leadingAnchor).isActive = true
        targetLabel.trailingAnchor.constraint(equalTo: sourceLabel.trailingAnchor).isActive = true
        targetLabel.bottomAnchor.constraint(equalTo: bubbleBackgroundView.bottomAnchor, constant: -8).isActive = true
        
        leadingConstraint = bubbleBackgroundView.leadingAnchor.constraint(equalTo: self.leadingAnchor, constant: 16)
        trailingConstraint = bubbleBackgroundView.trailingAnchor.constraint(equalTo: self.trailingAnchor, constant: -16)
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
}
