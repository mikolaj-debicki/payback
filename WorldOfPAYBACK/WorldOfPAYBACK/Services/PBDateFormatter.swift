//
//  PBDateFormatter.swift
//  WorldOfPAYBACK
//
//  Created by Mikołaj Dębicki on 29/01/2024.
//

import Foundation

final class PBDateFormatter {
    static func formatDateString(_ dateString: String) -> String? {
        let dateFormatter = DateFormatter()
        dateFormatter.dateFormat = "yyyy-MM-dd'T'HH:mm:ssZ"

        if let date = dateFormatter.date(from: dateString) {
            let formattedDateFormatter = DateFormatter()
            formattedDateFormatter.dateStyle = .medium
            formattedDateFormatter.timeStyle = .short
            formattedDateFormatter.locale = .autoupdatingCurrent

            return formattedDateFormatter.string(from: date)
        }

        return nil
    }
}
