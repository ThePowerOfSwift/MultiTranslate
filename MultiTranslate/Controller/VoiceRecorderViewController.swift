//
//  VoiceRecorderViewController.swift
//  MultiTranslate
//
//  Created by Keishin CHOU on 2020/01/11.
//  Copyright © 2020 Keishin CHOU. All rights reserved.
//

import UIKit

class VoiceRecorderViewController: UIViewController {
    
    // MARK: - Variables and constants
    
    private var isRecording: Bool = false
    
    private lazy var container: UIView = {
        let view = UIView()
        view.translatesAutoresizingMaskIntoConstraints = false
        view.backgroundColor = .black
        return view
    }()
    
    private lazy var waveformView: SCSiriWaveformView = {
        let view = SCSiriWaveformView()
        view.waveColor = .red
        view.primaryWaveLineWidth = 3.0
        view.secondaryWaveLineWidth = 1.0
        view.translatesAutoresizingMaskIntoConstraints = false

        return view
    }()
    
    private lazy var recorderButtonContainer: UIView = {
        let view = UIView()
        view.translatesAutoresizingMaskIntoConstraints = false
        view.layer.cornerRadius = 10
        view.layer.maskedCorners = [.layerMinXMinYCorner, .layerMaxXMinYCorner]
        view.layer.masksToBounds = true
        
        return view
    }()
    
    private lazy var recorderButtonBackground: UIImageView = {
        let view = UIImageView()
        view.image = UIImage(named: "RecorderBackground")
        view.contentMode = .scaleToFill
        view.translatesAutoresizingMaskIntoConstraints = false
        
        return view
    }()
    
    private lazy var recorderButton: UIButton = {
        let button = UIButton()
        button.backgroundColor = .red
        button.heightAnchor.constraint(equalToConstant: 50).isActive = true
        button.widthAnchor.constraint(equalToConstant: 50).isActive = true
        button.layer.cornerRadius = 25
        button.layer.masksToBounds = true
        
//        button.layer.borderColor = UIColor.white.cgColor
//        button.layer.borderWidth = 2
        button.translatesAutoresizingMaskIntoConstraints = false
        
        return button
    }()
    
    private lazy var recorderButtonBorder: UIView = {
        let view = UIView()
        view.translatesAutoresizingMaskIntoConstraints = false
        view.backgroundColor = .black
        view.layer.borderWidth = 2
        view.layer.borderColor = UIColor.white.cgColor
        view.heightAnchor.constraint(equalToConstant: 60).isActive = true
        view.widthAnchor.constraint(equalToConstant: 60).isActive = true
        view.layer.cornerRadius = 30
        
        return view
    }()
    
    override func loadView() {
        super.loadView()
        
        view.addSubview(container)
//        container.frame = view.safeAreaLayoutGuide.layoutFrame
        container.topAnchor.constraint(equalTo: view.safeAreaLayoutGuide.topAnchor).isActive = true
        container.bottomAnchor.constraint(equalTo: view.safeAreaLayoutGuide.bottomAnchor).isActive = true
        container.leadingAnchor.constraint(equalTo: view.safeAreaLayoutGuide.leadingAnchor).isActive = true
        container.trailingAnchor.constraint(equalTo: view.safeAreaLayoutGuide.trailingAnchor).isActive = true
        
        
        container.addSubview(recorderButtonContainer)
        recorderButtonContainer.leadingAnchor.constraint(equalTo: container.leadingAnchor).isActive = true
        recorderButtonContainer.trailingAnchor.constraint(equalTo: container.trailingAnchor).isActive = true
        recorderButtonContainer.bottomAnchor.constraint(equalTo: container.bottomAnchor).isActive = true
        recorderButtonContainer.heightAnchor.constraint(equalToConstant: 100).isActive = true
        
        recorderButtonContainer.addSubview(recorderButtonBackground)
        recorderButtonBackground.frame = recorderButtonContainer.frame
        
        recorderButtonContainer.addSubview(recorderButtonBorder)
        recorderButtonBorder.centerXAnchor.constraint(equalTo: recorderButtonContainer.centerXAnchor).isActive = true
        recorderButtonBorder.centerYAnchor.constraint(equalTo: recorderButtonContainer.centerYAnchor).isActive = true
        
        recorderButtonContainer.addSubview(recorderButton)
        recorderButton.centerXAnchor.constraint(equalTo: recorderButtonContainer.centerXAnchor).isActive = true
        recorderButton.centerYAnchor.constraint(equalTo: recorderButtonContainer.centerYAnchor).isActive = true
        
        container.addSubview(waveformView)
        waveformView.topAnchor.constraint(equalTo: container.topAnchor).isActive = true
        waveformView.leadingAnchor.constraint(equalTo: container.leadingAnchor).isActive = true
        waveformView.trailingAnchor.constraint(equalTo: container.trailingAnchor).isActive = true
        waveformView.bottomAnchor.constraint(equalTo: recorderButtonContainer.topAnchor).isActive = true
    }

    override func viewDidLoad() {
        super.viewDidLoad()
        
        recorderButton.addTarget(self, action: #selector(recordButtonTapped), for: .touchUpInside)

    }

    @objc func recordButtonTapped() {
        if isRecording {
            UIView.animate(withDuration: 0.2) {
                self.recorderButton.transform = CGAffineTransform(scaleX: 1.0, y: 1.0)
                self.recorderButton.layer.cornerRadius = 25
            }
        } else {
            UIView.animate(withDuration: 0.2) {
                self.recorderButton.transform = CGAffineTransform(scaleX: 0.7, y: 0.7)
                self.recorderButton.layer.cornerRadius = 3.0
            }
        }
        isRecording = !isRecording
    }


}
