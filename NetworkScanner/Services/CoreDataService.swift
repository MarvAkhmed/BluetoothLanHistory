//
//  CoreDataService.swift
//  NetworkScannerP
//
//  Created by Marwa Awad on 27.10.2025.
//

import Foundation
import CoreData

protocol ScanDataServiceProtocol {
    func saveScanSession(devices: [DeviceDataLocal], sessionType: String) async throws
    func fetchAllScanSessions() async throws -> [ScanSessionLocal]
    func fetchDevicesLocal(for session: ScanSessionLocal) async throws -> [DeviceDataLocal]
    func fetchScanSessions(ofType sessionType: String) async throws -> [ScanSessionLocal] 
}

final class CoreDataService: ScanDataServiceProtocol {
    
    private let container: NSPersistentContainer
    private let backgroundContext: NSManagedObjectContext
    
    init(container: NSPersistentContainer = NSPersistentContainer(name: "CoreDataModel")) {
        self.container = container
        container.loadPersistentStores { _, error in
            if let error = error {
                fatalError("Core Data load failed: \(error)")
            }
        }
        backgroundContext = container.newBackgroundContext()
    }
    
    func saveScanSession(devices: [DeviceDataLocal], sessionType: String) async throws {
        try await backgroundContext.perform {
            let session = ScanSession(context: self.backgroundContext)
            session.id = UUID()
            session.date = Date()
            session.sessionType = sessionType 
            
            for deviceData in devices {
                let device = Device(context: self.backgroundContext)
                device.id = deviceData.id
                device.name = deviceData.name
                device.type = deviceData.type
                device.uuid = deviceData.uuid
                device.ipAddress = deviceData.ipAddress
                device.macAddress = deviceData.macAddress
                device.rssi = deviceData.rssi
                device.status = deviceData.status
                device.scanSession = session
            }
            
            try self.backgroundContext.save()
        }
    }
    
    // Add this new method for type-specific fetching
    func fetchScanSessions(ofType sessionType: String) async throws -> [ScanSessionLocal] {
        try await backgroundContext.perform {
            let request: NSFetchRequest<ScanSession> = ScanSession.fetchRequest()
            request.predicate = NSPredicate(format: "sessionType == %@", sessionType)
            request.sortDescriptors = [NSSortDescriptor(key: "date", ascending: false)]
            let sessions = try self.backgroundContext.fetch(request)
            
            return sessions.map { session in
                let devices = (session.device as? Set<Device>)?.map { device in
                    DeviceDataLocal(
                        id: device.id ?? UUID(),
                        name: device.name,
                        type: device.type ?? "Unknown",
                        uuid: device.uuid,
                        ipAddress: device.ipAddress,
                        macAddress: device.macAddress,
                        rssi: device.rssi,
                        status: device.status ?? "Unknown"
                    )
                } ?? []
                
                return ScanSessionLocal(
                    id: session.id ?? UUID(),
                    date: session.date ?? Date(),
                    devices: devices
                )
            }
        }
    }
    
    func fetchAllScanSessions() async throws -> [ScanSessionLocal] {
        try await backgroundContext.perform {
            let request: NSFetchRequest<ScanSession> = ScanSession.fetchRequest()
            request.sortDescriptors = [NSSortDescriptor(key: "date", ascending: false)]
            let sessions = try self.backgroundContext.fetch(request)
            
            return sessions.map { session in
                let devices = (session.device as? Set<Device>)?.map { device in
                    DeviceDataLocal(
                        id: device.id ?? UUID(),
                        name: device.name,
                        type: device.type ?? "Unknown",
                        uuid: device.uuid,
                        ipAddress: device.ipAddress,
                        macAddress: device.macAddress,
                        rssi: device.rssi,
                        status: device.status ?? "Unknown"
                    )
                } ?? []
                
                return ScanSessionLocal(
                    id: session.id ?? UUID(),
                    date: session.date ?? Date(),
                    devices: devices
                )
            }
        }
    }
    
    func fetchDevicesLocal(for session: ScanSessionLocal) async throws -> [DeviceDataLocal] {
        try await fetchAllScanSessions()
            .first(where: { $0.id == session.id })?
            .devices ?? []
    }
    
    // Keep the original method for backward compatibility
    func saveScanSession(devices: [DeviceDataLocal]) async throws {
        try await saveScanSession(devices: devices, sessionType: "unknown")
    }
}
