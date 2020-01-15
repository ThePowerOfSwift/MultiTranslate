//
//  PDFTranslateViewController.swift
//  MultiTranslate
//
//  Created by Keishin CHOU on 2020/01/06.
//  Copyright © 2020 Keishin CHOU. All rights reserved.
//

import UIKit
import Vision

import KRProgressHUD
import PMSuperButton
import WeScan

class PDFTranslateViewController: UIViewController {
    
    var sourceText: String = ""
    var detectedResultString: String = ""
    
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

        // Do any additional setup after loading the view.
        print("PDFTranslateViewController here.")
        
        cameraImageContainer.addTarget(self, action: #selector(scanDocument), for: .touchUpInside)

    }
    

    @objc func scanDocument() {
        let scannerViewController = ImageScannerController(image: nil, delegate: self)
        scannerViewController.modalPresentationStyle = .fullScreen
        present(scannerViewController, animated: true)
    }
    
    func handleDetectedText(request: VNRequest?, error: Error?) {
        if error == nil {
            guard let observations = request?.results as? [VNRecognizedTextObservation] else {
                print("Detecting error.")
                return
            }
            
            if observations.count == 0 {
                print("Cannot detect text in the image.")
                detectedResultString = ""
            } else {
                for observation in observations {
                    let bestObservation = observation.topCandidates(1).first
                    print(bestObservation?.string ?? "No text")
                    print(bestObservation?.confidence ?? 0)
                    guard let string = bestObservation?.string else { return }
                    detectedResultString += (string + " ")
                }
            }
            
        } else {
            print(error!.localizedDescription)
        }
    }

}

extension PDFTranslateViewController: UINavigationControllerDelegate, ImageScannerControllerDelegate {
    
    func imageScannerController(_ scanner: ImageScannerController, didFinishScanningWithResults results: ImageScannerResults) {

        KRProgressHUD.show()
        
        let resultImage: UIImage?
        if results.doesUserPreferEnhancedImage == true {
            resultImage = results.enhancedImage
        } else {
            resultImage = results.scannedImage
        }
        
        guard let cgImage = resultImage?.cgImage else { return }
        let requests = [textDetectionRequest]
        let imageRequestHandler = VNImageRequestHandler(cgImage: cgImage, options: [:])
        
        do {
            try imageRequestHandler.perform(requests)
        } catch {
            print("Process image error: \(error.localizedDescription)")
        }
        
        dismiss(animated: true) {
            if self.detectedResultString.isEmpty {
                KRProgressHUD.dismiss()

                print("Result is empty.") // UIAlertViewController
            } else {
                KRProgressHUD.dismiss()
                
                let viewController = TextTranslateViewController()
                viewController.sourceInputText.text = self.detectedResultString
                self.present(viewController, animated: true, completion: nil)
                self.detectedResultString = ""
            }
        }
    }

    func imageScannerControllerDidCancel(_ scanner: ImageScannerController) {
        scanner.dismiss(animated: true, completion: nil)
    }

    func imageScannerController(_ scanner: ImageScannerController, didFailWithError error: Error) {
        print(error.localizedDescription)
        scanner.dismiss(animated: true, completion: nil)
    }
}

