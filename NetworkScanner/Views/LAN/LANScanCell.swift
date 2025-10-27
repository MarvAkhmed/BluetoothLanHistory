//
//  LANScanCell.swift
//  NetworkScannerP
//
//  Created by Marwa Awad on 27.10.2025.
//


import SwiftUI

struct LANScanCell: View {
    let device: LanDevice
    
    var body: some View {
        HStack(spacing: 12) {
            // MARK: - Icon
            Circle()
                .fill(Color.blue.opacity(0.2))
                .frame(width: 44, height: 44)
                .overlay(
                    Image(systemName: "wifi")
                        .foregroundColor(.blue)
                        .font(.title3)
                )
            
            VStack(alignment: .leading, spacing: 4) {
                Text(device.displayName)
                    .font(.headline)
                    .foregroundColor(.primary)
                
                HStack(spacing: 8) {
                    Label(device.ipAddress, systemImage: "number.circle")
                        .font(.subheadline)
                        .foregroundColor(.primary)
                    
                    Label(device.displayMAC, systemImage: "network")
                        .font(.subheadline)
                        .foregroundColor(.secondary)
                }
            }
            
            Spacer()
        }
        .padding()
        .background(
            RoundedRectangle(cornerRadius: 12)
                .fill(Color(.systemBackground))
                .shadow(color: Color.black.opacity(0.05), radius: 4, x: 0, y: 2)
        )
        .padding(.horizontal) 
    }
}

#Preview {
    let dev = LanDevice(ipAddress: "", macAddress: "", name: "")
    LANScanCell(device: dev)
}
