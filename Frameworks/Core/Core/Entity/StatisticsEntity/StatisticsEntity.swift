//
//  StatisticsEntity.swift
//  DatabaseLayer
//
//  Created by Глеб Капустин on 20.05.2025.
//

import Foundation
import RealmSwift

public class StatisticsEntity: Object {
    @Persisted public var id: Int
    @Persisted public var type: String
    @Persisted public var dates: List<String>

    public override init() {}
}
