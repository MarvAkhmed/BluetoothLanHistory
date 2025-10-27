//
//  ContentView.swift
//  BlotoothLanNetwork
//
//  Created by Marwa Awad on 26.10.2025.
//

import SwiftUI

struct ContentView: View {
    var body: some View {
        TabView {
            
            
            NavigationView {
                BluetoothScanView()
            }
            
            .tabItem {
                Image(systemName: "antenna.radiowaves.left.and.right")
                Text("Bluetooth")
            }
            
            
            NavigationView {
                LanScanView()
            }
            .tabItem {
                Image(systemName: "network")
                Text("LAN")
            }
        }
    }
}

#Preview {
    ContentView()
}
