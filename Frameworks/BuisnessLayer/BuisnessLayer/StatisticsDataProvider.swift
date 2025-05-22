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
    func loadAvatarImageData(users: [UserModel]) -> Observable<[UserModel]>
}

public final class StatisticsDataProvider: IStatisticsDataProvider {

    private let imageFetcher = ImageFetcher()
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

    public func loadAvatarImageData(users: [UserModel]) -> Observable<[UserModel]> {
        let observables: [Observable<(String, Data)>] = users.map { user in
            guard let urlString = user.files.first(where: { $0.type == .avatar })?.url else {
                AppLogger.shared.logWarning("URL для аватара пользователя \(user.id) не найден.")
                return Observable.just((String(user.id), Data()))
            }

            return imageFetcher.fetchImageData(from: urlString)
                .map { data in (String(user.id), data) }
                .catch { error in
                    AppLogger.shared.logError("Ошибка загрузки аватара для пользователя \(user.id): \(error.localizedDescription)")
                    return .just((String(user.id), Data()))
                }
        }

        return Observable.zip(observables)
            .map { results -> [UserModel] in
                users.map { user in
                    var updatedUser = user
                    if let (_, data) = results.first(where: { $0.0 == String(user.id) }), !data.isEmpty {
                        updatedUser = updatedUser.withAvatarImageData(data)
                    }
                    return updatedUser
                }
            }
            .do(onNext: { [weak self] updatedUsers in
                updatedUsers.forEach { [weak self] user in
                    guard let self, let data = user.avatarImageData else { return }
                    realmManager.updateUser(id: user.id, avatarImageData: data)
                }
            }, onError: { error in
                AppLogger.shared.logError("Ошибка загрузки аватаров: \(error.localizedDescription)")
            })
    }

}

private extension StatisticsDataProvider {

    func cacheUsers(_ users: [UserModel]) {
        realmManager.clearObjects(UserEntity.self)
        users.forEach { user in
            let entity = UserEntity(from: user)
            self.realmManager.saveObject(entity, isUpdated: true)
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
        realmManager.clearObjects(StatisticsEntity.self)
        statistics.forEach { stat in
            let entity = StatisticsEntity(from: stat)
            realmManager.saveObject(entity)
        }
    }

}
