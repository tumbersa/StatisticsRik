//
//  StatisticsViewController.swift
//  StatisticsRik
//
//  Created by Глеб Капустин on 19.05.2025.
//

import UIKit
import BuisnessLayer
import RxSwift
import Core
import PinLayout

final class StatisticsViewController: UIViewController {

    private let bag = DisposeBag()
    private var users: [UserModel] = []
    private var statistics: [StatisticsModel] = []
    private var blocks: [StatisticsViewBlock] = []

    private lazy var tableView = {
        let tableView = UITableView()
        tableView.separatorStyle = .none
        tableView.backgroundColor = .clear
        tableView.showsVerticalScrollIndicator = false
        tableView.dataSource = self
        tableView.delegate = self
        tableView.register(EmptyTableViewCell.self)
        view.addSubview(tableView)
        return tableView
    }()

    var statisticsDataProvider: IStatisticsDataProvider?

    override func viewDidLoad() {
        super.viewDidLoad()
        loadData()
        view.backgroundColor = Colors.background
        tableView.refreshControl = UIRefreshControl()
    }

    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(animated)
        tableView.pin
            .all()
            .margin(view.safeAreaInsets)
    }

}

private extension StatisticsViewController {

    func loadData() {
        guard let provider = statisticsDataProvider else { return }

        let usersObservable = provider.loadUsers()
        let statisticsObservable = provider.loadStatistics()

        Observable.zip(usersObservable, statisticsObservable)
            .observe(on: MainScheduler.instance)
            .subscribe(onNext: { [weak self] users, statistics in
                // TODO: - убрать принты
                print(users)
                print(statistics)
                self?.users = users
                self?.statistics = statistics

                let blocks = StatisticsBlockBuilder.buildBlocks(for: users, statistics: statistics)
                self?.blocks = blocks

                self?.tableView.reloadData()
            })
            .disposed(by: bag)
    }

}

extension StatisticsViewController: UITableViewDataSource {

    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        blocks.count
    }

    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let block = blocks[indexPath.row]
        switch block {
            case
                    .label,
                    .monthVisitors,
                    .filter,
                    .diagramVisitors,
                    .visitor,
                    .roundedDiagramVisitors:
                return UITableViewCell()
            case .empty:
                let cell: EmptyTableViewCell = tableView.dequeueReusableCell(for: indexPath)
                return cell
        }
    }

}

extension StatisticsViewController: UITableViewDelegate {

    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        let block = blocks[indexPath.row]

        switch block {
            case
                    .empty(let height),
                    .monthVisitors(let height),
                    .filter(let height),
                    .diagramVisitors(let height),
                    .visitor(let height),
                    .roundedDiagramVisitors(let height):
                return height
            case .label(let model):
                return model.height
        }
    }

}
