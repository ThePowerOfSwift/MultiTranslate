//
//  VoiceRecorderViewController.swift
//  MultiTranslate
//
//  Created by Keishin CHOU on 2020/01/11.
//  Copyright © 2020 Keishin CHOU. All rights reserved.
//

import AVFoundation
import Speech
import UIKit

import KRProgressHUD

class VoiceRecorderViewController: UIViewController {
    
    // MARK: - Variables and constants
    private var isRecording: Bool = true
    private var recordingSession: AVAudioSession!
    private var audioRecorder: AVAudioRecorder?
    private var audioFileURL: URL?
    private var extractedText = ""
    
    
    // MARK: - View declarations
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
    
    
    // MARK: - View life circle
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

        recordingSession = AVAudioSession.sharedInstance()

        do {
            try recordingSession.setCategory(.playAndRecord, mode: .default)
            try recordingSession.setActive(true)
            recordingSession.requestRecordPermission() { [unowned self] allowed in
                DispatchQueue.main.async {
                    if allowed {
                        self.loadRecorderButton()
                        self.loadWaveform()
                    } else {
                        print("Failed to record!")
                    }
                }
            }
        } catch {
            print("Failed to record!")
        }
    }

    
    // MARK: - Button function implementations
    @objc func recordButtonTapped() {
        if isRecording {
            finishRecording(success: true)
            UIView.animate(withDuration: 0.2) {
                self.recorderButton.transform = CGAffineTransform(scaleX: 1.0, y: 1.0)
                self.recorderButton.layer.cornerRadius = 25
            }
            KRProgressHUD.show()

        } else {
            startRecording()
            UIView.animate(withDuration: 0.2) {
                self.recorderButton.transform = CGAffineTransform(scaleX: 0.7, y: 0.7)
                self.recorderButton.layer.cornerRadius = 3.0
            }
        }
        isRecording = !isRecording
    }
    
    
    // MARK: - Other function implementations
    func loadRecorderButton() {
        if isRecording {
            startRecording()
            recorderButton.transform = CGAffineTransform(scaleX: 0.7, y: 0.7)
            recorderButton.layer.cornerRadius = 3.0
        } else {
            finishRecording(success: true)
            recorderButton.transform = CGAffineTransform(scaleX: 1.0, y: 1.0)
            recorderButton.layer.cornerRadius = 25
        }
    }
    
    func loadWaveform() {
        let displayLink: CADisplayLink = CADisplayLink(target: self, selector: #selector(updateMeters))
        displayLink.add(to: RunLoop.current, forMode: RunLoop.Mode.common)
    }

    @objc func updateMeters() {
        if let recorder = audioRecorder {
            recorder.updateMeters()
            let normalizedValue: CGFloat = pow(10, CGFloat((recorder.averagePower(forChannel: 0))) / 50)
            waveformView.update(withLevel: normalizedValue)
        }
    }
    
    func startRecording() {
        audioFileURL = getDocumentsDirectory().appendingPathComponent("recording.m4a")
        guard let url = audioFileURL else { return }

        let settings = [
            AVFormatIDKey: Int(kAudioFormatMPEG4AAC),
            AVSampleRateKey: 12000,
            AVNumberOfChannelsKey: 1,
            AVEncoderAudioQualityKey: AVAudioQuality.high.rawValue
            ]

        do {
            audioRecorder = try AVAudioRecorder(url: url, settings: settings)
            audioRecorder?.delegate = self
            audioRecorder?.prepareToRecord()
            audioRecorder?.isMeteringEnabled = true
            audioRecorder?.record()

        } catch {
            finishRecording(success: false)
        }
    }

    func finishRecording(success: Bool) {
        audioRecorder!.stop()
        audioRecorder = nil

        if success {
            print("Recording successed.")
            
            requestTranscribePermissions()
            
        } else {
            print("Recording failed.")
            //Show alert
        }
    }
    
    func requestTranscribePermissions() {
        SFSpeechRecognizer.requestAuthorization { [unowned self] authStatus in
            DispatchQueue.main.async {
                if authStatus == .authorized {
                    print("Good to go!")
                    self.transcribeAudio(url: self.audioFileURL!)
                } else {
                    print("Transcription permission was declined.")
                }
            }
        }
    }
    
    func transcribeAudio(url: URL) {
        let recognizer = SFSpeechRecognizer(locale: Locale(identifier: "ja_JP"))
        let request = SFSpeechURLRecognitionRequest(url: url)

        recognizer?.recognitionTask(with: request) { [unowned self] (result, error) in
            guard let result = result else {
                print("There was an error: \(error!)")
                print("Cannot extract any text from the audio")
                // show alert
                
                KRProgressHUD.dismiss()
                self.dismiss(animated: true, completion: nil)
                // Transcription failed.
                
                return
            }

            if result.isFinal {
                self.extractedText = result.bestTranscription.formattedString
                print(self.extractedText)

                KRProgressHUD.dismiss()
                self.dismiss(animated: true, completion: nil)
            }
        }
    }


    func getDocumentsDirectory() -> URL {
        let paths = FileManager.default.urls(for: .documentDirectory, in: .userDomainMask)
        print(paths[0])
        return paths[0]
    }

}

// MARK: - Extensions
extension VoiceRecorderViewController: AVAudioRecorderDelegate {
    func audioRecorderDidFinishRecording(_ recorder: AVAudioRecorder, successfully flag: Bool) {
        if !flag {
            finishRecording(success: false)
        }
    }
}
