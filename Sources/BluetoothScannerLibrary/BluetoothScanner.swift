//
//  BluetoothScanner.swift
//
//
//  Created by Ali Han DEMIR on 1.07.2024.
//

import Foundation
import CoreBluetooth

@objc public protocol BluetoothScannerDelegate: AnyObject {
    func didDiscoverDevice(name: String, rssi: Int, timestamp: Date)
    @objc optional func didCentralManagerUpdateState(_ central: CBCentralManager)
}

public class BluetoothScanner: NSObject, CBCentralManagerDelegate, CBPeripheralDelegate {
    private var centralManager: CBCentralManager?
    private(set) public var isScanning = false
    public weak var delegate: BluetoothScannerDelegate?

    public override init() {
        super.init()
        centralManager = CBCentralManager(delegate: self, queue: nil)
    }

    public func startScanning() {
        guard centralManager?.state == .poweredOn else { return }
        guard !isScanning else { return }
        isScanning = true
        centralManager?.scanForPeripherals(withServices: nil, options: nil)
    }

    public func stopScanning() {
        guard isScanning else { return }
        isScanning = false
        centralManager?.stopScan()
    }

    public func centralManagerDidUpdateState(_ central: CBCentralManager) {
        delegate?.didCentralManagerUpdateState?(central)
    }

    public func centralManager(_ central: CBCentralManager, didDiscover peripheral: CBPeripheral, advertisementData: [String: Any], rssi RSSI: NSNumber) {
        guard let name = peripheral.name else { return }
        let timestamp = Date()
        delegate?.didDiscoverDevice(name: name, rssi: RSSI.intValue, timestamp: timestamp)
    }
}
