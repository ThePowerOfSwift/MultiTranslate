//
//  CameraTranslateViewController.swift
//  MultiTranslate
//
//  Created by Keishin CHOU on 2020/01/06.
//  Copyright © 2020 Keishin CHOU. All rights reserved.
//

import UIKit
import Vision

import LBTATools
import PMSuperButton
import CropViewController
import KRProgressHUD


class CameraTranslateViewController: UIViewController {
    
    var detectedResultString = ""
    
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
    
    let imagePicker: UIImagePickerController = {
        let imagePicker = UIImagePickerController()
        imagePicker.allowsEditing = true
        imagePicker.sourceType = .camera
        
        return imagePicker
    }()
    
    lazy private var textDetectionRequest: VNRecognizeTextRequest = {
        let request = VNRecognizeTextRequest(completionHandler: self.handleDetectedText)
        request.recognitionLevel = .accurate
        request.recognitionLanguages = ["en_US"]
        request.usesLanguageCorrection = true
        return request
    }()
    
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
        imagePicker.delegate = self
        
    }
    
    @objc func useCamera() {
        print("Use camera tapped.")
        
        if UIImagePickerController.isSourceTypeAvailable(UIImagePickerController.SourceType.camera) {
            present(imagePicker, animated: true, completion: nil)
        } else {
            print("Camera is not available.")
        }
        
    }
    
    func handleDetectedText(request: VNRequest?, error: Error?) {
        if error == nil {
            guard let observations = request?.results as? [VNRecognizedTextObservation] else { return }
            for observation in observations {
                let bestObservation = observation.topCandidates(1).first
                print(bestObservation?.string ?? "")
                print(bestObservation?.confidence ?? 0)
                guard let string = bestObservation?.string else { return }

//                print(bestObservation?.boundingBox(for: Range<String.Index>))
                detectedResultString += (string + " ")
            }
            
//            let newViewController = ResultTableViewController()
//            newViewController.observations = observations
//            newViewController.modalPresentationStyle = .fullScreen
//            self.navigationController?.pushViewController(newViewController, animated: true)
            
        }
    }

}

extension CameraTranslateViewController: UIImagePickerControllerDelegate, UINavigationControllerDelegate, CropViewControllerDelegate {
    func imagePickerController(_ picker: UIImagePickerController, didFinishPickingMediaWithInfo info: [UIImagePickerController.InfoKey : Any]) {

        dismiss(animated: true) {
            guard let image = info[.editedImage] as? UIImage else { return }

            let cropViewController = CropViewController(image: image)
            cropViewController.delegate = self
            self.present(cropViewController, animated: true, completion: nil)
        }
    }
    
    func cropViewController(_ cropViewController: CropViewController, didCropToImage image: UIImage, withRect cropRect: CGRect, angle: Int) {
        
        KRProgressHUD.show()
        
        guard let cgImage = image.cgImage else { return }
        let requests = [textDetectionRequest]
        let imageRequestHandler = VNImageRequestHandler(cgImage: cgImage, options: [:])
//        DispatchQueue.global(qos: .userInitiated).async {
        
        do {
            try imageRequestHandler.perform(requests)
        } catch {
            print("Process image error: \(error.localizedDescription)")
        }
        
//        }
        
//        DispatchQueue.global(qos: .default).async(execute: { // time-consuming task
        DispatchQueue.main.asyncAfter(deadline: .now()+1) {
            KRProgressHUD.dismiss()
        }
        
        dismiss(animated: true) {
            let viewController = TextTranslateViewController()
            viewController.sourceInputText.text = self.detectedResultString
            self.present(viewController, animated: true, completion: nil)
            
        }
    }
    
}
