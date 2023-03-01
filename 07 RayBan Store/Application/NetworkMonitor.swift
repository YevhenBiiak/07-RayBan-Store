//
//  NetworkMonitor.swift
//  07 RayBan Store
//
//  Created by Yevhen Biiak on 01.03.2023.
//

import Network

extension NWInterface.InterfaceType: CaseIterable {
    public static var allCases: [NWInterface.InterfaceType] = [
        .other,
        .wifi,
        .cellular,
        .loopback,
        .wiredEthernet
    ]
}

final class NetworkMonitor {

    private let monitor: NWPathMonitor = NWPathMonitor()
    private let queue = DispatchQueue(label: "NetworkConnectivityMonitor")

    private(set) var isConnected = false
    private(set) var isExpensive = false
    private(set) var interfaceType: NWInterface.InterfaceType?
    
    var updateHandler: ((NetworkMonitor) -> Void)?

    func startMonitoring() {
        monitor.pathUpdateHandler = { [weak self] path in
            guard let self else { return }
            self.isConnected = path.status == .satisfied
            self.isExpensive = path.isExpensive
            self.interfaceType = NWInterface.InterfaceType.allCases.filter { path.usesInterfaceType($0) }.first
            self.updateHandler?(self)
        }
        monitor.start(queue: queue)
    }

    func stopMonitoring() {
        monitor.cancel()
    }
}
