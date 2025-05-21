//
//  StatisticsEntity+Map.swift
//  DatabaseLayer
//
//  Created by Глеб Капустин on 20.05.2025.
//

import Foundation
import RealmSwift

public extension StatisticsEntity {
    convenience init(from statisticsModel: StatisticsModel) {
        self.init()
        self.id = statisticsModel.id
        self.type = statisticsModel.type.rawValue
        let dates = List<String>()
        statisticsModel.dates.forEach{ date in
            let string = DateParser.dateToString(date) ?? ""
            dates.append(string)
        }
        self.dates = dates
    }
}
