//
//  Connectivty.swift
//  Banque Misr - iOS Exercise
//
//  Created by Ahmed El Gndy on 06/10/2024.
//

import Network
import Foundation


class NetworkMonitor {
    
    static let shared = NetworkMonitor()
    private let monitor = NWPathMonitor()
    private let queue = DispatchQueue.global(qos: .background)
    
    var isConnected: Bool = false
    
    private init() {
        startMonitoring() 
    }
    
    private func startMonitoring() {
        monitor.start(queue: queue)
        monitor.pathUpdateHandler = { [weak self] path in
            self?.isConnected = path.status == .satisfied
            print(self?.isConnected == true ? "Connected to the internet." : "No internet connection.")
        }
    }
    
    func checkConnection(completion: @escaping (Bool) -> Void) {
        completion(isConnected)
        monitor.pathUpdateHandler = { [weak self] path in
            self?.isConnected = path.status == .satisfied
            completion(self?.isConnected ?? false)
        }
    }
    
    func stopMonitoring() {
        monitor.cancel()
    }
}
