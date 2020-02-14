//
//  FBLanguageTableViewCell.swift
//  MultiTranslate
//
//  Created by Keishin CHOU on 2020/02/14.
//  Copyright © 2020 Keishin CHOU. All rights reserved.
//

import UIKit

class FBLanguageTableViewCell: UITableViewCell {
    
    var isDownloaded: Bool = false

    private let container: UIView = {
        let view = UIView()
        view.translatesAutoresizingMaskIntoConstraints = false
        
        return view
    }()
    
    private let titleView: UIView = {
        let view = UIView()
        view.translatesAutoresizingMaskIntoConstraints = false
        
        return view
    }()
    
    let detailView: UIView = {
        let view = UIView()
        view.translatesAutoresizingMaskIntoConstraints = false
        
        return view
    }()
    
    let downloadedImageView: UIImageView = {
        let imageView = UIImageView()
        imageView.translatesAutoresizingMaskIntoConstraints = false
        imageView.image = UIImage(systemName: "checkmark.seal.fill")
        imageView.tintColor = .systemOrange
        imageView.contentMode = .scaleAspectFit
        
        return imageView
    }()
    
    let downloadButton: UIButton = {
        let button = UIButton()
        button.translatesAutoresizingMaskIntoConstraints = false
        button.setImage(UIImage(systemName: "tray.and.arrow.down"), for: .normal)
        
        return button
    }()
    
    let languageNameLabel: UILabel = {
        let label = UILabel()
        label.translatesAutoresizingMaskIntoConstraints = false
        label.textAlignment = .left
        
        return label
    }()
    
    override init(style: UITableViewCell.CellStyle, reuseIdentifier: String?) {
        super.init(style: style, reuseIdentifier: reuseIdentifier)
        
        self.addSubview(container)
        container.topAnchor.constraint(equalTo: self.topAnchor, constant: 16).isActive = true
        container.bottomAnchor.constraint(equalTo: self.bottomAnchor, constant: -16).isActive = true
        container.leadingAnchor.constraint(equalTo: self.leadingAnchor, constant: 16).isActive = true
        container.trailingAnchor.constraint(equalTo: self.trailingAnchor, constant: -16).isActive = true
        
        container.HStack(titleView,
                         detailView.setWidth(35),
                         spacing: 0,
                         alignment: .fill,
                         distribution: .fill)
        
        titleView.addSubview(languageNameLabel)
        languageNameLabel.edgeTo(languageNameLabel)
        
        detailView.addSubview(downloadedImageView)
        downloadedImageView.edgeTo(detailView)

        detailView.addSubview(downloadButton)
        downloadButton.edgeTo(detailView)
        
        downloadButton.addTarget(self, action: #selector(downloadFBLanguage), for: .touchUpInside)
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    @objc func downloadFBLanguage() {
        if let text = self.languageNameLabel.text {
            print("\(text) is tapped.")
        }
    }
}
