//
//  StatisticsEntry.swift
//  NetworkLayer
//
//  Created by Глеб Капустин on 20.05.2025.
//

import Foundation

// MARK: - StatisticsEntry
public struct StatisticsEntry: Codable {
    let statistics: [Statistic]

    // MARK: - Statistic
    public struct Statistic: Codable {
        let userID: Int
        let type: String
        let dates: [Int]

        enum CodingKeys: String, CodingKey {
            case userID = "user_id"
            case type, dates
        }
    }
}

