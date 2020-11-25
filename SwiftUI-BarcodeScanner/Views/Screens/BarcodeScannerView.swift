//
//  BarcodeScannerView.swift
//  SwiftUI-BarcodeScanner
//
//  Created by Petre Vane on 18/11/2020.
//

import SwiftUI

struct BarcodeScannerView: View {
    
    
    @StateObject var model = BarcodeScannerViewModel()

    
    var body: some View {
        NavigationView {
            VStack {
                ScannerView(scannedValue: $model.scannedCode, alert: $model.alertItem)
                    .frame(maxWidth: 350, maxHeight: 250)
                    .border(Color.blue, width: 1)
                    .padding(.bottom)
                
                Label("Scanned barcode", systemImage: "barcode.viewfinder")
                    .font(.title)
                    .shadow(color: Color(.label), radius: 0.2)
                
                Spacer().frame(height: 80, alignment: .center)
                    
                Text(model.labelText)
                    .font(.title2)
                    .fontWeight(.bold)
                    .foregroundColor(model.labelColor)
                    .shadow(color: Color(.label), radius: 0.2)
                    
            }.navigationTitle("Barcode scanner")
            .alert(item: $model.alertItem) { alertItem in
                Alert(title: Text(alertItem.title), message: Text(alertItem.message), dismissButton: alertItem.alertButton)
            }
        }
    }
}

