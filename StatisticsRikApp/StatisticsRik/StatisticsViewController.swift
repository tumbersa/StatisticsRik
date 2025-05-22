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
import DatabaseLayer

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
        tableView.register(LabelTableViewCell.self)
        tableView.register(MonthVisitorsTableViewCell.self)
        tableView.register(VisitorTableViewCell.self)
        view.addSubview(tableView)
        return tableView
    }()

    private let refreshControl = UIRefreshControl()

    var statisticsDataProvider: IStatisticsDataProvider?

    override func viewDidLoad() {
        super.viewDidLoad()
//        RealmManager().deleteDatabaseFiles()
//        RealmManager().clearDatabase()
        loadData()

        view.backgroundColor = Colors.background
        tableView.refreshControl = refreshControl
        refreshControl.addTarget(self, action: #selector(refresh), for: .valueChanged)
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
                self?.users = users
                self?.statistics = statistics
                self?.loadAvatarImageData()
                self?.reloadData()
            })
            .disposed(by: bag)
    }

    @objc
    func refresh() {
        guard let provider = statisticsDataProvider else { return }

        let usersObservable = provider.fetchRemoteUsers()
        let statisticsObservable = provider.fetchRemoteStatistics()

        Observable.zip(usersObservable, statisticsObservable)
            .observe(on: MainScheduler.instance)
            .subscribe(onNext: { [weak self] users, statistics in
                self?.users = users
                self?.statistics = statistics
                self?.loadAvatarImageData()

                self?.reloadData()
                self?.refreshControl.endRefreshing()
            })
            .disposed(by: bag)
    }

    func reloadData() {
        let blocks = StatisticsBlockBuilder.shared.buildBlocks(for: users, statistics: statistics)
        self.blocks = blocks

        tableView.reloadData()
    }

    func loadAvatarImageData() {
        let usersModel = TopUsersProvider.topViewedUsers(users: users, statistics: statistics)
        statisticsDataProvider?.loadAvatarImageData(users: usersModel)
            .observe(on: MainScheduler.instance)
            .subscribe(onNext: { [weak self] users in
                self?.users = users

                self?.reloadVisitors()
            })
            .disposed(by: bag)
    }

    func reloadVisitors() {
        let blocks = StatisticsBlockBuilder.shared.buildBlocks(for: users, statistics: statistics)
        self.blocks = blocks
        let indexPaths = blocks.enumerated()
            .compactMap { index, block in
                if case .visitor = block {
                    return IndexPath(row: index, section: 0)
                } else {
                    return nil
                }
            }
        tableView.reloadRows(at: indexPaths, with: .automatic)
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
                    .filter,
                    .diagramVisitors,
                    .roundedDiagramVisitors:
                return UITableViewCell()
            case .empty:
                let cell: EmptyTableViewCell = tableView.dequeueReusableCell(for: indexPath)
                return cell
            case .label(let model):
                let cell: LabelTableViewCell = tableView.dequeueReusableCell(for: indexPath)
                cell.set(model: model)
                return cell
            case .monthVisitors(let model):
                let cell: MonthVisitorsTableViewCell = tableView.dequeueReusableCell(for: indexPath)
                cell.set(model: model)
                return cell
            case .visitor(let model):
                let cell: VisitorTableViewCell = tableView.dequeueReusableCell(for: indexPath)
                cell.set(model: model)
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
                    .filter(let height),
                    .diagramVisitors(let height),
                    .roundedDiagramVisitors(let height):
                return height
            case .label(let model):
                return model.height
            case .monthVisitors(let model):
                return model.height
            case .visitor(let model):
                return model.height
        }
    }

}
