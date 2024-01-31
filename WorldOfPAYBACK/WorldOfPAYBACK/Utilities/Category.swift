//
//  Category.swift
//  WorldOfPAYBACK
//
//  Created by Mikołaj Dębicki on 31/01/2024.
//

import Foundation
import SwiftUI

enum Category: Equatable {
    case showAll
    case regular(_ value: Int)

    var value: Int {
        switch self {
        case .showAll:
            return 0
        case let .regular(value):
            return value
        }
    }

    var description: LocalizedStringKey {
        switch self {
        case .showAll:
            return "categoryAll"
        case let .regular(value):
            return "category \(value)"
        }
    }
}
