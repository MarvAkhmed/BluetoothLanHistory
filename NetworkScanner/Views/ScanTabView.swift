//
//  ScanTabView.swift
//  NetworkScannerP
//
//  Created by Marwa Awad on 27.10.2025.
//

import SwiftUI

struct ScanTabView: View {
    @State private var selectedScan = 0
    private let scanTypes = ["Bluetooth", "LAN"]

    var body: some View {
        NavigationView {
            VStack {
                Picker("Scan Type", selection: $selectedScan) {
                    ForEach(0..<scanTypes.count, id: \.self) { index in
                        Text(scanTypes[index])
                    }
                }
                .pickerStyle(SegmentedPickerStyle())
                .padding()

                if selectedScan == 0 {
                    BluetoothScanView()
                } else if selectedScan == 1{
                    LanScanView()
                }

                Spacer()
            }
            .navigationTitle("Network Scanner")
        }
    }
}
