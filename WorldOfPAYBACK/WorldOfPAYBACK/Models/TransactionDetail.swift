//
//  TransactionDetail.swift
//  WorldOfPAYBACK
//
//  Created by Mikołaj Dębicki on 29/01/2024.
//

import Foundation

struct TransactionDetail: Decodable {
    let description: String?
    let bookingDate: String
    let value: TransactionValue
}
