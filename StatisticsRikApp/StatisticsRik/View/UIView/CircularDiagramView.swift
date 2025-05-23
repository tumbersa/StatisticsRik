//
//  CircularDiagramView.swift
//  StatisticsRik
//
//  Created by Глеб Капустин on 23.05.2025.
//

import Foundation
import Core
import UIKit

final class CircularDiagramView: UIView {

    private struct Appearance {
        static let lineWidth: CGFloat = 10.0
        static let remainderColor = Colors.red
        static let progressColor = Colors.apricot
        static let emptyStateColor = Colors.gray
    }

    private lazy var progressLayer: CAShapeLayer = {
        let layer = CAShapeLayer()
        layer.lineWidth = Appearance.lineWidth
        layer.lineCap = .round
        layer.strokeStart = 0
        layer.strokeEnd = 0
        layer.fillColor = UIColor.clear.cgColor
        layer.strokeColor = Appearance.progressColor.cgColor

        return layer
    }()

    private lazy var remainderLayer: CAShapeLayer = {
        let layer = CAShapeLayer()
        layer.lineWidth = Appearance.lineWidth
        layer.lineCap = .round
        layer.strokeStart = 0
        layer.strokeEnd = 1
        layer.fillColor = UIColor.clear.cgColor
        layer.strokeColor = Appearance.remainderColor.cgColor
        return layer
    }()

    init() {
        super.init(frame: .zero)
        loadLayout()
    }

    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }

    private func loadLayout() {
        layer.addSublayer(progressLayer)
        layer.addSublayer(remainderLayer)
    }

    override func layoutSubviews() {
        super.layoutSubviews()

        let circlePath = UIBezierPath(
            arcCenter: CGPoint(x: bounds.midX, y: bounds.midY),
            radius: (bounds.width - Appearance.lineWidth) / 2,
            startAngle: -CGFloat.pi / 2,
            endAngle: CGFloat.pi * 3 / 2,
            clockwise: true
        ).cgPath

        progressLayer.path = circlePath
        remainderLayer.path = circlePath
    }

    func setProgress(_ progress: CGFloat) {
        let clampedProgress = max(min(progress, 0.93), 0)

        if clampedProgress == 0 {
            guard remainderLayer.strokeColor != Appearance.emptyStateColor.cgColor else {
                return
            }
            remainderLayer.strokeColor = Appearance.emptyStateColor.cgColor
            progressLayer.strokeColor = Appearance.emptyStateColor.cgColor
            remainderLayer.strokeStart = 0
            remainderLayer.strokeEnd = 1
            progressLayer.strokeEnd = 0
            return
        }

        remainderLayer.strokeColor = Appearance.remainderColor.cgColor
        progressLayer.strokeColor = Appearance.progressColor.cgColor
        progressLayer.strokeEnd = clampedProgress

        let gap = 0.03
        remainderLayer.strokeStart = clampedProgress + gap
        remainderLayer.strokeEnd = 0.97
    }

}

