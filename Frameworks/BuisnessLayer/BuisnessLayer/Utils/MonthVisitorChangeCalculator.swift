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

    // MARK: - Public

    /// Calculates visitor decreases for the specified number of months
    /// - Parameters:
    ///   - statisticsModels: Array of statistics data
    ///   - numberOfMonths: How many months to analyze (default: 6)
    /// - Returns: Array of decreases (absolute values) for each month-to-month comparison
    public func calculateDecreases(
        statisticsModels: [StatisticsModel],
        numberOfMonths: Int = 6
    ) -> [Int] {
        return calculateChanges(
            statisticsModels: statisticsModels,
            numberOfMonths: numberOfMonths
        ).map { change in
            change < 0 ? abs(change) : 0
        }
    }

    /// Calculates visitor growth for the specified number of months
    /// - Parameters:
    ///   - statisticsModels: Array of statistics data
    ///   - numberOfMonths: How many months to analyze (default: 6)
    /// - Returns: Array of growth values for each month-to-month comparison
    public func calculateGrowths(
        statisticsModels: [StatisticsModel],
        numberOfMonths: Int = 6
    ) -> [Int] {
        return calculateChanges(
            statisticsModels: statisticsModels,
            numberOfMonths: numberOfMonths
        ).map { change in
            change > 0 ? change : 0
        }
    }

    /// Calculates raw visitor changes for the specified number of months
    /// - Parameters:
    ///   - statisticsModels: Array of statistics data
    ///   - numberOfMonths: How many months to analyze (default: 6)
    /// - Returns: Array of changes (positive and negative) for each month-to-month comparison
    public func calculateChanges(
        statisticsModels: [StatisticsModel],
        numberOfMonths: Int = 6
    ) -> [Int] {

        let calendar = Calendar.current
        let now = Date()

        // Get the specified number of months (including current)
        let monthsInfo: [(month: Int, year: Int)] = (0..<numberOfMonths).map { i in
            let date = calendar.date(byAdding: .month, value: -i, to: now)!
            return getMonthAndYear(from: date)
        }.reversed()

        // Get unique user counts for each month
        let monthlyCounts = monthsInfo.map { month, year in
            uniqueUsersCount(in: statisticsModels, forMonth: month, year: year)
        }

        // Calculate changes between consecutive months
        var changes = [Int]()
        for i in 0..<monthlyCounts.count {
            changes.append( i == 0 ? monthlyCounts[i] : monthlyCounts[i] - monthlyCounts[i-1])
        }

        return changes
    }

}

private extension MonthVisitorChangeCalculator {

    private func getMonthAndYear(from date: Date) -> (month: Int, year: Int) {
        let calendar = Calendar.current
        return (
            calendar.component(.month, from: date),
            calendar.component(.year, from: date)
        )
    }

    private func uniqueUsersCount(
        in models: [StatisticsModel],
        forMonth month: Int,
        year: Int
    ) -> Int {
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
