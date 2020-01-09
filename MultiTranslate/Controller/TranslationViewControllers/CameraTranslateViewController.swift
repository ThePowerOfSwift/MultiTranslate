//
//  CameraTranslateViewController.swift
//  MultiTranslate
//
//  Created by Keishin CHOU on 2020/01/06.
//  Copyright © 2020 Keishin CHOU. All rights reserved.
//

import UIKit

import LBTATools
import PMSuperButton


class CameraTranslateViewController: UIViewController {
    
    let container = UIView()

    let cameraImageContainer: PMSuperButton = {
        let button = PMSuperButton()
        button.gradientEnabled = true
        button.gradientStartColor = #colorLiteral(red: 0.4745098054, green: 0.8392156959, blue: 0.9764705896, alpha: 1)
        button.gradientEndColor = #colorLiteral(red: 0.2196078449, green: 0.007843137719, blue: 0.8549019694, alpha: 1)
        button.gradientHorizontal = true
        button.ripple = true
        button.rippleColor = #colorLiteral(red: 0.9880490899, green: 0.7656863332, blue: 0.9337566495, alpha: 0.5442262414)
        
        return button
    }()
    
    let cameraImage = UIImageView(image: UIImage(named: "color_camera"), contentMode: .scaleAspectFit)
    let cameraLabel = UILabel(text: "Use camera", font: .systemFont(ofSize: 50, weight: .thin), textAlignment: .center, numberOfLines: 1)
    
    let paddingView1 = UIView(backgroundColor: .gray)
    let paddingView2 = UIView(backgroundColor: .brown)
    let buttonView = UIView(backgroundColor: .orange)
    
    override func loadView() {
        super.loadView()
        
        
        view.addSubview(container)
        container.edgeTo(view, safeArea: .all)
        
        container.VStack(paddingView1,
                         buttonView.setHeight(300),
                         paddingView2,
                         spacing: 10,
                         alignment: .fill,
                         distribution: .fill)
        
        paddingView1.heightAnchor.constraint(equalTo: paddingView2.heightAnchor).isActive = true
        
        buttonView.VStack(cameraImageContainer.setWidth(150).setHeight(150),
                          cameraLabel,
                          spacing: 8,
                          alignment: .center,
                          distribution: .fillProportionally).padTop(50)
        
        cameraImageContainer.layer.cornerRadius = 75

        cameraImageContainer.addSubview(cameraImage)
        cameraImage.translatesAutoresizingMaskIntoConstraints = false
        cameraImage.centerXAnchor.constraint(equalTo: cameraImageContainer.centerXAnchor).isActive = true
        cameraImage.centerYAnchor.constraint(equalTo: cameraImageContainer.centerYAnchor).isActive = true
        cameraImage.setWidth(100)
        cameraImage.setHeight(100)
    }

    override func viewDidLoad() {
        super.viewDidLoad()

        cameraImageContainer.addTarget(self, action: #selector(useCamera), for: .touchUpInside)
        
    }
    
    @objc func useCamera() {
        print("Use camera tapped.")
    }



}
