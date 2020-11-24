//
//  BarcodeScannerView.swift
//  SwiftUI-BarcodeScanner
//
//  Created by Petre Vane on 18/11/2020.
//

import SwiftUI

struct BarcodeScannerView: View {
    var body: some View {
        NavigationView {
            VStack {
                ScannerView()
                    .frame(maxWidth: 350, maxHeight: 150)
                    .border(Color.blue, width: 1)
                    .padding(.bottom)
                
                Label("Scanned barcode", systemImage: "barcode.viewfinder")
                    .font(.title)
                    .shadow(color: Color(.label), radius: 0.2)
                
                Spacer().frame(height: 80, alignment: .center)
                    
                Text("Not yet scanned")
                    .font(.title2)
                    .fontWeight(.bold)
                    .foregroundColor(.green)
                    .shadow(color: Color(.label), radius: 0.2)
                    
            }.navigationTitle("Barcode scanner")
        }
    }
}

struct ContentView_Previews: PreviewProvider {
    static var previews: some View {
        BarcodeScannerView()
    }
}
