//
//  Date+Ext.swift
//  Core
//
//  Created by Глеб Капустин on 23.05.2025.
//

import Foundation

public extension Date {

    func startOfDay() -> Date {
        return Calendar.current.startOfDay(for: self)
    }

    func startOfWeek() -> Date? {
        let calendar = Calendar.current
        let components = calendar.dateComponents([.yearForWeekOfYear, .weekOfYear], from: self)
        return calendar.date(from: components)
    }

    func endOfWeek() -> Date? {
        guard let start = startOfWeek() else { return nil }
        return Calendar.current.date(byAdding: .day, value: 6, to: start)
    }

    func startOfMonth() -> Date? {
        let calendar = Calendar.current
        let components = calendar.dateComponents([.year, .month], from: self)
        return calendar.date(from: components)
    }

}
