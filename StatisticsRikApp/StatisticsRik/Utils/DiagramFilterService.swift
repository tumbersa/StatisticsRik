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

}
