//
//  DateParser.swift
//  Core
//
//  Created by Глеб Капустин on 21.05.2025.
//

import Foundation

enum DateParser {
    static let dateFormatter = DateFormatter()

    static func stringToDate(_ dateString: String) -> Date? {
        let dateFormatter = DateParser.dateFormatter

        switch dateString.count {
            case 8:
                dateFormatter.dateFormat = "ddMMyyyy"
            case 7:
                dateFormatter.dateFormat = "dMMyyyy"
            default:
                return nil
        }

        return dateFormatter.date(from: dateString)
    }

    static func dateToString(_ date: Date) -> String? {
        let calendar = Calendar.current
        let components = calendar.dateComponents([.day, .month, .year], from: date)

        guard let day = components.day, let month = components.month, let year = components.year else {
            return nil
        }

        if day >= 10 {
            return String(format: "%02d%02d%04d", day, month, year)
        } else {
            return String(format: "%d%02d%04d", day, month, year)
        }
    }
}
