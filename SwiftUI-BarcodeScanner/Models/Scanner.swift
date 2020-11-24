//
//  Scanner.swift
//  SwiftUI-BarcodeScanner
//
//  Created by Petre Vane on 18/11/2020.
//

import UIKit
import AVFoundation

protocol ScannerDelegate: UIViewController {
    func showError(error: String)
    func moveSubviewsToFront()
    func showDecodedText(_ text: String)
    func didStartCapturing(_ capturingStarted: Bool)
}

final class Scanner: NSObject {
    
    
    private var captureSession = AVCaptureSession()
    private var videoPreviewLayer: AVCaptureVideoPreviewLayer?
    private var qrCodeFrameView: UIView?
    weak var delegate: ScannerDelegate?
    
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
                                      AVMetadataObject.ObjectType.face,
                                      AVMetadataObject.ObjectType.humanBody,
                                      AVMetadataObject.ObjectType.dogBody,
                                      AVMetadataObject.ObjectType.catBody,
                                      AVMetadataObject.ObjectType.qr]
    
    
    func startCapturingSession() {
        
        // Get the back-facing camera for capturing videos
        guard let captureDevice = AVCaptureDevice.default(.builtInWideAngleCamera, for: .video, position: .back) else { delegate?.showError(error: "Failed access to camera"); return }
        
        do {
            
            // Get an instance of the AVCaptureDeviceInput class using the previous device object
            let input = try AVCaptureDeviceInput(device: captureDevice)
            
            // Set the input device on the capture session
            if captureSession.canAddInput(input) { captureSession.addInput(input) }
            else {
                delegate?.showError(error: "Capture session cannot add this input source")
                return
            }
            
            
            // Initialize a AVCaptureMetadataOutput object and set it as the output device to the capture session
            let captureMetadataOutput = AVCaptureMetadataOutput()
            if captureSession.canAddOutput(captureMetadataOutput) { captureSession.addOutput(captureMetadataOutput) }
            else {
                delegate?.showError(error: "Capture session cannot add this output to screen")
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
        videoPreviewLayer?.frame = (delegate?.view.layer.bounds)!
        delegate?.view.layer.addSublayer(videoPreviewLayer!)
        
    
        // Move the message label and top bar to the front
        delegate?.moveSubviewsToFront()
        
        // Initialize QR Code Frame to highlight the QR code
        qrCodeFrameView = UIView()
        
        if let qrCodeFrameView = qrCodeFrameView {
            qrCodeFrameView.layer.borderColor = UIColor.green.cgColor
            qrCodeFrameView.layer.borderWidth = 2
            delegate?.view.addSubview(qrCodeFrameView)
            delegate?.view.bringSubviewToFront(qrCodeFrameView)
        } else {
            delegate?.showError(error: "Failed setting up the viewFrame")
            print("Failed setting up the viewFrame")
        }
        
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
            delegate?.showError(error: "No metadata objects in Scanner extension")
            return
        }
        
        // Get the metadata object
        guard let metadataObj = object as? AVMetadataMachineReadableCodeObject else {
            print("failed casting medatada objects")
            delegate?.showError(error: "failed casting medatada objects")
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
