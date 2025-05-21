//
//  StatisticsModel.swift
//  Core
//
//  Created by Глеб Капустин on 20.05.2025.
//

import Foundation

public struct StatisticsModel {
    public let id: Int
    public let type: StatisticsTypeModel
    public let dates: [Date]
}

public enum StatisticsTypeModel: String {
    case view
    case subscription
    case unsubscription
    case unknown
}
