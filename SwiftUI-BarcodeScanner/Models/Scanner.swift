//
//  Scanner.swift
//  SwiftUI-BarcodeScanner
//
//  Created by Petre Vane on 18/11/2020.
//

import UIKit
import AVFoundation

protocol ScannerDelegate: AnyObject {
    func showError(error: ErrorManager)
    func showDecodedText(_ text: String)
    func didStartCapturing(_ capturingStarted: Bool)
}

final class Scanner: UIViewController {
    
    
    private var captureSession = AVCaptureSession()
    private var videoPreviewLayer: AVCaptureVideoPreviewLayer?
    private var qrCodeFrameView: UIView?
    weak var delegate: ScannerDelegate?
    
    init(delegate: ScannerDelegate) {
        self.delegate = delegate
        super.init(nibName: nil, bundle: nil)
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    // type of supported codes
    private let supportedCodeTypes = [AVMetadataObject.ObjectType.upce,
                                      AVMetadataObject.ObjectType.code39,
                                      AVMetadataObject.ObjectType.code39Mod43,
                                      AVMetadataObject.ObjectType.code93,
                                      AVMetadataObject.ObjectType.code128,
                                      AVMetadataObject.ObjectType.ean8,
                                      AVMetadataObject.ObjectType.ean13,
                                      AVMetadataObject.ObjectType.aztec,
                                      AVMetadataObject.ObjectType.pdf417,
                                      AVMetadataObject.ObjectType.itf14,
                                      AVMetadataObject.ObjectType.dataMatrix,
                                      AVMetadataObject.ObjectType.interleaved2of5,
                                      AVMetadataObject.ObjectType.qr]
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        startCapturingSession()
    }
    
    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(animated)
        guard let videoPreviewLayer = videoPreviewLayer else { print("No video preview layer"); return }
        videoPreviewLayer.frame = view.layer.bounds
        view.layer.addSublayer(videoPreviewLayer)
    }
    
    override func viewDidLayoutSubviews() {
        super.viewDidLayoutSubviews()

        
    }
    
    override func viewDidDisappear(_ animated: Bool) {
        super.viewDidDisappear(animated)
        delegate?.didStartCapturing(false)
    }
    
    func startCapturingSession() {
        
        // Get the back-facing camera for capturing videos
        guard let captureDevice = AVCaptureDevice.default(.builtInWideAngleCamera, for: .video, position: .back) else { delegate?.showError(error: .noCameraAccess); return }
        
        do {
            
            // Get an instance of the AVCaptureDeviceInput class using the previous device object
            let input = try AVCaptureDeviceInput(device: captureDevice)
            
            // Set the input device on the capture session
            if captureSession.canAddInput(input) { captureSession.addInput(input) }
            else {
                delegate?.showError(error: .noCameraInput)
                return
            }
            
            
            // Initialize a AVCaptureMetadataOutput object and set it as the output device to the capture session
            let captureMetadataOutput = AVCaptureMetadataOutput()
            if captureSession.canAddOutput(captureMetadataOutput) { captureSession.addOutput(captureMetadataOutput) }
            else {
                delegate?.showError(error: .noCameraOutput)
            
                return
            }
            
            
            // Set delegate and use the default dispatch queue to execute the call back
            captureMetadataOutput.setMetadataObjectsDelegate(self, queue: DispatchQueue.main)
            captureMetadataOutput.metadataObjectTypes = supportedCodeTypes
            captureMetadataOutput.metadataObjectTypes = [AVMetadataObject.ObjectType.qr]
            
            
        } catch let error {
            // If any error occurs, simply print it out and don't continue any more
            print("Error capturing Session: \(error.localizedDescription)")
            delegate?.didStartCapturing(false)
            return
        }
        
        // Initialize the video preview layer and add it as a sublayer to the viewPreview view's layer
        // this happens within delegate object
        videoPreviewLayer = AVCaptureVideoPreviewLayer(session: captureSession)
        videoPreviewLayer?.videoGravity = AVLayerVideoGravity.resizeAspectFill
        
//        view.layer.addSublayer(videoPreviewLayer)
        
    
        // Move the message label and top bar to the front
//        self.view.moveSubviewsToFront()
        
        // Initialize QR Code Frame to highlight the QR code
        qrCodeFrameView = UIView()
        
        if let qrCodeFrameView = qrCodeFrameView {
            
            qrCodeFrameView.layer.borderColor = UIColor.green.cgColor
            qrCodeFrameView.layer.borderWidth = 2
            view.addSubview(qrCodeFrameView)
            view.bringSubviewToFront(qrCodeFrameView)
            
        } else { delegate?.showError(error: .noViewFrame) }
        
        // Start video capture
        captureSession.startRunning()
        delegate?.didStartCapturing(true)
    }
}


extension Scanner: AVCaptureMetadataOutputObjectsDelegate {
    
    func metadataOutput(_ output: AVCaptureMetadataOutput, didOutput metadataObjects: [AVMetadataObject], from connection: AVCaptureConnection) {
        // Check if the metadataObjects array is not nil and it contains at least one object
        guard let object = metadataObjects.first else {
            qrCodeFrameView?.frame = CGRect.zero
            delegate?.showError(error: .missingMetadataObject)
            return
        }
        
        // Get the metadata object
        guard let metadataObj = object as? AVMetadataMachineReadableCodeObject else {
            print("failed casting medatada objects")
            delegate?.showError(error: .failedCasting)
            return
        }
        
        if supportedCodeTypes.contains(metadataObj.type) {
            
            // If the found metadata is contained by the supported QR code types, then update the status label's text and set the bounds
            let barCodeObject = videoPreviewLayer?.transformedMetadataObject(for: metadataObj)
            qrCodeFrameView?.frame = barCodeObject!.bounds
            
            guard metadataObj.stringValue != nil else { return }
            // send decoded text to delegate label
            delegate?.showDecodedText(metadataObj.stringValue!)
            
        }
    }
    
}
