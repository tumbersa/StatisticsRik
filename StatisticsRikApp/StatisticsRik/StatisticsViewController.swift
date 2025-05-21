//
//  StatisticsViewController.swift
//  StatisticsRik
//
//  Created by Глеб Капустин on 19.05.2025.
//

import UIKit
import BuisnessLayer
import RxSwift

final class StatisticsViewController: UIViewController {

    var statisticsDataProvider: IStatisticsDataProvider?
    let bag = DisposeBag()

    override func viewDidLoad() {
        super.viewDidLoad()
        statisticsDataProvider?.loadUsers()
            .subscribe (
                onNext: { users in
                    print(users)
                }
            )
            .disposed(by: bag)

        statisticsDataProvider?.loadStatistics()
            .subscribe (
                onNext: { statistics in
                    print(statistics)
                }
            )
            .disposed(by: bag)
        view.backgroundColor = .gray
    }

}
