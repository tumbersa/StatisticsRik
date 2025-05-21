//
//  StatisticsBlockBuilder.swift
//  StatisticsRik
//
//  Created by Глеб Капустин on 21.05.2025.
//

import Foundation
import Core

final class StatisticsBlockBuilder {

    static func buildBlocks(for user: [UserModel], statistics: [StatisticsModel]) -> [StatisticsViewBlock] {
        var blocks: [StatisticsViewBlock] = []
        blocks.append(.empty(height: 48))
        blocks.append(headerBlock())
        blocks.append(.empty(height: 32))
        blocks.append(labelBlock(text: "Посетители"))
        blocks.append(.empty(height: 12))
        blocks.append(.monthVisitors(height: 98))
        blocks.append(.empty(height: 28))
        blocks.append(.filter(height: 32))
        blocks.append(.empty(height: 12))
        blocks.append(.diagramVisitors(height: 208))
        blocks.append(.empty(height: 28))
        blocks.append(labelBlock(text: "Чаще всех посещают Ваш профиль"))
        blocks.append(.empty(height: 12))
        blocks.append(.visitor(height: 62))
        blocks.append(.visitor(height: 62))
        blocks.append(.visitor(height: 62))
        blocks.append(.empty(height: 28))
        blocks.append(labelBlock(text: "Пол и Возраст"))
        blocks.append(.empty(height: 12))
        blocks.append(.filter(height: 32))
        blocks.append(.empty(height: 12))
        blocks.append(.roundedDiagramVisitors(height: 529))
        blocks.append(.empty(height: 28))
        blocks.append(labelBlock(text: "Наблюдатели"))
        blocks.append(.empty(height: 12))
        blocks.append(.monthVisitors(height: 100))
        blocks.append(.monthVisitors(height: 100))
        blocks.append(.empty(height: 32))
        return blocks
    }

}

private extension StatisticsBlockBuilder {

    static func headerBlock() -> StatisticsViewBlock {
        return .label(model: .init(
            text: "Статистика",
            height: 40,
            font: Fonts.gilroyBold(size: 40).font
        ))
    }

    static func labelBlock(text: String) -> StatisticsViewBlock {
        return .label(model: .init(
            text: text,
            height: 24,
            font: Fonts.gilroyBold(size: 20).font
        ))
    }

}
