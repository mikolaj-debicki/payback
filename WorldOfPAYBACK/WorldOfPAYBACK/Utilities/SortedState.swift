//
//  SortedState.swift
//  WorldOfPAYBACK
//
//  Created by Mikołaj Dębicki on 31/01/2024.
//

import Foundation
import SwiftUI

enum SortedState: Int, CaseIterable {
    case notSorted = 0
    case increasing = 1
    case decreasing = -1

    var description: LocalizedStringKey {
        switch self {
        case .notSorted:
            return "sortNotSorted"
        case .decreasing:
            return "sortDecreasing"
        case .increasing:
            return "sortIncreasing"
        }
    }
}
