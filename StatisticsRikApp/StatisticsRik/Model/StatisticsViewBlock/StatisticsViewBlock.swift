//
//  StatisticsViewBlock.swift
//  StatisticsRik
//
//  Created by Глеб Капустин on 21.05.2025.
//

import Foundation

enum StatisticsViewBlock {
    case empty(height: CGFloat)
    case label(model: LabelCellModel)
    case monthVisitors(model: MonthVisitorsCellModel)
    case filter(height: CGFloat, items: [String])
    case diagramVisitors(height: CGFloat)
    case visitor(model: VisitorCellModel)
    case roundedDiagramVisitors(height: CGFloat, models: [RoundedDiagramCellModel])
}
