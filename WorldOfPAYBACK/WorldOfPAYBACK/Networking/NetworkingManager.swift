//
//  NetowrkingManager.swift
//  WorldOfPAYBACK
//
//  Created by Mikołaj Dębicki on 31/01/2024.
//

import Combine
import Foundation

protocol NetworkingManagerProtocol {
    func loadJson<T: Decodable>(fileName: String) -> AnyPublisher<T, PBError>
}

final class NetworkingManager: NetworkingManagerProtocol {
    
    static let shared: NetworkingManager = NetworkingManager()
    
    private init() {}
    
    func loadJson<T: Decodable>(fileName: String) -> AnyPublisher<T, PBError> {
        return Bundle.main.url(forResource: fileName, withExtension: "json").publisher
            .delay(for: 2, scheduler: DispatchQueue.main)
            .throttle(for: 2, scheduler: DispatchQueue.main, latest: true)
            .tryMap { fileName in
                if Int.random(in: 1..<10) == 1 {
                    throw PBError.networkFailure
                } else {
                    return try Data(contentsOf: fileName)
                }
            }
            .decode(type: T.self, decoder: JSONDecoder())
            .mapError { _ in PBError.networkFailure }
            .receive(on: DispatchQueue.main)
            .eraseToAnyPublisher()
    }
}
