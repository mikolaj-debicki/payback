//
//  TransactionListViewModel.swift
//  WorldOfPAYBACK
//
//  Created by Mikołaj Dębicki on 29/01/2024.
//

import Combine
import Foundation

final class TransactionListViewModel: ObservableObject {

    @Published var allTransactions: [TransactionViewData] = []
    @Published var notSortedTransactions: [TransactionViewData] = []
    @Published var visibleTransactions: [TransactionViewData] = []
    @Published var selectedCategory = 0
    @Published var categories: [Category] = [.showAll]
    @Published var selectedSort = SortedState.notSorted
    @Published var sortedStates = SortedState.allCases
    @Published var totalValue: String = "0"
    @Published var isOffline: Bool = false
    @Published var toastMessage: String?
    @Published var isToastShowing: Bool = false
    @Published var isLoading: Bool = false

    private var cancellables = Set<AnyCancellable>()
    private let transactionService: TransactionServiceProtocol
    private let networkMonitor: NetworkConnectionMonitor
    private let errorTracker = PBErrorTracker()
    private let loadingIndicator = PBLoadingIndicator()

    init(transactionService: TransactionServiceProtocol = TransactionService.shared,
         networkMonitor: NetworkConnectionMonitor = NetworkConnectionMonitor.shared) {
        self.transactionService = transactionService
        self.networkMonitor = networkMonitor
        bind()
        getTransactions()
    }

    func bind() {
        bindTotalValue()
        bindFilter()
        bindSort()
        bindNetworkMonitor()
        bindErrorTracking()
        bindLoading()
    }

    func getTransactions() {
        let response = transactionService.getTransactions()
            .trackError(errorTracker)
            .trackLoading(loadingIndicator)
            .compactMap { $0.items }
            .share()

        let transactions = response
            .compactMap { transactions in
                transactions.map { TransactionViewData(from: $0) }
            }
            .share()

        transactions
            .assign(to: &$allTransactions)

        transactions
            .assign(to: &$visibleTransactions)

        transactions
            .assign(to: &$notSortedTransactions)

        response
            .compactMap { transactions in
                // Here I scan through all the categories and then remove duplicates to get a list of unique categories which is then presented in the picker
                var categories = [Category.showAll]
                let newCategories = transactions.map { Category.regular($0.category) }.removeDuplicates()
                categories.append(contentsOf: newCategories)

                return categories
            }
            .assign(to: &$categories)

        response
            .map { _ in 0 }
            .assign(to: &$selectedCategory)

        response
            .map { _ in SortedState.notSorted }
            .assign(to: &$selectedSort)
    }

    func bindTotalValue() {
        $visibleTransactions
            .compactMap { data in
                // I made the assumption that every transaction has the same currency while calculating the total
                guard let currency = data.compactMap({ $0.currency }).first else { return nil }
                let total = data.compactMap({ $0.rawValue }).reduce(0, +)
                return total.formatted(.currency(code: currency))
            }
            .assign(to: &$totalValue)
    }

    func bindFilter() {
        let filteredTransactions = $selectedCategory
            .combineLatest($allTransactions) { category, transactions in
                if category == 0 {
                    return transactions
                } else {
                    return transactions.filter { $0.category == category }
                }
            }
            .share()

        filteredTransactions
            .assign(to: &$visibleTransactions)

        filteredTransactions
            .assign(to: &$notSortedTransactions)
    }

    func bindSort() {
        $selectedSort
            .combineLatest($visibleTransactions, $notSortedTransactions) { selectedSort, transactions, notSortedTransactions in
                switch selectedSort {
                case .notSorted:
                    return notSortedTransactions
                case .decreasing:
                    return transactions.sorted(by: { $0.date.compare($1.date) == .orderedDescending })
                case .increasing:
                    return transactions.sorted(by: { $0.date.compare($1.date) == .orderedAscending })
                }
            }
            .assign(to: &$visibleTransactions)
    }

    func bindNetworkMonitor() {
        networkMonitor.$isOffline
            .assign(to: &$isOffline)
    }

    func bindErrorTracking() {
        let errorPublisher = errorTracker
            .toastErrorPublisher
            .share()

        errorPublisher
            .assign(to: &$toastMessage)

        errorPublisher
            .map { _ in true }
            .assign(to: &$isToastShowing)
    }

    func bindLoading() {
        loadingIndicator
            .loadingPublisher
            .assign(to: &$isLoading)
    }
}
