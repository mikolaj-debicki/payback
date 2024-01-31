//
//  TransactionValue.swift
//  WorldOfPAYBACK
//
//  Created by Mikołaj Dębicki on 29/01/2024.
//

import Foundation

struct TransactionValue: Decodable {
    let amount: Int
    let currency: String
}
