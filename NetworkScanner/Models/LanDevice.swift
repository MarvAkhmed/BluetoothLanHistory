//
//  LanDevice.swift
//  NetworkScannerP
//
//  Created by Marwa Awad on 27.10.2025.
//

import Foundation

struct LanDevice: Identifiable, Equatable {
    let id = UUID()
    let ipAddress: String
    let macAddress: String?
    let name: String?
    
    var displayName: String {
        if let name = name, !name.isEmpty, name != ipAddress {
            return name
        }
        return "Unknown Device"
    }
    
    var displayMAC: String {
        macAddress ?? "N/A"
    }
    
    static func ==(lhs: LanDevice, rhs: LanDevice) -> Bool {
        lhs.ipAddress == rhs.ipAddress
    }
}
