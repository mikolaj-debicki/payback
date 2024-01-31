//
//  TransactionListView.swift
//  WorldOfPAYBACK
//
//  Created by Mikołaj Dębicki on 29/01/2024.
//

import SwiftUI

struct TransactionListView: View {

    @StateObject private var viewModel: TransactionListViewModel

    init() {
        let viewModel = TransactionListViewModel()
        self._viewModel = .init(wrappedValue: viewModel)
    }

    var body: some View {
        NavigationStack {
            VStack(spacing: 10) {
                totalView
                HStack(spacing: 0) {
                    categoryPicker
                    sortPicker
                    Spacer()
                    refreshButton
                }
                transactionList
            }
            .navigationTitle("listTitle")
        }
        .pbToastView(message: viewModel.toastMessage,
                     isShowing: $viewModel.isToastShowing)
        .fullScreenCover(isPresented: $viewModel.isOffline) {
            offlineScreen
        }
    }
}

extension TransactionListView {
    private var totalView: some View {
        VStack(alignment: .leading, spacing: 0) {
            Text(viewModel.totalValue)
                .font(.system(size: 17, weight: .semibold))
                .foregroundStyle(.blue)
            Text("listTotal")
                .font(.system(size: 15, weight: .light))
                .foregroundStyle(.black60)
        }
        .padding(10)
        .frame(maxWidth: .infinity, alignment: .leading)
        .applyPBBackground()
        .padding(.horizontal, 10)
    }

    private var transactionList: some View {
        ScrollView {
            LazyVStack(alignment: .leading, spacing: 10) {
                ForEach(viewModel.visibleTransactions) { data in
                    NavigationLink {
                        TransactionDetailView(for: data)
                    } label: {
                        transactionCell(for: data)
                    }
                }
            }
            .padding(.vertical, 10)
        }
        .refreshable {
            viewModel.getTransactions()
        }
    }

    func transactionCell(for data: TransactionViewData) -> some View {
        HStack(spacing: 0) {
            VStack(alignment: .leading, spacing: 0) {
                Text(data.partnerDisplayName)
                    .font(.system(size: 15, weight: .semibold))
                    .foregroundStyle(.blue)
                if let date = data.formattedDate {
                    Text(date)
                        .font(.system(size: 15, weight: .light))
                        .foregroundStyle(.black60)
                }
                if let description = data.description {
                    Text(description)
                        .font(.system(size: 15, weight: .regular))
                        .foregroundStyle(.black60)
                        .padding(.top, 5)
                }
            }
            Spacer(minLength: 10)
            Text(data.formattedValue)
                .font(.system(size: 17, weight: .semibold))
                .foregroundStyle(.black80)
        }
        .padding(10)
        .applyPBBackground()
        .padding(.horizontal, 10)
    }

    private var categoryPicker: some View {
        Picker("", selection: $viewModel.selectedCategory) {
            ForEach(viewModel.categories, id: \.value) { category in
                Text(category.description)
                    .tag(category.value)
            }
        }
    }

    private var sortPicker: some View {
        Picker("", selection: $viewModel.selectedSort) {
            ForEach(viewModel.sortedStates, id: \.rawValue) { state in
                Text(state.description)
                    .tag(state)
            }
        }
    }

    private var refreshButton: some View {
        Button(action: {
            viewModel.getTransactions()
        }, label: {
            if viewModel.isLoading {
                ProgressView()
                    .controlSize(.regular)
            } else {
                Image(systemName: "arrow.clockwise")
            }
        })
        .padding(10)
    }

    private var offlineScreen: some View {
        VStack(spacing: 10) {
            Text("offlineTitle")
                .font(.system(size: 25, weight: .semibold))
                .foregroundStyle(.blue)
            Text("offlineDescription")
                .font(.system(size: 20, weight: .regular))
                .foregroundStyle(.black60)
                .multilineTextAlignment(.center)
            ProgressView()
        }
    }
}
