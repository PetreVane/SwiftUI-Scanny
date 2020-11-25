//
//  AlertItem.swift
//  SwiftUI-BarcodeScanner
//
//  Created by Petre Vane on 24/11/2020.
//

import SwiftUI


struct AlertItem: Identifiable {
    
    let id = UUID()
    let title: String
    let message: String
    let alertButton: Alert.Button
}
