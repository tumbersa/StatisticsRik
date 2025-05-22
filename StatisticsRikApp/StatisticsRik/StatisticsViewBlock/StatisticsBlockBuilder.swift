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

        let growth = MonthVisitorChangeCalculator.shared.calculateGrowth(statisticsModels: statistics)
        blocks.append(growthMonthVisitorsBlock(growth: growth, height: 98, isFirst: true, isLast: true))

        blocks.append(.empty(height: 28))
        blocks.append(.filter(height: 32, items: diagramFilterItems))
        blocks.append(.empty(height: 12))
        blocks.append(.diagramVisitors(height: 208))

        blocks.append(.empty(height: 28))
        blocks.append(labelBlock(text: "Чаще всех посещают Ваш профиль"))
        blocks.append(.empty(height: 12))
        blocks.append(contentsOf: visitorBlocks(users: users, statistics: statistics))

        blocks.append(.empty(height: 28))
        blocks.append(labelBlock(text: "Пол и Возраст"))
        blocks.append(.empty(height: 12))
        blocks.append(.filter(height: 32, items: roundedDiagramFilterItems))
        blocks.append(.empty(height: 12))
        blocks.append(.roundedDiagramVisitors(height: 529))

        blocks.append(.empty(height: 28))
        blocks.append(labelBlock(text: "Наблюдатели"))
        blocks.append(.empty(height: 12))
        blocks.append(growthMonthVisitorsBlock(growth: growth, height: 100, isFirst: true, isLast: false))
        let decrease = MonthVisitorChangeCalculator.shared.calculateDecrease(statisticsModels: statistics)
        blocks.append(decreaseMonthVisitorsBlock(decrease: decrease))
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

    func growthMonthVisitorsBlock(growth: Int, height: CGFloat, isFirst: Bool, isLast: Bool) -> StatisticsViewBlock {

        return .monthVisitors(model:  .init(
            title: "\(growth)",
            description: "Количество посетителей в этом месяце выросло",
            titleImage: Images.arrowUp,
            height: height,
            isFirst: isFirst,
            isLast: isLast
        ))
    }

    func decreaseMonthVisitorsBlock(decrease: Int) -> StatisticsViewBlock {
        return .monthVisitors(model:  .init(
            title: "\(decrease)",
            description: "Пользователей перестали за Вами наблюдать",
            titleImage: Images.arrowDown,
            height: 100,
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

}

