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

    private enum Constants {
        static let remainderAnimationKey = "remainder"
        static let progressAnimationKey = "progress"
    }

    private let lineWidth: CGFloat
    private let remainderColor: UIColor
    private let progressColor: UIColor
    private let emptyStateColor: UIColor


    private lazy var progressLayer: CAShapeLayer = {
        let layer = CAShapeLayer()
        layer.lineWidth = lineWidth
        layer.lineCap = .round
        layer.strokeStart = 0
        layer.strokeEnd = 0
        layer.fillColor = UIColor.clear.cgColor
        layer.strokeColor = progressColor.cgColor

        return layer
    }()

    private lazy var remainderLayer: CAShapeLayer = {
        let layer = CAShapeLayer()
        layer.lineWidth = lineWidth
        layer.lineCap = .round
        layer.strokeStart = 0
        layer.strokeEnd = 1
        layer.fillColor = UIColor.clear.cgColor
        layer.strokeColor = remainderColor.cgColor
        return layer
    }()

    init(lineWidth: CGFloat, remainderColor: UIColor, progressColor: UIColor, emptyStateColor: UIColor) {
        self.lineWidth = lineWidth
        self.remainderColor = remainderColor
        self.progressColor = progressColor
        self.emptyStateColor = emptyStateColor
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
            radius: (bounds.width - lineWidth) / 2,
            startAngle: -CGFloat.pi / 2,
            endAngle: CGFloat.pi * 3 / 2,
            clockwise: true
        ).cgPath

        progressLayer.path = circlePath
        remainderLayer.path = circlePath
    }

    func setProgress(_ progress: CGFloat, animated: Bool = false) {
        let clampedProgress = max(min(progress, 0.93), 0)

        if clampedProgress == 0 {
            if animated {
                UIView.animate(withDuration: 0.3) {
                    self.setEmptyState()
                }
            } else {
                self.setEmptyState()
            }
            removeAnimations()
            return
        }

        remainderLayer.strokeColor = remainderColor.cgColor
        let gap = 0.03

        if animated {
            let animation = CABasicAnimation(keyPath: "strokeEnd")
            animation.fromValue = progressLayer.strokeEnd
            animation.toValue = clampedProgress
            animation.duration = 1
            animation.timingFunction = CAMediaTimingFunction(name: .linear)
            progressLayer.removeAnimation(forKey: Constants.progressAnimationKey)
            progressLayer.add(animation, forKey: Constants.progressAnimationKey)

            let animationRemainder = CABasicAnimation(keyPath: "strokeStart")
            animationRemainder.fromValue = remainderLayer.strokeStart
            animationRemainder.toValue = clampedProgress + gap
            animationRemainder.duration = 1
            animationRemainder.timingFunction = CAMediaTimingFunction(name: .linear)
            remainderLayer.removeAnimation(forKey: Constants.remainderAnimationKey)
            remainderLayer.add(animationRemainder, forKey: Constants.remainderAnimationKey)
        }

        progressLayer.strokeEnd = clampedProgress

        remainderLayer.strokeStart = clampedProgress + gap
        remainderLayer.strokeEnd = 0.97
    }

}

private extension CircularDiagramView {

    func setEmptyState() {
        remainderLayer.strokeColor = emptyStateColor.cgColor
        remainderLayer.strokeStart = 0
        remainderLayer.strokeEnd = 1
        progressLayer.strokeEnd = 0
    }

    func removeAnimations() {
        remainderLayer.removeAnimation(forKey: Constants.remainderAnimationKey)
        progressLayer.removeAnimation(forKey: Constants.progressAnimationKey)
    }

}
