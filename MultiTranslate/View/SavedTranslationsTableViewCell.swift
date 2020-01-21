//
//  SavedTranslationsTableViewCell.swift
//  MultiTranslate
//
//  Created by Keishin CHOU on 2020/01/21.
//  Copyright © 2020 Keishin CHOU. All rights reserved.
//

import Foundation

class SavedTranslationsTableViewCell: UITableViewCell {
    
    var savedTranslation: SavedTranslation? {
        didSet {
            sourceTextLabel.text = savedTranslation?.sourceText
            sourceLanguageLabel.text = savedTranslation?.sourceLanguage
            targetTextLabel.text = savedTranslation?.targetText
            targetLanguageLabel.text = savedTranslation?.targetLanguage
        }
    }
    
    private let container: UIView = {
        let view = UIView()
        view.translatesAutoresizingMaskIntoConstraints = false
        view.backgroundColor = UIColor.init(white: 0.9, alpha: 0.8)
        view.layer.cornerRadius = 8
        
        return view
    }()
    
    let sourceView: UIView = {
        let view = UIView()
        view.translatesAutoresizingMaskIntoConstraints = false
        view.backgroundColor = UIColor(red: 250/250, green: 227/250, blue: 217/250, alpha: 0.98)
        view.layer.cornerRadius = 21
        view.layer.maskedCorners = [.layerMinXMinYCorner, .layerMaxXMinYCorner, .layerMaxXMaxYCorner]
        view.layer.masksToBounds = true
        
        return view
    }()
    
    let languageView: UIView = {
        let view = UIView()
        view.translatesAutoresizingMaskIntoConstraints = false
        
        return view
    }()
    
    let targetView: UIView = {
        let view = UIView()
        view.translatesAutoresizingMaskIntoConstraints = false
        view.backgroundColor = UIColor(red: 187/250, green: 222/250, blue: 214/250, alpha: 1.0)
        view.layer.cornerRadius = 21
        view.layer.maskedCorners = [.layerMinXMinYCorner, .layerMinXMaxYCorner, .layerMaxXMaxYCorner]
        view.layer.masksToBounds = true
        
        return view
    }()
    
    let sourceTextLabel: UILabel = {
        let label = UILabel()
        label.translatesAutoresizingMaskIntoConstraints = false
        label.numberOfLines = 0
        label.textAlignment = .left
        label.sizeToFit()
        
        return label
    }()
    
    let targetTextLabel: UILabel = {
        let label = UILabel()
        label.translatesAutoresizingMaskIntoConstraints = false
        label.numberOfLines = 0
        label.textAlignment = .right
        label.sizeToFit()
        
        return label
    }()
    
    let sourceLanguageLabel: UILabel = {
        let label = UILabel()
        label.translatesAutoresizingMaskIntoConstraints = false
        label.numberOfLines = 0
        label.textAlignment = .left
        label.sizeToFit()
        label.text = "Chinese"
        
        return label
    }()
    
    let arrowView: UIImageView = {
        let view = UIImageView()
        view.translatesAutoresizingMaskIntoConstraints = false
        view.image = UIImage(systemName: "arrow.right.circle")
        view.tintColor = .systemGray
        view.contentMode = .scaleAspectFit
        
        return view
    }()
    
    let targetLanguageLabel: UILabel = {
        let label = UILabel()
        label.translatesAutoresizingMaskIntoConstraints = false
        label.numberOfLines = 0
        label.textAlignment = .right
        label.sizeToFit()
        label.text = "Japanese"
        
        return label
    }()
    
    
    override init(style: UITableViewCell.CellStyle, reuseIdentifier: String?) {
        super.init(style: style, reuseIdentifier: reuseIdentifier)
        
        self.addSubview(container)
        container.topAnchor.constraint(equalTo: self.topAnchor, constant: 16).isActive = true
        container.bottomAnchor.constraint(equalTo: self.bottomAnchor, constant: -16).isActive = true
        container.leadingAnchor.constraint(equalTo: self.leadingAnchor, constant: 16).isActive = true
        container.trailingAnchor.constraint(equalTo: self.trailingAnchor, constant: -16).isActive = true
        
        container.VStack(sourceView,
                         languageView.setHeight(30),
                         targetView,
                         spacing: 0,
                         alignment: .fill,
                         distribution: .fill).padding([.allMargins], amount: 8)
        
        sourceView.heightAnchor.constraint(greaterThanOrEqualToConstant: 30).isActive = true
        targetView.heightAnchor.constraint(equalTo: sourceView.heightAnchor).isActive = true
        
        sourceView.addSubview(sourceTextLabel)
        sourceTextLabel.topAnchor.constraint(equalTo: sourceView.topAnchor,constant: 12).isActive = true
        sourceTextLabel.bottomAnchor.constraint(equalTo: sourceView.bottomAnchor, constant: -12).isActive = true
        sourceTextLabel.leadingAnchor.constraint(equalTo: sourceView.leadingAnchor, constant: 12).isActive = true
        sourceTextLabel.trailingAnchor.constraint(equalTo: sourceView.trailingAnchor, constant: -12).isActive = true
        
        targetView.addSubview(targetTextLabel)
        targetTextLabel.topAnchor.constraint(equalTo: targetView.topAnchor,constant: 12).isActive = true
        targetTextLabel.bottomAnchor.constraint(equalTo: targetView.bottomAnchor, constant: -12).isActive = true
        targetTextLabel.leadingAnchor.constraint(equalTo: targetView.leadingAnchor, constant: 12).isActive = true
        targetTextLabel.trailingAnchor.constraint(equalTo: targetView.trailingAnchor, constant: -12).isActive = true
        
        languageView.hstack(sourceLanguageLabel,
                            arrowView.setFrame(CGSize(width: 30, height: 30)),
                            targetLanguageLabel,
                            spacing: 0,
                            alignment: .fill,
                            distribution: .fill)
        
        sourceLanguageLabel.widthAnchor.constraint(equalTo: targetLanguageLabel.widthAnchor).isActive = true
        
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
}
