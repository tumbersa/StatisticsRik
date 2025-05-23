//
//  DiagramFilterService.swift
//  BuisnessLayer
//
//  Created by Глеб Капустин on 22.05.2025.
//

import Foundation

enum DiagramFilterService {

    static func filterModels(
        _ cells: [RoundedDiagramCellModel],
        by period: FilterPeriod.Extended,
        currentDate: Date = Date()
    ) -> [RoundedDiagramCellModel] {
        let calendar = Calendar.current
        let filteredCells: [RoundedDiagramCellModel]

        switch period {
        case .today:
            let startOfDay = calendar.startOfDay(for: currentDate)
            filteredCells = cells.filter { $0.date >= startOfDay }

        case .week:
            guard let startOfWeek = calendar.date(from: calendar.dateComponents([.yearForWeekOfYear, .weekOfYear], from: currentDate)) else {
                return []
            }
            filteredCells = cells.filter { $0.date >= startOfWeek }

        case .month:
            guard let startOfMonth = calendar.date(from: calendar.dateComponents([.year, .month], from: currentDate)) else {
                return []
            }
            filteredCells = cells.filter { $0.date >= startOfMonth }

        case .allTime:
            filteredCells = cells
        }

        var uniqueUserIds = Set<Int>()
        return filteredCells.reduce(into: []) { result, model in
            if !uniqueUserIds.contains(model.userId) {
                uniqueUserIds.insert(model.userId)
                result.append(model)
            }
        }
    }

    static func filterModels(
        _ cells: [DiagramVisitorsCellModel],
        by period: FilterPeriod,
        currentDate: Date = Date()
    ) -> [DiagramVisitorsCellModel] {
        let calendar = Calendar.current
        let filteredCells: [DiagramVisitorsCellModel]

        switch period {
        case .day:
            guard let startDate = calendar.date(byAdding: .day, value: -6, to: calendar.startOfDay(for: currentDate)) else {
                return []
            }
            filteredCells = cells.filter { $0.date >= startDate }

        case .week:
            guard let startOfCurrentWeek = calendar.date(from: calendar.dateComponents([.yearForWeekOfYear, .weekOfYear], from: currentDate)),
                  let startDate = calendar.date(byAdding: .weekOfYear, value: -6, to: startOfCurrentWeek) else {
                return []
            }
            filteredCells = cells.filter { $0.date >= startDate }

        case .month:
            guard let startOfCurrentMonth = calendar.date(from: calendar.dateComponents([.year, .month], from: currentDate)),
                  let startDate = calendar.date(byAdding: .month, value: -6, to: startOfCurrentMonth) else {
                return []
            }
            filteredCells = cells.filter { $0.date >= startDate }
        }

        var uniqueUserIds = Set<Int>()
        return filteredCells.reduce(into: []) { result, model in
            if !uniqueUserIds.contains(model.userId) {
                uniqueUserIds.insert(model.userId)
                result.append(model)
            }
        }.sorted { $0.date > $1.date }
    }

}
