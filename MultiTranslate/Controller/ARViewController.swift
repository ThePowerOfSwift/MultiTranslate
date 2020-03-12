//
//  ARViewController.swift
//  MultiTranslate
//
//  Created by Keishin CHOU on 2020/03/04.
//  Copyright © 2020 Keishin CHOU. All rights reserved.
//

import ARKit
import SceneKit
import UIKit

import SPAlert
import Vision

class ARViewController: UIViewController, ARSCNViewDelegate {

    private let container: UIView = {
        let view = UIView()
        view.translatesAutoresizingMaskIntoConstraints = false
        return view
    }()
    
    private let sceneView: ARSCNView = {
        let view = ARSCNView()
        view.translatesAutoresizingMaskIntoConstraints = false
        return view
    }()
    
    private let debugTextView: UITextView = {
        let view = UITextView()
        view.translatesAutoresizingMaskIntoConstraints = false
        view.text = "Detecting object..."
        view.isEditable = false
        return view
    }()
    
    private let crossImageView: UIImageView = {
        let view = UIImageView()
        view.translatesAutoresizingMaskIntoConstraints = false
        view.image = UIImage(systemName: "plus.circle")
        view.tintColor = UIColor(white: 0.95, alpha: 0.5)
        return view
    }()
    
    private let dismissButton: UIButton = {
        let button = UIButton()
        let config = UIImage.SymbolConfiguration(pointSize: 20, weight: .regular, scale: .large)
        button.translatesAutoresizingMaskIntoConstraints = false
        button.setImage(UIImage(systemName: "xmark.circle.fill", withConfiguration: config), for: .normal)
        button.tintColor = UIColor(white: 0.95, alpha: 0.5)
        button.contentMode = .scaleAspectFill
        return button
    }()
    
    private let clearButton: UIButton = {
        let button = UIButton()
        let config = UIImage.SymbolConfiguration(pointSize: 20, weight: .regular, scale: .large)
        button.translatesAutoresizingMaskIntoConstraints = false
        button.setImage(UIImage(systemName: "arrow.2.circlepath.circle.fill", withConfiguration: config), for: .normal)
        button.tintColor = UIColor(white: 0.95, alpha: 0.5)
        return button
    }()
    
    private let bubbleDepth: Float = 0.01 // the 'depth' of 3D text
    private var latestPrediction: String = "…" // a variable containing the latest CoreML prediction
    
    // COREML
    private var visionRequests = [VNRequest]()
    private let dispatchQueueML = DispatchQueue(label: "MLDispatchQueue") // A Serial Queue
    private var nodeArray = [SCNNode]()
    
    var targetLanguage = String()
    private var targetLanguageCode = String()
    private var translatedCharactersCurrentMonth = 0
    private var cloudDBTranslatedCharacters = 0
    
    override func loadView() {
        super.loadView()
        
        view.addSubview(container)
        container.edgeTo(view, safeArea: .vertical)
        
        container.addSubview(sceneView)
        sceneView.edgeTo(container)
        
        container.addSubview(debugTextView)
        debugTextView.topAnchor.constraint(equalTo: container.topAnchor).isActive = true
        debugTextView.leadingAnchor.constraint(equalTo: container.leadingAnchor).isActive = true
        debugTextView.trailingAnchor.constraint(equalTo: container.trailingAnchor).isActive = true
        debugTextView.heightAnchor.constraint(equalToConstant: 45).isActive = true
        
        container.addSubview(crossImageView)
        crossImageView.centerInSuperview()
        crossImageView.heightAnchor.constraint(equalToConstant: 30).isActive = true
        crossImageView.widthAnchor.constraint(equalToConstant: 30).isActive = true
        
        container.addSubview(dismissButton)
        dismissButton.topAnchor.constraint(equalTo: debugTextView.bottomAnchor, constant: 16).isActive = true
        dismissButton.trailingAnchor.constraint(equalTo: container.trailingAnchor, constant: -16).isActive = true
        dismissButton.heightAnchor.constraint(equalToConstant: 36).isActive = true
        dismissButton.widthAnchor.constraint(equalTo: dismissButton.heightAnchor).isActive = true
        
        container.addSubview(clearButton)
        clearButton.topAnchor.constraint(equalTo: dismissButton.topAnchor).isActive = true
        clearButton.trailingAnchor.constraint(equalTo: dismissButton.leadingAnchor, constant: -16).isActive = true
        clearButton.heightAnchor.constraint(equalToConstant: 36).isActive = true
        clearButton.widthAnchor.constraint(equalTo: clearButton.heightAnchor).isActive = true
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        setUpCloudKit()
        
        // Set the view's delegate
        sceneView.delegate = self
        
        // Show statistics such as fps and timing information
        sceneView.showsStatistics = true
        
        // Create a new scene
        let scene = SCNScene()
        
        // Set the scene to the view
        sceneView.scene = scene
        
        // Enable Default Lighting - makes the 3D text a bit poppier.
        sceneView.autoenablesDefaultLighting = true
        
        // Tap Gesture Recognizer
        let tapGesture = UITapGestureRecognizer(target: self, action: #selector(handleTap(gestureRecognize:)))
        view.addGestureRecognizer(tapGesture)
                
        // Set up Vision Model
        guard let selectedModel = try? VNCoreMLModel(for: Inceptionv3().model) else {
            fatalError("Could not load model. Ensure model has been drag and dropped (copied) to XCode Project from https://developer.apple.com/machine-learning/ . Also ensure the model is part of a target (see: https://stackoverflow.com/questions/45884085/model-is-not-part-of-any-target-add-the-model-to-a-target-to-enable-generation ")
        }
        
        // Set up Vision-CoreML Request
        setUpVisionCoreMLRequest(with: selectedModel)
        
        // Begin Loop to Update CoreML
        loopCoreMLUpdate()
        
        dismissButton.addTarget(self, action: #selector(dismissViewController), for: .touchUpInside)
        clearButton.addTarget(self, action: #selector(clearRecord), for: .touchUpInside)
        
        translatedCharactersCurrentMonth = UserDefaults.standard.integer(forKey: Constants.translatedCharactersCountKey)
        
        if let index = SupportedLanguages.gcpLanguageList.firstIndex(of: targetLanguage) {
            targetLanguageCode = SupportedLanguages.gcpLanguageCode[index]
        }
        
        print("targetLanguage is \(targetLanguage)")
        print("targetLanguageCode is \(targetLanguageCode)")
    }
    
    func setUpCloudKit() {
        CloudKitManager.isCountRecordEmpty { [weak self] (isEmpty) in
            if isEmpty {
                CloudKitManager.initializeCloudDatabase()
            } else {
                CloudKitManager.queryCloudDatabaseCountData { (result, error) in
                    if let result = result {
                        self?.cloudDBTranslatedCharacters = result
                        print("cloudDBTranslatedCharacters is \(result)")
                    } else {
                        print("queryCloudDatabaseCountData error \(error!.localizedDescription)")
                    }
                }
            }
        }
    }
    
    func setUpVisionCoreMLRequest(with mlModel: VNCoreMLModel) {
        let classificationRequest = VNCoreMLRequest(model: mlModel) { [weak self] (request, error) in
            // Catch Errors
            if error != nil {
                print("Error: " + (error?.localizedDescription)!)
                return
            }
            guard let observations = request.results else {
                print("No results")
                return
            }
            
            // Get Classifications
            let classifications = observations[0...1] // top 2 results
                .compactMap({ $0 as? VNClassificationObservation })
                .map({ "\($0.identifier) \(String(format: "- %.2f", $0.confidence))" })
                .joined(separator: "\n")
            
            
            DispatchQueue.main.async {
            // Print Classifications
//            print(classifications)
//            print("--")
                
                // Display Debug Text on screen
                var debugText: String = ""
                debugText += classifications
                self?.debugTextView.text = debugText
                
                // Store the latest prediction
                var objectName: String = "…"
                objectName = classifications.components(separatedBy: "-")[0]
                objectName = objectName.components(separatedBy: ",")[0]
                self?.latestPrediction = objectName
            }
        }
        classificationRequest.imageCropAndScaleOption = VNImageCropAndScaleOption.centerCrop
        // Crop from centre of images and scale to appropriate size.
        visionRequests = [classificationRequest]
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        
        // Create a session configuration
        let configuration = ARWorldTrackingConfiguration()
        // Enable plane detection
        configuration.planeDetection = .horizontal
        
        // Run the view's session
        sceneView.session.run(configuration)
    }
    
    override func viewWillDisappear(_ animated: Bool) {
        super.viewWillDisappear(animated)
        
        // Pause the view's session
        sceneView.session.pause()
    }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Release any cached data, images, etc that aren't in use.
    }
    
    @objc func dismissViewController() {
        dismiss(animated: true)
    }
    
    @objc func clearRecord() {
        debugTextView.text = "Restarting AR session..."
        if !nodeArray.isEmpty {
            for node in nodeArray {
                node.removeFromParentNode()
            }
        }
    }

    // MARK: - ARSCNViewDelegate
    
    func renderer(_ renderer: SCNSceneRenderer, updateAtTime time: TimeInterval) {
        DispatchQueue.main.async {
            // Do any desired updates to SceneKit here.
        }
    }
    
    // MARK: - Status Bar: Hide
    override var prefersStatusBarHidden : Bool {
        return true
    }
    
    // MARK: - Interaction
    
    @objc func handleTap(gestureRecognize: UITapGestureRecognizer) {
        guard let raw = UserDefaults.standard.string(forKey: Constants.userTypeKey) else { return }
        let userType = UserType(rawValue: raw)!
        print(userType)
        
        if isTranslatePossible(userType: userType) {
            if targetLanguage == "English" {
                addNodeToScene(using: latestPrediction)
            } else {
                performTranslate()
            }
            translatedCharactersCurrentMonth += latestPrediction.count
            cloudDBTranslatedCharacters += latestPrediction.count
            
            let updatedCount = translatedCharactersCurrentMonth >= cloudDBTranslatedCharacters ? translatedCharactersCurrentMonth : cloudDBTranslatedCharacters
            print("updatedCount is \(updatedCount)")
            
            UserDefaults.standard.set(updatedCount, forKey: Constants.translatedCharactersCountKey)
            
            CloudKitManager.updateCountData(to: updatedCount)
            
        } else {
            print("Here is the limit, pay more money!")
            let alert = PMAlertController(title: "Translate character has reach the limit",
                                          description: "You can change your plan and get more characters",
                                          image: UIImage(named: "reading2"),
                                          style: .alert)
            let cancelAction = PMAlertAction(title: "Not now", style: .cancel)
            let defaultAction = PMAlertAction(title: "See more plans", style: .default) { [weak self] in
                let viewController = AccountViewController()
                let navController = UINavigationController(rootViewController: viewController)
                self?.present(navController, animated: true, completion: nil)
            }
            alert.addAction(cancelAction)
            alert.addAction(defaultAction)
            present(alert, animated: true, completion: nil)
        }
    }
    
    func isTranslatePossible(userType: UserType) -> Bool {
        if userType == .tenKUser && translatedCharactersCurrentMonth <= 10_000 {// the limits should be fetched from Firestore
            print("translate ok")
            return true
        } else if userType == .fiftyKUser && translatedCharactersCurrentMonth <= 50_000 {
            print("translate ok")
            return true
        } else if userType == .noLimitUset {
            print("translate ok")
            return true
        } else if userType == .guestUser && translatedCharactersCurrentMonth <= 10_000 {
            print("translate ok")
            return true
        } else {
            print("here's the limit")
            return false
        }
    }
    
    func performTranslate() {
        if isOfflineTranslateAvailable(from: "english", to: targetLanguage) {
            performFBOfflineTranslate(from: "english", to: targetLanguage, for: latestPrediction)
        } else {
            performGoogleCloudTranslate(from: "en", to: targetLanguageCode, for: latestPrediction)
        }
    }
    
    func isOfflineTranslateAvailable(from sourceLanguage: String, to targetLanguage: String) -> Bool {
        return FBOfflineTranslate.isTranslationPairSupportedByFBOfflineTranslate(from: sourceLanguage, to: targetLanguage) &&
            FBOfflineTranslate.isTranslateLanguageModelDownloaded(for: sourceLanguage) &&
            FBOfflineTranslate.isTranslateLanguageModelDownloaded(for: targetLanguage)
    }
    
    func performFBOfflineTranslate(from sourceLanguage: String, to targetLanguage: String, for textToTranslate: String) {
        guard let fbTranslator = FBOfflineTranslate.generateFBTranslator(from: sourceLanguage, to: targetLanguage) else { return }
        fbTranslator.translate(textToTranslate) { [weak self] (translatedText, error) in
            if let result = translatedText {
                self?.addNodeToScene(using: result)
                print("the FB translation is \(result)")
            } else {
                print(error!.localizedDescription)
                SPAlert.present(title: "Error",
                                message: error?.localizedDescription,
                                image: UIImage(systemName: "exclamationmark.triangle")!)
            }
        }
    }
    
    func performGoogleCloudTranslate(from sourceLanguage: String, to targetLanguage: String, for textToTranslate: String) {
        GoogleCloudTranslate.textTranslate(sourceLanguage: sourceLanguage,
                                           targetLanguage: targetLanguage,
                                           textToTranslate: textToTranslate) { [weak self] (translatedText, error) in
            if let result = translatedText {
                self?.addNodeToScene(using: result)
                print("the GCP translation is \(result)")
            } else {
                print(error!.localizedDescription)
                SPAlert.present(title: "Error",
                                message: error?.localizedDescription,
                                image: UIImage(systemName: "exclamationmark.triangle")!)
            }
        }
    }
    
    func addNodeToScene(using result: String) {
        let screenCentre: CGPoint = CGPoint(x: sceneView.bounds.midX, y: sceneView.bounds.midY)
        
        let arHitTestResults: [ARHitTestResult] = sceneView.hitTest(screenCentre, types: [.featurePoint]) // Alternatively, we could use '.existingPlaneUsingExtent' for more grounded hit-test-points.
        
        if let closestResult = arHitTestResults.first {
            // Get Coordinates of HitTest
            let transform: matrix_float4x4 = closestResult.worldTransform
            let worldCoord: SCNVector3 = SCNVector3Make(transform.columns.3.x, transform.columns.3.y, transform.columns.3.z)
            
            // Create 3D Text
            let node: SCNNode = createNewBubbleParentNode(result)
            sceneView.scene.rootNode.addChildNode(node)
            node.position = worldCoord
            
            nodeArray.append(node)
        }
    }
    
    func createNewBubbleParentNode(_ text : String) -> SCNNode {
        // Warning: Creating 3D Text is susceptible to crashing. To reduce chances of crashing; reduce number of polygons, letters, smoothness, etc.
        
        // TEXT BILLBOARD CONSTRAINT
        let billboardConstraint = SCNBillboardConstraint()
        billboardConstraint.freeAxes = SCNBillboardAxis.Y
        
        // BUBBLE-TEXT
        let bubble = SCNText(string: text, extrusionDepth: CGFloat(bubbleDepth))
//        var font = UIFont(name: "Futura", size: 0.15)
//        font = font?.withTraits(traits: .traitBold)
        bubble.font = UIFont.boldSystemFont(ofSize: 0.15)
        bubble.alignmentMode = CATextLayerAlignmentMode.center.rawValue
        bubble.firstMaterial?.diffuse.contents = UIColor.orange
        bubble.firstMaterial?.specular.contents = UIColor.white
        bubble.firstMaterial?.isDoubleSided = true
        // bubble.flatness // setting this too low can cause crashes.
        bubble.chamferRadius = CGFloat(bubbleDepth)
        
        // BUBBLE NODE
        let (minBound, maxBound) = bubble.boundingBox
        let bubbleNode = SCNNode(geometry: bubble)
        // Centre Node - to Centre-Bottom point
        bubbleNode.pivot = SCNMatrix4MakeTranslation( (maxBound.x - minBound.x)/2, minBound.y, bubbleDepth/2)
        // Reduce default text size
        bubbleNode.scale = SCNVector3Make(0.2, 0.2, 0.2)
        
        // CENTRE POINT NODE
        let sphere = SCNSphere(radius: 0.005)
        sphere.firstMaterial?.diffuse.contents = UIColor.cyan
        let sphereNode = SCNNode(geometry: sphere)
        
        // BUBBLE PARENT NODE
        let bubbleNodeParent = SCNNode()
        bubbleNodeParent.addChildNode(bubbleNode)
        bubbleNodeParent.addChildNode(sphereNode)
        bubbleNodeParent.constraints = [billboardConstraint]
        
        return bubbleNodeParent
    }
    
    // MARK: - CoreML Vision Handling
    
    func loopCoreMLUpdate() {
        // Continuously run CoreML whenever it's ready. (Preventing 'hiccups' in Frame Rate)
        
        dispatchQueueML.async { [weak self] in
            // 1. Run Update.
            self?.updateCoreML()
            
            // 2. Loop this function.
            self?.loopCoreMLUpdate()
        }
    }
    
    func updateCoreML() {
        // Get Camera Image as RGB
        let pixbuff : CVPixelBuffer? = (sceneView.session.currentFrame?.capturedImage)
        if pixbuff == nil { return }
        let ciImage = CIImage(cvPixelBuffer: pixbuff!)
        // Note: Not entirely sure if the ciImage is being interpreted as RGB, but for now it works with the Inception model.
        // Note2: Also uncertain if the pixelBuffer should be rotated before handing off to Vision (VNImageRequestHandler) - regardless, for now, it still works well with the Inception model.
        
        // Prepare CoreML/Vision Request
        let imageRequestHandler = VNImageRequestHandler(ciImage: ciImage, options: [:])
        // let imageRequestHandler = VNImageRequestHandler(cgImage: cgImage!, orientation: myOrientation, options: [:]) // Alternatively; we can convert the above to an RGB CGImage and use that. Also UIInterfaceOrientation can inform orientation values.
        
        // Run Image Request
        do {
            try imageRequestHandler.perform(visionRequests)
        } catch {
            print(error)
        }
        
    }
    
    deinit {
        print("ARViewController deallocated.")
    }
}

extension UIFont {
    // Based on: https://stackoverflow.com/questions/4713236/how-do-i-set-bold-and-italic-on-uilabel-of-iphone-ipad
    func withTraits(traits:UIFontDescriptor.SymbolicTraits...) -> UIFont {
        let descriptor = fontDescriptor.withSymbolicTraits(UIFontDescriptor.SymbolicTraits(traits))
        return UIFont(descriptor: descriptor!, size: 0)
    }
}
