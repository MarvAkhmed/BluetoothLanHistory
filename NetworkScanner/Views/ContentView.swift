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
            ScanTabView()
                .tabItem {
                    Image(systemName: "dot.radiowaves.left.and.right")
                    Text("Scan")
                }

            ScanHistoryTabView()
                .tabItem {
                    Image(systemName: "clock.arrow.circlepath")
                    Text("History")
                }
        }
    }
}

#Preview {
    ContentView()
}
