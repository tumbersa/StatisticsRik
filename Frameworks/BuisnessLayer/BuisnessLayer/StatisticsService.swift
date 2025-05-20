//
//  StatisticsService.swift
//  BuisnessLayer
//
//  Created by Глеб Капустин on 19.05.2025.
//

import Foundation
import NetworkLayer
import RxSwift

public final class StatisticsService {
    private let fetcher = Fetcher()
    private let bag = DisposeBag()
    public init() {}

    public func loadData()  {
        fetcher.fetchUsers()
            .subscribe (
                onNext: { users in
                    print(users)
                },
                onError: { error in
                    AppLogger.shared.logError("Error fetching users: \(error)")
                },
                onCompleted: {
                    AppLogger.shared.logInfo("Users fetch completed")
                }
            )
            .disposed(by: bag)
        fetcher.fetchStatistics()
            .subscribe (
                onNext: { statistics in
                    print(statistics)
                },
                onError: { error in
                    AppLogger.shared.logError("Error fetching statistics: \(error)")
                },
                onCompleted: {
                    AppLogger.shared.logInfo("Statistics fetch completed")
                }
            )
            .disposed(by: bag)
    }

}
