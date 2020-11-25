//
//  ErrorManager.swift
//  SwiftUI-BarcodeScanner
//
//  Created by Petre Vane on 20/11/2020.
//

import SwiftUI


enum ErrorManager: Error {
    typealias RawValue = String
    
    case noCameraAccess
    case noCameraInput
    case noCameraOutput
    case noViewFrame
    case missingMetadataObject
    case failedCasting
    
    var presentAlert: AlertItem {
        
        switch self {
            case .failedCasting: return createAlertItem(errorMessage: "Failed casting metadata objects")
            case.missingMetadataObject: return createAlertItem(errorMessage: "This code cannot be recognized")
            case.noCameraAccess: return createAlertItem(errorMessage: "Camera access denied")
            case.noCameraInput: return createAlertItem(errorMessage: "No input source")
            case.noCameraOutput: return createAlertItem(errorMessage: "There is nothing to show")
            case.noViewFrame: return createAlertItem(errorMessage: "Failed setting up QRCode frame")
        }
    }
    
    private func createAlertItem(errorMessage: String) -> AlertItem {
        return AlertItem(title: "Oops an error", message: errorMessage, alertButton: .default(Text("Dismiss")))
    }
}
