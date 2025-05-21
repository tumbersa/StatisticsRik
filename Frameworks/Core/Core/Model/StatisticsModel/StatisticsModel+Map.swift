//
//  StatisticsModel+Map.swift
//  Core
//
//  Created by Глеб Капустин on 21.05.2025.
//

import Foundation

public extension StatisticsModel {
    init(from statisticsEntry: StatisticsEntry.Statistic) {
        let dates = statisticsEntry.dates.compactMap { DateParser.stringToDate("\($0)") }
        self.init(
            id: statisticsEntry.userID,
            type: StatisticsTypeModel.init(rawValue: statisticsEntry.type) ?? .unknown,
            dates: dates
        )
    }

    init(from statisticsEntity: StatisticsEntity) {
        let dates = Array(statisticsEntity.dates).compactMap { DateParser.stringToDate("\($0)") }
        self.init(
            id: statisticsEntity.id,
            type: StatisticsTypeModel.init(rawValue: statisticsEntity.type) ?? .unknown,
            dates: dates
        )
    }
}
