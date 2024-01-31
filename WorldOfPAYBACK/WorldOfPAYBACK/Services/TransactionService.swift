//
//  TransactionService.swift
//  WorldOfPAYBACK
//
//  Created by Mikołaj Dębicki on 31/01/2024.
//

import Combine
import Foundation

protocol TransactionServiceProtocol {
    func getTransactions() -> AnyPublisher<TransactionList, PBError>
}

final class TransactionService: TransactionServiceProtocol {
    
    static let shared: TransactionServiceProtocol = TransactionService()
    private let networkingManager: NetworkingManagerProtocol
    
    init(networkingManager: NetworkingManagerProtocol = NetworkingManager.shared) {
        self.networkingManager = networkingManager
    }
    
    func getTransactions() -> AnyPublisher<TransactionList, PBError> {
        networkingManager.loadJson(fileName: "PBTransactions")
    }
}
