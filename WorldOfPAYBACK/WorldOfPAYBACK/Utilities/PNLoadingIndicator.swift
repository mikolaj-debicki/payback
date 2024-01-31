//
//  PNLoadingIndicator.swift
//  WorldOfPAYBACK
//
//  Created by Mikołaj Dębicki on 31/01/2024.
//

import Combine
import Foundation

final class PBLoadingIndicator {

    // MARK: - Private stored properties
    private let lock = NSRecursiveLock()
    private let subject = CurrentValueSubject<Int, Never>(0)
    let loadingPublisher: AnyPublisher<Bool, Never>

    // MARK: - Internal methods
    init() {
        loadingPublisher = subject
            .receive(on: DispatchQueue.main)
            .map { $0 > 0 }
            .removeDuplicates()
            .share()
            .eraseToAnyPublisher()
    }

    deinit {
        subject.send(completion: .finished)
    }

    // MARK: - Fileprivate methods
    fileprivate func trackActivityOfObservable<T: Publisher>(_ publisher: T) -> AnyPublisher<T.Output, T.Failure> {
        publisher.handleEvents(receiveSubscription: { [weak self] _ in
            self?.increment()
        }, receiveCompletion: { [weak self] _ in
            self?.decrement()
        }, receiveCancel: { [weak self] in
            self?.decrement()
        })
        .eraseToAnyPublisher()
    }

    // MARK: - Private methods
    private func increment() {
        lock.lock()
        subject.send(subject.value + 1)
        lock.unlock()
    }

    private func decrement() {
        lock.lock()
        subject.send(subject.value - 1)
        lock.unlock()
    }
}

extension Publisher {
    func trackLoading(_ activityIndicator: PBLoadingIndicator) ->
    AnyPublisher<Output, Failure> {
        activityIndicator.trackActivityOfObservable(self)
    }
}
