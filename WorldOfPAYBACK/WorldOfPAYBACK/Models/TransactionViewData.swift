//
//  TransactionViewData.swift
//  WorldOfPAYBACK
//
//  Created by Mikołaj Dębicki on 29/01/2024.
//

import Foundation

struct TransactionViewData: Identifiable {
    let id = UUID()
    let partnerDisplayName: String
    let category: Int
    let date: String
    let formattedDate: String?
    let description: String?
    let formattedValue: String
    let rawValue: Int
    let currency: String
    
    init(from data: TransactionItem) {
        partnerDisplayName = data.partnerDisplayName
        category = data.category
        date = data.transactionDetail.bookingDate
        formattedDate = PBDateFormatter.formatDateString(date)
        description = data.transactionDetail.description
        rawValue = data.transactionDetail.value.amount
        currency = data.transactionDetail.value.currency
        formattedValue = rawValue.formatted(.currency(code: currency))
    }
    
}
