//
//  MonthVisitorChangeCalculator.swift
//  BuisnessLayer
//
//  Created by Глеб Капустин on 22.05.2025.
//

import Foundation
import Core

public final class MonthVisitorChangeCalculator {

    public static let shared = MonthVisitorChangeCalculator()

    private init() {}

    public func calculateDecrease(statisticsModels: [StatisticsModel]) -> Int {
        let change = calculateChange(statisticsModels: statisticsModels)
        return change < 0 ? abs(change) : 0
    }

    public func calculateGrowth(statisticsModels: [StatisticsModel]) -> Int {
        let change = calculateChange(statisticsModels: statisticsModels)
        return change > 0 ? change : 0
    }

}

private extension MonthVisitorChangeCalculator {

    private func calculateChange(statisticsModels: [StatisticsModel]) -> Int {
        let lastDate = Date()
        let (currentMonth, currentYear) = getMonthAndYear(from: lastDate)
        let (previousMonth, previousYear) = getPreviousMonthAndYear(from: lastDate)

        let currentViews = uniqueUsersCount(
            in: statisticsModels,
            forMonth: currentMonth,
            year: currentYear
        )
        let previousViews = uniqueUsersCount(
            in: statisticsModels,
            forMonth: previousMonth,
            year: previousYear
        )

        return currentViews - previousViews
    }

    func getMonthAndYear(from date: Date) -> (month: Int, year: Int) {
        let calendar = Calendar.current
        return (
            calendar.component(.month, from: date),
            calendar.component(.year, from: date)
        )
    }

    func getPreviousMonthAndYear(from date: Date) -> (month: Int, year: Int) {
        let previousDate = Calendar.current.date(byAdding: .month, value: -1, to: date)!
        return getMonthAndYear(from: previousDate)
    }

    func uniqueUsersCount(in models: [StatisticsModel], forMonth month: Int, year: Int) -> Int {
        let filtered = models
            .filter { $0.type == .view }
            .flatMap { model in
                model.dates.map { date in (userId: model.id, date: date) }
            }
            .filter { entry in
                let components = Calendar.current.dateComponents([.month, .year], from: entry.date)
                return components.month == month && components.year == year
            }

        return Set(filtered.map { $0.userId }).count
    }

}
