//
//  AgeStatisticsProcessor.swift
//  StatisticsRik
//
//  Created by Глеб Капустин on 24.05.2025.
//

import Foundation

enum AgeStatisticsProcessor {

    static let rangesAge: [String] = [
        "18-21", "22-25", "26-30", "31-35", "36-40", "40-50", ">50"
    ]

    static func groupModelsByAgeRange(models: [RoundedDiagramCellModel]) -> [[RoundedDiagramCellModel]] {
        return rangesAge.map { ageRange in
            models.filter { model in
                switch ageRange {
                    case "18-21": return (18...21).contains(model.age)
                    case "22-25": return (22...25).contains(model.age)
                    case "26-30": return (26...30).contains(model.age)
                    case "31-35": return (31...35).contains(model.age)
                    case "36-40": return (36...40).contains(model.age)
                    case "40-50": return (40...50).contains(model.age)
                    case ">50": return model.age > 50
                    default: return false
                }
            }
        }
    }

}
