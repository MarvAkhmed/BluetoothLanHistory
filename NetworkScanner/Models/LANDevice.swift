//
//  LANDevice.swift
//  NetworkScanner
//
//  Created by Marwa Awad on 26.10.2025.
//

import Foundation

struct LANDevice: Identifiable {
    let id = UUID()
    let ipAddress: String
    let macAddress: String?
    let name: String?
}
