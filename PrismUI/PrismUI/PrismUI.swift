//
//  PrismUI.swift
//  PrismUI
//
//  Created by fanni suyuti on 6/9/17.
//  Copyright © 2017 Prism. All rights reserved.
//

import Foundation
import PrismCore
import PrismAnalytics
import CoreTelephony

public protocol PrismUIDelegate {
    func didReceive(message data: Data, in topic: String)
}

open class PrismUI {
    
    open static var shared = PrismUI()
    private init() {}
    
    var delegate: PrismUIDelegate?
    
    open func configure(environment: EnvironmentType, merchantID: String, delegate: PrismUIDelegate) {
        self.delegate = delegate
        PrismCore.shared.configure(environment: environment, merchantID: merchantID)
        
        let analyticsEnv = environment == .Production ? AnalyticEnvironment.Production : AnalyticEnvironment.Sandbox
        PrismAnalytics.shared.configure(environment: analyticsEnv)
        
        sendDeviceInfoToRover()
    }
    
    open func present(on viewController: UIViewController) {
        let rootVC = RootViewController()
        viewController.present(rootVC, animated: true, completion: nil)
    }
    
    private func sendDeviceInfoToRover() {
        UIDevice.current.isBatteryMonitoringEnabled = true
        
        guard let credential = Vendor.shared.credential, let UUID = UIDevice.current.identifierForVendor?.description, let languageCode = Locale.current.languageCode, let regionCode = Locale.current.regionCode, let timezoneAbbr = TimeZone.current.abbreviation() else {
            return
        }
        
        var batteryState = "Unknown"
        
        switch UIDevice.current.batteryState {
        case .charging:
            batteryState = "Charging"
        case .full:
            batteryState = "Full"
        case .unplugged:
            batteryState = "Unplugged"
        case .unknown:
            batteryState = "Unknown"
        }
        
        let MCCode = CTCarrier().mobileCountryCode ?? "0"
        let MNCode = CTCarrier().mobileNetworkCode ?? "0"
        let operatorCodeInt = Int(MCCode + MNCode) ?? 0
        let operatorName = CTCarrier().carrierName ?? "Unknown"
        
        PrismAnalytics.shared.getIPAddress { (ipAddress) in
            let data: [String: Any] = [
                "device_id": UUID,
                "public_ip_address": ipAddress,
                "source": "VISITOR",
                "sender_id": credential.sender.id,
                "sent_time": Int(floor(Date().timeIntervalSince1970)),
                "device_info": [
                    "model": DeviceGuru.hardwareDescription(),
                    "hostname": DeviceGuru.getNodeName(),
                    "ios_version": UIDevice.current.systemVersion,
                    "locale": languageCode + "_" + regionCode,
                    "timezone": [
                        "timezone": timezoneAbbr,
                        "id": TimeZone.current.identifier
                    ]
                ],
                "storage": [
                    "total": DiskStatus.totalDiskSpaceInBytes,
                    "available": DiskStatus.freeDiskSpaceInBytes,
                    "used": DiskStatus.usedDiskSpaceInBytes
                ],
                "battery": [
                    "status": batteryState,
                    "level": UIDevice.current.batteryLevel * 100
                ],
                "network": [
                    "operator_code": operatorCodeInt,
                    "carrier": operatorName
                ]
            ]
            
            PrismAnalytics.shared.sendDeviceInfoToRover(data: data, token: credential.accessToken)
        }
    }
}

extension PrismUI: PrismCoreDelegate {
    public func didReceive(message data: Data, in topic: String) {
        delegate?.didReceive(message: data, in: topic)
    }
}
