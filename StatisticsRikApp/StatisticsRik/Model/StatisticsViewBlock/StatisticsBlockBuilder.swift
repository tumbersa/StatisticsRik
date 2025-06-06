//
//  StatisticsBlockBuilder.swift
//  StatisticsRik
//
//  Created by Глеб Капустин on 21.05.2025.
//

import Foundation
import Core
import BuisnessLayer

final class StatisticsBlockBuilder {

    static let shared = StatisticsBlockBuilder()

    private init() {}

    func buildBlocks(
        for users: [UserModel],
        statistics: [StatisticsModel],
        diagramFilterItems: [String],
        roundedDiagramFilterItems: [String]
    ) -> [StatisticsViewBlock] {
        var blocks: [StatisticsViewBlock] = []
        blocks.append(.empty(height: 48))
        blocks.append(headerBlock())
        blocks.append(.empty(height: 32))
        blocks.append(labelBlock(text: "Посетители"))
        blocks.append(.empty(height: 12))

        let growth = MonthVisitorChangeCalculator.shared.calculateGrowths(statisticsModels: statistics, numberOfMonths: 1).first ?? 0
        let monthVisiotsGrowths = MonthVisitorChangeCalculator.shared.calculateGrowths(statisticsModels: statistics, numberOfMonths: 6)
        blocks.append(
            growthMonthVisitorsBlock(
                monthVisiotsChange: monthVisiotsGrowths,
                growth: growth,
                height: 98,
                isFirst: true,
                isLast: true
            )
        )

        blocks.append(.empty(height: 28))
        blocks.append(.filter(height: 32, items: diagramFilterItems))
        blocks.append(.empty(height: 12))
        blocks.append(diagramVisitorsBlock(statistics: statistics))

        blocks.append(.empty(height: 28))
        blocks.append(labelBlock(text: "Чаще всех посещают Ваш профиль"))
        blocks.append(.empty(height: 12))
        blocks.append(contentsOf: visitorBlocks(users: users, statistics: statistics))

        blocks.append(.empty(height: 28))
        blocks.append(labelBlock(text: "Пол и Возраст"))
        blocks.append(.empty(height: 12))
        blocks.append(.filter(height: 32, items: roundedDiagramFilterItems))
        blocks.append(.empty(height: 12))
        blocks.append(roundedDiagramVisitorsBlock(users: users, statistics: statistics))

        blocks.append(.empty(height: 28))
        blocks.append(labelBlock(text: "Наблюдатели"))
        blocks.append(.empty(height: 12))

        blocks.append(
            growthMonthVisitorsBlock(
                monthVisiotsChange: monthVisiotsGrowths,
                growth: growth,
                height: 100,
                isFirst: true,
                isLast: false
            )
        )
        let decrease = MonthVisitorChangeCalculator.shared.calculateDecreases(statisticsModels: statistics, numberOfMonths: 1).first ?? 0
        let monthVisiotsDecreases = MonthVisitorChangeCalculator.shared.calculateDecreases(statisticsModels: statistics, numberOfMonths: 6)
        blocks.append(decreaseMonthVisitorsBlock(monthVisiotsChange: monthVisiotsDecreases, decrease: decrease))
        blocks.append(.empty(height: 32))
        return blocks
    }

}

private extension StatisticsBlockBuilder {

    func headerBlock() -> StatisticsViewBlock {
        return .label(model: .init(
            text: "Статистика",
            height: 40,
            font: Fonts.gilroyBold(size: 40).font
        ))
    }

    func labelBlock(text: String) -> StatisticsViewBlock {
        return .label(model: .init(
            text: text,
            height: 24,
            font: Fonts.gilroyBold(size: 20).font
        ))
    }

    func growthMonthVisitorsBlock(monthVisiotsChange: [Int], growth: Int, height: CGFloat, isFirst: Bool, isLast: Bool) -> StatisticsViewBlock {

        return .monthVisitors(model:  .init(
            title: "\(growth)",
            description: "Количество посетителей в этом месяце выросло",
            titleImage: Images.arrowUp,
            height: height,
            monthVisiotsChange: monthVisiotsChange,
            diagramColor: Colors.green2,
            isFirst: isFirst,
            isLast: isLast
        ))
    }

    func decreaseMonthVisitorsBlock(monthVisiotsChange: [Int], decrease: Int) -> StatisticsViewBlock {
        return .monthVisitors(model:  .init(
            title: "\(decrease)",
            description: "Пользователей перестали за Вами наблюдать",
            titleImage: Images.arrowDown,
            height: 100,
            monthVisiotsChange: monthVisiotsChange,
            diagramColor: Colors.red2,
            isFirst: false,
            isLast: true
        ))
    }

    func visitorBlocks(users: [UserModel], statistics: [StatisticsModel]) -> [StatisticsViewBlock] {
        let usersModel = TopUsersProvider.topViewedUsers(users: users, statistics: statistics)
        return usersModel.enumerated().map { index, userModel in
            let avatarUrl = userModel.files.filter { $0.type == .avatar }.map { $0.url }.first ?? ""
            let isFirst = index == 0
            let isLast = index == usersModel.count - 1

            return StatisticsViewBlock.visitor(model: .init(
                text: userModel.username + ", " + "\(userModel.age)",
                isOnline: userModel.isOnline,
                avatarImageData: userModel.avatarImageData,
                imageUrl: avatarUrl,
                isFirst: isFirst,
                isLast: isLast,
                height: 62
            ))
        }
    }

    func roundedDiagramVisitorsBlock(users: [UserModel],
                                     statistics: [StatisticsModel]) -> StatisticsViewBlock {
        let viewStatistics = statistics.filter{ $0.type == .view }
        var models: [RoundedDiagramCellModel] = []

        for statistic in viewStatistics {
            guard let user = users.first(where: { $0.id == statistic.id }) else {
                continue
            }

            let userModels = statistic.dates.map { date in
                RoundedDiagramCellModel(
                    userId: user.id,
                    date: date,
                    sex: user.sex,
                    age: user.age
                )
            }

            models.append(contentsOf: userModels)
        }

        return .roundedDiagramVisitors(height: 529, models: models)
    }

    func diagramVisitorsBlock(statistics: [StatisticsModel]) -> StatisticsViewBlock {
        let viewStatistics = statistics.filter { $0.type == .view }

        let models = viewStatistics.reduce(into: [DiagramVisitorsCellModel]()) { result, statistic in
            let diagramModels = statistic.dates.map { date in
                DiagramVisitorsCellModel(
                    userId: statistic.id,
                    date: date
                )
            }
            result.append(contentsOf: diagramModels)
        }

        return .diagramVisitors(height: 208, models: models)
    }

}

