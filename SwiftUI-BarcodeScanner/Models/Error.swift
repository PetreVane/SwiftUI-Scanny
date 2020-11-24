//
//  ErrorManager.swift
//  SwiftUI-BarcodeScanner
//
//  Created by Petre Vane on 20/11/2020.
//

import Foundation


enum ErrorManager: Error {
    typealias RawValue = String
    
    case noCameraAccess
    case noCameraInput
    case noCameraOutput
    case noViewFrame
    case missingMetadataObject
    case failedCasting
    
    
    var description: String {
        switch self {
            case .noCameraAccess: return "Camera access denied"
            case .noCameraInput: return "No input source"
            case .noCameraOutput: return "There is nothing to show"
            case .noViewFrame: return "Failed setting up QRCode frame"
            case .missingMetadataObject: return "No metadata objects"
            case .failedCasting: return "Failed casting metadata objects"
        }
    }
}
