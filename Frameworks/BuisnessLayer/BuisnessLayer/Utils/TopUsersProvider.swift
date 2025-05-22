//
//  TopUsersProvider.swift
//  BuisnessLayer
//
//  Created by Глеб Капустин on 22.05.2025.
//

import Foundation
import Core

public enum TopUsersProvider {

    public static func topViewedUsers(users: [UserModel], statistics: [StatisticsModel], limit: Int = 3) -> [UserModel] {
        let usersId = Set(
            statistics
                .filter { $0.type == .view }
                .map { $0.id }
                .sorted(by: >)
        )
            .prefix(limit)
            .sorted(by: >)

        return usersId.compactMap { userId in
            users.first { $0.id == userId }
        }
    }

}
