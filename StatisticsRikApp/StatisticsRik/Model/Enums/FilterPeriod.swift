//
//  FilterPeriod.swift
//  StatisticsRik
//
//  Created by Глеб Капустин on 22.05.2025.
//

import Foundation

enum FilterPeriod: String, CaseIterable {
    case day = "По дням"
    case week = "По неделям"
    case month = "По месяцам"

    enum Extended: String, CaseIterable {
        case today = "Сегодня"
        case week = "Неделя"
        case month = "Месяц"
        case allTime = "Все время"
    }
}

extension FilterPeriod {

    func getLastSevenPeriods() -> [String] {
        let calendar = Calendar.current

        let now = Date()
        var periods = [String]()
        let dateFormatter = DateFormatter()

        switch self {
            case .day:
                dateFormatter.dateFormat = "dd.MM"
                for day in (0..<7).reversed() {
                    if let date = calendar.date(byAdding: .day, value: -day, to: now) {
                        periods.append(dateFormatter.string(from: date))
                    }
                }

            case .week:
                dateFormatter.dateFormat = "dd"
                for week in (0..<7).reversed() {
                    if let startOfWeek = calendar.date(byAdding: .weekOfYear, value: -week, to: now),
                       let endOfWeek = calendar.date(byAdding: .day, value: 6, to: startOfWeek) {
                        let startDay = dateFormatter.string(from: startOfWeek)
                        let endDay = dateFormatter.string(from: endOfWeek)
                        periods.append("\(startDay)-\(endDay)")
                    }
                }

            case .month:
                dateFormatter.dateFormat = "MM"
                for month in (0..<7).reversed() {
                    if let date = calendar.date(byAdding: .month, value: -month, to: now) {
                        periods.append(dateFormatter.string(from: date))
                    }
                }
        }

        return periods
    }

}
