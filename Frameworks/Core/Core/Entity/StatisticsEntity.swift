//
//  StatisticsEntity.swift
//  DatabaseLayer
//
//  Created by Глеб Капустин on 20.05.2025.
//

import Foundation
import RealmSwift

class StatisticsEntity: Object {
    @Persisted(primaryKey: true) var id: Int
    @Persisted var type: String
    @Persisted var dates: List<Date>
}
