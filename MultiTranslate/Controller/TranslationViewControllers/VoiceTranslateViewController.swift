//
//  VoiceTranslateViewController.swift
//  MultiTranslate
//
//  Created by Keishin CHOU on 2020/01/06.
//  Copyright © 2020 Keishin CHOU. All rights reserved.
//

import UIKit

import PMSuperButton

class VoiceTranslateViewController: UIViewController {

    let container = UIView()
    
//    let microphoneImageContainer = UIView(backgroundColor: .cyan)
    let microphoneImageContainer: PMSuperButton = {
        let button = PMSuperButton()
        button.gradientEnabled = true
        button.gradientStartColor = #colorLiteral(red: 0.9568627477, green: 0.6588235497, blue: 0.5450980663, alpha: 1)
        button.gradientEndColor = #colorLiteral(red: 0.9098039269, green: 0.4784313738, blue: 0.6431372762, alpha: 1)
        button.gradientHorizontal = true
        button.ripple = true
        button.rippleColor = #colorLiteral(red: 0.9880490899, green: 0.7656863332, blue: 0.9337566495, alpha: 0.5442262414)
        
        return button
    }()
    
    let microphoneImage = UIImageView(image: UIImage(named: "color_microphone"), contentMode: .scaleAspectFit)
    let microphoneLabel = UILabel(text: "Use microphone", font: .systemFont(ofSize: 50, weight: .thin), textAlignment: .center, numberOfLines: 1)
    
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
        
        buttonView.VStack(microphoneImageContainer.setWidth(150).setHeight(150),
                          microphoneLabel,
                          spacing: 8,
                          alignment: .center,
                          distribution: .fillProportionally).padTop(50)
        
        microphoneImageContainer.layer.cornerRadius = 75

        microphoneImageContainer.addSubview(microphoneImage)
        microphoneImage.translatesAutoresizingMaskIntoConstraints = false
        microphoneImage.centerXAnchor.constraint(equalTo: microphoneImageContainer.centerXAnchor).isActive = true
        microphoneImage.centerYAnchor.constraint(equalTo: microphoneImageContainer.centerYAnchor).isActive = true
        microphoneImage.setWidth(100)
        microphoneImage.setHeight(100)
    }

    override func viewDidLoad() {
        super.viewDidLoad()

        microphoneImageContainer.addTarget(self, action: #selector(useMicrophone), for: .touchUpInside)
            
    }
        
    @objc func useMicrophone() {
        print("Use microphone tapped.")
        let viewController = VoiceRecorderViewController()
        viewController.modalPresentationStyle = .automatic
        present(viewController, animated: true, completion: nil)
    }

    

    /*
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        // Get the new view controller using segue.destination.
        // Pass the selected object to the new view controller.
    }
    */

}
