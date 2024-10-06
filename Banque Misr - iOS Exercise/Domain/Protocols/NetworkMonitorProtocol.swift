//
//  NetworkMonitorProtocol.swift
//  Banque Misr - iOS Exercise
//
//  Created by Ahmed El Gndy on 06/10/2024.
//

import Foundation
protocol NetworkMonitorProtocol {
    var isConnected: Bool { get }
    func startMonitoring()
    func stopMonitoring()
    func checkConnection(completion: @escaping (Bool) -> Void)
}
