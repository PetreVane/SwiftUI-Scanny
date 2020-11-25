//
//  BarcodeScannerViewModel.swift
//  SwiftUI-BarcodeScanner
//
//  Created by Petre Vane on 25/11/2020.
//

import SwiftUI


final class BarcodeScannerViewModel: ObservableObject {
    
    @Published var scannedCode = ""
    @Published var alertItem: AlertItem?
    
    var labelText: String {
        return scannedCode.isEmpty ? "No code scanned" : scannedCode
    }
    
    var labelColor: Color {
        return scannedCode.isEmpty ? .red : .green
    }
}
