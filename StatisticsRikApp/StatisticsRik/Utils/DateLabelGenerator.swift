//
//  DateLabelGenerator.swift
//  StatisticsRik
//
//  Created by Глеб Капустин on 24.05.2025.
//

import Foundation

struct DateLabelFormatter {

    private let calendar: Calendar
    private let locale: Locale

    init(calendar: Calendar = .current, locale: Locale = Locale(identifier: "ru_RU")) {
        self.calendar = calendar
        self.locale = locale
    }

    func generateLabels(for period: FilterPeriod, referenceDate: Date = Date()) -> [String] {
        var labels = [String](repeating: "", count: 7)

        for i in 0..<7 {
            let label = labelForPeriod(period, offset: i, referenceDate: referenceDate)
            labels[6 - i] = label
        }

        return labels
    }

}

private extension DateLabelFormatter {

    func labelForPeriod(_ period: FilterPeriod, offset: Int, referenceDate: Date) -> String {
        let dateFormatter = DateFormatter()
        dateFormatter.locale = locale

        switch period {
        case .day:
            return dayLabel(offset: offset, referenceDate: referenceDate, formatter: dateFormatter)
        case .week:
            return weekLabel(offset: offset, referenceDate: referenceDate)
        case .month:
            return monthLabel(offset: offset, referenceDate: referenceDate, formatter: dateFormatter)
        }
    }

    func dayLabel(offset: Int, referenceDate: Date, formatter: DateFormatter) -> String {
        guard let date = calendar.date(byAdding: .day, value: -offset, to: referenceDate) else { return "" }
        formatter.dateFormat = "d MMMM"
        return formatter.string(from: date)
    }

    func weekLabel(offset: Int, referenceDate: Date) -> String {
        guard let weekStart = calendar.date(byAdding: .weekOfYear, value: -offset, to: referenceDate)?.startOfWeek(),
              let weekEnd = calendar.date(byAdding: .weekOfYear, value: -offset, to: referenceDate)?.endOfWeek() else {
            return ""
        }

        let startFormatter = DateFormatter()
        startFormatter.locale = locale
        startFormatter.dateFormat = "d"

        let endFormatter = DateFormatter()
        endFormatter.locale = locale
        endFormatter.dateFormat = "d MMMM"

        let startStr = startFormatter.string(from: weekStart)
        let endStr = endFormatter.string(from: weekEnd)
        return "\(startStr)–\(endStr)"
    }

    func monthLabel(offset: Int, referenceDate: Date, formatter: DateFormatter) -> String {
        guard let monthStart = calendar.date(byAdding: .month, value: -offset, to: referenceDate)?.startOfMonth() else {
            return ""
        }
        formatter.dateFormat = "LLLL"
        return formatter.string(from: monthStart).capitalized
    }

}
