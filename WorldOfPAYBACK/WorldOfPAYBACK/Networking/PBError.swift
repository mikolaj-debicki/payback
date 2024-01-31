//
//  PBError.swift
//  WorldOfPAYBACK
//
//  Created by Mikołaj Dębicki on 31/01/2024.
//

import Foundation

public enum PBError: Error {
    case networkFailure
    case decodingFailure
}

extension PBError: LocalizedError {
    public var errorDescription: String? {
        switch self {
        case .decodingFailure:
            return "errorDecoding"
        case .networkFailure:
            return "errorNetwork"
        }
    }
}
