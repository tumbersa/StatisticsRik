//
//  FilterPeriod.swift
//  StatisticsRik
//
//  Created by Глеб Капустин on 22.05.2025.
//

import Foundation

enum FilterPeriod: String, CaseIterable {
    case today = "По дням"
    case week = "По неделям"
    case month = "По месяцам"

    enum Extended: String, CaseIterable {
        case today = "Сегодня"
        case week = "Неделя"
        case month = "Месяц"
        case allTime = "Все время"
    }
}
