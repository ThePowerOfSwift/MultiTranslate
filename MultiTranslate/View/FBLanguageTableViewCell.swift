//
//  FBLanguageTableViewCell.swift
//  MultiTranslate
//
//  Created by Keishin CHOU on 2020/02/14.
//  Copyright © 2020 Keishin CHOU. All rights reserved.
//

import UIKit

import Firebase
//import KRProgressHUD

class FBLanguageTableViewCell: UITableViewCell {
    
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
    
    let indicator: UIActivityIndicatorView = {
        let view = UIActivityIndicatorView()
        view.translatesAutoresizingMaskIntoConstraints = false
        view.style = .medium
        
        return view
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
        
        detailView.addSubview(indicator)
        indicator.edgeTo(detailView)
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    @objc func downloadFBLanguage() {
//        KRProgressHUD.show()
        
        downloadButton.isHidden = true
        downloadedImageView.isHidden = true
        indicator.isHidden = false
        indicator.startAnimating()

        guard let language = self.languageNameLabel.text,
            let requestModel = FBOfflineTranslate.createTranslateRemoteModel(from: language) else { return }
        
        let condition = ModelDownloadConditions(allowsCellularAccess: false, allowsBackgroundDownloading: true)
        ModelManager.modelManager().download(requestModel, conditions: condition)
        
        fbLanguageModelDownloadDidSuccessObserver(of: requestModel)
        fbLanguageModelDownloadDidFailObserver()
        
    }
    
    func fbLanguageModelDownloadDidSuccessObserver(of requestModel: TranslateRemoteModel) {
        NotificationCenter.default.addObserver(
            forName: .firebaseMLModelDownloadDidSucceed,
            object: nil,
            queue: nil
        ) { [weak self] notification in
            guard let strongSelf = self,
                let userInfo = notification.userInfo,
                let model = userInfo[ModelDownloadUserInfoKey.remoteModel.rawValue]
                    as? TranslateRemoteModel,
                model == requestModel
                else { return }
            // The model was downloaded and is available on the device
            strongSelf.indicator.stopAnimating()
            strongSelf.indicator.isHidden = true
            strongSelf.downloadButton.isHidden = true
            strongSelf.downloadedImageView.isHidden = false
            
            FBOfflineTranslate.initializeFBTranslation()
            
            NotificationCenter.default.post(name: .fbDownloadedLanguagesDidUpdate, object: nil)
            
//            KRProgressHUD.dismiss()
            print("download completed.")
        }
    }
    
    func fbLanguageModelDownloadDidFailObserver() {
        NotificationCenter.default.addObserver(
            forName: .firebaseMLModelDownloadDidFail,
            object: nil,
            queue: nil
        ) { [weak self] notification in
            guard let strongSelf = self,
                let userInfo = notification.userInfo,
                let model = userInfo[ModelDownloadUserInfoKey.remoteModel.rawValue]
                    as? TranslateRemoteModel
                else { return }
            let error = userInfo[ModelDownloadUserInfoKey.error.rawValue]
            print("download error is occured: \(error.debugDescription)")
            strongSelf.indicator.stopAnimating()
            strongSelf.indicator.isHidden = true
            strongSelf.downloadButton.isHidden = false
            strongSelf.downloadedImageView.isHidden = true
        }
    }
}
