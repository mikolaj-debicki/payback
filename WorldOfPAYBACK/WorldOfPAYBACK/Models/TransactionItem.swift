//
//  TransactionItem.swift
//  WorldOfPAYBACK
//
//  Created by Mikołaj Dębicki on 29/01/2024.
//

import Foundation

struct TransactionItem: Decodable {
    let partnerDisplayName: String
    let alias: TransactionAlias
    let category: Int
    let transactionDetail: TransactionDetail
}
