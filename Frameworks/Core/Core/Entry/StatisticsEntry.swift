//
//  StatisticsEntry.swift
//  NetworkLayer
//
//  Created by Глеб Капустин on 20.05.2025.
//

import Foundation

// MARK: - StatisticsEntry
public struct StatisticsEntry: Codable {
    public let statistics: [Statistic]

    // MARK: - Statistic
    public struct Statistic: Codable {
        public let userID: Int
        public let type: String
        public let dates: [Int]

        enum CodingKeys: String, CodingKey {
            case userID = "user_id"
            case type, dates
        }
    }
}

