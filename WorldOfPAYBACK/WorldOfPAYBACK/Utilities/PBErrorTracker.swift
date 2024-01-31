//
//  PBErrorTracker.swift
//  WorldOfPAYBACK
//
//  Created by Mikołaj Dębicki on 31/01/2024.
//

import Combine

final class PBErrorTracker {
    
    // MARK: - Private stored properties
    private let errorSubject = PassthroughSubject<PBError, Never>()
    let toastErrorPublisher: AnyPublisher<String?, Never>
    
    // MARK: - Internal methods
    init() {
        toastErrorPublisher = errorSubject.share()
            .compactMap { error -> String? in
                error.errorDescription
            }
            .eraseToAnyPublisher()
    }
    
    deinit {
        errorSubject.send(completion: .finished)
    }
    
    func trackError<T: Publisher>(from publisher: T) -> AnyPublisher<T.Output, Never> where T.Failure == PBError {
        publisher.catch { [weak self] error -> Empty<T.Output, Never> in
            self?.errorSubject.send(error)
            return .init()
        }
        .eraseToAnyPublisher()
    }
}

extension Publisher {
    func trackError(_ errorTracker: PBErrorTracker) -> AnyPublisher<Output, Never> where Self.Failure == PBError {
        errorTracker.trackError(from: self)
    }
}
