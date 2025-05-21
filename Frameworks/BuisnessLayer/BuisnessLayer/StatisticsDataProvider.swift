//
//  StatisticsDataProvider.swift
//  BuisnessLayer
//
//  Created by Глеб Капустин on 19.05.2025.
//

import Core
import Foundation
import NetworkLayer
import RxSwift
import DatabaseLayer

public protocol IStatisticsDataProvider {
    func loadUsers() -> Observable<[UserModel]>
    func fetchRemoteUsers() -> Observable<[UserModel]>
    func loadStatistics() -> Observable<[StatisticsModel]>
    func fetchRemoteStatistics() -> Observable<[StatisticsModel]>
}

public final class StatisticsDataProvider: IStatisticsDataProvider {

    private let fetcher: IFetcher
    private let realmManager: IRealmManager

    public init(fetcher: IFetcher, realmManager: IRealmManager) {
        self.fetcher = fetcher
        self.realmManager = realmManager
    }

    public func loadUsers() -> Observable<[UserModel]> {
        return loadCachedUsers()
            .flatMap { [weak self] cachedUsers in
                if let self, cachedUsers.isEmpty {
                    return fetchRemoteUsers()
                } else {
                    return .just(cachedUsers)
                }
            }
    }

    public func fetchRemoteUsers() -> Observable<[UserModel]> {
        return fetcher.fetchUsers()
            .map { [weak self] usersEntry in
                let userModels = usersEntry.users.map { UserModel(from: $0) }
                self?.cacheUsers(userModels)
                return userModels
            }
            .do(
                onNext: { _ in
                    AppLogger.shared.logInfo("Users fetched and cached successfully.")
                },
                onError: { error in
                    AppLogger.shared.logError("Error fetching users: \(error)")
                }
            )
    }

    public func loadStatistics() -> Observable<[StatisticsModel]> {
        return loadCachedStatistics()
            .flatMap { [weak self] cachedStats in
                if let self, cachedStats.isEmpty {
                    return self.fetchRemoteStatistics()
                } else {
                    return .just(cachedStats)
                }
            }
    }

    public func fetchRemoteStatistics() -> Observable<[StatisticsModel]> {
        return fetcher.fetchStatistics()
            .map { [weak self] statisticsEntry in
                let statisticsModels = statisticsEntry.statistics.map { StatisticsModel(from: $0) }
                self?.cacheStatistics(statisticsModels)
                return statisticsModels
            }
            .do(
                onNext: { _ in
                    AppLogger.shared.logInfo("Statistics fetched and cached successfully.")
                },
                onError: { error in
                    AppLogger.shared.logError("Error fetching statistics: \(error)")
                }
            )
    }

}

private extension StatisticsDataProvider {

    func cacheUsers(_ users: [UserModel]) {
        users.forEach { user in
            let entity = UserEntity(from: user)
            self.realmManager.saveObject(entity)
        }
    }

    func loadCachedUsers() -> Observable<[UserModel]> {
        let userEntities: [UserEntity] = realmManager.getObjects()
        let userModels = userEntities.map { UserModel(from: $0) }
        return .just(userModels)
    }

    func loadCachedStatistics() -> Observable<[StatisticsModel]> {
        let statisticsEntities: [StatisticsEntity] = realmManager.getObjects()
        let statisticsModels = statisticsEntities.map { StatisticsModel(from: $0) }
        return .just(statisticsModels)
    }

    func cacheStatistics(_ statistics: [StatisticsModel]) {
        statistics.forEach { stat in
            let entity = StatisticsEntity(from: stat)
            realmManager.saveObject(entity)
        }
    }

}
