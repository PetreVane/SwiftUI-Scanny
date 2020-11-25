//
//  CustomAlert.swift
//  SwiftUI-BarcodeScanner
//
//  Created by Petre Vane on 24/11/2020.
//

import SwiftUI

struct CustomAlert: Identifiable {
    let id = UUID()
    let title: String
    let message: String
    let alertButton: Alert.Button
}


