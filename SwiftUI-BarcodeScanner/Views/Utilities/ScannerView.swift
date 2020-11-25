//
//  ScannerView.swift
//  SwiftUI-BarcodeScanner
//
//  Created by Petre Vane on 20/11/2020.
//

import SwiftUI

// Interoperability between UiKit and SwiftUI
struct ScannerView: UIViewControllerRepresentable {
    
    @Binding var scannedValue: String
    @Binding var alert: AlertItem?

    
    typealias UIViewControllerType = Scanner
    
    func makeCoordinator() -> Coordinator {
        return Coordinator(scannerView: self)
    }
    
    func makeUIViewController(context: Context) -> Scanner {
        return Scanner(delegate: context.coordinator)
    }
    
    func updateUIViewController(_ uiViewController: Scanner, context: Context) { }

    final class Coordinator: NSObject, ScannerDelegate {
        
        private let scanner: ScannerView
        
        init(scannerView: ScannerView) {
            self.scanner = scannerView
        }
        
        func showError(error: ErrorManager) {
            scanner.alert = error.presentAlert
        }
        
        
        func showDecodedText(_ text: String) {
            scanner.scannedValue = text
        }
        
        func didStartCapturing(_ capturingStarted: Bool) {
            print("Delegate: camera is capturing: \(capturingStarted)")
        }
        
    }
    
}

