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
    case monthVisitors(height: CGFloat)
    case filter(height: CGFloat)
    case diagramVisitors(height: CGFloat)
    case visitor(height: CGFloat)
    case roundedDiagramVisitors(height: CGFloat)
}
