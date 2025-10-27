//
//  LanScanService.swift
//  NetworkScannerP
//
//  Created by Marwa Awad on 27.10.2025.
//


import Foundation
import MMLanScan

protocol LanScanServiceDelegate: AnyObject {
    func didFind(device: LanDevice)
    func didFinishScanning()
    func didFailWithError(_ error: Error)
}

final class LanScanService: NSObject {
    
    weak var delegate: LanScanServiceDelegate?
    private var lanScanner: MMLANScanner?
    private var isScanning = false
    
    override init() {
        super.init()
        setupScanner()
    }
    
    private func setupScanner() {
        lanScanner = MMLANScanner()
        lanScanner?.delegate = self
    }
    
    func startScan() {
        guard !isScanning else { return }
        isScanning = true
        lanScanner?.start()
    }
    
    func stopScan() {
        guard isScanning else { return }
        isScanning = false
        lanScanner?.stop()
    }
}

extension LanScanService: MMLANScannerDelegate {
    func lanScanDidFindNewDevice(_ device: MMDevice!) {
        let lanDevice = LanDevice(
            ipAddress: device.ipAddress ?? "Unknown",
            macAddress: device.macAddress,
            name: device.hostname
        )
        delegate?.didFind(device: lanDevice)
    }
    
    func lanScanDidFinishScanning(with status: MMLanScannerStatus) {
        isScanning = false
        delegate?.didFinishScanning()
    }
    
    func lanScanDidFailedToScan() {
        isScanning = false
        let error = NSError(
            domain: "LanScanService",
            code: -1,
            userInfo: [NSLocalizedDescriptionKey: "LAN scan failed"]
        )
        delegate?.didFailWithError(error)
    }
}
