//
//  QRScannerViewController.swift
//  crypto-address-book
//
//  Created by Mario Lin on 1/21/18.
//  Copyright © 2018 Mario Lin. All rights reserved.
//

import UIKit
import AVFoundation

protocol QRScannerDelegate: AnyObject {
    func didCaptureQRCode(_ qrCode: String)
}

class QRScannerViewController: UIViewController {
    // MARK: IBOutlets
    @IBOutlet weak var exitButton: UIButton!
    @IBOutlet weak var scanLabel: UILabel!
    
    // MARK: IBActions
    @IBAction func exitButtonTapped(_ sender: Any) {
        self.dismiss(animated: true, completion: nil)
    }
    
    
    // MARK: Non-IB Properties
    var captureDevice: AVCaptureDevice?
    var captureSession: AVCaptureSession?
    var videoPreviewLayer: AVCaptureVideoPreviewLayer?
    let qrViewFrame = UIView()
    
    weak var delegate: QRScannerDelegate?
    
    let sessionQueue = DispatchQueue(label: "video-session-queue")
    var authorizationStatus: AVAuthorizationStatus!
    
    override var supportedInterfaceOrientations: UIInterfaceOrientationMask { return .portrait }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        scanLabel.textColor = .ethereumPurple
        exitButton.setImage(#imageLiteral(resourceName: "exit").imageWithColor(color: .ethereumPurple), for: .normal)
        setupViewFrame()
        
        // Do any additional setup after loading the view.
        self.authorizationStatus = AVCaptureDevice.authorizationStatus(for: .video)
        switch self.authorizationStatus {
        case .notDetermined:
            sessionQueue.suspend()
            AVCaptureDevice.requestAccess(for: .video) { if $0 { self.sessionQueue.resume() } }
        case .denied, .restricted:
            presentDeniedAlert()
        default:
            break
        }
        setupCapture()
    }
    
    private func setupViewFrame() {
        qrViewFrame.layer.borderColor = UIColor.ethereumPurple.cgColor
        qrViewFrame.layer.borderWidth = 3.5
        view.addSubview(qrViewFrame)
        
        qrViewFrame.translatesAutoresizingMaskIntoConstraints = false
        qrViewFrame.widthAnchor.constraint(equalToConstant: 200).isActive = true
        qrViewFrame.heightAnchor.constraint(equalToConstant: 200).isActive = true
        qrViewFrame.centerXAnchor.constraint(equalTo: view.centerXAnchor).isActive = true
        qrViewFrame.centerYAnchor.constraint(equalTo: view.centerYAnchor).isActive = true
    }
    
    private func setupCapture() {
        guard let device = AVCaptureDevice.default(for: .video) else { return }
        captureDevice = device
        let input: AVCaptureDeviceInput
        do {
            input = try AVCaptureDeviceInput(device: device)
        } catch {
            return
        }
        
        captureSession = AVCaptureSession()
        captureSession?.addInput(input)
        
        let output = AVCaptureMetadataOutput()
        captureSession?.addOutput(output)
        output.setMetadataObjectsDelegate(self, queue: DispatchQueue.main)
        output.metadataObjectTypes = [AVMetadataObject.ObjectType.qr]
        
        videoPreviewLayer = AVCaptureVideoPreviewLayer(session: captureSession!)
        
        guard videoPreviewLayer != nil else { return }
        
        videoPreviewLayer?.frame = view.bounds
        videoPreviewLayer?.videoGravity = .resizeAspectFill
        
        view.layer.addSublayer(videoPreviewLayer!)
        view.bringSubview(toFront: qrViewFrame)
        view.bringSubview(toFront: exitButton)
        view.bringSubview(toFront: scanLabel)

        sessionQueue.async {
            self.captureSession?.startRunning()
        }
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        sessionQueue.async {
            if self.authorizationStatus == .authorized && self.captureSession?.isRunning == false {
                self.captureSession?.startRunning()
            }
        }
    }
    
    override func viewWillDisappear(_ animated: Bool) {
        super.viewWillDisappear(animated)
        sessionQueue.async {
            if self.authorizationStatus == .authorized && self.captureSession?.isRunning == false {
                self.captureSession?.stopRunning()
            }
        }
    }
    
    private func presentDeniedAlert() {
        let alertController = UIAlertController(title: "Camera Permissions Disabled", message: "To allow for QR scanning, you must turn it back on in settings", preferredStyle: .alert)
        let settingsAction = UIAlertAction(title: "Settings", style: .default, handler: { (action) in
            if let settingsUrl = URL(string: UIApplicationOpenSettingsURLString) {
                UIApplication.shared.open(settingsUrl, options: [:], completionHandler: { (complete) in
                    self.dismiss(animated: true, completion: nil)
                })
            } else {
                self.dismiss(animated: true, completion: nil)
                
            }
        })
        let cancelAction = UIAlertAction(title: "Cancel", style: .cancel, handler: nil)
        alertController.addAction(settingsAction)
        alertController.addAction(cancelAction)
        present(alertController, animated: true, completion: nil)
    }
}

extension QRScannerViewController: AVCaptureMetadataOutputObjectsDelegate {
    func metadataOutput(_ output: AVCaptureMetadataOutput, didOutput metadataObjects: [AVMetadataObject], from connection: AVCaptureConnection) {
        if let metadataObj = metadataObjects.first {
            guard let readableObject = metadataObj as? AVMetadataMachineReadableCodeObject else { return }
            guard let stringValue = readableObject.stringValue else { return }
            
            let alert = UIAlertController(title: nil, message: "Success!", preferredStyle: .alert)
            present(alert, animated: true)
            
            DispatchQueue.main.asyncAfter(deadline: DispatchTime.now() + 1) {
                alert.dismiss(animated: true)
                self.dismiss(animated: true, completion: nil)
            }

            AudioServicesPlayAlertSound(SystemSoundID(kSystemSoundID_Vibrate))
            delegate?.didCaptureQRCode(stringValue)
        } else {
            dismiss(animated: true, completion: nil)
        }
        captureSession?.stopRunning()
    }
}
