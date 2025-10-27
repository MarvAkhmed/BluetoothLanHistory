//
//  Device+CoreDataProperties.swift
//  NetworkScannerP
//
//  Created by Marwa Awad on 28.10.2025.
//
//

public import Foundation
public import CoreData


public typealias DeviceCoreDataPropertiesSet = NSSet

extension Device {

    @nonobjc public class func fetchRequest() -> NSFetchRequest<Device> {
        return NSFetchRequest<Device>(entityName: "Device")
    }

    @NSManaged public var id: UUID?
    @NSManaged public var name: String?
    @NSManaged public var type: String?
    @NSManaged public var uuid: String?
    @NSManaged public var ipAddress: String?
    @NSManaged public var macAddress: String?
    @NSManaged public var rssi: Int16
    @NSManaged public var status: String?
    @NSManaged public var scanSession: ScanSession?

}

extension Device : Identifiable {

}
