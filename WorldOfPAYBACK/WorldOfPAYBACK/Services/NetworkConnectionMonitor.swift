//
//  NetworkConnectionMonitor.swift
//  WorldOfPAYBACK
//
//  Created by Mikołaj Dębicki on 31/01/2024.
//

import Foundation
import Network

final class NetworkConnectionMonitor: ObservableObject {

    static let shared: NetworkConnectionMonitor = NetworkConnectionMonitor()
    let monitor = NWPathMonitor()
    @Published var isOffline = false

    init() {
        monitor.pathUpdateHandler = { [weak self] path in
            DispatchQueue.main.async {
                self?.isOffline = path.status != .satisfied
            }
        }
        monitor.start(queue: DispatchQueue(label: "Monitor"))
    }
}
