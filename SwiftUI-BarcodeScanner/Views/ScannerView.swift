//
//  ScannerView.swift
//  SwiftUI-BarcodeScanner
//
//  Created by Petre Vane on 20/11/2020.
//

import SwiftUI

struct ScannerView: UIViewControllerRepresentable {
    
    typealias UIViewControllerType = Scanner
    
    func makeCoordinator() -> Coordinator {
        return Coordinator()
    }
    
    func makeUIViewController(context: Context) -> Scanner {
        return Scanner(delegate: context.coordinator)
    }
    
    func updateUIViewController(_ uiViewController: Scanner, context: Context) { }

    final class Coordinator: NSObject, ScannerDelegate {
        
        override init() {
            print("Coordinator initialized")
        }
        
        func showError(error: ErrorManager) {
            print(error.description)
        }
        
        
        func showDecodedText(_ text: String) {
            print("Delegate: decoded text is \(text)")
        }
        
        func didStartCapturing(_ capturingStarted: Bool) {
            print("Delegate: camera is capturing: \(capturingStarted)")
        }
        
    }
    
}

struct ScannerView_Previews: PreviewProvider {
    static var previews: some View {
        ScannerView()
    }
}
