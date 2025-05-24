//
//  VisitorStatisticsProcessor.swift
//  StatisticsRik
//
//  Created by Глеб Капустин on 24.05.2025.
//

import Foundation

enum VisitorStatisticsProcessor {

    static func calculateVisitorCounts(
        from models: [DiagramVisitorsCellModel],
        for period: FilterPeriod
    ) -> [Int] {
        let calendar = Calendar.current
        let now = Date()
        var result = [Int](repeating: 0, count: 7)

        for i in 0..<7 {
            let (startDate, endDate): (Date, Date)

            switch period {
            case .day:
                guard let dayStart = calendar.date(byAdding: .day, value: -i, to: now)?.startOfDay(),
                      let dayEnd = calendar.date(byAdding: .day, value: -i + 1, to: now)?.startOfDay() else { continue }
                startDate = dayStart
                endDate = dayEnd

            case .week:
                guard let weekStart = calendar.date(byAdding: .weekOfYear, value: -i, to: now)?.startOfWeek(),
                      let weekEnd = calendar.date(byAdding: .weekOfYear, value: -i + 1, to: now)?.startOfWeek() else { continue }
                startDate = weekStart
                endDate = weekEnd

            case .month:
                guard let monthStart = calendar.date(byAdding: .month, value: -i, to: now)?.startOfMonth(),
                      let monthEnd = calendar.date(byAdding: .month, value: -i + 1, to: now)?.startOfMonth() else { continue }
                startDate = monthStart
                endDate = monthEnd
            }

            let filteredUsers = models.filter { $0.date >= startDate && $0.date < endDate }
            let uniqueUserIds = Set(filteredUsers.map { $0.userId })
            result[6 - i] = uniqueUserIds.count
        }

        return result
    }

    static func getLastSevenPeriods(filterPeriod: FilterPeriod) -> [String] {
        let calendar = Calendar.current

        let now = Date()
        var periods = [String]()
        let dateFormatter = DateFormatter()

        switch filterPeriod {
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
                    if let startOfWeek = calendar.date(byAdding: .weekOfYear, value: -week, to: now)?.startOfWeek(),
                       let endOfWeek = calendar.date(byAdding: .weekOfYear, value: -week, to: now)?.endOfWeek() {
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
